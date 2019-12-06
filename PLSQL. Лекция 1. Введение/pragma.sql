--- DEMO. PRAGMA

-- Запускать в sqlplus
declare
  v number;
  no_such_sequence exception;
  pragma exception_init(no_such_sequence, –02289);
begin
  execute immediate 'select seq.nextval from dual' into v;
exception
  when no_such_sequence then
    dbms_output.put_line('!!! Sequence not defined');
end;
/


declare
  v number;
begin
  execute immediate 'select seq.nextval from dual' into v;
exception
  when others then
    if sqlcode = -02289 then
       dbms_output.put_line('!!! Sequence not defined');
    end if;
end;
/


---- Автономные транзакции
declare
  pragma autonomous_transaction;  
begin
  commit;
end;
