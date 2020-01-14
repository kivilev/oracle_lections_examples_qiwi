-- *********** DEMO. Создание системных триггеров **************
-- ! Запускать под SYSDBA (ODBA)

--- 1. Таблица логирования входа/выхода
drop table session_log;
create table session_log
(
  user_name    varchar2(128 char) not null,
  action_type  varchar2(10 char) not null,
  dtime        timestamp default systimestamp not null
);

alter table session_log add constraint session_log_ch
check (action_type in ('logon','logoff'));

--- 2. Процедура логирования
create or replace procedure log_session(pi_action_type session_log.action_type%type) is
  pragma autonomous_transaction;
begin
  insert into session_log(user_name, action_type)
  values(user, pi_action_type);
  commit;
end;
/

--- 3. Создаем триггеры
create or replace trigger logon_user_trg
after logon on database
begin
  log_session('logon');
end;
/

create or replace trigger logoff_user_trg
before logoff on database
begin
  log_session('logoff');
end;
/


--- 4. Проверяем 
-- входим, выходим с разных аккаунтов: sqlplus hr/ltdtkjgth
select * from session_log order by dtime desc;

