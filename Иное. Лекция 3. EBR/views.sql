-- *************** DEMO. Системные представления ***************
---- ! под DBA

--- Создадим в базовой эдиции процедуру
alter session set edition = ora$base;
create or replace procedure hr.proc_base is
begin
  null;
end;
/

--- Создадим новую эдицию для примера
create edition demo_view_edition;
comment on edition demo_view_edition is 'Редакция для демо view';
grant use on edition ora$base to hr;
grant use on edition demo_view_edition to hr;

--- Создадим процедуру в новой эдиции
alter session set edition = demo_view_edition;

create or replace procedure hr.proc_demo_view is
begin
  null;
end;
/

--- ! Под пользователем HR
-- посмотреть все эдции
select t.*
      ,c.comments
      ,level
  from dba_editions t
  join dba_edition_comments c on c.edition_name = t.edition_name
  start with t.edition_name = 'ORA$BASE'
connect by prior t.edition_name = t.parent_edition_name
 order by level desc;

-- объекты
select * from user_objects t;
select * from user_objects_ae t;

-- переключаемся между эдициями
alter session set edition = demo_view_edition;
alter session set edition = ora$base;
select sys_context('userenv', 'current_edition_name') from dual;

-- информация о вкл\выкл EBR
select t.username, t.editions_enabled 
  from dba_users t 
 where t.username in ('HR', 'HR_NOEBR');


---- почистим за собой (system)
drop edition demo_view_edition cascade;

alter session set edition = ora$base;
drop procedure hr.proc_base;

