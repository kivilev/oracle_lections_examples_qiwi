---------- DEMO. VARRAY

--- Пример 1. Коллекция из примитивов
declare
  type t_varr is varray (5) of varchar2 (100 char);
  v_arr t_varr := t_varr();
begin
  v_arr.extend(1);
  v_arr(v_arr.last) := '1st';

  v_arr.extend(1);
  v_arr(v_arr.last) := '2nd';

  v_arr.extend(1);
  v_arr(v_arr.last) := '3th';

  -- перебор в цикле
  for i in v_arr.first..v_arr.last loop
    dbms_output.put_line('index: '||i||'. value: '|| v_arr(i));
  end loop;
  
  dbms_output.put_line('Max size: '||v_arr.limit()); 
  
end;
/

--- Пример 2. Коллекция из записей
declare
  type t_rec is record(
    field_1 user_tables.table_name%type,
    field_2 number(10)
  );

  type t_varr is varray(10) of t_rec;
  v_arr t_varr := t_varr();
begin
  v_arr.extend(1);
  v_arr(1).field_1 := '1й элемент. поле 11';
  v_arr(1).field_2 := 999;

  v_arr.extend(1);
  v_arr(2).field_1 := '2й элемент. поле 12';

  v_arr.extend(1);
  v_arr(3).field_1 := '3й элемент. поле 13';    
  
  -- перебор в цикле
  for i in v_arr.first..v_arr.last loop
    dbms_output.put_line('index: '||i||'. field_1: '|| v_arr(i).field_1||'. field_2: '||v_arr(i).field_2);
  end loop;
  
  dbms_output.put_line('Max size: '||v_arr.limit()); 
end;
/
