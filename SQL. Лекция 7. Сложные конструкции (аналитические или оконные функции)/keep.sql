-------------------------- DEMO. KEEP DENSE_RANK.
create or replace type ids_tab is table of number(20);
/

---------- Пример 1. Тарифы кошелька.
-- 1й способ Агрегация
with twallets as (
        select value(t) prs_id, 'tarif_1' tff_id, 100 priority
          from table(ids_tab(71111111111, 71111111121)) t
        union all
        select value(t), 'tarif_2', 50
          from table(ids_tab(71111111112, 71111111121)) t
        union all
        select value(t), 'tarif_3', 1
          from table(ids_tab(71111111113, 71111111121)) t)
--          
select prs_id,
       min(tff_id) keep(dense_rank first order by priority desc, tff_id nulls last) tff_id,
       min(priority) keep(dense_rank first order by priority desc, tff_id nulls last) priority
  from twallets t
 group by prs_id
 order by prs_id;

-- 2й способ. Аналитика
with twallets as (
        select value(t) prs_id, 'tarif_1' tff_id, 100 priority
          from table(ids_tab(71111111111, 71111111121)) t
        union all
        select value(t), 'tarif_2', 50
          from table(ids_tab(71111111112, 71111111121)) t
        union all
        select value(t), 'tarif_3', 1
          from table(ids_tab(71111111113, 71111111121)) t)
--          
select min(prs_id) keep(dense_rank first order by priority desc, tff_id nulls last) over (partition by prs_id)prs_id,
       min(tff_id) keep(dense_rank first order by priority desc, tff_id nulls last) over (partition by prs_id)tff_id,
       min(priority) keep(dense_rank first order by priority desc, tff_id nulls last) over (partition by prs_id)priority
  from twallets t
 order by prs_id;


------- Пример 2. Курсы валют. В день могут быть курсовые колебания. 
-- Задача: получить значения курса + время изменения на начало и на конец дня для каждой валюты.

-- Простейшая структура для хранения отношения между валютами.
drop table d$currency_rate;
create table d$currency_rate
(
  from_curr_code   char(3 char) not null,
  to_curr_code     char(3 char) not null,
  dtime            date default sysdate,
  val              number(10,2) not null
);
alter table d$currency_rate add constraint d$currency_rate_pk primary key (from_curr_code, to_curr_code, dtime);

-- RUB -> USD
insert into d$currency_rate values ('RUB', 'USD', to_date('01.01.2014 01:00:00','dd.mm.YYYY hh24:mi:ss'), 1.1);
insert into d$currency_rate values ('RUB', 'USD', to_date('01.01.2014 02:00:00','dd.mm.YYYY hh24:mi:ss'), 1.2);
insert into d$currency_rate values ('RUB', 'USD', to_date('01.01.2014 03:00:00','dd.mm.YYYY hh24:mi:ss'), 1.3);
insert into d$currency_rate values ('RUB', 'USD', to_date('01.01.2014 23:59:00','dd.mm.YYYY hh24:mi:ss'), 1.4);

insert into d$currency_rate values ('EUR', 'RUB', to_date('01.01.2014 00:30:00','dd.mm.YYYY hh24:mi:ss'), 0.1);
insert into d$currency_rate values ('EUR', 'RUB', to_date('01.01.2014 02:40:00','dd.mm.YYYY hh24:mi:ss'), 0.2);
insert into d$currency_rate values ('EUR', 'RUB', to_date('01.01.2014 13:30:00','dd.mm.YYYY hh24:mi:ss'), 0.3);
insert into d$currency_rate values ('EUR', 'RUB', to_date('01.01.2014 23:00:00','dd.mm.YYYY hh24:mi:ss'), 0.4);
commit;

insert into d$currency_rate values ('EUR', 'RUB', to_date('02.01.2014 00:30:00','dd.mm.YYYY hh24:mi:ss'), 0.1);
insert into d$currency_rate values ('EUR', 'RUB', to_date('02.01.2014 02:40:00','dd.mm.YYYY hh24:mi:ss'), 0.2);
insert into d$currency_rate values ('EUR', 'RUB', to_date('02.01.2014 13:30:00','dd.mm.YYYY hh24:mi:ss'), 0.3);
insert into d$currency_rate values ('EUR', 'RUB', to_date('02.01.2014 23:00:00','dd.mm.YYYY hh24:mi:ss'), 0.4);
commit;


select * from d$currency_rate;

-- Запрос, отдающий курсы на начало и на конец дня
select t.from_curr_code
     , t.to_curr_code
     , trunc(dtime) ddate
     -- начало дня
     , min(val) keep(dense_rank first order by dtime nulls last) begin_day_val
     , min(dtime) keep(dense_rank first order by dtime nulls last) begin_day_dtime
     -- конец дня
     , min(val) keep(dense_rank first order by dtime desc nulls last) end_day_val     
     , min(dtime) keep(dense_rank first order by dtime desc nulls last) end_day_dtime    
 from d$currency_rate t
 group by t.from_curr_code, t.to_curr_code, trunc(dtime)
 order by from_curr_code, t.to_curr_code;

