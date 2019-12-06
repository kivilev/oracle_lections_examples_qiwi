-------- DEMO. RECORDS.

------ Пример 1. Объявление записей
declare
   -- 1. На основе таблицы
   v_row_1 EMPLOYEES%rowtype;

   -- 2. На основе курсора
   cursor cur_emp is 
    select t.employee_id emmmmp_id,
           t.first_name,
           t.email
      from employees t 
     where t.department_id = 30 
     order by t.employee_id desc;
   
   v_row_2 CUR_EMP%rowtype; -- использовали курсор как определения записи
   
   -- 3. Определяемое вручную
   type t_emp is record(
     emp_id employees.employee_id%type,
     email  varchar2(1000 char),
     dep_id departments.department_id%type not null := 0
   );
   v_row_3 T_EMP; -- использовали новый тип
    
begin
  -- 1. Просто таблица
  select t.*
    into v_row_1 
    from employees t
   where t.employee_id = 100;
    
  -- 2. Курсор
  open cur_emp;
  fetch cur_emp into v_row_2;
  close cur_emp;
  
  -- 3. Выборка из таблицы
  select t.employee_id, t.email, t.department_id
    into v_row_3
    from employees t
   where t.employee_id = 105;
  
  --- Вывод
  dbms_output.put_line('1: '||v_row_1.employee_id); 
  dbms_output.put_line('2: '||v_row_2.emmmmp_id); 
  dbms_output.put_line('3: '||v_row_3.emp_id); 
      
end;
/


