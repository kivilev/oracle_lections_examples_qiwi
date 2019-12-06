---- ************* DEMO. Кэширование результатов функций *************

create or replace function get_partition_number(pi_date date) return number
result_cache
is
begin
  dbms_session.sleep(1);-- спим 1 сек
  return 1;
end;
/

create or replace function get_partition_number_nrc(pi_date date) return number
is
begin
  dbms_session.sleep(1);-- спим 1 сек
  return 1;
end;
/


-- Дергаем с кэшем
declare
  v number;
begin
  v := hr.get_partition_number(trunc(sysdate)); 
end;
/

-- Дергаем без кэша
declare
  v number;
begin
  v := hr.get_partition_number_nrc(trunc(sysdate)); 
end;
/
