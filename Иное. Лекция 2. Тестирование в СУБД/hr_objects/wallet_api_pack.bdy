create or replace package body wallet_api_pack is

  g_is_api boolean := false;

  -- создание кошелька
  function create_wallet
  (
    pi_currency_id  wallet.currency_id%type
   ,pi_balance      wallet.balance%type := 0
   ,pi_hold_balance wallet.hold_balance%type := 0
  ) return wallet.wallet_id%type is
    v_res wallet.wallet_id%type;
  begin
    -- проверяем входные параметры
    if pi_currency_id is null
       or pi_balance is null
       or pi_hold_balance is null
    then
      raise_application_error(c_error_code_wrong_input_param,
                              c_error_msg_null_params);
    end if;
        
    if pi_balance < 0
       or pi_hold_balance < 0
    then
      raise_application_error(c_error_code_wrong_input_param,
                              c_error_msg_negative_balance);
    end if;
      
    if pi_currency_id not in (c_rub_code, c_usd_code)
    then
      raise_application_error(c_error_code_wrong_input_param,
                              c_error_msg_incorrect_currency_code);
    end if;

    -- вставка
    begin
      g_is_api := true;
      -- вставка
      insert into wallet
        (wallet_id
        ,currency_id
        ,balance
        ,hold_balance)
      values
        (wallet_seq.nextval
        ,pi_currency_id
        ,pi_balance
        ,pi_hold_balance)
      returning wallet_id into v_res;
    
      g_is_api := false;
    
      return v_res;
    exception
      when others then
      
        g_is_api := false;
        raise;
    end;
  
  end;

  -- удаление кошелька
  procedure delete_wallet(pi_wallet_id wallet.wallet_id%type) is
  begin
    -- проверяем входные параметры
    if pi_wallet_id is null
    then
      raise_application_error(c_error_code_wrong_input_param,
                              c_error_msg_null_params);
    end if;
  
    begin
      g_is_api := true;
      delete from wallet t where t.wallet_id = pi_wallet_id;
      g_is_api := false;
    exception
      when others then
        g_is_api := false;
        raise;
    end;
  end;

  -- тело триггера
  procedure restrict_trigger_body is
  begin
  
    -- запрещаем изменения не из API
    if not (g_is_api or
        nvl(sys_context('clientcontext', 'force_dml'), 'false') = 'true')
    then
      raise_application_error(c_error_code_manual_change_forbidden,
                              c_error_msg_manual_change_forbidden);
    end if;
  end;

end;
/
