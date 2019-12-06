---- DEMO. Пользовательские исключения

-- ORA-06510: PL/SQL: unhandled user-defined exception (Вызывающая среда не знает что есть e_no_money).
declare
  e_no_money exception;
  v_money    number(10,2) := 0;
begin
  
  if v_money = 0 then
    raise e_no_money; -- возбуждаем исключение
  end if;

end;
/

------- 
declare
  v_money    number(10,2) := 0;
begin  
  if v_money = 0 then
    raise_application_error(-20100, 'Денег нет, но вы держитесь');
  end if;
end;
/


------ Комбинированный вариант
declare
  e_no_money exception;
  v_money    number(10,2) := 0;
begin
  
  if v_money = 0 then
    raise e_no_money;
  end if;

exception 
  when e_no_money then
     raise_application_error(-20100, 'Денег нет, но вы держитесь');
end;
/
