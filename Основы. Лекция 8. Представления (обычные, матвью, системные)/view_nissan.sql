------ Пользователь 2. d_nissan
-- drop table nissan_mark;
-- Создаем таблицу
create table nissan_mark
(
id number not null,
name varchar2(200 char)
);
-- вставляем данные
insert into nissan_mark select level, decode(level, 1,'qashqai', 2,'skyline', 3,'teana', 4, 'murano', 5, null) from dual connect by level <= 5; 
commit;

-- Получаем данные
select t.* from nissan_mark t;

--- 2) Чужая таблица и своя view (для схемы d_toyota)
grant select on nissan_mark to d_toyota;-- для возможности создания view
grant update on nissan_mark to d_toyota;-- для возможности редактирования view
revoke all on nissan_mark from d_toyota;-- забирааем все гранты -> d_toyota.view становится невалидной

--- 3) Чужая таблица и чужая view (для схемы d_toyota)
-- создадим view
drop view v_nissan_full_mark;
create or replace view v_nissan_full_mark as
select id, 'nissan_mark_'||id mark_id, 'nissan '||name full_name 
  from nissan_mark 
 where name is not null;

select * from v_nissan_full_mark

-- даем гранты на select
grant select on v_nissan_full_mark to d_toyota;

-- даем гранты на update
grant update on v_nissan_full_mark to d_toyota;

---------------
select t.*, rowid from d_toyota.v_toyota_mark_read_only t;

