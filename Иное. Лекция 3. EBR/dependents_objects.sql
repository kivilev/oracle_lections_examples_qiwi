--************* DEMO. Возможность использования версионных объектов ***************
-- БД oracle18xe
-- connect SYSTEM/boole34

-- 1. Создадим пользователя с выключенным EBR
/*
drop user hr_noebr cascade;

create user hr_noebr
 identified by ltdtkjgth
  default tablespace users
  temporary tablespace temp
  profile default
  quota unlimited on users;
  
grant resource to hr_noebr;
grant connect to hr_noebr;
*/

-- пользователи
select t.username, t.editions_enabled 
  from dba_users t 
 where t.username in ('HR', 'HR_NOEBR');

------------------- hr
-- функция в HR. Версионирована по умолчанию.
create or replace function hr.vers_sysdate return date
is
begin
  return sysdate;
end;
/

-- функция в HR. Версионирование отключено.
create or replace noneditionable function hr.no_vers_sysdate return date
is
begin
  return sysdate;
end;
/

grant execute on hr.vers_sysdate to hr_noebr;
grant execute on hr.no_vers_sysdate to hr_noebr;

------------------- hr_noebr
-- Ошибка. Вызываем версионированную функцию.
create or replace function hr_noebr.call_vers_sysdate return date
is
begin
  return hr.vers_sysdate();
end;
/  

-- Выполняется ок. Версионированная функция в SQL.
select hr.vers_sysdate() from dual;


-- Выполняется ок. Вызываем неверсионированную функцию.
create or replace function hr_noebr.call_no_vers_sysdate return date
is
begin
  return hr.no_vers_sysdate();
end;
/  
