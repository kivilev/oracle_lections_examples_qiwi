------ DEMO. Возбуждение и обработка исключений

--- Системное именованное
begin
  raise NO_DATA_FOUND;
end;
/

--- Пользовательское исключение
declare
  e_my exception;
begin
  raise e_my;
end;
/

--- Ошибка в блоке инициализации. Будет отдана в вызывающую среду
declare
  n1 number := 0;
  n2 number := 10/n1;
  n3 number;
begin
  n3 := 10/n1; -- до этого не дойдет
exception 
  when zero_divide then
     dbms_output.put_line('Деление на ноль!');
end;
/

---------- Комплексный пример --------------
drop table wallet;
create table wallet
(
   wallet_id    number(30) not null,
   balance      number(10,2) default 0 not null,
   hold_balance number(10,2) default 0 not null
);

insert into wallet values (1, 0, 0);
insert into wallet values (2, 200.20, 0);
insert into wallet values (3, 0, 300.30);
insert into wallet values (666, 0, 0);
commit;

---- пакет с константами (у нас там 2 исключения)
create or replace package common_pack is
  e_have_money exception;-- имеет бабло
  e_hold_money exception;-- захолдированная сумма на балансе
end;
/

---- пакет с функционалом
create or replace package wallet_pack is
 
  -- удаление кошелька
  procedure delete_wallet(p_wallet_id wallet.wallet_id%type);
  
end;
/

create or replace package body wallet_pack is

  -- удаление кошелька
  procedure delete_wallet(p_wallet_id wallet.wallet_id%type)
  is
    v_balance      wallet.balance%type;
    v_hold_balance wallet.hold_balance%type;
  begin
    -- проверка на спец кошелек
    if p_wallet_id = 666 then
      raise_application_error(-20666, 'Не трогай спец кошелек!');
    end if;

    -- получаем балансы

    select t.balance, t.hold_balance
      into v_balance, v_hold_balance
      from wallet t
     where t.wallet_id = p_wallet_id;
     
    -- баланс не нулевой
    if v_balance <> 0 then
      raise common_pack.e_have_money;
    end if;
    
    -- есть захолдированный баланс
    if v_hold_balance <> 0 then
      raise common_pack.e_hold_money;
    end if;
    
  end;
  
end;
/

---- Тестируем код
declare
  v_money number := 0;
begin
  -- попытка удалить кошелек
  wallet_pack.delete_wallet(p_wallet_id => 1);
  dbms_output.put_line('ok'); 

exception
     
  when common_pack.e_have_money  then -- балан не нулевой
    dbms_output.put_line('Баланс не нулевой. Удалить нельзя.'); 
        
  when common_pack.e_hold_money then -- есть захолдированный баланс
    dbms_output.put_line('Есть захолдированный баланс. Удалить нельзя.'); 

  when no_data_found then -- данные не найдены (опасность!)
      dbms_output.put_line('Кошелек не найден.'); 
  
  when others then
    dbms_output.put_line('Какая-то другая ошибка. SQLCODE: '||SQLCODE||'. Error: '||SQLERRM);   
end;
/

