create or replace package test_wallet_api_pack is

  -- Author  : D.KIVILEV
  -- Created : 24.03.2020 18:21:21
  -- Purpose : Тестирование пакета wallet_pack_api

  --%suite(Test wallet_api_pack)
  --%suitepath(wallet)

  ----- кейсы для процедуры create_wallet_one

  --%test(Создание кошелька с валидными параметрами API)
  --%aftertest(delete_wallet_one)
  procedure create_wallet_with_valid_params;

  --%test(Создание кошелька с недопустимой валютой приводит к ошибке)
  --%aftertest(delete_wallet_one)
  --%throws(-20100)  
  procedure create_wallet_with_wrong_currency;

  --%test(Создание кошелька с отрицательным балансом приводит к ошибке)
  --%aftertest(delete_wallet_one)
  --%throws(-20100)  
  procedure create_wallet_with_negative_balance;

  --%test(Создание кошелька с пустым холдом приводит к ошибке)
  --%aftertest(delete_wallet_one)
  --%throws(-20100)  
  procedure create_wallet_with_null_hold_balance;


  ----- кейсы для процедуры delete_wallet_one

  --%test(Удаление существующего кошелька)
  --%beforetest(create_wallet_one)
  --%aftertest(delete_wallet_one)
  procedure delete_existing_wallet;

  --%test(Удаление несуществующего кошелька не приводит к ошибке)
  procedure delete_non_existing_wallet;

  --%test(Удаление с не заданным параметром id кошелька приводит к ошибке)
  --%throws(-20100)
  procedure delete_wallet_with_null_wallet_id_leads_to_error;


  ----- другой функционал

  --%test(Изменение кошелька не через API должно завершаться с ошибкой)
  --%throws(-20999)
  procedure change_wallet_without_api_leads_to_error;


  ----- вспомогательные процедуры
  procedure create_wallet_one;
  procedure delete_wallet_one;

end;
/
