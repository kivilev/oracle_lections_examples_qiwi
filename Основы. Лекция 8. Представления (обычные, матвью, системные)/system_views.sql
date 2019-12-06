---- Объекты только текущей схемы
select * from user_objects;

---- Все доступные объекты из разных схем
select * from all_objects t 
  where t.owner in ('D_NISSAN', 'D_TOYOTA') order by t.owner;

---- Доступа к этому представлению нет
-- раздадим специально доступ под ДБА
-- grant select on dba_objects to d_toyota;
select * from dba_objects t where t.owner = 'QIWI'


-- Аналогично. По умолчанию доступа нет.
-- grant select on sys.v_$session to d_toyota;
select * from v$session;
