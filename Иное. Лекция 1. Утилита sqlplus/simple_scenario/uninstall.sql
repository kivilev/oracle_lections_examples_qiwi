-- выкл отображение замены переменных
set verify off
-- считываем версию патча
@services/patch_ver.sql

-- спулим в файл
spool uninstall_&patch_num..log replace

-- описание приложения
set appinfo 'UnInstall Script Oracle patch &patch_num'

-- при возникновении ошибки идем дальше
whenever sqlerror continue

-- заголовок
@@services/title.sql

-- вывод системной инфы
@@services/banner.sql

prompt ================

---- удаляются объекты
prompt drop package wallet_api_pack;
drop package wallet_api_pack;

prompt drop sequence wallet_seq;
drop sequence wallet_seq;

prompt drop table wallet;
drop table wallet;

prompt drop table currency;
drop table currency;

prompt ================
prompt 
prompt Patch was successfull uninstalled :)


-- отрубаем спулл
spool off

exit;



