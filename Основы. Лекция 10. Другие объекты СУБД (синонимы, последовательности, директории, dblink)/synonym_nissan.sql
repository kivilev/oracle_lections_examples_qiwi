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

-- Грант на таблицу
grant select on nissan_mark to d_toyota;
--revoke select on nissan_mark  from d_toyota;

create or replace synonym nissan_mark_original for d_nissan.nissan_mark;
grant select on nissan_mark_original to d_toyota;




