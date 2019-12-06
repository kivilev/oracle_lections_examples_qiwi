------- DEMO. Неименованные системные исключения

----- Шаг 1. Создадим табличку с 1 строкой
drop table demo1;
create table demo1 as select 'str' n1 from dual;

----- Шаг 2. Блокируем строку в другой сессии
/*
select * 
  from demo1 
   for update nowait;
*/

----- Шаг 3.1. Пытаемся заблокировать строку (exception + pragma)
declare
  e_row_locked exception;
  pragma exception_init(e_row_locked, -00054);
  
  v1 number; -- Тип не совпадает с типом столбца таблицы
begin
  -- пытаемся заблокировать
  select n1 into v1
    from demo1 
     for update nowait;     
exception 
  when e_row_locked then -- True путь
    dbms_output.put_line('Путь джедая по обработке ошибок.');
end;
/


----- Шаг 3.2. Пытаемся заблокировать строку (others + sqlcode)
declare
  v1 number;
begin
  -- пытаемся заблокировать
  select n1 into v1
    from demo1 
     for update nowait;
     
exception 
  when others then -- Так сибе путь
    if sqlcode = -00054 then
      dbms_output.put_line('Возможно, конечно, но шляпа');
    --! момент
    end if;
end;
/
