-- ************** DEMO. DBMS_SQL ***************

------ Пример 1. Выполнение команд DDL
create or replace procedure exec(string in varchar2) as
    cursor_name integer;
    ret integer;
begin
    cursor_name := dbms_sql.open_cursor;
    dbms_sql.parse(cursor_name, string, dbms_sql.native);
    ret := dbms_sql.execute(cursor_name);
    dbms_sql.close_cursor(cursor_name);
end;
/

begin
  exec('create sequence seq1'); 
end;
/

begin
  exec('drop sequence seq1'); 
end;
/


----- Пример 2. DML с использованием коллекций
declare
  v_stmt varchar2(200);
  v_empno_array     dbms_sql.number_table;
  v_salary_array    dbms_sql.number_table;
  c               number;
  dummy           number;
begin
 
  v_empno_array(1):= 100;
  v_empno_array(2):= 101;
  v_empno_array(3):= 102;
  v_empno_array(4):= 103;
 
  v_salary_array(1) := 666;
  v_salary_array(2) := 777;
  v_salary_array(3) := 888;
  v_salary_array(4) := 999;
 
  v_stmt := 'update employees 
                set salary = :salary_array
              where employee_id = :num_array';
            
  c := dbms_sql.open_cursor;
  dbms_sql.parse(c, v_stmt, dbms_sql.native);
  dbms_sql.bind_array(c, ':num_array', v_empno_array);
  dbms_sql.bind_array(c, ':salary_array', v_salary_array);
  dummy := dbms_sql.execute(c);
  dbms_sql.close_cursor(c);
 
exception when others then
  if dbms_sql.is_open(c) then
    dbms_sql.close_cursor(c);
  end if;
  raise;
end;
/

-- проверяем
select t.employee_id, t.salary 
  from employees t where t.employee_id in (100, 101, 102, 103);


------ Пример 3. Переменное количество столбцов
create or replace procedure get_employees(p_cols varchar2, p_where varchar2 := '')
is
  v_cur   pls_integer;
  v_cols  dbms_sql.desc_tab;
  v_ncols pls_integer;
  v_res number;
  
  function print_type(p_type_id number)
  is
  begin
    
  end;
begin
  -- открываем курсор
  v_cur := dbms_sql.open_cursor;

  -- Разбор запроса
  dbms_sql.parse(v_cur,
                 'select '||p_cols||' from employees '||p_where,
                 dbms_sql.native);

  -- Получение информации о столбцах
  dbms_sql.describe_columns(v_cur, v_ncols, v_cols);

  -- Вывод каждого из имен столбцов
  for colind in 1 .. v_ncols loop
    dbms_output.put_line(v_cols(colind).col_name||': '||print_type(v_cols(colind).col_type));
  end loop;

  v_res := dbms_sql.execute (v_cur);

  -- .... большая процедура разбора получившегося результата.

  dbms_sql.close_cursor(v_cur);
end;
/


begin
  -- get_employees('salary');
  get_employees('salary, salary*0.1 avans');
  -- get_employees('first_name', 'where employee_id = 100');
end;
/








