create or replace package collect_select_pack is

  -- Author  : D.KIVILEV
  -- Created : 11.11.2019 16:48:29
  -- Purpose : DEMO. Пакетные типы
  
  type t_record is record(
    n1 number,
    n2 number
  );

  type t_array is table of t_record;
  
  procedure demo1;  

end collect_select_pack;
/
create or replace package body collect_select_pack is


end;
/
