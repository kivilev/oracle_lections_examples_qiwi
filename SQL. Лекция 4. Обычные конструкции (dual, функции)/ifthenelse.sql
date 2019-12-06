------- Схема HR

-- пример 1
select t.region_id,
       decode(t.region_id, 1, 'Europe', 2, 'Americas', 3, 'Asia', 'Unknown') region_name
  from countries t;

-- пример 2, сложней )
select SUM(decode(t.region_id, 1, 1, 0)) Europe_count,
       SUM(decode(t.region_id, 2, 1, 0)) Americas_count,
       SUM(decode(t.region_id, 3, 1, 0)) Asia_count,
       -- Какой вариант лучше? )
       SUM(case when t.region_id not in (1, 2, 3) then 1 else 0 end) Unknown_count1,
       SUM(decode(t.region_id, 1, 0, 2, 0, 3, 0, 1)) Unknown_count2
  from countries t;


