---------- Удаление данных по commit
create global temporary table del$commit_delete_gtt (
field1 number,
field2 varchar2(30 char))
on commit delete rows;

insert into del$commit_delete_gtt select level, level from dual connect by level <= 10;

select * from del$commit_delete_gtt;

commit;

select * from del$commit_delete_gtt;


---------- Удаление данных по завершению сессии
create global temporary table del$commit_preserve_gtt (
field1 number,
field2 varchar2(30 char))
on commit preserve rows;

insert into del$commit_preserve_gtt select level, level from dual connect by level <= 10;

select * from del$commit_preserve_gtt;

commit;

select * from del$commit_preserve_gtt;

truncate table del$commit_preserve_gtt;

