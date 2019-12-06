------- DEMO. Ассоциативный массив
declare
  type t_arr is table of emp.fio%type index by varchar2(100 char);
  
  v_arr t_arr; -- можно не инициализировать  
  v_key varchar2(100 char);-- ключ для цикла
begin  
  -- добавили элемент в коллекцию 
  -- v_arr.extend(1); -- Не надо расширять
  v_arr('key1') := 'val_1';
  v_arr('key6') := 'val_2';
  v_arr('key9') := 'val_3';
  v_arr('aaaa') := 'val_4';
  v_arr('key_del') := 'val_5';
  --v_arr('') := 'val_null';

  -- удаляем запись по ключу
  v_arr.delete('key_del');
 
  -- проход по циклу. так поскольку ключем м.б. и v2 и number
  -- ключи в отсортированном порядке
  v_key := v_arr.first;
  while v_key is not null loop
    dbms_output.put_line('key: '||v_key ||'. val: ' || v_arr(v_key));
    v_key := v_arr.next(v_key);
  end loop;
  
  -- Обращаемся к "левому" ключу. Получаем ошибку No data found.
  -- dbms_output.put_line(v_arr('key_none'));

end;
/
