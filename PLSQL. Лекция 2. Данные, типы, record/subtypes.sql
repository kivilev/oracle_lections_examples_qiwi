------- DEMO. SUBTYPE

-- sys.standard

declare
  subtype natural99 is binary_integer range 1..99;

  subtype natural99nn is natural99 not null;-- добавили проверку на NULL

  subtype varchar3 is VARCHAR2(32760 char);

  v_nat natural99 := null;
  v_nat_nn natural99nn := 55;
  v_str varchar3 := 'Моя строка';  
  v_str2 varchar3(100) := 'Моя строк2'; 
begin

  dbms_output.put_line('Тип natural99: '||v_nat);  
  dbms_output.put_line('Тип natural99nn: '||v_nat_nn);
  dbms_output.put_line('Тип varchar3: '||v_str);
   dbms_output.put_line('Тип varchar3: '||v_str2);  
end;
/
