------- ПРИМЕР ЗАМЕНЫ ПАРТИЦИИ 
-- Создаем партиционированную таблицу
drop table del$part_tab;
create table del$part_tab (
  id      number,
  v1      varchar2(100),
  padding varchar2(100)
)partition by range(id)(
  partition p1000 values less than (1001),
	partition p3000 values less than (3001),
	partition p5000 values less than (5001)
);
create index del$part_tab_idx on del$part_tab(v1) local;

-- Вставляем данные в каждую партицию
insert into del$part_tab values(1000, 'старт', '');
insert into del$part_tab values(3000, 'старт', '');
insert into del$part_tab values(5000, 'старт', '');

-- смотрим данные в партициях
select * from del$part_tab partition(p1000);
select * from del$part_tab partition(p3000);
select * from del$part_tab partition(p5000);

-- Создаем таблицу с точно такой же структурой + индекс
drop table del$change_tab;
create table del$change_tab(
  id      number,
  v1      varchar2(100),
  padding varchar2(100)
);
create index del$change_tab_idx on del$change_tab(v1);

-- Вставляем данные в обменную таблицу
insert into del$change_tab values(1000, 'temp', '');

-- подмена партиции (БЕЗ ВАЛИДАЦИИ, в результате имеем неверные данные в партиции)
alter table del$part_tab exchange partition p5000
with table del$change_tab 
including indexes
without validation;

-- смотрим данные в партициях
select * from del$part_tab partition(p1000);
select * from del$part_tab partition(p3000);
select * from del$part_tab partition(p5000);
-- пробуем получить 1000. Отдает "старт", а не "temp".
-- почему? определяет по метаданным.
select * from del$part_tab t where t.id = 1000;


-- подмена партиции (С ВАЛИДАЦИЕЙ) --> ошибка
-- ORA-14099: all rows in table do not qualify for specified partition
alter table del$part_tab exchange partition p5000
with table del$change_tab 
including indexes
with validation;

-- смотрим что в нашей обменной таблице
select * from del$change_tab;
