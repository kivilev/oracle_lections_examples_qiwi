------ Задача пагинация по сотрудникам. Получить с N по M записи.

---- Способ 1. Rownum + order by
select * 
  from (select rownum rn, 
               a.*
          from (select *
                  from employees e
                 order by e.employee_id) a
         where rownum < 20)
 where rn >= 10;

---- Способ 2. Аналитическая функция row_number
select *
  from (select row_number() over(order by t.employee_id) rn, 
               t.*
          from employees t) a
 where a.rn between 10 and 19;
 
---- Способ 3. Использование расширения SQL c Oracle 12c.
select *
  from employees t 
 order by T.EMPLOYEE_ID 
 offset 9 rows fetch next 10 rows only;






---------------------- СКОРОСТЬ? РЕСУРСЫ? ------------------------------------------------
--- Создаем 1М 
drop table employees_big;
create table employees_big as
select e.employee_id,
       e.first_name,
       e.last_name,
       e.email,
       e.phone_number,
       e.hire_date + lvl hire_date,
       e.job_id,
       e.salary,
       e.commission_pct,
       e.manager_id,
       e.department_id
  from employees e, (select level lvl from dual connect by level <=10000);

-- SQLPLUS. Включаем стату.
set autotrace traceonly;
select * 
  from (select rownum rn, 
               a.*
          from (select *
                  from employees_big e
                 order by e.hire_date) a
         where rownum <= 500100)
 where rn >= 500000;

---- Способ 2. Аналитическая функция row_number
select *
  from (select row_number() over(order by t.hire_date) rn, 
               t.*
          from employees_big t) a
 where a.rn between 500000 and 500100;
 
---- Способ 3. Использование расширения SQL c Oracle 12c.
select *
  from employees_big t 
 order by hire_date 
 offset 500000 rows fetch next 100 rows only;


  
  
