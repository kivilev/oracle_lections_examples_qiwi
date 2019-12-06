--*************  DEMO. Параметры процедур ***********************

-------- 1) Режимы передачи ---------
declare
  v_param1 number := 1;
  v_param2 number := 2;
  v_param3 number := 3;
  
  ---- локальная процедура
  procedure prc( pi_param1 in number  -- вх
                ,pi_param2 out number -- вых
                ,pi_param3 in out number -- вх + вых
               ) is
  begin
    dbms_output.put_line('p1: '||pi_param1 ||'. p2: '||pi_param2||'. p3: '||pi_param3 ); 
    --pi_param1 := 100; нельзя изменять IN параметр
    pi_param2 := pi_param3 + 100;
    pi_param3 := 300;
  end;
 
begin
  -- вызов
  prc(v_param1, v_param2, v_param3);
  
  dbms_output.put_line('loc param2: '||v_param2); 
  dbms_output.put_line('loc param3: '||v_param3); 
end;
/


------- 2) Нахождение default значений ------

declare
  v_param1 number := 1;
  v_param2 number := 2;
  v_param3 number := 3;
  
  procedure prc( pi_param1 in number default 0
                ,pi_param2 in number 
                ,pi_param3 out number) is
  begin
    dbms_output.put_line('p1: '||pi_param1 ||'. p2: '||pi_param2||'. p3: '||pi_param3 ); 
    pi_param3 := 300;
  end;
  
begin
  -- вызов
  prc(v_param1, v_param2, v_param3);
  
  -- что делать, если хочется вызвать с pi_param1 = default?
  prc(pi_param2 => v_param2, pi_param3 => v_param3);
  
  dbms_output.put_line('loc param1: '||v_param1);   
  dbms_output.put_line('loc param2: '||v_param2); 
  dbms_output.put_line('loc param3: '||v_param3); 
end;
/


------ 3)  Еще один пример с default значениями.
alter session set NLS_DATE_LANGUAGE = RUSSIAN;
alter session set NLS_DATE_FORMAT = 'dd.MON.YYYY';

declare
  -- процедура с default значениями
  procedure prc( pi_param1 in number 
                ,pi_param2 in number := 200
                ,pi_param3 in date := date'1983-07-14') is
  begin
    dbms_output.put_line('p1: '||pi_param1 ||'. p2: '||pi_param2||'. p3: '||pi_param3 ); 
  end;
  
begin

  -- один обязательный
  prc(1);

  -- два параметра
  prc(1, 2);

  -- все три параметра
  prc(1, 2, date'1984-01-21');
  
  -- позиционный вызов
  prc(pi_param3 => date'1984-01-21', pi_param1 => -1);
  
end;
/


------ 4) Функция, которая возвращает значения и в вых параметрах и в return
declare
  v_param1 number := 1;
  v_param2 number := 2;
  v_param3 number := 3;
  v_param4 number;
    
  -- процедура с default значениями
  function my_fun( pi_param1 in  number     := 100
                ,pi_param2   in  out number
                ,pi_param3   out number) return number is
  begin
    dbms_output.put_line('p1: '||pi_param1 ||'. p2: '||pi_param2||'. p3: '||pi_param3 ); 
    pi_param2 := -1;
    pi_param3 := -2;
    return -3;
  end;
  
begin
  v_param4 := my_fun(v_param1, v_param2, v_param3);
  
  dbms_output.put_line('loc param1: '||v_param1);   
  dbms_output.put_line('loc param2: '||v_param2); 
  dbms_output.put_line('loc param3: '||v_param3); 
  dbms_output.put_line('loc param4: '||v_param4);   
end;
/


