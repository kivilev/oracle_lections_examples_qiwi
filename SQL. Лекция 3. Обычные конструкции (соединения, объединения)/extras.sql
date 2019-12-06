--- QW DEV
-- Первоначальный
select t1.txn_id,  et.ext_n_id, en.ext_name, et.ext_value
  from txn2 t1
  join ext_val_str es on t1.txn_id = es.txn_id and trunc(t1.txn_date) = es.txn_date
 cross join table(ext_values_pack.to_table(es.txn_str)) et 
 join ext_names en   on en.exn_id = et.ext_n_id
 where t1.txn_id = 393629888;

-- Шаг 1. Получаем 1 строку - транзакция
select t1.txn_id
  from txn2 t1
 where t1.txn_id = 393629888;

-- Шаг 2. Получаем свойства транзакции в форме строки 
select t1.txn_id, es.txn_str--, et.ext_n_id, en.ext_name, et.ext_value
  from txn2 t1
  join ext_val_str es on t1.txn_id = es.txn_id and trunc(t1.txn_date) = es.txn_date
 where t1.txn_id = 393629888;
 
-- Шаг 3. Из строки получаем массив и умножаем 1 строку с шага 1 на получившийся массив
select t1.txn_id, es.txn_str, et.ext_n_id, et.ext_value--, en.ext_name
  from txn2 t1
  join ext_val_str es on t1.txn_id = es.txn_id  and trunc(t1.txn_date) = es.txn_date
 cross join table(ext_values_pack.to_table(es.txn_str)) et 
-- join ext_names en   on en.exn_id = et.ext_n_id
 where t1.txn_id = 393629888;


-- Шаг 4. Добавляем название к полученной экстре
select t1.txn_id, es.txn_str, et.ext_n_id, et.ext_value, en.ext_name
  from txn2 t1
  join ext_val_str es on t1.txn_id = es.txn_id  and trunc(t1.txn_date) = es.txn_date
 cross join table(ext_values_pack.to_table(es.txn_str)) et 
 join ext_names en   on en.exn_id = et.ext_n_id
 where t1.txn_id = 393629888;
