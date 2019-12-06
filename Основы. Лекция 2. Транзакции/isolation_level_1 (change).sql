---- СЕССИЯ МЕНЯЮЩАЯ ДАННЫЕ
/*
drop table T1;
create table T1
(
  dt TIMESTAMP(6),
  id NUMBER
);
*/
--truncate table t1;
select t1.*, rowid from t1 order by t1.dt desc;

insert into t1 values(systimestamp, seq1.nextval);


