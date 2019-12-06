/*
create table T1
(
  dt TIMESTAMP(6),
  id NUMBER
);
truncate table t1;
*/

--- ПРИМЕР С ОПЕРАЦИЯМИ УПРАВЛЕНИЯ ТРАНЗАКЦИЯМИ

----- Простой пример отката до точки сохранения --------
-- Установили точку отката/сохранения
insert into t1 values(systimestamp, seq1.nextval);
savepoint sp1;
  -- Вставили запись
  insert into t1 values(systimestamp, seq1.nextval);
  -- Проверили, что она есть в таблице. Данные еще не закоммичены
  select * from t1;
-- Совершили откат до точки sp1;
rollback to sp1;

-- Проверили, что таблица пуста
select * from t1;

-------------- Пример двойной вложенности --------------
-- создали точку отката sp1
savepoint sp1;
-- Вставили запись
insert into t1 values(systimestamp, seq1.nextval);
-- Проверили. Должна быть 1 запись.
select * from t1;

  -- Установили точку отката/сохранения sp2
  savepoint sp2;
      -- Вставили запись
      insert into t1 values(systimestamp, seq1.nextval);
      -- Проверили, что она есть в таблице. Данные еще не закоммичены
      select * from t1;
  -- Совершили откат до точки sp1;
  rollback to sp2;

-- Проверили, что таблица имеет запись вставленную до установления точки сохранения sp2.
select * from t1;


------------- Пример ошибки, когда точки уже нет -------
-- создали точку отката sp1
savepoint sp1;
-- Вставили запись
insert into t1 values(systimestamp, seq1.nextval);
-- Проверили. Должна быть 1 запись.
select * from t1;
-- сохраняем изменения
commit;
-- Пробуем откатиться до sp1;
rollback to sp1;

-- ORA-01086: savepoint 'SP1' never established in this session or is invalid





