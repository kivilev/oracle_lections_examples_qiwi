------------ Скрипт выполняется под SYS, ODBA --------

------ создание пользователя USER_LESSON9
-- drop user user_lesson9 cascade;

create user user_lesson9
 identified by 123123  -- способ идентификации
  default tablespace users   -- табл пространство для размещения объектов (иногда надо давать отдельный грант на использование размера)
  temporary tablespace temp  -- временное табл пространство
  profile default;  -- профиль пользователя

-- без этого гранта невозможно будет подключиться
grant create session to user_lesson9;

-- на создание объектов можно дать минимальную роль на создание объектов
grant resource to user_lesson9;
--revoke resource from  user_lesson9;


---- Заблокируем
alter user user_lesson9 account lock;
-- alter user user_lesson9 account unlock;

---- Можно создать профиль. Установить количество попыток логина на 3
drop profile del$profile;
create profile del$profile limit failed_login_attempts 3;
alter user user_lesson9 profile del$profile;

---- Пытаемся залогиниться три раза с неправильным паролем
select * from dba_users t where t.username = 'USER_LESSON9'
select * from all_users t where t.username = 'USER_LESSON9'


-- Удаление пользователя и схемы
drop user user_lesson9;
--drop user user_lesson9 cascade;

