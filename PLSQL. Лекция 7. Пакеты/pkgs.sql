-- ******************* DEMO. Примеры пакетов. ****************

----------- Пример 1. Спецификация + тело

-- 1. Спецификация
create or replace package my_pkg is

    -- Определение константы
    c_right_value constant varchar2(100 char) := 'super';

    -- Определение пользовательского исключения
    e_my_excpetion exception;

    -- Процедура проверки значения
    procedure check_value(pi_value varchar2);

end;
/

-- 2. Тело пакета (реализация):
create or replace package body my_pkg is
   
    -- Процедура проверки значения
    procedure check_value(pi_value varchar2)
    is
    begin
       if pi_value <> c_right_value then
          raise e_my_excpetion;
       end if;
    end;
    
end;
/

-- Тестируем функционал 
begin
  my_pkg.check_value(null);-- дергаем процедуру пакета
  dbms_output.put_line('Супер. Все работает!'); 
exception 
  when my_pkg.e_my_exception then -- обрабатываем пользовательское исключение
     dbms_output.put_line('Ааааа! Исключение! Все пропало!'); 
end;
/




-------- Пример 2. Только спефикация.
select * from user_objects t where t.OBJECT_NAME = 'MY_PKG';

-- 1. Удалим тело
drop package body my_pkg;

-- Тестируем функционал 
begin
   -- my_pkg.check_value(null);-- дергаем процедуру пакета. Ошибка!
   if 'super' <> my_pkg.c_right_value then
      raise my_pkg.e_my_exception;
   end if;
  
  dbms_output.put_line('Супер. Все работает!'); 
exception 
  when my_pkg.e_my_exception then -- обрабатываем пользовательское исключение
     dbms_output.put_line('Ааааа! Исключение! Все пропало!'); 
end;
/



