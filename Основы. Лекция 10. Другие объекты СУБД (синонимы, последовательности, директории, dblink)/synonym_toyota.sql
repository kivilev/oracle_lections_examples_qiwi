-- Создаем синоним
create or replace synonym nissan_mark for d_nissan.nissan_mark;

-- Теперь можем обращаться спокой по этому синониму к таблице
select * from nissan_mark;

select * from user_synonyms;
select * from user_objects t where t.object_name = 'NISSAN_MARK';

-- Пробуем выбрать при раздаче select только на синоним
select * from d_nissan.nissan_mark_original;
select * from d_nissan.nissan_mark;

drop synonym nissan_mark;

