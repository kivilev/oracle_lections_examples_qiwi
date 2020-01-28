-- ************* Часть DEMO выполняемая под ODBA ****************
-- на версии Enterprise Edition (commonid_dev)

-- Правило на SELECT
begin 
  dbms_fga.add_policy(object_schema => 'HR',
                      object_name   => 'WALLET',
                      policy_name   => 'HR_DEMO_SELECT',
                      statement_types => 'SELECT',
                      audit_column => 'BALANCE',                                         
                      enable        => true);                    
end;
/

------ кастомный логгер
drop table email_queue;
create table email_queue(
  object_schema varchar2(100 char), 
  object_name varchar2(100), 
  policy_name varchar2(100),
  dtime timestamp default systimestamp
);

create or replace procedure reg_audit(object_schema varchar2, object_name varchar2, policy_name varchar2)
is
--pragma autonomous_transaction;
begin
  insert into email_queue values(object_schema, object_name, policy_name, default);
  --commit;
end;
/


-- Правило на DML
begin  
  dbms_fga.add_policy(object_schema => 'HR',
                      object_name   => 'WALLET',
                      policy_name   => 'HR_DEMO_UPDATE',
                      statement_types => 'UPDATE',
                      audit_column => 'BALANCE, STATE_ID',
                      handler_schema => 'ODBA',
                      handler_module => 'reg_audit',
                      enable        => true);
end;
/

-- Смотрим на лог аудита
select *
  from dba_fga_audit_trail t
 where t.timestamp >= sysdate - 1/24
 order by t.timestamp desc;-- (timestamp!)

select * from email_queue;

/*
select * from v$option t order by t.parameter;
select * from v$version;

begin
  dbms_fga.drop_policy(object_schema => 'HR', object_name => 'WALLET', policy_name => 'HR_DEMO_UPDATE');
end;
/  

*/
