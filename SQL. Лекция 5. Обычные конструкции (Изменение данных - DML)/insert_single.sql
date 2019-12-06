-- Схема D_TOYOTA. Демо для одиночных вставок.
drop table mytab;

create table mytab
(
  id number not null,
  str1 varchar2(100 char),
  dtime date not null,
  def1  number default 999,
  def2  varchar2(100 char) default 'default value'
);

--- Перечисление полей при вставке
insert into mytab (id, str1, dtime, def1, def2)
values (1, 'val_1', sysdate, -1, 'non def value 1');

select * from mytab order by id desc;

--- Вставка без перечисления полей
insert into mytab values (2, 'val_2', sysdate, -2, 'non def value 2');

select * from mytab order by id desc;

--- Вставка с полями наоборот
insert into mytab(def2, def1, dtime, str1, id) values ('non def value 3', -3, sysdate, 'val_3', 3);

select * from mytab order by id desc;

--- Указываем DEFAULT
insert into mytab (id, str1, dtime, def1, def2)
values (4, 'val_4', sysdate, default, default);

select * from mytab order by id desc;

--- Не указываем значения по умолчанию
insert into mytab (id, str1, dtime)
values (5, 'val_5', sysdate);

select * from mytab order by id desc;



