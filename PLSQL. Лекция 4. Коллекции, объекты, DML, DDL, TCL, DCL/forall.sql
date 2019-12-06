--- DEMO. FORALL - множественно связывание.

/*
drop table my_tab;

create table my_tab
(
 id number,
 n2 number,
 v1 varchar2(10 char)
);

create or replace type t_row force is object (n1 number, n2 number);
/
create or replace type t_rows force is table of t_row;
/
*/

------ Общие примеры
declare
  v_array   t_rows := t_rows(t_row(1, 11), t_row(2, 22), t_row(3, 33));
  v_arr_upd t_rows := t_rows(t_row(1, 110));

  type t_numbers is table of number;
  v_arr_del t_numbers := t_numbers(3, 5);

begin
  execute immediate 'truncate table my_tab';

  -- INSERT
  forall i in v_array.first .. v_array.last
    insert into my_tab
    values
      (v_array(i).n1, v_array(i).n2, 'строка:)');
  
  --dbms_output.put_line('Rows affected: '|| SQL%BULK_ROWCOUNT); 
  
  -- UPDATE
  forall i in v_arr_upd.first .. v_arr_upd.last
    update my_tab t set n2 = v_arr_upd(i).n2 
     where t.id = v_arr_upd(i).n1;

  --dbms_output.put_line('Rows affected: '||sql%bulk_rowcount); 
  
  -- DELETE
  forall i in indices of v_arr_del
    delete from my_tab t 
     where t.id = v_arr_del(i);

  --dbms_output.put_line('Rows affected: '||sql%bulk_rowcount); 

  commit;
end;
/

select * from my_tab;

------ Пример. Save exception
declare
  type t_arr is table of varchar2(50 char);
  v_arr t_arr := t_arr('Длинаааая строка больше 10 символов',                       
                       '10символов',
                       '123456',
                       'Длинаааая строка больше 10 символов');
begin
  
  execute immediate 'truncate table my_tab';

  -- INSERT. Две строки с ошибкой
  begin
 
   forall i in v_arr.first .. v_arr.last save exceptions
      insert into my_tab (id, v1) values (1, v_arr(i));
 
  exception 
    when others then
      dbms_output.put_line('indices of Error: ' || sqlcode || ' - ' || sqlerrm);
      for index_err in 1 .. sql%bulk_exceptions.count loop
        dbms_output.put_line('Index ' || index_err || ' итерация ' || sql%bulk_exceptions(index_err).error_index 
            || ' Код ошибки ' || sql%bulk_exceptions(index_err).error_code 
            || ' Сообщение: ' || sqlerrm(-sql%bulk_exceptions(index_err).error_code));
      end loop;
  end;
 
end;
/
