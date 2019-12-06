--- Создаем функцию, которая будет вычислять нам второй столбец
create or replace function del$virt_col_gen(p_in_val date)
  return varchar2 deterministic is
begin
  -- извлечение номера дня
  return extract(year from p_in_val);
end;
/

--- Создаем таблицу с виртуальным столбцом
drop table d$virt_col_tab;
create table d$virt_col_tab
(
  id number,
  ins_date date,
  -- вирт столбец, которые отдает день недели ins_date на RUS
  ins_day  generated always as (to_char(ins_date, 'Day', 'NLS_DATE_LANGUAGE=RUSSIAN')) virtual,
  -- вирт столбец, который использует функцию для вычисления
  ins_day_num  generated always as (del$virt_col_gen(ins_date)) virtual 
);

-- Вставляем данные
insert into d$virt_col_tab(id, ins_date) values (1, sysdate);
insert into d$virt_col_tab(id, ins_date) values (2, sysdate+1);
insert into d$virt_col_tab(id, ins_date) values (3, sysdate+2);

-- Смотрим данные
select * from d$virt_col_tab;

