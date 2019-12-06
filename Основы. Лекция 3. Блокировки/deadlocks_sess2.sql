-- 3) блокируем 10
update del$deadlocks t set t.val = 5 where t.id = 10;

-- 5) пытаемся блочить "2". получаем ошибку в сессии 1.
update del$deadlocks t set t.val = 5 where t.id = 2;


