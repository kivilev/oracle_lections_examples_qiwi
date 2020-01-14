-- ************** DEMO. DML-триггеры. Обычные **************

drop table my_tab;
create table my_tab
(
  id   number(10) not null,
  name varchar2(100 char)  not null 
);
insert into my_tab select level, level from dual connect by level <= 5;


------- Пример 1. Обычный BEFORE-триггер на команду DELETE.
create or replace trigger my_tab_b_d_stmt
before
delete on my_tab
begin
  raise_application_error(-20101, 'Удалять нельзя!');  
end;
/

-- d
delete my_tab;
delete my_tab t where t.id = 0; -- ошибка, хотя такой строки даже нет


------- Пример 2. Обычный BEFORE-триггер на каждую строчку при INSERT или UPDATE
create or replace trigger my_tab_b_iu
before
insert or update on my_tab
for each row
begin
  if :new.id <= 0 then
    raise_application_error(-20100, 'Атата! Негативный ID');
  end if;  
end;
/

-- i
insert into my_tab values (1, '1'); -- ok
insert into my_tab values (-1, '-1');-- ошибка

-- u
update my_tab t set t.id = -1;


-------- Пример 3. AFTER на вставку данных
create or replace trigger my_tab_a_i
after 
insert on my_tab
for each row
begin
  dbms_output.put_line('В очередь событий добавлена запись с новым ID: '||:new.id);
end;
/

insert into my_tab values (2, '1'); -- ok

