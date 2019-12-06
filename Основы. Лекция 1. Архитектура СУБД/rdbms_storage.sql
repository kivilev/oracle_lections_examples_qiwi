----- ТП, Сегменты, экстенты, блоки
select * from dba_tablespaces;

-- Сегменты = объекты
select t.owner
      ,t.segment_name
      ,t.segment_type
      ,t.tablespace_name
      ,t.extents
      ,t.initial_extent
      ,t.*
  from dba_segments t
 where t.owner = 'QIWI'
   and t.segment_name = 'PERSONS_AUTH';--'TXN2';

select * from dba_extents t where t.owner =  'QIWI' and t.segment_name = 'PERSONS_AUTH';

select * from dba_data_files t where t.FILE_ID = 40;

