-- КЛОН TXN2 (с правками)
drop table del$txn2;
create table del$txn2
(
  txn_id                number(20) not null,
  txn_date              timestamp(6) default systimestamp,
  txn_minute            date generated always as (trunc(txn_date, 'mi')) virtual -- виртуальный столбец
)
partition by range (txn_minute)  -- РАЗБИЕНИЕ ПО ДИАПАЗОНАМ. ПО ВИРТ СТОЛБЦУ
interval (numtodsinterval(1, 'DAY')) -- ОПЦИЯ АВТОНАРЕЗАНИЯ (ИНТЕРВАЛЬНОЕ ПАРТИЦИОНИРОВАНИЕ)
--interval (numtoyminterval(1, 'MONTH')) -- ОПЦИЯ АВТОНАРЕЗАНИЯ (ИНТЕРВАЛЬНОЕ ПАРТИЦИОНИРОВАНИЕ)
(
  -- ЕДИНСТВЕННАЯ ПАРТИЦИЯ. БЕЗ НЕЁ СОЗДАТЬ НЕ ПОЛУЧИТСЯ
  partition pmin values less than (TO_DATE(' 2008-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIAN'))
)
enable row movement; -- СТРОЧКИ МОГУТ МИГРИРОВАТЬ МЕЖДУ ПАРТИЦИЯМИ

-- Партиции нарезаются вне зависимости от того чем закончилась транзакция commit/rollback.
insert into del$txn2(txn_id, txn_date)
 select level, sysdate +level 
 from dual connect by level <= 1000;

select * from del$txn2;

select * from user_tab_partitions t where t.table_name = 'DEL$TXN2';


insert into del$txn2(txn_id, txn_date)
 select level, sysdate +level 
 from dual connect by level <= 1000;




-- MONTHS
--insert into del$txn2(txn_id, txn_date) values (1, to_date('03.01.2018 00:00:00','dd.mm.YYYY hh24:mi:ss'));
--insert into del$txn2(txn_id, txn_date) values (1, to_date('03.01.2018 00:00:00','dd.mm.YYYY hh24:mi:ss'));
