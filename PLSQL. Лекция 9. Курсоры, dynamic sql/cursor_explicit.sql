-- ************** Явные курсоры (explicit) ***************


----- Пример 1. Простой SQL. Построчная выборка
declare
  cursor cur_emps is
    select e.employee_id, e.first_name||' '||e.last_name full_name, e.salary
      from employees e
     where rownum <= 10;
  v_rec cur_emps%rowtype;
begin
  open cur_emps; -- открытие
  
  -- проход по полученным строкам
  loop
    fetch cur_emps into v_rec;
    exit when cur_emps%notfound;
    
    dbms_output.put_line(v_rec.employee_id||'. '||v_rec.full_name||' - ' ||v_rec.salary ||'$'); 

  end loop;

  close cur_emps; -- закрытие
end;
/

------- Пример 2. Параметризованный курсор
declare
  -- параметр курсора - p_num_rows
  cursor cur_emps(p_num_rows number) is
    select e.employee_id, e.first_name||' '||e.last_name full_name, e.salary
      from employees e
     where rownum <= p_num_rows;
  
  v_rec cur_emps%rowtype;
begin
  open cur_emps(10); -- открытие
  
  -- проход по полученным строкам
  loop
    fetch cur_emps into v_rec;
    exit when cur_emps%notfound;
    
    dbms_output.put_line(v_rec.employee_id||'. '||v_rec.full_name||' - ' ||v_rec.salary ||'$'); 

  end loop;

  close cur_emps; -- закрытие
end;
/


------- Пример 3. Параметризованный курсор с выборкой в коллекцию
declare
  -- параметр курсора - p_num_rows
  cursor cur_emps(p_num_rows number) is
    select e.employee_id, e.first_name||' '||e.last_name full_name, e.salary
      from employees e
     where rownum <= p_num_rows;

  type t_array is table of cur_emps%rowtype;
  v_array t_array;
begin
  open cur_emps(18); -- открытие
  
  -- проход по полученным строкам
  loop
    fetch cur_emps bulk collect into v_array limit 5;
    
    dbms_output.put_line('Count current array: '||v_array.count());
    -- цикл прохода по v_array
        
    exit when cur_emps%notfound;
  end loop;

  close cur_emps; -- закрытие
end;
/

------ Пример 4. Курсор с обновлением некоторых строк
declare
  cursor cur_emps is
    select e.employee_id, e.first_name||' '||e.last_name full_name, e.salary
      from employees e
       for update ;
  v_rec cur_emps%rowtype;
begin
  open cur_emps; -- открытие
  
  -- проход по полученным строкам
  loop
    fetch cur_emps into v_rec;
    exit when cur_emps%notfound;
    
    if v_rec.salary >= 10000 then
      update employees e
         set e.salary = 666
       where current of cur_emps;
    end if;

  end loop;

  close cur_emps; -- закрытие
end;
/

-- select * from employees t where t.salary = 666;


