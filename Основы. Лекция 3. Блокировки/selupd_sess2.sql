--- ПРИМЕР SELECT ... FOR UPDATE; 

select * from del$t1 t where t.id = 1;

-- Пытаемся заблокировать запись "1" с вечным ожиданием
select * from del$t1 t where t.id = 1 for update;

-- Пытаемся заблокировать запись "1" с ожиданием 10 секунд
select * from del$t1 t where t.id = 1 for update wait 5;

-- Пытаемся заблокировать запись "1" без ожидания
select * from del$t1 t where t.id = 1 for update nowait;

-- Пытаемся заблокировать запись "1" с пропуском
select * from del$t1 t where rownum < 4 for update skip locked;



