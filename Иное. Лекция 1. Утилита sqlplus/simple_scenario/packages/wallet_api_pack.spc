create or replace package wallet_api_pack is

  -- Author  : D.KIVILEV
  -- Created : 16.03.2020 18:43:42
  -- Purpose : API для работы с таблицей Wallet

  -- создание кошелька
  function create_wallet
  (
    pi_currency_id  wallet.currency_id%type
   ,pi_balance      wallet.balance%type := 0
   ,pi_hold_balance wallet.hold_balance%type := 0
  ) return wallet.wallet_id%type;

  -- удаление кошелька
  procedure delete_wallet(pi_wallet_id wallet.wallet_id%type);

end;
/
