--- ПРИМЕР С АВТОНОМНЫМИ ТРАНЗАКЦИЯМИ (SQL, DDL)
/*
create table t1
(
  dt TIMESTAMP(6),
  id NUMBER
);
create table t1_audit
(
  dt TIMESTAMP(6),
  id NUMBER,
  uname varchar2(200 char)
);
truncate table t1;
truncate table t1_audit;
*/
---- Входные данные
truncate table t1;
truncate table t1_audit;
insert into t1 select sysdate, level from dual connect by level <=10;
select * from t1;
commit;

-- Функция аудита БЕЗ автономной транзакии
create or replace function del$aud_t1(p_id t1.id%type) return number
is
begin
  insert into t1_audit(dt, id, uname) values (systimestamp, p_id, user);
  commit;
  return 1;
end;
/
-- Функция аудита с автономной транзакией
create or replace function del$aud_t1_autonomouse(p_id t1.id%type) return number
is
  pragma autonomous_transaction;
begin
  insert into t1_audit(dt, id, uname) values (systimestamp, p_id, user);
  commit;
  return 1;
end;
/


-- Попробуем выполнить аудит при помощи обычной функции. Получаем ошибку :(
select t.*, del$aud_t1(t.id)
  from T1 t;
-- ORA-14551: cannot perform a DML operation inside a query 


-- Попробуем выполнить аудит при помощи функции с АТ. Все отлично :)
select t.*, del$aud_t1_autonomouse(t.id)
  from T1 t;
-- аудит  
select * from t1_audit order by dt desc;


-- !PLSQL в SQL лучше не употреблять или специально оптимизировать plsql-функции
