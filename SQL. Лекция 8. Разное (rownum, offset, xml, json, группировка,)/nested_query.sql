------ DEMO. Связные подзапросы

select * 
  from employees e
 where e.salary >= (select avg(salary)
                      from employees e2
                     where e2.department_id = e.department_id);

-- Что делать, если нам нужна ср зп в выводе?

-- переписанный запрос
select avg_emp.avg_salary, e.salary, e.*
  from (select department_id, round(avg(salary),2) avg_salary
          from employees e2
         group by e2.department_id) avg_emp
  join employees e on e.department_id = avg_emp.department_id and e.salary >= avg_emp.avg_salary;

-- Что не учитывают это равенства?
