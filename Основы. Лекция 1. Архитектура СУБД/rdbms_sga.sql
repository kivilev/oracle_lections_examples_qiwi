-- Размер SGA
SELECT name, round(bytes/1024/1024/1024,2) "Size, Gb" FROM v$sgainfo order by name;

-- детальная информация по каждому пулу
select * from  v$sgastat;
