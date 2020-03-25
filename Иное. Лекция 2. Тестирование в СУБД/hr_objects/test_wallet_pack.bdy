create or replace package body test_wallet_pack is

  g_wallet_id wallet.wallet_id%type;


  -- получить несуществующий кошелек
  function get_non_exists_wallet return wallet.wallet_id%type;

  --****************** процедура create_wallet

  procedure create_wallet_with_valid_params is
    v_currency_id  wallet.currency_id%type := wallet_api_pack.c_rub_code;
    v_balance      wallet.balance%type := 100;
    v_hold_balance wallet.hold_balance%type := 100;
    v_wallet_row   wallet%rowtype;
  begin
    -- дергаем API
    g_wallet_id := wallet_api_pack.create_wallet(pi_currency_id  => v_currency_id,
                                                 pi_balance      => v_balance,
                                                 pi_hold_balance => v_hold_balance);
    -- провеям данные в таблице  
    select *
      into v_wallet_row
      from wallet t
     where t.wallet_id = g_wallet_id;
  
    ut.expect(v_wallet_row.currency_id, 'Неверная валюта счета').to_equal(v_currency_id);
    ut.expect(v_wallet_row.balance).to_equal(v_balance);
    ut.expect(v_wallet_row.hold_balance).to_equal(v_hold_balance);
  
  end;


  procedure create_wallet_with_wrong_currency is
    v_currency_id  wallet.currency_id%type := -1;
    v_balance      wallet.balance%type := 100;
    v_hold_balance wallet.hold_balance%type := 100;
  begin
    -- дергаем API
    g_wallet_id := wallet_api_pack.create_wallet(pi_currency_id  => v_currency_id,
                                                 pi_balance      => v_balance,
                                                 pi_hold_balance => v_hold_balance);                                                       
  end;


  procedure create_wallet_with_negative_balance
  is
    v_currency_id  wallet.currency_id%type := wallet_api_pack.c_rub_code;
    v_balance      wallet.balance%type := -1;
    v_hold_balance wallet.hold_balance%type := 100;
  begin
    -- дергаем API
    g_wallet_id := wallet_api_pack.create_wallet(pi_currency_id  => v_currency_id,
                                                 pi_balance      => v_balance,
                                                 pi_hold_balance => v_hold_balance);                                                       
  end;
  
  procedure create_wallet_with_null_hold_balance
  is
    v_currency_id  wallet.currency_id%type := wallet_api_pack.c_rub_code;
    v_balance      wallet.balance%type := 100;
    v_hold_balance wallet.hold_balance%type := null;
  begin
    -- дергаем API
    g_wallet_id := wallet_api_pack.create_wallet(pi_currency_id  => v_currency_id,
                                                 pi_balance      => v_balance,
                                                 pi_hold_balance => v_hold_balance);                                                       
  end;
  
  --****************** процедура delete_wallet

  procedure delete_existing_wallet is
  begin
    wallet_api_pack.delete_wallet(pi_wallet_id => g_wallet_id);
  end;


  procedure delete_non_existing_wallet is
    v_wallet_id wallet.wallet_id%type;
  begin
    -- получаем несущетвующий кошель
    v_wallet_id := get_non_exists_wallet();
    -- вызываем API
    wallet_api_pack.delete_wallet(pi_wallet_id => v_wallet_id);
  end;


  procedure delete_wallet_with_null_wallet_id_leads_to_error is
  begin
    -- вызываем API
    wallet_api_pack.delete_wallet(pi_wallet_id => null);
  end;

  ----- другой функционал

  procedure change_wallet_without_api_leads_to_error is
  begin
    -- делаем прямой DML (не учитываются I и U)
    delete from wallet t where 1 = 0;
  end;


  --****************** вспомогательные процедуры

  -- создание кошелька
  procedure create_wallet is
  begin
    dbms_session.set_context('clientcontext', 'force_dml', 'true');
  
    insert into wallet
      (wallet_id
      ,currency_id
      ,balance
      ,hold_balance)
    values
      (wallet_seq.nextval
      ,wallet_api_pack.c_rub_code
      ,0
      ,0)
    returning wallet_id into g_wallet_id;
  
    dbms_session.set_context('clientcontext', 'force_dml', 'false');
  exception
    when others then
      dbms_session.set_context('clientcontext', 'force_dml', 'false');
  end;

  -- удаление кошелька
  procedure delete_wallet is
  begin
    if g_wallet_id is null
    then
      return;
    end if;
  
    dbms_session.set_context('clientcontext', 'force_dml', 'true');
  
    delete wallet where wallet_id = g_wallet_id;
  
    g_wallet_id := null;
  
    dbms_session.set_context('clientcontext', 'force_dml', 'false');
  exception
    when others then
      g_wallet_id := null;
      dbms_session.set_context('clientcontext', 'force_dml', 'false');
  end;

  -- получить несуществующий кошелек
  function get_non_exists_wallet return wallet.wallet_id%type is
    v_wallet_id wallet.wallet_id%type;
  begin
    v_wallet_id := -dbms_random.value(10000, 2000000);
    -- здесь будет запрос проверяющий нет ли такого кошелька и генерящий заново, если есть
    return v_wallet_id;
  end;

end test_wallet_pack;
/
