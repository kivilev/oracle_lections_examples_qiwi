------ Демонстрация индекса по функции
drop table del$tab_fb;

-- создаем таблицу
create table del$tab_fb
(
id number,
val varchar2(100)
);

-- вставляем 10К записей
insert into del$tab_fb select level, 'val'||level from dual connect by level <= 10000;
commit;

-- Создаем обычный индекс.
create index del$tab_fb_usually on del$tab_fb(val);

-- Собираем статистику
begin
  dbms_stats.gather_table_stats(ownname          => user,
                                tabname          => 'del$tab_fb');
end;
/

-- проверяем план запроса (индекс не используется
select t.* from del$tab_fb t where lower(t.val) = 'val6666';

-- Создаем индекс по функции
create index del$tab_fb_funct_based on del$tab_fb(lower(val));
-- проверяем план запроса (индекс используется)
select t.* from del$tab_fb t where lower(t.val) = 'val6666';
--select t.* from del$tab_fb t where lower(t.val) = lower('VaL6666');

