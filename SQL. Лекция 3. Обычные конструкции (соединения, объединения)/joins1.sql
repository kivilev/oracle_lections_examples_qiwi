--drop table A; drop table B;
create table A(col number);
create table B(col number);

insert into A values(1); 
insert into A values(2);
--insert into A values(null);

insert into B values(2); 
insert into B values(3); 
--insert into B values(null);

---------- INNER JOIN. Внутренние соединения
select a.col col_a, b.col col_b
  from A a
  join B b on a.col = b.col;

-- null не соединился. Можно так. Через заглушку -999.
select a.col col_a, b.col col_b
  from A a
  inner join B b on nvl(a.col, -999) = nvl(b.col, -999);
  
---------- OUTER JOIN. Внещние соединения
-- левое внешнее
select a.col col_a, b.col col_b
  from A a
  left join B b on a.col = b.col;

-- правое внешнее
select a.col col_a, b.col col_b
  from A a
  right join B b on a.col = b.col;

-- полное внешнее
select a.col col_a, b.col col_b
  from A a
  full join B b on a.col = b.col;

--------- Декартово произведение 
select a.col col_a, b.col col_b
  from A a 
  cross join B b;
-- ИЛИ
select a.col col_a, b.col col_b
  from A a, B b;

--------- Natural join
select *
  from A a
  natural join B b;

