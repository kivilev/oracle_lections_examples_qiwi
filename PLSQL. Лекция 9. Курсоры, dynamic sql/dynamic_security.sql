-- ********** DEMO. Безопасность **********

----- Процедура отдающая динамически инфу в зависимости от фильтра
create or replace function get_employees(p_where varchar2) return sys_refcursor
is
  v_out sys_refcursor;
begin
  open v_out for 'select employee_id, first_name ||'' ''|| last_name
                    from employees
                   where '||p_where;

  return v_out;
end;
/

----- Зловредный "клиент"
declare 
  v_cur sys_refcursor;
  type t_emp_rec is record (id employees.employee_id%type
                            ,full_name varchar2(400 char));
  v_rec t_emp_rec;
begin
  -- получаем курсор
  v_cur := get_employees('employee_id = 100');

  -- идем по нему 
  loop
    fetch v_cur into v_rec;
    exit when v_cur%notfound;
   
    dbms_output.put_line(v_rec.id ||': '||v_rec.full_name); 
      
  end loop;
  
  -- закрываем курсор
  close v_cur;  
end;
/








-- Варианты инъекций
--v_cur := get_employees('employee_id = 10 or 1=1');  
--v_cur := get_employees('employee_id = 100 or 1=1 union all select employee_id, to_char(salary) from employees');  
