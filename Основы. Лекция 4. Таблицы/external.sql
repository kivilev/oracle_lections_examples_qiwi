--drop directory my_dir;
--drop table my_ext_tab;

-- Создаем путь к файлу
create or replace directory my_dir as '/home/oracle/testdata';

-- Создаем табличку
create table my_ext_tab(
id number,
full_name varchar2(200 char)
)
organization external 
(
  type oracle_loader
  default directory my_dir
  access parameters
  (
    records delimited by newline
    fields terminated by ";" ldrtrim
    missing field values are null
  )
  location ('test.data')
)
reject limit unlimited;

-- Выбираем данные
select * from my_ext_tab;
