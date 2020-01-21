-- ************* Курсорные переменные *****************


--------- Пример 1. Пользовательская курсорная переменная.
declare
  type  t_my_cur is ref cursor;
  v_cur t_my_cur;
  v_row employees%rowtype;
begin
  -- открываем
  open v_cur for select * from employees;
  
  loop
     fetch v_cur into v_row;
     exit when v_cur%notfound;
     dbms_output.put_line('id: '||v_row.employee_id||'. salary: '||v_row.salary);      
  end loop;
  
  -- закрываем
  close v_cur;
  
exception when others then
  if v_cur%isopen then
    close v_cur;
  end if;
  raise;
end;
/

---------- Пример 2. Передача курсорной переменной

---- 1) Создаем пакет с функционалом
create or replace package employee_pack is

  -- получить список сотрудников по имени
  function get_employees_by_name(pi_name employees.first_name%type) return sys_refcursor;
  
  -- получить сотрудника по ID
  function get_employees_by_id(pi_employee_id employees.employee_id%type) return sys_refcursor;
  
end;
/

create or replace package body employee_pack is

  function get_employees_by_name(pi_name employees.first_name%type) return sys_refcursor
  is
    v_out sys_refcursor;
  begin
    open v_out for select *  
                     from employees t
                    where t.first_name = pi_name
                    order by t.employee_id;
    return v_out;
  end;

  -- получить сотрудника по ID
  function get_employees_by_id(pi_employee_id employees.employee_id%type) return sys_refcursor
  is
    v_out sys_refcursor;
  begin
    open v_out for select * 
                     from employees t
                    where t.employee_id = pi_employee_id
                    order by t.employee_id;
    return v_out;
  end;

end;
/


---- 2) Тестируем
declare
  v_cur sys_refcursor;
  v_row employees%rowtype;

  -- печать результатов
  procedure print(pi_cur sys_refcursor)
  is
  begin
    loop
      fetch pi_cur into v_row;
      exit when v_cur%notfound;
       dbms_output.put_line('id: '||v_row.employee_id||'. first_name: '|| v_row.first_name ||'. salary: '||v_row.salary);      
    end loop;
  end;

begin
  dbms_output.put_line('----- get_employees_by_name');   
  v_cur := employee_pack.get_employees_by_name('David');
  print(v_cur);

  dbms_output.put_line('----- get_employees_by_id'); 
  v_cur := employee_pack.get_employees_by_id(100);
  print(v_cur);
  
end;
/

