---- DEMO. Возможности смещения окна

-- как в примере из лекции, только окно из трех строк
select max(salary) over(partition by department_id order by salary rows between current row and 2 FOLLOWING ) ma_salary,
       max(t.employee_id) over(partition by department_id order by salary rows between current row and 2 FOLLOWING) min_employee_id,
       t.employee_id,
       t.department_id,
       t.salary       
  from employees t
 where t.department_id in (30, 50)
 order by department_id, salary;

-- обратная ситуация, -2 строки + текущая.
select min(salary) over(partition by department_id order by salary rows between 2 preceding and current row) min_salary,
       min(t.employee_id) over(partition by department_id order by salary rows between 2 preceding and current row) min_employee_id,
       t.employee_id,
       t.department_id,
       t.salary       
  from employees t;
