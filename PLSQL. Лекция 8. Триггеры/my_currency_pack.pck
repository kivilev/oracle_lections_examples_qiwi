create or replace package my_currency_pack is
  -- внутренний тип
  type t_curr_code is table of currency.iso_code%type index by pls_integer;

  -- функция возвращающая код
  function get_code_by_curr_id(pi_curr_id currency.curr_id%type) return currency.iso_code%type;

  -- реализация с result_cache
  function get_code_by_curr_id_rc(pi_curr_id currency.curr_id%type) return currency.iso_code%type result_cache;

  -- обычная реализация
  function get_code_by_curr_id_simple(pi_curr_id currency.curr_id%type) return currency.iso_code%type;

end;
/
create or replace package body my_currency_pack is

  g_currency_array t_curr_code;

  -- функция возвращающая код
  function get_code_by_curr_id(pi_curr_id currency.curr_id%type) return currency.iso_code%type
  is
    v_out currency.iso_code%type := null;
  begin
    if g_currency_array.exists(pi_curr_id) then
      v_out := g_currency_array(pi_curr_id);
    end if;
    return v_out;
  end;
  
  -- реализация с result_cache
  function get_code_by_curr_id_rc(pi_curr_id currency.curr_id%type)
  return currency.iso_code%type 
  result_cache 
  is
    v_out currency.iso_code%type := null;
  begin
    begin
      select c.iso_code
        into v_out
        from currency c
       where c.curr_id = pi_curr_id;
    exception
      when no_data_found or too_many_rows then
        null;
    end;
    return v_out;
  end;
  
  -- Обычная процедура
  function get_code_by_curr_id_simple(pi_curr_id currency.curr_id%type)
  return currency.iso_code%type
  is
    v_out currency.iso_code%type := null;
  begin
    begin
      select c.iso_code
        into v_out
        from currency c
       where c.curr_id = pi_curr_id;
    exception
      when no_data_found or too_many_rows then
        null;
    end;
    return v_out;
  end;


-- блок инициализации
begin
  -- кэшируем справочник
  for i in (select * from currency) loop
    g_currency_array(i.curr_id) := i.iso_code;
  end loop;
end;
/
