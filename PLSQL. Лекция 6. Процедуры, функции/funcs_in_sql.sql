---------- DEMO.  Функции в SQL ------------
/*
drop table demo_tbl;
create table demo_tbl (n1 number);
*/

------- Пример 1. Недопустимость DDL, DML
create or replace function inc_level(pi_param1 number) return varchar2
is
begin
  dbms_output.put_line('schema level: '||pi_param1); 
  --insert into demo_tbl values (pi_param1);
  execute immediate 'truncate table demo_tbl';
  return pi_param1 + 100;
end;
/

-- вызываем
select level, inc_level(level) res_func
  from dual
 connect by level <= 10;

-------- Пример 2. Функция в запросе (12.2+)
with
  function inc_level(pi_param1 number) return varchar2
  is
  begin
     dbms_output.put_line('sql level: '||pi_param1); 
     return pi_param1 + 100;
  end;
select level, inc_level(level)
  from dual t
  connect by level <= 10
;--!


-------- Пример 3. Pragma UDF
create or replace function func_with_udf return number
is
  pragma udf;
  v_res number;
begin
  select object_id
    into v_res
    from (select t.object_id
            from user_objects t
           order by dbms_random.value())
   where rownum < 2;
  return v_res;
end;
/

create or replace function func_without_udf return number
is
  v_res number;
begin
  select object_id
    into v_res
    from (select t.object_id
            from user_objects t
           order by dbms_random.value())
   where rownum < 2;
  return v_res;
end;
/



----- Тестовый скрипт
declare
  t1 pls_integer;
  t2 pls_integer;
  t3 pls_integer;
  v_tmp number;
  v_cnt_try number := 1000;
begin
  t1 := dbms_utility.get_time();
  -- вызов с UDF
  select count(func_with_udf())
    into v_tmp
    from dual connect by level <= v_cnt_try;

  
  t2 := dbms_utility.get_time();
  -- вызов без UDF
  select count(func_without_udf())
    into v_tmp
    from dual connect by level <= v_cnt_try;

  t3 := dbms_utility.get_time();
  
  dbms_output.put_line('UDF: '||(t2-t1)/100 ||'. No UDF: '||(t3-t2)/100); 

end;
/







