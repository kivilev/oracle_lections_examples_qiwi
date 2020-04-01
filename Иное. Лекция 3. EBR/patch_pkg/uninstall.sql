-- ********* СКРИПТ ОТКАТА ИЗМЕНЕНИЙ **********
-- отключаем вывод замены sqlplus переменных
set verify off

-- при возникновении ошибки выходим
whenever sqlerror exit failure

-- получаем номер накатываемого патча
@@services/patch_ver.sql

-- логируем в файл
spool uninstall_&patch_num..log replace

-- украшалочка
@@services/header.sql

-- задаем имя новой эдиции. Формат: номер патча + дата до секунд
define tmpdate = ""
column ddate new_value tmpdate
select to_char(sysdate, 'ddmmyy_hh24miss') ddate
  from dual;  
define edition_name = "ed_patch_&patch_num._&tmpdate._R";

prompt New edition is &edition_name
-------------------------------------------

---- 1. Создаем новую эдицию
create edition &edition_name;
comment on edition &edition_name is 'UnInstall patch &patch_num';
grant use on edition &edition_name to hr;

---- 2. Переключаем нашу сессиию в эту эдицию
alter session set edition = &edition_name;

---- 3. Накатываем новую версию пакета wallet_api_pack по пользователем hr
alter session set current_schema = hr;

-- отключаем сканирование амперсанда
set define off

prompt old_wallet_api_pack.spc
@@objects/old_wallet_api_pack.spc

prompt old_wallet_api_pack.bdy
@@objects/old_wallet_api_pack.bdy
-- включаем сканирование амперсанда
set define on

---- 4. Делаем новую эдицию по умолчанию при подключении новых сессий
--alter session set current_schema = "_USER";

alter database default edition = &edition_name;


-------------------------------------------
prompt 
prompt UnInstall updates for wallet_api_pack have been successfull :)
prompt 

spool off;

exit;
