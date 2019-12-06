create or replace package my_pkg is
  procedure my_prc;
end my_pkg;
/
create or replace package body my_pkg is

  g_var number := 0; -- глобальная/пакетная переменная

  procedure my_prc is
    v_var2 number := my_pkg.g_var + 1;
  begin
    declare
      v_var2 number := 2;
    begin
      dbms_output.put_line(v_var2); -- локальная переменная
      dbms_output.put_line(my_prc.v_var2); -- переменная из родительского блок
      dbms_output.put_line(my_pkg.my_prc.v_var2);
      dbms_output.put_line(g_var); -- глобальная переменная
    end;
  end;
  
end my_pkg;
/
