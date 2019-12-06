------ Логинимся под d_toyota
-- 1. Создаем синоним
drop table my_private_tab;
drop public synonym toyota_tab;

create table my_private_tab
(
  id number,
  name varchar2(200 char)
);

-- 2. Заполняем данные
insert into my_private_tab select level, 'name-'||level from dual connect by level <= 100;
commit;

-- 3. Создаем PUBLIC синоним (grant create public synonym to d_toyota; grant drop public synonym to d_toyota;)
-- create public synonym toyota_tab for my_private_tab;

-- Без грантов на сам объект, работать не будет
grant select on my_private_tab to public;

