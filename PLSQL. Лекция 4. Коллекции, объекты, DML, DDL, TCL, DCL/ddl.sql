--- DEMO. DDL

drop table my_tab;
create table my_tab
(
  n1 number
);

-- Неправильно
begin
  truncate table my_tab;
end;
/

-- Правильно
begin
  execute immediate 'truncate table my_tab';
end;
/

