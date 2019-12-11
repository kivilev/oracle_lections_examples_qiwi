-- *********** DEMO. Ошибка состояния ***************

drop package demo_pack;

create or replace package demo_pack is
  g_var number;
   
  function my_func return number;
end;
/

create or replace package body demo_pack is
   
  function my_func return number
  is
  begin
    return 1;
  end;
  
end;
/

-- изменяем
alter package demo_pack compile;
alter package demo_pack compile body;


-- в другой сессии
select demo_pack.my_func() call_res from dual;

