begin
   dbms_result_cache.memory_report();
end;
/   

select COUNT(*) from v$result_cache_objects t where t.NAME like '%GET_PARTITION_NUMBER%';

select * from v$result_cache_objects t where t.NAME like '%GET_PARTITION_NUMBER%';


declare
  v_res boolean;
begin
  sys.dbms_result_cache.bypass (true);
  v_res := sys.dbms_result_cache.Flush();
  sys.dbms_result_cache.bypass (false);  
end;
/ 

select sys.dbms_result_cache.status from dual;

select * from v$result_cache_statistics
