------------ DEMO. OFFSET. Only Oracle 12.1+

-- с 10 по 19 записи (10 строк)
select t.*
  from employees t
 order by t.employee_id
offset 9 rows
fetch next 10 rows only;

-- 5% случайных строк
select t.*
  from employees t
order by dbms_random.value()
    offset 0 row
fetch next 5 percent rows only;


