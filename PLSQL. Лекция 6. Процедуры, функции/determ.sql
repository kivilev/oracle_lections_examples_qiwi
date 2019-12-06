-- ************** DETERMENISTIC *****************

-- 1. Создаем функцию 
-- noneditionable, если EBR
create or replace function sqr(p_param1 number) return number
deterministic
is
begin
  return p_param1*p_param1;
end;
/


--- 1) SQL
select sqr(level) square
  from dual connect by level <= 10;

--- 2) Создание виртуального столбца
drop table my_tab;
create table my_tab
(
 size_1 number,
 size_2 number,
 square  number generated always as (sqr(size_1)) virtual
);

insert into my_tab(size_1, size_2) 
select level, level 
  from dual connect by level <= 100;

select * from my_tab;

--- 3) Функция для индекса
create index my_tab_idx on my_tab(sqr(size_2));

select t.status, t.* 
  from user_indexes t 
 where t.index_name = 'MY_TAB_IDX';


