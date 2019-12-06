------ DEMO. Конструкции WITH.
---- Нужен dbms_lock -> ODBA, QIWI

--- Простой пример WITH (показать план)
with mytab as (
select level id
  from dual 
  connect by level <= 5)
--  
select 'use1' n, t.* 
  from mytab t


-- Двойное использование запроса из WITH (показать план -> tmp)
with mytab as (
select level id
  from dual 
  connect by level <= 5)
--  
select 'use1' n, t.* 
  from mytab t
union all
select 'use2' n, t.* 
  from mytab t
order by 1,2;


------ Двойное использование запроса из WITH (показать план -> tmp)
-- 1я табл
with tab1 as (
  select /*+ materialize */level id
    from dual 
 connect by level <= 5),
-- 2я табл  
tab2 as (
  select /*+ materialize */* 
    from tab1 
   where id <= 4
)
-- использование
select 'tab1' n, t.* 
  from tab1 t
union all
select 'tab2' n, t.* 
  from tab2 t
order by 1,2;



---- создаем задержку в 1 секунды
create or replace function del$sleep return number
is
begin
  dbms_lock.sleep(1);
  return 1;
end;
/

---- Формируем таблицу mytab и выбираем из получившейся таблицы

-- выполнится 10 секунд. Директива INLINE.
with mytab as (
select /*+ inline */ level id,
       del$sleep()
  from dual connect by level <= 5)
select * 
  from mytab  
union all  
select * 
  from mytab;    

-- выполнится 5 секунд. Директива MATERIALIZED.
with mytab as (
select /*+ materialized */ 
       del$sleep()
  from dual connect by level <= 5)
select * 
  from mytab  
union all  
select * 
  from mytab;

