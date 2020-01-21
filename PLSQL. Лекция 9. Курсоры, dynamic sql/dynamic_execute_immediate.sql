-- *********** DEMO. Динамический SQL (execute immediate)

drop table demo;
create table demo
(
 id number,
 name varchar2(200 char)
);
alter table demo add constraint demo_pk primary key (id);

--- Пример 1. Вставка 10 записей
declare
begin
  for i in 1..10 loop
    -- здесь мы меняем динамически значение, а не сам запрос - это ок
    execute immediate 'insert into demo values(:id, :name)' using i, 'name_'||i;
  end loop;
end;
/
select * from demo;

--- Пример 2. Очистка таблицы
declare
   procedure clear_tab(pi_table_name user_objects.object_name%type)
   is
   begin
     execute immediate 'truncate table '||pi_table_name;
   end;
begin
   clear_tab('demo');
end;
/
select * from demo;


--- Пример 3. Получаем результат в коллекцию (рекорд). Условие тоже из коллекции (number)
insert into demo select level, 'n_'||level 
  from dual connect by level <= 10;

create or replace type t_ids is table of number;
/

declare
  type t_arr is table of demo%rowtype;  
  v_result t_arr;
  v_ids t_ids := t_ids(1, 2, 3);
begin
  execute immediate 'select * 
                       from demo 
                      where id in (select value(t) 
                                     from table(:ids) t)'
     bulk collect into v_result
    using v_ids;
  
  dbms_output.put_line('Count: '||v_result.count());  
  
end;
/

--- Пример 4. Получаем результат в две переменные.
declare
  v_id    demo.id%type; 
  v_name  demo.name%type;
begin
  execute immediate 'select id, name from demo where id = :v_id'
     into v_id, v_name
    using 5;
  
  dbms_output.put_line('id: '||v_id||'. name: '||v_name); 
end;
/


--- Пример 5. Вызываем PL/SQL-блок
create or replace procedure demo_prc(p_id in demo.id%type, p_name out demo.name%type)
is
begin
  select t.name
    into p_name
    from demo t
  where t.id = p_id;
end;
/

declare
  v_id   demo.id%type := 10;
  v_name demo.name%type;
begin
  execute immediate 'begin
                         demo_prc(:id, :name);
                     end;'
    using in v_id, out v_name;
  
  dbms_output.put_line('id: '||v_id||'. name: '||v_name);
end;
/

