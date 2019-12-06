--*************** DEMO. Типы вызова ***********************

--- Demo процедура и функция
create or replace procedure demo_proc(pi_param number)
is
begin
  dbms_output.put_line('==> It''s demo proc. Param1: '||pi_param);
end;
/

create or replace function demo_func(pi_param number) return varchar2
is
begin
  return '==> It''s demo func. Param1: '||pi_param;
end;
/


--------- 1. EXECUTE -----
-- exec demo_func(100); -- функции нельзя
exec demo_proc(100); -- процедуры без проблем (только sqlplus)



---------- 2. CALL ---------

---- 1) Функция (только sqlplus)
-- переменная результат
variable res varchar2(50 char);
-- вызов функции
call demo_func(100) into :res;
-- вывод результата
print res;

--- 2) Процедуры (plsql developer - работает и sqlplus - работает)
call demo_proc(100);



-------- 3. PL/SQL-блок --------

-- 1) Функция
declare
  v varchar2(1000 char);
begin
  v := demo_func(100);
  dbms_output.put_line(v); 
end;
/

-- 2) Процедура
begin
  demo_proc(999); 
end;
/



-------- 4. SQL ----------------
--- Только функции
select demo_func(100)
  from dual;

