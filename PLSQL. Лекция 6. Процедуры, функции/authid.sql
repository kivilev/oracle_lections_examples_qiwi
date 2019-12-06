-- ****************** DEMO. AUTHID. ПРАВА У МОДУЛЕЙ ********************

---- AUTHID DEFINER (по умолчанию)
create or replace procedure print_count_objects
authid current_user
is
  v_res number;
begin
  select count(*) into v_res
    from user_objects;
  dbms_output.put_line(v_res);
end;
/

-- Дали всем грант на исполнения и для простоты сделали Public синоним.
grant execute on print_count_objects to public;
create public synonym print_count_objects for print_count_objects;


/*
 1. Под разными пользователями вызываем 1-ю версию процедуры.  => везде одинаково
 2. Перкомпилим с расскоментированной строкой authid...
 3. Пробуем заново под разными пользователями => везде разный результат
*/

begin
  print_count_objects();
end;
/

