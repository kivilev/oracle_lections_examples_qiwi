SELECT employee_id, last_name
FROM   employees
WHERE  salary = (SELECT   MIN(salary)
                 FROM     employees
                 GROUP BY department_id);
