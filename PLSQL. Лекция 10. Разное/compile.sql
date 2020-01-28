---- ************ Условная компиляция ************
create or replace package cc_demo_pack is

  function do_some(p_in number) return number;

end;
/

create or replace package body cc_demo_pack is

  g_debug boolean := false; -- флажок включен ли у нас дебаг режим. По умолч выключен.

  -- процедура показываюшая сообщения
  procedure show_log(p_msg varchar2)
  is
  begin
    if g_debug then
      dbms_output.put_line(p_msg);
    end if;
  end;

  function do_some(p_in number) return number
  is
    v_res number;
  begin
    show_log('p_in: '|| p_in);
    v_res := p_in + 1;
    show_log('v_res: '|| v_res);
    return v_res;
  end;

begin
  -- блок условной компиляции
  $if $$debug $then
    dbms_output.enable(100000);
    g_debug := true;
  $end
  null;
end;
/




