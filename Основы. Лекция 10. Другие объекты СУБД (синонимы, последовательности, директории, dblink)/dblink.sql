----- Создаем какого-то пользователя
create user c##some_user
 identified by pass123
  default tablespace users
  temporary tablespace temp
  profile default
  quota unlimited on users;

grant create session to c##some_user;
grant resource to c##some_user;

create table c##some_user.mytab(
n1 number,
v2 varchar2(200 char)
);
insert into c##some_user.mytab values (1, 'this is another db. in another user. in mytab');

----- Создаем ДБ-линк
--drop database link dblink_to_some_db;
create database link dblink_to_some_db
connect to c##some_user identified by pass123 -- коннект к пользователю другой БД с паролем
using 'some_db'; -- alias из tnsnames на сервере СУБД

-- обращение по DBLINK'у идет через @
select * from mytab@dblink_to_some_db;
