---- Демо столбцов со значениями по умолчанию
drop table del$test_tab;

-- Создаем таблицу
create table del$test_tab
(
  f_nn    number(10,0),
  f_num   number        default 100,
  f_v2    varchar2(100 char) default 'Def',
  f_date  date          default sysdate,
  f_date2 date          default trunc(sysdate),
  f_ts    timestamp(4)  default systimestamp,
  f_clob  clob,
  f_blob  blob
);

-- вставляем строку, столбцы со значениями по умолчанию можно не указывать!
insert into del$test_tab(f_nn) values (1);

-- смотрим. все заполнено значениями по умолчанию.
select * from del$test_tab t;

-- Дата в поле f_date2 ИМЕЕТ час/мин/сек, посмотреть можно преобразовав в строку
select t.*, to_char(f_date2, 'dd.mm.YYYY hh24:mi:ss') f_date2_c from del$test_tab t;

-- пример как преобразуются числа 
insert into del$test_tab(f_nn) values (1.1); --> f_nn = 1
insert into del$test_tab(f_nn) values (1.6); --> f_nn = 2

-- можно посмотреть свойства столбца
select * from user_tab_cols t where t.TABLE_NAME = 'DEL$TEST_TAB';


