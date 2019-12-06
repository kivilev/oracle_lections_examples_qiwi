drop table del$tab3;

-- создаем таблицу
create table del$tab3
(
id number,
val1 varchar2(100),
val2 varchar2(100)
);

-- вставляем 10К записей
insert into del$tab3 select level, 'val1'||level, 'val2'||level  from dual connect by level <= 10000;
commit;

------ Общая инфа по индексам
-- смотрим индексы -> индексов пока нет
select * from user_indexes t where t.TABLE_NAME = 'DEL$TAB3';

-- добавляем PK, вместе с ним добавится индекс с таким же именем
alter table del$tab3 add constraint del$tab3_pk primary key (id);

-- создадим второй составной индекс
create index del$tab3_upper_val1_idx on del$tab3(upper(val1));

-- смотрим индексы -> появилось 2 индекса DEL$TAB3_PK и DEL$TAB3_UPPER_VAL1_IDX
select t.* from user_indexes t where t.TABLE_NAME = 'DEL$TAB3';


------ Visible/invisible
-- смотрим план выполнения запроса -> используется индекс DEL$TAB3_UPPER_VAL1_IDX
select * from del$tab3 t where upper(t.val1) = 'VAL11';

-- сделаем его невидимым 
alter index del$tab3_upper_val1_idx invisible;

-- смотрим план выполнения запроса ->  индекс НЕ используется DEL$TAB3_UPPER_VAL1_IDX
select * from del$tab3 t where upper(t.val1) = 'VAL11';

-- включим обратно
alter index del$tab3_upper_val1_idx visible;


------- Monitoring
-- создадим индекс
create index del$tab3_some_idx on del$tab3(id, substr(val2,10));

-- навешаем мониторинг
alter index del$tab3_some_idx monitoring usage;

-- смотрим использование 
select * from v$object_usage t where t.INDEX_NAME = 'DEL$TAB3_SOME_IDX';

----- повыполняем различные запросы к табличке
select * from del$tab3 t where id = 34234 and substr(val2,10) = 'sdsd'

--отключим мониторинг
alter index del$tab3_some_idx nomonitoring usage;

drop index del$tab3_some_idx;

------- Оценка занимаемого места
declare
  l_index_ddl       varchar2(1000);
  l_used_bytes      number;
  l_allocated_bytes number;
begin
  dbms_space.create_index_cost(ddl         => 'create index del$tab3_some_idx on del$tab3(id, substr(val2,10))',
                               used_bytes  => l_used_bytes,
                               alloc_bytes => l_allocated_bytes);
  dbms_output.put_line('RESULT:');
  dbms_output.put_line('used_bytes = ' || round(l_used_bytes/1024, 2) || ' Kb');
  dbms_output.put_line('alloc_bytes = ' || round(l_allocated_bytes/1024, 2) || ' Kb');
end;
/





