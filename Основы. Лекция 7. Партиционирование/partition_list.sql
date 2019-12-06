----- ПРИМЕР. LIST-партиционирования (по диапазону)
create table del$list_order(
  order_id number,
  sernum varchar2(100),
  state_code varchar2(10)
)
partition by list (state_code) -- диапазон
(
 partition region_east   values ('MA','NY'),
 partition region_west values ('CA','AZ'),
 partition region_south values ('TX','KY'),
 partition region_null  values (null),
 partition region_unknown values (default)
);

-- вставляем записи
insert into del$list_order(order_id, sernum, state_code)
values (1, '111', 'MA');

insert into del$list_order(order_id, sernum, state_code)
values (2, '222', 'TX');

insert into del$list_order(order_id, sernum, state_code)
values (3, '333', null);

insert into del$list_order(order_id, sernum, state_code)
values (4, '444', 'ZZZ');

-- смотрим партиции, в какие куда вошли записи
select * from del$list_order partition (region_east);
select * from del$list_order partition (region_west);
select * from del$list_order partition (region_south);
select * from del$list_order partition (region_null);
select * from del$list_order partition (region_unknown);

