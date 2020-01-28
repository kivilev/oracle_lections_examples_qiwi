-- ************* DEMO. Контексты ************

----- Пример 1. Установка системного CLIENTCONTEXT

-- устанавливаем
begin
  dbms_session.set_context('clientcontext', 'param1', 'value1' );
end;
/
-- извлекаем
select sys_context('clientcontext', 'param1')
  from dual;

begin
  dbms_output.put_line(sys_context('clientcontext', 'param1'));   
end;
/

-- извлекаем, если нет параметра -> NULL
select sys_context('clientcontext', 'net_parametra_takogo')
  from dual;




----- Пример 2. Получение системных свойств сессии

select 
  sys_context ( 'userenv', 'CURRENT_SCHEMA' )      curr_schema
, sys_context ( 'userenv', 'CURRENT_USER' )        curr_user
, sys_context ( 'userenv', 'DB_NAME' )             db_name
, sys_context ( 'userenv', 'DB_DOMAIN' )           db_domain
, sys_context ( 'userenv', 'HOST' )                host
, sys_context ( 'userenv', 'IP_ADDRESS' )          ip_address
, sys_context ( 'userenv', 'OS_USER' )             os_user
, sys_context ( 'userenv', 'LANGUAGE' )            language
, sys_context ( 'userenv', 'ORACLE_HOME' )         oracle_home
from dual;

