------ DEMO. Иерархические запросы

-- Таблица с провайдерами
drop table provider;
 
create table provider
(
  id        number(20) not null,
  parent_id number(20),
  name      varchar2(200 char) not null,
  active    number(1) default 1 not null
);

-- 1 уровень
insert into provider values (1, null, 'Сотовые операторы', default);
insert into provider values (20, null, 'Интернет-провайдер', default);
-- 2 уровень
insert into provider values(2, 1, 'Билайн', default);
insert into provider values(3, 1, 'МТС', default);
insert into provider values(4, 1, 'Теле2', default);
insert into provider values(5, 1, 'Шмелайн', 0); -- отключенный сотовый оператор

insert into provider values (21, 20, 'Акадо', default);
insert into provider values (22, 20, 'Дом.ру', default);
-- 3 уровень
insert into provider values(7, 4, 'Теле2.Центр', default);
insert into provider values(6, 4, 'Теле2.Москва', default);
insert into provider values(8, 4, 'Теле2.Юг', default);

--insert into provider values (21, 23, 'Акадо. Цикл', 1);
insert into provider values (23, 21, 'Акадо Москва', default);
insert into provider values (24, 21, 'Акадо Новосиб', default);
insert into provider values (25, 21, 'Акадо Питер', 0); -- отключенный филиал провайдера
-- 
commit;

select * from provider;

---- Рекурсивный запрос. С вершины в листья.
select level lvl -- уровень иерархии
     , id
     , lpad(' ', 5*(level-1))||name bview -- красивый вид :)
     , sys_connect_by_path (name, '->' ) catalog_path -- путь в каталоге     
     , connect_by_isleaf as isleaf  -- является узел конечным
     , prior name as parent_name    -- свойство родителя
     , connect_by_root name as root_name  -- свойство вершины
     --, connect_by_iscycle is_cycle
  from provider p -- исходная таблица с иерархией
 where p.active = 1 -- интересуют только активные
 start with p.parent_id is null -- стартуем разворот дерева с самой верхушки
connect by  prior p.id = p.parent_id -- как соединениям наши строки. Устранять циклы.
order siblings by name asc; -- сортируем именно в иерархии

--- Разворот в обратную сторону. С листа в корень.
select level lvl -- уровень иерархии
     , id
     , lpad(' ', 5*(level-1))||name bview -- красивый вид :)
     , sys_connect_by_path (name, '/' ) catalog_path -- путь в каталоге     
     , connect_by_isleaf as isleaf  -- является узел конечным
     , prior name as parent_name    -- свойство родителя
     , connect_by_root name as root_name  -- свойство вершины
     , connect_by_iscycle is_cycle
  from provider p -- исходная таблица с иерархией
 where p.active = 1 -- интересуют только активные
 start with p.id in(8, 24)
connect by nocycle  p.id = prior p.parent_id -- как соединениям наши строки. Устранять циклы.
order siblings by name asc; -- сортируем именно в иерархии

