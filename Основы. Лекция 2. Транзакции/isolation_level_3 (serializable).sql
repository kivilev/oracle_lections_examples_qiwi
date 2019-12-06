------ СЕССИЯ ЧИТАЕТ ДАННЫЕ В SERIALIZABLE

set transaction isolation level serializable name 'my_transaction';

select * from t1;
--commit;
--rollback;

