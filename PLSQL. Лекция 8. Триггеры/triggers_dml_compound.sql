-- ********* DEMO. Составные триггеры ********

drop table my_tab;
create table my_tab
(
  id   number(10) not null,
  name varchar2(100 char)  not null 
);

create or replace trigger my_tab_iu_c
for update or insert on my_tab
compound trigger
  g_mod varchar2(20 char);

  -- до операции
  before statement is begin
    dbms_output.put_line('--- before statement'); 
    g_mod := 'mod';
  end before statement;

  -- до операции построчно
  before each row is begin
    dbms_output.put_line(chr(9)||'-- before row '); 
    dbms_output.put_line(chr(9)||'new.name: '||:new.name);
    dbms_output.put_line(chr(9)||'old.name: '||:old.name);
    :new.name := :new.name || ' '||g_mod;
  end before each row;  

  -- после операции построчно
  after each row is begin
    dbms_output.put_line(chr(9)||'== after row '); 
    dbms_output.put_line(chr(9)||'new.name: '||:new.name);
    dbms_output.put_line(chr(9)||'old.name: '||:old.name);
  end after each row;

  -- после операции
  after statement is begin
    dbms_output.put_line('--- after statement'); 
  end after statement;

end;
/

insert into my_tab select level, 'str'||level from dual connect by level <= 3;
