--- DEMO. Системные исключения

sys.standard

--ORA-06502: PL/SQL: numeric or value error: character to number conversion error
declare
  v number;
begin
  select *
    into v
   from dual;
end;
/

-- ORA-01403: no data found
declare
  v number;
begin
  select *
    into v
   from dual
   where 1 = 0;
end;
/

-- ORA-01422: exact fetch returns more than requested number of rows
declare
  v number;
begin
  select *
    into v
   from dual connect by level <= 2;
end;
/

-- Вызов исключения в run-time: ORA-01476: divisor is equal to zero
declare
  v number := 10;
  v2 number := 0;
begin
  v := v/v2;
end;
/

-- Вызов определенного исключения. ORA-01476: divisor is equal to zero
begin
  raise ZERO_DIVIDE;  
end;
/
