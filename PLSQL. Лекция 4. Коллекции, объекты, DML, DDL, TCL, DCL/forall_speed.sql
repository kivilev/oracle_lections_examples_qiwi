--- DEMO. FORALL - множественно связывание.

/*
drop table my_tab;

create table my_tab
(
 n1 number,
 n2 number,
 v1 varchar2(200 char)
);

create or replace type t_row force is object (n1 number, n2 number);
/
create or replace type t_rows force is table of t_row;
/
*/


----- Сравнение скорости
declare
  v_array t_rows;
  t1 number; t2 number; t3 number; t4 number;  t5 number; t6 number; 
begin
  
  select t_row(level, level)
    bulk collect into v_array 
    from dual 
    connect by level <= 100000;
  
  execute immediate 'truncate table my_tab';-- чистим.  
  ------- Обычный цикл
  t1 := dbms_utility.get_time();
  
  for i in v_array.first..v_array.last loop
    insert into my_tab values (v_array(i).n1, v_array(i).n2, 'какая-то строка_______');
  end loop;
  
  t2 := dbms_utility.get_time();

  execute immediate 'truncate table my_tab';-- чистим.  

  ------- Forall
  t3 := dbms_utility.get_time();  
  
  forall i in v_array.first..v_array.last
   insert into my_tab values (v_array(i).n1, v_array(i).n2, 'какая-то строка_______');
   
  t4 := dbms_utility.get_time();

  execute immediate 'truncate table my_tab';-- чистим.  
  
  ------- Select
  t5 := dbms_utility.get_time();  
  
  insert into my_tab
  select value(t).n1, value(t).n2, 'какая-то строка_______'
    from table(v_array) t;
    
  t6 := dbms_utility.get_time();
  
  dbms_output.put_line('Loop: '||(t2-t1)/100 || 's. Forall: '|| (t4-t3)/100||'s. Select: '|| (t6-t5)/100 ||'s'); 
  rollback;      
end;
/
