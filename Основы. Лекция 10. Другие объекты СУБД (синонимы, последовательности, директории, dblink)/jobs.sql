-- Создаем
begin
  dbms_scheduler.create_job(job_name        => 'MY_JOB_NAME',
                            job_type        => '',
                            job_action      => '',
                            start_date      => sysdate + 1/24/60,
                            repeat_interval => '');
end;
/

begin
  dbms_scheduler.enable(name => 'MY_JOB_NAME');
end;
/

begin
  dbms_scheduler.disable(name => 'MY_JOB_NAME', force => true);
end;
/

begin
  dbms_scheduler.run_job(job_name => '', use_current_session => false); 
end;
/


--- Представления
select * from user_scheduler_jobs; -- список джобов
select * from user_scheduler_job_log;  -- лог работы джобов
select * from user_scheduler_job_run_details;  -- детали работы
select * from user_scheduler_running_jobs; -- список работающих джобов на даннй момент

