--- DEMO. Rownum

-- 1) пять записей, после чего происходит сортировка
select *
  from employees
 where rownum <= 5
 order by salary asc;

-- 2) ничего не вернет (неверное условие)
SELECT *
  FROM employees
  WHERE rownum > 1;

-- 3) вернет с 2й записи (условие верное)
select *
  from (select rownum rn,
               a.*
          from (select *
                  from employees e
                 order by e.hire_date) a)
 where rn > 1;

