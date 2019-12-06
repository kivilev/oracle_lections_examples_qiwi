drop table employees2;

create table employees2 as
Select e.*
  from employees e, (select level from dual connect by level <=10000) t;
  
select count(*) cnt from employees2;

create index employees2_job_i on employees2 (job_id);

begin
   dbms_stats.gather_table_stats(ownname => user, tabname =>  'EMPLOYEES2'); 
end;
/

-- alter session set optimizer_features_enable = '9.0.1';

--- Показать планы
select employee_id, last_name, job_id, salary
  from hr.employees2 e1
 where e1.first_name in
       (select first_name from hr.employees2 e2 where job_id = 'IT_PROG')
   and job_id <> 'IT_PROG';

select employee_id, last_name, job_id, salary
  from hr.employees2 e1
 where exists (select 1
          from hr.employees2 e2
         where job_id = 'IT_PROG'
           and e2.first_name = e1.first_name)
   and job_id <> 'IT_PROG';

