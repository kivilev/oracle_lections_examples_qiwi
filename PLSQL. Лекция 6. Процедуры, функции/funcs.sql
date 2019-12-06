--****************** DEMO. Функции *****************************

------ 1) Глобальное определение (на уровне схемы)
create or replace function schema_func(pi_param1 number, pi_param2 varchar2) return number 
is
begin
  dbms_output.put_line('SCHEMA level function. Param1: '||pi_param1||'. Param2: '||pi_param2);
  return 999;
end;
/

-- Вызов
begin
  dbms_output.put_line(  schema_func(1, 'Параметр2')  ); 
end;
/

------ 2) Уровень пакета 
create or replace package my_pkg is
  function package_func return varchar2;
end;
/
create or replace package body my_pkg is
  function package_func return varchar2 is
  begin
    dbms_output.put_line('PACKAGE level function. No params.');
    return 'Hello world!';
  end;
end;
/

-- Вызов
declare
  v varchar2(200 char);
begin
  v := my_pkg.package_func();
  dbms_output.put_line(v);
end;
/


------ 3) Локальное определение (на уровне PL/SQL блока)

--- 1 пример. Анонимный PL/SQL-блок (пример для Oracle 12+, инициализ рекордов)
declare
 -- тип 
 type t_rec is record(
   id   number(10),
   name varchar2(100 char)
  );
  v t_rec;
  
  -- локальная процедура
  function fill_record(pi_param1 number) return t_rec is
  begin
    dbms_output.put_line('PLSQL-block level function. Param1: '|| pi_param1);  
    return t_rec(pi_param1, 'hello world ' ||pi_param1);
  end;
  
begin
  -- вызов
  v := fill_record(100);
  
  dbms_output.put_line(v.id ||' => '||v.name );   
end;
/

