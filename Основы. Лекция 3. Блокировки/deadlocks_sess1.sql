/*
create table del$deadlocks 
(
id number,
val number
);
truncate table del$deadlocks;
insert into del$deadlocks select level, level from dual connect by level <= 10;
commit;
*/

-- 1) проверяем записи
select * from del$deadlocks;

-- 2) блокируем "2"
update del$deadlocks t set t.val = 5 where t.id = 2;

-- 4) пытаемся блокировать "10", попадаем на заблокированную строку
update del$deadlocks t set t.val = 5 where t.id = 10;
