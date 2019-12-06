--- ПРИМЕР SELECT ... FOR UPDATE; 
/*
drop table del$t1;
create table del$t1
(
id number,
val varchar2(20)
);
truncate table del$t1;
insert into del$t1 select level, level from dual connect by level <= 10;
commit;
*/

-- 1) Блокируем запись "1"
select * from del$t1 t where t.id = 1 for update;

-- 2) Меняем запись "1"
update del$t1 t set t.val = 'hello' where t.id = 1;

