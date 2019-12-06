------ Создаем таблички
------ Клиент (master)
drop table client;
create table client
(
  client_id number(20) not null
);
--PK
alter table client add constraint client_pk primary key (client_id);

------ Данные по клиенту (detail)
drop table client_data;
create table client_data
(
  client_data_id number(20) not null,
  client_id      number(20) not null,
  val            varchar2(100 char)
);
--PK
alter table client_data add constraint client_data_pk primary key (client_data_id);
-- FK
alter table client_data add constraint client_data_fk foreign key (client_id)
references client (client_id);

------------
--- Поскольку FK у нас не отложенный, мы получим ошибку сразу на вставке.
insert into client_data values(1,1,'v1');

--- Пересоздадим ограничение на отложенную проверку.
alter table client_data drop constraint client_data_fk;
alter table client_data add constraint client_data_fk foreign key (client_id)
references client (client_id) deferrable initially deferred;

--- Сделаем повторную попытку. При инсерте -> ok, Commit -> error
insert into client_data values(1,1,'v1');

