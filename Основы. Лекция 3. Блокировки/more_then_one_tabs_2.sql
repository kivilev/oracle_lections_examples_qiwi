-- Пробуем заблокировать кошелек, НЕ баланс
select * from persons_auth au where au.prs_id = 260063 for update nowait;
