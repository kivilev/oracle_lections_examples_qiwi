----- DEMO. Опережающее объявление

/*
  Решение:
  1. Перенести A выше B
  2. Сделать опережающее объявление A
*/
declare
  procedure B is
  begin
    dbms_output.put_line('B');
    A();
  end;
  
  procedure A is
  begin
    dbms_output.put_line('A'); 
  end;

begin
  B();
end;
/

