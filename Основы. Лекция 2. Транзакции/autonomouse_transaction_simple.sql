--- ПРИМЕР С АВТОНОМНЫМИ ТРАНЗАКЦИЯМИ
/*
drop table T1;
drop table T2;
create table T1
(
  dt TIMESTAMP(6),
  id NUMBER
);
create table T2
(
  dt TIMESTAMP(6),
  id NUMBER
);
truncate table t1;
truncate table t2;
*/

select * from t1 order by dt desc;
select * from t2 order by dt desc;

declare
  v_new_id t1.id%type := 3;

  -- процедура будет выполняться в автономной транзакции
  procedure child_tr(pi_id t2.id%type) 
  is
    pragma autonomous_transaction;
  begin
    insert into t2 values(systimestamp, pi_id);
    commit;
  end;  
    
begin
  -- вставляем запись
  insert into t1 values(systimestamp, v_new_id);
  -- всталяем запись в Т2 в автономной транзакции
  child_tr(v_new_id);
  -- откатываемся
  rollback;
  -- сохраняем
  --commit;
end;
/
select * from t1 order by dt desc;
select * from t2 order by dt desc;
