----- DEMO. Операции с коллекциями

declare
  type t_arr is table of number(2);
  A t_arr := t_arr();
  B t_arr := t_arr();
  C t_arr := t_arr();
  CD t_arr := t_arr();
  v_obj number := 10;
  
  -- печать
  procedure print(P t_arr) is
  begin
    for i in P.first..P.last loop
      dbms_output.put_line(chr(9)||P(i)); 
    end loop;
    dbms_output.put_line(chr(9)||'--'); 
  end;   
  
begin
  A.extend(3);
  A(1) := 1;
  A(2) := 2;
  A(3) := 2;
    
  B.extend(3);
  B(1) := 2;
  B(2) := 3;
  B(3) := 3;
    
  ------- 1. Равенство
  if A = B or B = B then -- NULL не даст равенство
    dbms_output.put_line('1) Равенство выполняется'); 
  else
    dbms_output.put_line('1) Равенство не выполняется'); 
  end if;
  
  ------- 2. А минус B. Distinct - оставляет только уникальные элементы
  dbms_output.put_line('2) Минус:'); 
  C := A multiset except B; 
  print(C);
  CD := A multiset except distinct B;
  print(CD);
  
  ------- 3. A пересечение с B.
  dbms_output.put_line('3) Пересечение:'); 
  C := A multiset intersect B;
  print(C);
  CD := A multiset intersect distinct B; --изменить 2 в множестве B.
  print(CD);
    
  ------- 4. Только уникальные элементы + проверка на уникальность
  C := set(A); -- 1, 2
  dbms_output.put_line('4) Только уникальные. Count "C": '|| C.count);
  print(C);

  dbms_output.put_line('4) Проверка на уникальнось. '||(case 
                                                         when a is a set 
                                                           then 'Уникально' 
                                                         else 'Не уникально' end));
  
  -------- 5. Есть ли такой элемент в коллекции (часто используется)
  if v_obj member of A then
    dbms_output.put_line('5) "'||v_obj|| '" есть среди элементов коллекции.'); 
  else
    dbms_output.put_line('5) "'||v_obj|| '" НЕТ среди элементов коллекции.'); 
  end if;
  
  -------- 6. Является ли А подмножеством B
  if t_arr(2,3, 5) submultiset B then
    dbms_output.put_line('6) Является подмножеством B.'); 
  else
    dbms_output.put_line('6) Не является подмножеством B.'); 
  end if;

end;
/
