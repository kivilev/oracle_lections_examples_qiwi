create or replace package collect_select_pack is

  -- Author  : D.KIVILEV
  -- Created : 11.11.2019 16:48:29
  -- Purpose : DEMO. Пакетные типы

  type t_record is record(
    n1 number,
    n2 number);

  type t_array is table of t_record;

  procedure demo1;

end collect_select_pack;
/
create or replace package body collect_select_pack is
  function varrya2str(pi_arr utl_call_stack.unit_qualified_name) return varchar2
  is
    v_out varchar2(32000);
  begin
    
    if pi_arr.count > 0 then
      for i in pi_arr.first..pi_arr.last loop
        v_out := v_out ||'.'||pi_arr(i);
      end loop;
    end if;  

    return lower(substr(v_out,2));
  end;

  procedure demo2 is
  begin
    dbms_output.put_line(varrya2str(utl_call_stack.subprogram(dynamic_depth => 1)));
  end;

  procedure demo1 is
  begin
    demo2;
  end;

end;
/
