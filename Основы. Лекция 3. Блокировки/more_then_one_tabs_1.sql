-- Блокируем НЕ ПРАВИЛЬНО с указанием столбца
select b.prs_id, pa.prs_role
 from prs_bal_tab b
 join persons_auth pa on pa.prs_id = b.prs_id
where b.prs_id = 260063
  and bal_currency_id = 643
  for update;

-- Блокируем ПРАВИЛЬНО с указанием столбца
select b.prs_id, pa.prs_role
 from prs_bal_tab b
 join persons_auth pa on pa.prs_id = b.prs_id
where b.prs_id = 260063
  and bal_currency_id = 643
  for update of b.prs_id wait 60; 
