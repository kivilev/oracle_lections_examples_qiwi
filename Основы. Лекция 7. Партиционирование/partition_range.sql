----- ПРИМЕР. RANGE-партиционирования (по диапазону)
create table del$range_order(
  order_id number,
  sernum varchar2(100 char),
  order_date date
)
partition by range (order_date) -- диапазон
(
  partition pmin values less than (to_date(' 2008-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS')),
  partition p200802 values less than (to_date(' 2008-02-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS')),
  partition pmax values less than (maxvalue)
);

-- вставляем записи
insert into del$range_order(order_id, sernum, order_date)
values (1, '111', sysdate);

insert into del$range_order(order_id, sernum, order_date)
values (2, '222', to_date(' 2008-02-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'));

insert into del$range_order(order_id, sernum, order_date)
values (3, '333', to_date(' 2001-12-20 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'));

-- смотрим партиции, в какие куда вошли записи
select * from del$range_order partition (pmin);
select * from del$range_order partition (p200802);
select * from del$range_order partition (pmax);

select * from user_tab_partitions t where t.table_name = 'DEL$RANGE_ORDER'

select * from del$range_order where order_date < to_date(' 2002-12-20 00:00:00', 'SYYYY-MM-DD HH24:MI:SS')
