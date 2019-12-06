------ DEMO. Вложенные таблицы


declare
  type t_arr is table of employees.first_name%type;
  v_arr t_arr := t_arr();
begin  
  -- добавили элемент в коллекцию 
  v_arr.extend(1); -- обязательно расширяем
  v_arr(v_arr.last) := 'val_1';
  v_arr.extend(2);
  v_arr(2) := 'val_2';
  v_arr(3) := 'val_3';
  
  ---- Перебор массива
  for i in v_arr.first..v_arr.last loop
    dbms_output.put_line('i: '||i || '. val: '||v_arr(i));
  end loop;
  
  dbms_output.put_line('---');
  
  ---- Удаляем элемент. Получаем дырку по индексу "2".
  v_arr.delete(2);
  
  ---- Перебор массива (есть дырки)
  -- Такой метод подходит только для плотных коллекций
  for i in v_arr.first..v_arr.last loop
    dbms_output.put_line('i: '||i || '. val: '|| 
                         (case when v_arr.exists(i) then v_arr(i) else 'дырка' end));
  end loop;

end;
/

