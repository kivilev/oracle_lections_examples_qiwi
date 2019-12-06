----- DEMO. Пример. Очередь Игоря Иванова

-- Создаем таблицу с очередью сообщений
drop table common_queue;
create table common_queue
(
  item_id           varchar2(32 char) not null,
  state_id          number(1) not null,
  update_count      number(10) default 1 not null
);

comment on table common_queue is 'Очередь сущностей для фоновой обработки (техническая)';
comment on column common_queue.item_id is 'UID события';
comment on column common_queue.state_id is 'Состояние события. 1 - в процесс обработки (PROCESS), 2 - работа полностью завершена (FINISH)';
comment on column common_queue.update_count is 'Количество обработок.';

alter table common_queue add constraint item_group_item_uk primary key (item_id);
alter table common_queue add constraint common_queue_state_ch check (state_id in (1,2));

----- Заполним тестовыми данными
insert into common_queue values (11, 1, 0); -- ни разу не брали в обработку. только поставили
insert into common_queue values (22, 1, 0); -- ни разу не брали в обработку. только поставили
insert into common_queue values (33, 1, 0); -- ни разу не брали в обработку. только поставили
insert into common_queue values (44, 1, 0); -- ни разу не брали в обработку. только поставили

insert into common_queue values (55, 1, 3); --  уже 3 раза обрабатывали
insert into common_queue values (66, 1, 1); -- уже 1 раз обрабатывали
insert into common_queue values (77, 1, 2); -- уже 2 раз обрабатывали
insert into common_queue values (101, 1, 4); -- уже 4 раз обрабатывали
insert into common_queue values (102, 1, 6); -- уже 6 раз обрабатывали

insert into common_queue values (103, 1, 11); -- уже 4 раз обрабатывали
insert into common_queue values (104, 1, 12); -- уже 6 раз обрабатывали
insert into common_queue values (88, 1, 30); -- уже 30 раз обрабатывали
insert into common_queue values (99, 1, 40); -- уже 40 раз обрабатывали
insert into common_queue values (100, 1, 50); -- уже 50 раз обрабатывали

insert into common_queue values (1000, 2, 100); -- финишный статус. в обработку такие не попадают.
commit;

----- поэтапно разберем запрос выгребания сообщений из очереди
select que.item_id  
      ,que.state_id  
      ,que.update_count  
  from (
        select min(rowid) 
               keep(dense_rank first order by least(&equal_update_count_limit /*10*/
                                                    , ceil(t.update_count / &sampling_step /*3*/) 
                                                    * &sampling_step /*3*/) asc,  
                                              dbms_random.value(1, 100) asc nulls last
                   ) item_rowid  
          from common_queue t  
         where state_id <> &finished_state /*2*/
        ) minq  
  join common_queue que on que.rowid = minq.item_rowid
   for update of que.item_id skip locked;



----- поэтапно разберем запрос выгребания сообщений из очереди
select t.*,
       least(10 /*10*/, ceil(t.update_count / 3 ) * 3 ),
        ceil(t.update_count / 3 ) * 3,
        dbms_random.value(1, 100)
  from common_queue t
 where state_id <> 2 /*2*/
 order by least(10 /*10*/,
                ceil(t.update_count / 3 /*3*/) * 3 ) asc,
          dbms_random.value(1, 100) asc nulls last;
          
          
select level
  from dual
connect by level <=5
 order by dbms_random.value(1, 100);
          
