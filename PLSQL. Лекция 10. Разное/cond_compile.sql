---- ************ Условная компиляция ************

----- 1. Создаем пакет
--спека
create or replace package cc_demo_pack is

  function do_some(p_in number) return number;

end;
/
-- тело
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

-- проверяем -> отладочных сообщений нет
begin
  dbms_output.put_line('Result: '||cc_demo_pack.do_some(10));
end;
/  

-- 1 способ
alter package cc_demo_pack compile body plsql_ccflags = 'debug:FALSE' reuse settings;
-- alter package cc_demo_pack compile body plsql_ccflags = 'debug:TRUE' reuse settings;


-- 2 способ
alter session set plsql_ccflags = 'debug:true';
alter package cc_demo_pack compile body;


---- Посмотреть скомпилированный код пакета
begin
  dbms_preprocessor.print_post_processed_source (
    object_type => 'PACKAGE BODY',
    schema_name => user,
    object_name => 'CC_DEMO_PACK');
end;
/



----- Директива ERROR
begin
  -- блок условной компиляции
  $if $$debug $then
     $ERROR 'Cann''t compile with debug = true!' $END
  $end
  null;
end;
/

alter session set plsql_ccflags = 'debug:false';
