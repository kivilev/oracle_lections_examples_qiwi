-- Примеры арифм операций над датами
select sysdate cur_date
     , sysdate + 1 plus_one_day
     , sysdate + 1/24 plus_one_hour
     , sysdate + 1/2 /* 12/24 или 1/2 или 1/24*12 */  plus_12_hour
     , sysdate + 1/24/60 plus_one_minute    
     , sysdate + 1/24/60/60 plus_one_second
     , sysdate + 1/24/60*15 --???
     , (trunc(sysdate) - trunc(sysdate, 'yyyy'))*24 hours_after_ny
  from dual;

-- ариф операции с интервалами
select sysdate
     , sysdate + interval '3' day plus_3day
     , sysdate + interval '1-2' year to month plus_1y_2m
     , sysdate + interval '-1-6' year to month minus_1y_6m
     , sysdate - interval '1-6' year to month minus_1y_6m
     , sysdate + interval '1 12' day to hour plus_1d_12h
     , sysdate + interval '10:30' minute to second plus_10m_30sec
  from dual;

-- Что будет с TS?
select systimestamp cur_date
     , systimestamp + 1 plus_one_day
     , systimestamp + 1/24 plus_one_hour
     , systimestamp + 1/2 /* 12/24 или 1/2 или 1/24*12 */  plus_12_hour
     , systimestamp + 1/24/60 plus_one_minute    
     , systimestamp + 1/24/60/60 plus_one_second
     , systimestamp + 1/24/60*15 --???
     , (trunc(systimestamp) - trunc(systimestamp, 'yyyy'))*24 hours_after_ny
  from dual;
