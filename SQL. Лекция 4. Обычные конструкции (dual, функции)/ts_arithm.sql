--create table del$tab as 
select systimestamp cur_ts
     , systimestamp + interval '1' month plus_1month
     , sysdate + interval '1' month plus_1month_date -- с DATE это тоже работает
     , systimestamp + interval '1' day + interval '30' minute plus_1day_30min     
     , systimestamp - (systimestamp + interval '2' day) col2
  from dual;
  
