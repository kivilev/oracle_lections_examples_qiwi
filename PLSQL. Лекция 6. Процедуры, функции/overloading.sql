declare
  
  v_res boolean;

  procedure print is -- 1я версия
  begin
    dbms_output.put_line('Nothing print.');
  end;

  procedure print(pi_value3 boolean := true) is -- 2я версия
  begin
    dbms_output.put_line(sys.diutil.bool_to_int(pi_value3)); 
  end;
  
  procedure print(pi_value boolean) is -- 3я версия
  begin
    dbms_output.put_line(sys.diutil.bool_to_int(pi_value)); 
  end;
  
  procedure print(pi_value2 boolean) is -- 4я версия
  begin
    dbms_output.put_line(sys.diutil.bool_to_int(not pi_value2)); 
  end;

  function print(pi_value boolean) return boolean is -- 5я версия
  begin
    dbms_output.put_line(sys.diutil.bool_to_int(not pi_value));
    return pi_value;
  end;
  
  function print(pi_value boolean) return varchar2 is -- 6я версия
  begin
    dbms_output.put_line(sys.diutil.bool_to_int(not pi_value));
    return '';
  end;
  
begin
  --print(pi_value => true);
  null;
end;
/
