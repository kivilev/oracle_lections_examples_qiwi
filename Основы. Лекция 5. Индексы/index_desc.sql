------ Демонстрация индекса с обратным ключем

-- создаем таблицу
create table del$tab_idx
(
id number,
val varchar2(100)
);

-- вставляем 10К записей
insert into del$tab_idx select level, 'v'||level from dual connect by level <= 10000;
commit;

-- Создаем обычный индекс.
create index del$tab_idx_usually on del$tab_idx(id, val);
-- Создаем индекс с обратной сортировкой
create index del$tab_idx_desc on del$tab_idx(id desc, val asc);

-- Собираем статистику
begin
  dbms_stats.gather_table_stats(ownname          => user,
                                tabname          => 'del$tab_idx');
end;
/


-- Сравниваем два плана
select /*+ INDEX(t del$tab_idx_usually)*/ t.* from del$tab_idx t where t.id >= 9000 order by t.id desc, t.val asc;
select /*+ INDEX(t del$tab_idx_desc)*/ t.* from del$tab_idx t where t.id >= 9000 order by t.id desc, t.val asc;

