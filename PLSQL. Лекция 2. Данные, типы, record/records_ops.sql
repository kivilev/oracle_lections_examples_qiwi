-------- DEMO. RECORDS. ОПЕРАЦИИ

------- Пример 1. Сравнение
declare
  type t_type is record(
    field1 number,
    field2 varchar2(10 char)
  );
  v_rec1 t_type;
  v_rec2 t_type;

begin
  v_rec1.field1 := 1;
  v_rec2.field1 := 1;
  
  v_rec1.field2 := null;
  v_rec2.field2 := null;
    
  --if v_rec1 = v_rec2 then  -- НЕ РАБОТАЕТ
  -- Сравниваем по каждому полю. Не забываем про NULL.
  if v_rec1.field1 = v_rec2.field1 and 
     ((v_rec1.field2 = v_rec2.field2) or (v_rec1.field2 is null and v_rec2.field2 is null)) then
     dbms_output.put_line('equals'); 
  else
     dbms_output.put_line('not equals');     
  end if;     
end;
/  


------ Пример 2. Запись в записи
declare
  -- подразделение
  type t_department is record (
    dep_id     departments.department_id%type,
    dep_name   departments.department_name%type
  );
  -- сотрудник
  type t_employee is record(
    emp_id         employees.employee_id%type,
    emp_full_name  varchar2(1000 char),
    department     t_department -- используем новый тип
  );
  
  v_employee t_employee;
begin
  select e.employee_id,
         e.first_name ||' '|| e.last_name,
         --
         d.department_id,
         d.department_name
    into v_employee.emp_id,
         v_employee.emp_full_name,
         --
         v_employee.department.dep_id,
         v_employee.department.dep_name
    from employees e
    join departments d
      on e.department_id = d.department_id
   where e.employee_id = 105;
  
  dbms_output.put_line('Emp name: '||v_employee.emp_full_name ||'. Dep name: '|| v_employee.department.dep_name);
  
end;
/

------- Пример 3. DML
delete from employees t where t.employee_id = 1000;
declare
  v_emp employees%rowtype;
begin
  -- получили запись
  select *
    into v_emp
    from employees t
   where t.employee_id = 105;
  
  v_emp.employee_id := 1000; -- Новое ID
  v_emp.email := '!!new email!!';
  
  insert into employees values v_emp; -- INSERT
  
/*  update employees t set t.* = v_emp
   where employee_id = 1000;*/
  
end;
/

select * from employees t where t.employee_id IN( 1000, 105);





