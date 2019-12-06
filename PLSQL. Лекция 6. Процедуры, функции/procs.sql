--****************** DEMO. Процедуры *****************************

------ 1) Глобальное определение (на уровне схемы)
CREATE OR REPLACE procedure schema_proc(pi_param1 number, pi_param2 varchar2) is
begin
  dbms_output.put_line('SCHEMA level procedure. Param1: '||pi_param1||'. Param2: '||pi_param2);  
end;
/

-- Вызов
begin
  schema_proc(1, 'Параметр2');
end;
/

------ 2) Уровень пакета 
create or replace package my_pkg is
  procedure package_proc;
end;
/
create or replace package body my_pkg is
  procedure package_proc is
  begin
    dbms_output.put_line('PACKAGE level procedure. No params.');  
  end;
end;
/

-- Вызов
begin
  my_pkg.package_proc();
end;
/


------ 3) Локальное определение (на уровне PL/SQL блока)

-- 1 пример. Анонимный PL/SQL-блок
declare
  
  -- локальная процедура
  procedure local_proc(pi_param1 number) is
  begin
      dbms_output.put_line('PLSQL-block level procedure. Param1: '|| pi_param1);  
  end;
  
begin
  -- вызов
  local_proc(1);
end;
/

-- 2 пример. Именованный PL/SQL-блок
create or replace procedure schema_proc_with_local_proc(pi_param1 varchar2) is

   -- локальная процедура
   procedure local_proc(pi_param1 varchar2) is
   begin
     dbms_output.put_line('PLSQL-block level procedure. Param1: '||pi_param1);  
   end;

begin
  dbms_output.put_line('SCHEMA level procedure');  
  -- вызов
  local_proc(pi_param1);
end;
/

-- вызов
begin
  schema_proc_with_local_proc('Hello!');
end;
/  

