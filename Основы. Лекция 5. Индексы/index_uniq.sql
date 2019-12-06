------ Демонстрация уникального индекса
drop table del$tab_uniq;

-- создаем таблицу
create table del$tab_uniq
(
id number,
val1 varchar2(100),
val2 varchar2(100)
);

-- вставляем 10К записей
insert into del$tab_uniq select level, 'val1'||level, 'val2'||level  from dual connect by level <= 10000;
commit;

---- 1) создаем ограничение. Автоматом создастся уникальный индекс!
alter table del$tab_uniq add constraint del$tab_uniq_uq unique (val1);

---- 2) попробуем создать уникальный ключ по функции от столбца. Не получится.
alter table del$tab_uniq add constraint del$tab_uniq_uq unique (lower(val1));
-- выход, создать уникальный индекс без создания ограничения.
create unique index del$tab_uniq_uq2 on del$tab_uniq(lower(val1));

---- 3) Добавляем первичный ключ. Автоматом создастся уникальный индекс!
alter table del$tab_uniq add constraint del$tab_uniq_pk primary key (id);

