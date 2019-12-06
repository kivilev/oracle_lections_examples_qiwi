--- DEMO. Системные исключения

sys.standard

--ORA-06502: PL/SQL: numeric or value error: character to number conversion error
--ORA-06512: at line 5
declare
  v number;
begin
  select *
    into v
   from dual;
end;
/

-- Вызов исключения в run-time
declare
  v number := 10;
  v2 number := 0;
begin
  v := v/v2;
end;
/

-- Вызов определенного исключения
begin
  raise ZERO_DIVIDE;  
end;
/
