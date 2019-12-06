------ Пользователь 1. d_toyota
-- drop table toyota_mark;
-- Создаем таблицу
create table toyota_mark
(
id number not null,
name varchar2(200 char)
);
-- вставляем данные
insert into toyota_mark select level, decode(level, 1,'camry', 2,'mark2',
 3,'crown', 4, 'chaser', 5, null) from dual connect by level <= 5; 
commit;

------------- Создаем простое представление из 2х колонок
create or replace view v_toyota_full_mark as
select id, 'toyota_mark_'||id mark_id, 'toyota '||name full_name 
  from toyota_mark 
 where name is not null;

-- Добавляем комментарии к представлению
comment on table v_toyota_full_mark is 'Автомашины Toyota';
comment on column v_toyota_full_mark.id is 'ID марки';
comment on column v_toyota_full_mark.mark_id is 'Text ID марки';
comment on column v_toyota_full_mark.full_name is 'Полное название марки.';

-- Получаем данные из представления
select t.* from v_toyota_full_mark t;
select * from toyota_mark


------------- Доступы и изменение данных представления

----- 1) Наша таблица + наша view -> полный доступ к данным. Поменять ID можем, full_name - Нет!
select t.*, rowid from v_toyota_full_mark t;

----- 2) Чужая таблица + наша view -> доступ только по выделенным грантам.
-- для создания нужен грант на select на таблицу d_nissan.nissan_mark
create or replace view v_nissan_full_mark as
select id, 'nissan '||name full_name 
  from d_nissan.nissan_mark t
 where t.name is not null;

select t.*, rowid from v_nissan_full_mark t;

----- 3) Чужая таблица + чужая view
-- пока нет грантов на view ничего сделать не можем.
select t.*, rowid from d_nissan.v_nissan_full_mark t;
select * from d_nissan.nissan_mark;-- после выдачи грантов на view, доступа к таблице все равно нет!
-- даем гранты на update view -> теперь можно менять


------------ Создаем представление только на чтение (READ ONLY)
create or replace view v_toyota_mark_read_only as
select * from toyota_mark with read only;

-- Даем возможность читать
grant select on v_toyota_mark_read_only to d_nissan;
-- Даем грант на изменение. Он успешно выдается (!)
grant update on v_toyota_mark_read_only to d_nissan;

select t.*, rowid from v_toyota_mark_read_only t;


------------ Информация о представлениях
select t.view_name, t.text, t.read_only, t.editioning_view from user_views t where t.view_name in('V_TOYOTA_FULL_MARK', 'V_TOYOTA_MARK_READ_ONLY');
select * from user_tab_cols t where t.table_name = 'V_TOYOTA_FULL_MARK';
select * from user_tab_comments t where t.table_name = 'V_TOYOTA_FULL_MARK';
select * from user_col_comments t where t.table_name = 'V_TOYOTA_FULL_MARK';
