-- ************** Тщательный (детальный) аудит FGA **************
-- на версии Enterprise Edition (commonid_dev)

-- 1. Создадим табличку за которой будем наблюдать
drop table wallet;
create table wallet
(
 wallet_id number,
 phone     varchar2(200 char),
 balance   number(20,2),
 state_id  number(2)
);
insert into wallet
  select level
         , rpad('+7',10, level) phone
         , level * 100 balance
         , mod(level,2)
    from dual connect by level <= 100;
commit;

-- 2. Создаем правила для аудита (ODBA)
-- Правило на SELECT
begin 
  dbms_fga.add_policy(object_schema => 'HR',
                      object_name   => 'WALLET',
                      policy_name   => 'HR_DEMO_SELECT',
                      statement_types => 'SELECT',
                      audit_column => 'BALANCE',                                         
                      enable        => true);                    
end;
/

-- Правило на DML
begin  
  dbms_fga.add_policy(object_schema => 'HR',
                      object_name   => 'WALLET',
                      policy_name   => 'HR_DEMO_UPDATE',
                      statement_types => 'UPDATE',
                      audit_column => 'BALANCE, STATE_ID',  
                      enable        => true);    
end;
/

-- 3. Проверяем наш аудит

-- select
select t.wallet_id, t.phone, t.state_id--, t.balance
  from wallet t
 where t.wallet_id in (1, 2, 3);

-- update
update wallet t set t.balance = t.balance*100
  where t.wallet_id in(1, 2, 3);


-- Смотрим на лог аудита
select *
  from dba_fga_audit_trail t
 order by t.timestamp desc;-- (timestamp!)

/*
select * from v$option t order by t.parameter;
select * from v$version;

begin
  dbms_fga.drop_policy(object_schema => 'HR', object_name => 'WALLET', policy_name => 'HR_DEMO_SELECT');
end;
/  

*/
