---- DEMO. LISTAGG

-- обычно применение
select t.department_id,
       listagg(t.first_name, ', ') within group(order by t.first_name) as all_dept_first_names
  from employees t
 group by t.department_id
 order by t.department_id;


-- переполнение с ошибкой
select t.department_id,
       listagg(rpad(t.first_name, 300,'_'), ', ' on overflow error) within group(order by t.first_name) as all_dept_first_names
  from employees t
 group by t.department_id
 order by t.department_id;

-- переполнение Без ошибки + разделитель еще
select t.department_id,
       listagg(rpad(t.first_name, 300,'_'), ', ' ON OVERFLOW truncate 'еще') within group(order by t.first_name) as all_dept_first_names
  from employees t
 group by t.department_id
 order by t.department_id;


