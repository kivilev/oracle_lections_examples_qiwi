---------------- СКРИПТ ВЫПОЛНЯЕТСЯ ПОД ODBA/SYS

------- Создаем роль
--drop role user_admin_role;
create role user_admin_role;

-- Наделим её системными правами на создание, удаление, изменение пользователей
grant create user, alter user, drop user to user_admin_role;
grant select on qiwi.persons_auth to user_admin_role; -- даем чисто по приколу, чтоб продемонстрировать объектные права к роли
-- смотрим, что есть в роли
select * from dba_sys_privs where grantee = 'USER_ADMIN_ROLE';
select * from all_tab_privs t where t.table_schema = 'QIWI' and t.table_name = 'PERSONS_AUTH';

select * from dba_roles t where t.role = 'USER_ADMIN_ROLE';


------ Создаем пользователя
drop user user_admin cascade;
create user user_admin
 identified by ltdtkjgth
  default tablespace users 
  temporary tablespace temp
  profile default
  quota unlimited on users;

-- даем грант на соединение с БД  
grant create session to user_admin;

----- Соединяемся под user_admin, пытаемся создать табличку или пользователя -> облом -> надо дать роль
-- Даем роль и реконнектимся под user_admin
grant user_admin_role to user_admin;

-- Пока не дадим роли create session with admin option, не сможем создавать пользователей и давать им гранты на сессии
grant create session to user_admin_role with admin option;



