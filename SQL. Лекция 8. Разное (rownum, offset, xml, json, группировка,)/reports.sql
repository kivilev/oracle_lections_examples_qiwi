---- DEMO. Функции для очетов
select department_id, sum(salary)
   from  employees  
where  department_id < 60
group by rollup(department_id)
 order by department_id nulls last;

select department_id, sum(salary)
  from employees
 where department_id < 60
 group by cube(department_id)
 order by department_id nulls last;


---- По двум столбцам
select department_id, job_id, sum(salary)
  from employees
 where department_id < 60
 group by rollup(department_id, job_id)
 order by department_id nulls last;

select department_id, manager_id, sum(salary)
  from employees e
 where department_id < 50
 group by cube(department_id, manager_id)
 order by department_id nulls last;

