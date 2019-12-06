---- ПРИМЕР ВЛОЖЕННЫХ ТАБЛИЦ (В СХЕМЕ БЕЗ EBR!)
drop table del$people;
drop type del$t_string_arr;

-- Создаем тип - коллекция
create type del$t_string_arr is table of varchar2(100 char);

-- Создаем таблицу со столбцом типа коллекция
create table del$people (
id number, 
full_names del$t_string_arr
)
nested table full_names store as del$people_full_name;

-- У нас включены эдиции в схеме QIWI
-- ORA-38818: illegal reference to editioned object QIWI.DEL$T_STRING_ARR
-- Вложенные таблицы работают только в схеме без EBR

-- вставляем записи
insert into del$people(id, full_names) values 
(1, del$t_string_arr('Иванова','Петрова', 'Сидорова'));

insert into del$people(id, full_names) values
 (2, del$t_string_arr('Ivanova','Petrova', 'Сидорова'));

-- выбираем все записи
-- 1
select t.*,rowid from del$people t;
-- 2
select t1.id
      ,value(t2) full_name
  from del$people t1, table(t1.full_names) t2;

-- выбираем записи + условие
select t1.id
      ,value(t2) full_name
  from del$people t1, table(t1.full_names) t2
 where value(t2) = 'Сидорова';

