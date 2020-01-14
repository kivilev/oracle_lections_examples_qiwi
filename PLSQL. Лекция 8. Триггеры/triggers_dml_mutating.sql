-- ************** DEMO. Мутирующая таблица **************

drop table my_tab;
create table my_tab
(
  id   number(10) not null,
  name varchar2(100 char)  not null 
);

--- Триггер
create or replace trigger my_tab_a_iud
after -- после операции
insert or update or delete on my_tab -- для трех операций
for each row
declare
  v_cnt number;
begin
  select count(*) into v_cnt from my_tab;
end;
/

-- ORA-04091: table HR.MY_TAB is mutating, trigger/function may not see it
insert into my_tab values(1, 'USD');
