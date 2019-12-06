---- DEMO. IF - THEN - ELSE

----- IF THEN ELSE
declare
  v number := 1;
begin
  if v = 1 then
    dbms_output.put_line('v = 1'); 
  elsif v = 2 then
    dbms_output.put_line('v = 2'); 
  else
    dbms_output.put_line('v is ?'); 
  end if;    
end;
/

----- CASE. DECODE нет.
declare
  v number := 1;
  a number;
begin  
  --- case в режиме функции
  a := (case when v = 1 then 100 else 0 end);
  dbms_output.put_line('a = '||a);
  
  --- case в режиме switch
  case v
    when 1 then a := 200; dbms_output.put_line('v = 1'); 
    when 2 then a := 300; dbms_output.put_line('v = 2'); 
    else a := 0; 
  end case;
  dbms_output.put_line('a = '||a);
  
end;
/

---- Ленивый IF
declare
  function proc1 return boolean
  is
  begin
    dbms_output.put_line('proc1'); 
    return false;
  end;

begin
  if true or proc1() then
    dbms_output.put_line('2'); 
  end if;
end;
/
