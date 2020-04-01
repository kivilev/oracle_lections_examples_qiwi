--- ********** СОЗДАНИЕ ПОЛЬЗОВАТЕЛЯ И ВКЛЮЧЕНИЕ EBR

-- drop user my_ebr_user cascade;

create user my_ebr_user
 identified by ltdtkjgth
  default tablespace users
  temporary tablespace temp
  profile default
  quota unlimited on users;
  
grant resource to my_ebr_user;
grant connect to my_ebr_user;
grant select_catalog_role to my_ebr_user;

-- вкл EBR
alter user my_ebr_user enable editions;


-- пользователи
select t.username, t.editions_enabled 
  from dba_users t 
 where t.username in ('HR', 'HR_NOEBR', 'MY_EBR_USER');



