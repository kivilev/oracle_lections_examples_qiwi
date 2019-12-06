--=========================== LOOP ============================
declare
  v_index pls_integer := 1;
begin
  -- от 1 до 3х
  loop 
    dbms_output.put_line('simple while: '||v_index); 
    v_index := v_index + 1;
    -- условие выхода
    exit when v_index > 3;
  end loop;
 
end;
/

--=========================== WHILE ============================
declare
  v_index pls_integer := 1;
begin  
  -- от 1 до 3х
  while v_index <= 3
  loop    
    dbms_output.put_line('simple while: '||v_index); 
    v_index := v_index + 1;
  end loop;
end;
/

declare
  v_index pls_integer;
begin  
  -- не выполнится
  while v_index <= 3
  loop    
    dbms_output.put_line('simple while: '||v_index); 
    v_index := v_index + 1;
  end loop;
end;
/


--=========================== FOR ============================
begin
  -- Цикл от 1 до 3х (вкл). Шаг: 1
  for i in 1..3 loop
    dbms_output.put_line('simple loop: '||i); 
  end loop;
end;
/

begin
  -- Цикл от с 3-х до 1-го (вкл). Шаг: -1
  for i in reverse 1..3 loop
    dbms_output.put_line('revers loop: '||i); 
  end loop;

  -- Цикл не выполнится!
  for i in reverse 3..1 loop
     dbms_output.put_line('wrong revers loop: '||i);
  end loop;
 
end;
/


--======================== Метки ============================

begin
  
  <<main_loop>>
  for i in 1..10 loop
    dbms_output.put_line('i: '||i);
    
    <<innner_loop>>
    for j in 100..200 loop      
       if j > 102 then -- переход на новую итерацию внешнего цикла
         continue main_loop;
       end if;       
       
       if i > 5 then -- прекращение внешнего цикла
         dbms_output.put_line('exit from main loop');
         exit main_loop; 
       end if;
       
       dbms_output.put_line('j: '||j);       
    end loop inner_loop;
  
  end loop main_loop;

end;
/
