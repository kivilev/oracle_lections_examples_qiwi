--- Пример: MERGE
drop table sale;
drop table action_sale;
drop sequence sale_seq;

---- Создаем таблицу "Продажи"
create table sale
(
  id_sale      number(30,0) not null,
  state     varchar2(20 char) not null,
  create_dtime timestamp default systimestamp not null,  
  modify_dtime timestamp default systimestamp not null
);

alter table sale add constraint sale_pk primary key (id_sale);
alter table sale add constraint sale_ch check (state in ('NEW', 'PROCESSING', 'SENT', 'CANCELLED', 'DELETE'));

-- текущие заказы
insert into sale(id_sale, state) values (1, 'NEW');
insert into sale(id_sale, state) values (2, 'PROCESSING');
insert into sale(id_sale, state) values (3, 'PROCESSING');
insert into sale(id_sale, state) values (4, 'SENT');
commit;


create sequence sale_seq start with 100;

---- Создаем таблицу "Действия над продажами"
create table action_sale
(
  id_sale   number(30,0),
  action    varchar2(20 char) not null,
  ready     number(1) default 1 not null
);

-- Данные
insert into action_sale values (null, 'NEW SALE', default);
insert into action_sale values (1, 'CANCEL', default);
insert into action_sale values (2, 'SEND', default);
insert into action_sale values (3, 'DELETE', default);
insert into action_sale values (10, 'SEND', 0);
commit;

select * from action_sale;

select * from sale order by modify_dtime desc;




--- Мерджим изменения
merge into sale o
  using (select * from action_sale t where ready = 1) n
  on (o.id_sale = n.id_sale)
  when matched then
    update set 
        o.state = decode (n.action, 'CANCEL', 'CANCELLED', 'SEND', 'SENT', n.action)
      , o.modify_dtime = systimestamp
    delete where n.action = 'DELETE'
  when not matched then
    insert (id_sale, state)
    values (sale_seq.nextval, 'NEW')
    where n.action = 'NEW SALE';
  
  
  
  
    
select * from sale order by modify_dtime desc;

-- Смотрим на последовательность
select sale_seq.currval from dual;


create or replace function get_next_sale_id return number 
is
pragma udf; -- указание, что ф-я будет юзаться в основнов в SQL.
begin
  return sale_seq.nextval;
end;
/


--- Мерджим изменения
merge into sale o
  using (select * from action_sale t where ready = 1) n
  on (o.id_sale = n.id_sale)
  when matched then
    update set 
        state = decode (n.action, 'CANCEL', 'CANCELLED', 'SEND', 'SENT', n.action)
      , modify_dtime = systimestamp
    delete where n.action = 'DELETE'
  when not matched then
    insert (id_sale, state)
    values (get_next_sale_id(), 'NEW')
  where n.action = 'NEW SALE';

