---------------- СКРИПТ ВЫПОЛНЯЕТСЯ ПОД USER_CREATOR

-- ORA-01031: insufficient privileges
-- Создать таблицу мы не можем -> нет прав
create table my_tab
(
  id number,
  v2 varchar2(200 char)
);

----- Создать пользователя тоже не можем -> только после выдачи роли
-- drop user del$user cascade;

create user del$user
 identified by ltdtkjgth
  default tablespace users
  temporary tablespace temp
  profile default
  quota unlimited on users;

-- 
grant create session to del$user;  


----------

select * from qiwi.persons_auth

