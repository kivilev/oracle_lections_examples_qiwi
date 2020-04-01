create or replace package body wallet_api_pack is

  -- создание кошелька
  function create_wallet
  (
    pi_currency_id  wallet.currency_id%type
   ,pi_balance      wallet.balance%type := 0
   ,pi_hold_balance wallet.hold_balance%type := 0
  ) return wallet.wallet_id%type is
    v_res wallet.wallet_id%type;
  begin
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
  
    return v_res;
  
  end;

  -- удаление кошелька
  procedure delete_wallet(pi_wallet_id wallet.wallet_id%type) is
  begin
    delete from wallet t where t.wallet_id = pi_wallet_id;
  end;

end;
/
