------------- DEMO. Конвейерные функции - PIPELINED --------

-- Создаем коллекцию
create or replace type t_numbers is table of number(10);
/

---- Обычная процедура
create or replace function delay_simple_proc return t_numbers 
is
  v_out t_numbers := t_numbers();
begin
  for i in (select level 
              from dual connect by level <= 10
             order by level desc)
  loop
    dbms_session.sleep(1); -- спим 1 сек
    v_out.extend(1);
    v_out(v_out.last) := i.level;
  end loop;
  
  return v_out; -- вернуть результат
end;
/

---- Конвейерная процедура
create or replace function delay_pipelined_proc return t_numbers 
PIPELINED
is  
begin
  for i in (select level 
              from dual connect by level <= 10 
             order by level desc)
  loop
    dbms_session.sleep(1); -- спим 1 сек
    PIPE ROW(i.level);
  end loop;
end;
/
----------------- Эксперимент 1. Ограничение по выборке

select * from delay_simple_proc();
select * from delay_pipelined_proc();

-- Вызов до 12го
select * 
  from table(delay_simple_proc()) 
 where res in (1,5)

select * 
  from table(delay_pipelined_proc()) 
 where rownum <= 5;


---------------- Эксперимент 2. Фиксируем время возврата строки
drop table del$some_tab;
create table del$some_tab
(
  source varchar2(20 char),
  lvl    number,
  dtime  date
);

-- функция для получения timestamp именно на момент вставки
create or replace function get_actual_dtime return date
is
  pragma autonomous_transaction;
begin
  commit;
  return sysdate;
end;
/

-- Заполняем таблицу из конвейерной функции
insert into del$some_tab
select 'pipeline', value(t), get_actual_timestamp()
  from delay_pipelined_proc() t;

-- Заполняем таблицу из обычной функции
insert into del$some_tab
select 'simple', value(t), get_actual_timestamp()
  from delay_simple_proc() t;  

select * from del$some_tab order by source, dtime;
