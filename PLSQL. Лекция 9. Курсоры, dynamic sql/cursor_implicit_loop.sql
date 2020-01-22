-- *************** Неявный курсор в цикле *******************

-- Пример 1. Простой запрос
begin
  for v_rec in (select * from employees) loop
    dbms_output.put_line(v_rec.employee_id || ': ' || v_rec.first_name || ': ' ||  v_rec.salary);
  end loop;
end;
/


-- Пример 2. Параметризированный запрос
declare
  -- процедура печати
  procedure print(pi_employee_id employees.employee_id%type)
    is
  begin
    -- цикл по курсору
    for v_rec in (select t.employee_id
                       , t.first_name||' '||t.last_name full_name
                       , t.salary
                    from employees t 
                   where t.employee_id = pi_employee_id) loop

      dbms_output.put_line(v_rec.employee_id || ': ' || v_rec.full_name || ': ' ||  v_rec.salary);

    end loop;
  end;
  
begin
  print(100);
  dbms_output.put_line('---'); 
  print(101);  
end;
/

-- Пример 3. Вначале формируется результирующая выборка затем проходим по курсору
create or replace type t_ids is table of number;
/

-- для чистоты эксперимента создадим pipelined функцию, которая будет отдавать данные по мере их готовности
create or replace function pipe_func return t_ids
pipelined
is
begin
  for i in (select level lvl from dual connect by level <= 5) loop
      dbms_session.sleep(1);
      pipe row(i.lvl);
  end loop;

  return;
end;
/

declare
  procedure run
    is
  begin
    -- неявный курсор в цикле
    for v_rec in (select value(t) lvl 
                    from pipe_func() t ) loop

      dbms_output.put_line(v_rec.lvl||' - ' || to_char(sysdate, 'hh24:mi:ss')); 

    end loop;
  end;
  
begin
  run();
end;
/
