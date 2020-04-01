-- ********** УДАЛЕНИЕ ВСЕХ 

select t.*
      ,level
      ,'drop edition '||t.edition_name||' cascade;'
  from dba_editions t
  start with edition_name = 'ORA$BASE'
connect by prior edition_name = parent_edition_name
 order by level desc;

--select * from dba_objects_ae t where t.edition_name = 'ED_PATCH_9999_310320_084513';

alter database default edition = ORA$BASE;

