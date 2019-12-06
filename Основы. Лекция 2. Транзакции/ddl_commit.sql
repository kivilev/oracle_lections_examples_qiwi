/*
drop table T1;
drop table del$my_tab1;

create table T1
(
  dt TIMESTAMP(6),
  id NUMBER
);
create table del$my_tab1
(
  id NUMBER
);

truncate table t1;
*/

------------- НЕЯВНЫЙ COMMIT в DDL -------
-- пустая табличка
select * from t1;
-- Вставили запись
insert into t1 values(systimestamp, seq1.nextval);
-- Проверили. Должна быть 1 запись.
select * from t1;

-- Оператор DDL усекает табличку 
begin execute immediate 'truncate table del$my_tab1'; end;
/
-- Откатывемся. 
rollback;

-- Проверили. Должна быть 1 запись.
select * from t1;


