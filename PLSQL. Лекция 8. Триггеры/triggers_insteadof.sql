-- ************* DEMO. Instead of триггер *****************

-- 1. Создаем необновляемое view
create or replace view v_dep_emp as 
select d.department_name dep_name, e.employee_id, e.first_name, e.last_name, e.salary
  from departments d
  left join employees e on e.department_id = d.department_id
 order by d.department_name asc;

-- 2. Пытаемся обновить -> ошибка
update v_dep_emp t 
   set t.salary  = 666
 where t.employee_id = 206;


-- 3. Создаем триггер Instead of на Update
create or replace trigger v_dep_emp_inst_u
instead of update
on v_dep_emp
for each row
begin
  -- Важно получить employee_id
  if :new.employee_id is not null then
    if :new.salary >= 0 then -- проверяем допустимость
      -- обновляем
      update employees e 
         set e.salary = :new.salary
       where e.employee_id = :new.employee_id ;
    else
      raise_application_error(-20100,'Зп не может быть отрицательная'); 
    end if;
  end if;
end;

-- 4. Проверяем
select * 
  from v_dep_emp t 
 where t.employee_id = 206;
