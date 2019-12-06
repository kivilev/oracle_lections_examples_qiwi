------- ДЕМО. МЕТКИ

-- Выполнять в sqlplus!
<<main_block>>
declare
  v_var number := 1;
begin
  
  <<local_block>>  
  declare
    v_var number := 2;
  begin
    -- Одно и тоже
    dbms_output.put_line('Local: '|| v_var);
    dbms_output.put_line('Local: '|| local_block.v_var);
    -- Родительский блок
    dbms_output.put_line('Main: '|| main_block.v_var);
  end local_block;

end main_block;
/
