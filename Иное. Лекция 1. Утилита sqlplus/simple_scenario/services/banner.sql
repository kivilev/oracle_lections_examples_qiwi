COLUMN patchset FORMAT A10 HEADING 'Patch ver'
COLUMN db_user FORMAT A10 HEADING 'DB User'
COLUMN cur_date FORMAT A20 HEADING 'Current Date'
COLUMN os_user FORMAT A15 HEADING 'OS User'
COLUMN nls_lang FORMAT A15 HEADING 'NLS Language'
COLUMN db_name FORMAT A15 HEADING 'DB Name'
COLUMN db_version FORMAT A30 HEADING 'DB Version' WRAP

prompt ______________________________
select '&patch_num' patchset
	  ,user db_user    
      ,to_char(sysdate, 'dd.mm.YYYY hh24:mi:ss') cur_date
      ,sys_context('userenv', 'OS_USER') os_user
      ,sys_context('userenv', 'language') nls_lang
      ,sys_context('userenv', 'DB_UNIQUE_NAME') db_name
      ,t.banner db_version
  from v$version t;
prompt ______________________________
