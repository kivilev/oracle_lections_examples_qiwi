-- СОЗДАНИЕ IOT ТАБЛИЦЫ
create table del$iot_tab
(
  n1 number,
  n2 number,
  n3 number,
  n4 number,
  primary key (N1, N2) -- один раз построив, потом не перестроить
) organization index;

-- Создаем доп индекс по другим столбцам
create index del$iot_tab_idx on del$iot_tab(n3);

insert into del$iot_tab
select level, level+1, level+10, level+100 
  from dual connect by level <= 1000;

commit;

-- Используется PK (показать план)
select t.*, rowid from del$iot_tab t where t.n1 = 1 and t.n2 = 2;

-- Используется индекс, затем опять PK (Показать план)
select * from del$iot_tab t where t.n3 = 1;


-- У IOT отображается признак IOT
select t.iot_type, t.* from user_tables t where t.table_name in ('DEL$IOT_TAB', 'DUAL');

-- Индекс самой таблицы отображается в индексах
select * from user_indexes t where t.table_name = 'DEL$IOT_TAB';


