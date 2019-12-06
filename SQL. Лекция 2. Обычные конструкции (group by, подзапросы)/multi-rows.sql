---- IN 
select employee_id, last_name, job_id, salary
  from hr.employees e1
 where e1.first_name in
       (select e2.first_name from hr.employees e2 where job_id = 'IT_PROG')
   and e1.job_id <> 'IT_PROG';

---- NOT IN 
select employee_id, last_name, job_id, salary
  from employees e1
 where e1.first_name not in
       (select e2.first_name from employees e2 where job_id = 'IT_PROG')
   and job_id <> 'IT_PROG';

----- ANY
select employee_id, last_name, job_id, salary
  from employees
 where salary < any (select salary from employees where job_id = 'IT_PROG')
   and job_id <> 'IT_PROG';

------ ALL
select employee_id, last_name, job_id, salary
  from employees
 where salary < all (select salary from employees where job_id = 'IT_PROG')
   and job_id <> 'IT_PROG';

------ EXISTS
-- 1
select employee_id, last_name, job_id, salary
  from employees e1
 where exists (select 1
          from employees e2
         where job_id = 'IT_PROG'
           and e2.first_name = e1.first_name)
   and job_id <> 'IT_PROG';

-- 2
select employee_id, last_name, job_id, salary
  from employees e1
 where exists (select 1
          from employees e2
         where job_id = 'IT_PROG'
           and e2.first_name = e1.first_name
           and e2.job_id <> e1.job_id);

------ Пустые значения результата
select employee_id, last_name, job_id, salary
  from employees e1
 where e1.first_name in
       (select null from employees e2 where job_id = 'IT_PROG')
   and job_id <> 'IT_PROG';

select employee_id, last_name, job_id, salary
  from employees e1
 where exists (select null
          from employees e2
         where job_id = 'IT_PROG'
           and e2.first_name = e1.first_name)
   and job_id <> 'IT_PROG';
