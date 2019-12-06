/*
drop table del$t1;
create table del$t1
(
id number,
val varchar2(100)
);
truncate table del$t1;
insert into del$t1 select level, 'val'||level from dual connect by level <= 100000;
commit;
*/

-- Получить текущий SCN  
select current_scn from v$database;


  
