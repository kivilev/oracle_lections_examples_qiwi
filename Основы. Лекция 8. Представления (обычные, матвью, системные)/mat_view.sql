drop table sale;
drop table sale_car;
drop materialized view mv_sale_cars_demand;
drop materialized view mv_sale_cars_commit;
drop view v_sale_cars;

----- Создаем структуры
-- продажи
create table sale
(
  id number(20) not null,
  sale_date date not null
);
-- автомобили, которые были в покупке
create table sale_car
(
  sale_id number(20) not null,
  vin     varchar2(20 char) not null,
  summa   number(10,2) not null
);

----- Создаем представления
-- обычное (считается всегда "на лету")
create or replace view v_sale_cars
as select s.id, s.sale_date, SUM(sc.summa) total_summa
     from sale s
     join sale_car sc on sc.sale_id = s.id
    group by s.id, s.sale_date;

-- материализованное view, обновление по commit'у
create materialized view mv_sale_cars_commit
refresh on commit -- по commit
as select s.id, s.sale_date, SUM(sc.summa) total_summa
     from sale s
     join sale_car sc on sc.sale_id = s.id
    group by s.id, s.sale_date;
     
-- материализованное view, обновление по запросу
create materialized view mv_sale_cars_demand
refresh on demand -- обновление вручную
as select s.id, s.sale_date, SUM(sc.summa) total_summa
     from sale s
     join sale_car sc on sc.sale_id = s.id
    group by s.id, s.sale_date;     


----- Заполняем данными 
-- продажи
insert into sale values(1, trunc(sysdate)-1);
insert into sale values(2, trunc(sysdate));
-- продажи в авто
insert into sale_car values(1, 'vin1', 100.1);
insert into sale_car values(2, 'vin2', 100.1);
insert into sale_car values(2, 'vin3', 100.1);
-- commit;

----- Что отдают представления?
-- видим не закоммиченные данные. Посмотреть план запроса
select * from v_sale_cars;

-- видим, только закоммиченные данные. Посмотреть план запроса.
select * from mv_sale_cars_commit;

-- видим данные только после принудительного рефреша. Посмотреть план запроса
select * from mv_sale_cars_demand;

begin
  dbms_mview.refresh('MV_SALE_CARS_DEMAND');
end;
/

----- Смотрим что за кадром
select * from user_objects t where t.object_name = 'MV_SALE_CARS_DEMAND';
select * from user_objects;
