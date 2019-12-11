-- ********** DEMO. Инициализация и сброс состояни *****************

----- Пример 1. 

-- заголовок
create or replace package my_pack is

   c_currency_code_rub  varchar2(3 char) := 'RUB'; -- константа
  
   function is_rub(pi_currency_code varchar2) return boolean; -- какая-то функция
     
   procedure infinite;
     
end;
/

-- тело
create or replace package body my_pack is

   function is_rub(pi_currency_code varchar2) return boolean
   is
   begin
     return pi_currency_code = c_currency_code_rub;
   end;

   procedure infinite
   is
   begin
     loop
       dbms_session.sleep(1);
     end loop;
   end;
  
begin
  dbms_output.put_line('c_currency_code_rub: '||c_currency_code_rub); 
  dbms_output.put_line('init block');
end;
/

-- Тест 1. Просто обращаемся к переменной
begin
  if 'RUB' = my_pack.c_currency_code_rub then
     dbms_output.put_line('It''s rubles!');     
  end if;  
end;
/

-- Тест 2. Обращаемся к функции пакета
begin
  if my_pack.is_rub('RUB') then
     dbms_output.put_line('It''s rubles!');     
  end if;  
end;
/

--------- Варианты сброса

--- Пример 1. Сброс состояния пакета
call dbms_session.reset_package();

--- Пример 2. Сброс через компиляцию
alter package my_pack compile;
-- call my_pack.infinite();

--



/*ORA-04068: existing state of packages has been discarded
ORA-04061: existing state of package "HR.MY_PACK" has been invalidated
ORA-04065: not executed, altered or dropped package "HR.MY_PACK"
ORA-06508: PL/SQL: could not find program unit being called: "HR.MY_PACK"
ORA-06512: at line 2
*/
