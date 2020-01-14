-- ************** DEMO. OLD/NEW **************

drop table my_tab;

create table my_tab
(
  id   number(10) not null,
  name varchar2(100 char)  not null 
);

--- Триггер
create or replace trigger my_tab_a_iud
after  -- после операции
insert or update or delete on my_tab  -- для трех операций
for each row   -- для каждой строки
begin
  -- Выводим инфу об операции
  if inserting then
    dbms_output.put_line('-- вставка');
  elsif updating then
    dbms_output.put_line('-- обновление');
  elsif deleting then
    dbms_output.put_line('-- удаление');
  end if;
  -- Значения ID для OLD/NEW
  dbms_output.put_line('new.name: '||:new.name);
  dbms_output.put_line('old.name: '||:old.name);
end;
/

-- вставка
insert into my_tab values(1, 'USD');
insert into my_tab values(2, 'RUB');

-- обновление
update my_tab t set t.name = t.name || '_upd';

-- удаление
delete from my_tab;



