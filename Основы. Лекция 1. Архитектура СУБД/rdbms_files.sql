-- файлы данных
select * from dba_data_files;

-- управляющие файлы
select * from v$parameter t where t.NAME = 'control_files';

-- журналы повторного выполнения (лог-файлы)
select * from v$logfile;

