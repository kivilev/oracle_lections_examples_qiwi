/*
drop table del$char_v2;
create table del$char_v2
(
  char_col char(10 char),
  v2_col   varchar2(10 char)
);
*/

-- вставляем одинаковое значение "val"
insert into del$char_v2(char_col, v2_col) values ('val', 'val');
commit;

-- смотрим. в char_col значение val дополнено пробелами
select char_col, v2_col from del$char_v2;
select replace(char_col, ' ', '_') char_col, v2_col from del$char_v2;

----- пытаем сравнить два столбца
-- НЕ получим -> через простое сравнение
select * from del$char_v2 t where t.char_col = t.v2_col;

-- получим -> через удаление пробелов из char_col
select * from del$char_v2 t where trim(t.char_col) = t.v2_col;

-- получим -> через дополнение пробелами в v2_col
select * from del$char_v2 t where t.char_col = rpad(t.v2_col, 10, ' ');


