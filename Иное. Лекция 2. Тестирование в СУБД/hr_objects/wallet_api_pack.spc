create or replace package wallet_api_pack is

  -- Author  : D.KIVILEV
  -- Created : 24.03.2020 18:43:42
  -- Purpose : API для работы с таблицей Wallet

  -- коды валют
  c_rub_code constant wallet.currency_id%type := 643;
  c_usd_code constant wallet.currency_id%type := 840;

  -- коды ошибок
  c_error_code_wrong_input_param       constant number := -20100;
  c_error_code_manual_change_forbidden constant number := -20999;
  
  -- сообщения ошибок
  c_error_msg_manual_change_forbidden constant varchar2(200 char) := 'Запрещено изменение не через API';
  c_error_msg_negative_balance        constant varchar2(200 char) := 'Баланс не может быть отрицательным';
  c_error_msg_incorrect_currency_code constant varchar2(200 char) := 'Недопустимый код валюты';
  c_error_msg_null_params             constant varchar2(200 char) := 'Параметры не могут быть пустыми';


  ------ API

  -- создание кошелька
  function create_wallet
  (
    pi_currency_id  wallet.currency_id%type
   ,pi_balance      wallet.balance%type := 0
   ,pi_hold_balance wallet.hold_balance%type := 0
  ) return wallet.wallet_id%type;

  -- удаление кошелька
  procedure delete_wallet(pi_wallet_id wallet.wallet_id%type);

  -- тело триггера
  procedure restrict_trigger_body;

end;
/
