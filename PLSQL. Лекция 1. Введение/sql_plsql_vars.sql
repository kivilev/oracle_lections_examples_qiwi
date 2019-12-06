---- DEMO. SQL-запросы и PL/SQL-переменные

drop table my_tab;

create table my_tab(
  mt_id number not null
);

insert into my_tab select level from dual connect by level <= 10;
commit;

declare
  v_count number;
begin
  -------
  <<insert_block>>  
  declare
    mt_id number := 2;
  begin
    select count(*) into v_count
      from my_tab t
     where t.mt_id = mt_id; -- !
  end;
  -------
  dbms_output.put_line(v_count);  
  
end;
/

declare
  v_count number;
begin
  -------
  <<insert_block>>  
  declare
    mt_id number := 2;
  begin
    select count(*) into v_count
      from my_tab t
     where t.mt_id = mt_id; -- !
  end;
  -------
  dbms_output.put_line(v_count);  
  
end;
/

