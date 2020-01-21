-- ************* DEMO. Динамические курсоры ************

drop table demo;
create table demo
(
 id number,
 name varchar2(200 char)
);
alter table demo add constraint demo_pk primary key (id);

insert into demo 
select level, 'n'||level from dual connect by level <= 10;
commit;

----- Пример 1. Подставное имя таблицы
declare
  v_cur sys_refcursor;
  v_cnt number;
  v_table_name user_tables.table_name%type := 'demo';
begin
  open v_cur for 'select count(*) from '||v_table_name;
  fetch v_cur into v_cnt;
  close v_cur;
   
  dbms_output.put_line('Count in "'||v_table_name||'": '||v_cnt); 
end;
/

----- Пример 2. Динамическая сортировка 
declare
  procedure show_demo(pi_order varchar2)
  is
    v_cur   sys_refcursor;
    v_id    demo.id%type;
    v_name  demo.name%type;
  begin
    if pi_order not in ('desc', 'asc') then
      raise_application_error(-20100,'Haccker detected!');
    end if;

    open v_cur for 'select id, name from demo order by id '||pi_order;
    loop
      fetch v_cur into v_id, v_name;
      exit when v_cur%notfound; 
      
      dbms_output.put_line(v_id||': '||v_name); 
      
    end loop;
    close v_cur;
  end;
  
begin
  show_demo('asc');
end;
/


----- Пример 3. Выбираем в рекорд всю строку 
declare
  procedure show_employees(pi_order varchar2)
  is
    v_cur   sys_refcursor;
    v_row   employees%rowtype;
  begin

    open v_cur for 'select * from employees order by salary '||pi_order;
    loop
      fetch v_cur into v_row;
      exit when v_cur%notfound; 
      
      dbms_output.put_line(v_row.employee_id||': '||v_row.last_name||' - '||v_row.salary||'$'); 
      
    end loop;
    close v_cur;
  end;
  
begin
  show_employees('asc');
end;
/







