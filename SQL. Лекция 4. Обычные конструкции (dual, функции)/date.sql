-- TRUNC
select sysdate,
       systimestamp,
       trunc(sysdate),
       trunc(systimestamp),       
       --trunc(sysdate, 'ss'),
       trunc(sysdate, 'mi'),
       trunc(sysdate, 'hh24'),
       trunc(sysdate, 'dd'),
       trunc(sysdate, 'mm'),
       trunc(sysdate, 'yyyy'),
       trunc(sysdate, 'year')
  from dual;


-- ROUND (практически не используетс€, нужно быть аккуратным!!)
select round(to_date('01.01.2019 12:00:00','dd.mm.YYYY hh24:mi:ss')) up_date_if
     , round(to_date('01.01.2019 11:59:00','dd.mm.YYYY hh24:mi:ss')) lower_date_if
     , round(to_date('10.08.2019 11:59:00','dd.mm.YYYY hh24:mi:ss'), 'mm') first_day_month_if
     , round(to_date('16.08.2019 11:59:00','dd.mm.YYYY hh24:mi:ss'), 'month') first_day_month_if
     , round(sysdate, 'yyyy') first_day_year_if
     , round(sysdate, 'year') first_day_year_if
  from dual;


-- Extract
select extract(minute from systimestamp) min,-- “олько дл€ TS
       extract(hour from systimestamp) hour,-- “олько дл€ TS
       extract(day from sysdate) day,
       extract(month from sysdate) month,
       extract(year from sysdate) year
  from dual;


-- ƒругие функции
select sysdate current_date
       -- –азница в мес€цах
       ,months_between(to_date('01.07.2019','dd.mm.YYYY'), to_date('01.01.2019','dd.mm.YYYY')) diff_months
       ,round(months_between(to_date('15.07.2019','dd.mm.YYYY'), to_date('01.01.2019','dd.mm.YYYY')),2) diff_months
       -- добавление мес€цев
       ,add_months(sysdate, 12) one_year_plus
       ,add_months(sysdate, -12) one_year_minus
       -- следующий день за указанной датой
       ,next_day(sysdate, 'Monday') next_monday
       -- последний день мес€ца
       ,last_day(sysdate) last_day_month
  from dual;


-- ’итрости
select trunc(sysdate,'yyyy') f_day_year -- первый день года
      , add_months(trunc(sysdate, 'yyyy'), 12) - 1 l_day_year  -- последний день года
      , next_day(add_months(trunc(sysdate,'yyyy'), 12), 'Monday') first_monday -- первый понедельник следующего мес€ца
      , trunc(months_between(trunc(sysdate), to_date('14.07.1983', 'dd.mm.YYYY')) / 12) full_years   
  from dual;



