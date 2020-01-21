--- ******************** Неявные курсоры (implicit) *********************

drop table demo;
create table demo
(
 id number,
 name varchar2(200 char)
);
alter table demo add constraint demo_pk primary key (id);

insert into demo 
select level, 'n'||level from dual connect by level <= 10;
commit;


--- Пример 1. SELECT ... INTO
declare
  v_cnt number;
begin
  select count(*) into v_cnt 
    from demo; -- это неявный курсор
  
  dbms_output.put_line('Count rows: '||v_cnt||'. Rows return by query: '||sql%rowcount); 
end;
/

-- Пример 2. SELECT ... BULK COLLECT INTO 
declare
  v_cnt number;
  type t_ids is table of demo.id%type;
  v_ids t_ids;
begin
  select id 
    bulk collect into v_ids 
    from demo; -- это неявный курсор
  
  dbms_output.put_line('Collection size: '|| v_ids.count() ||'. Rows return by query: '||sql%rowcount); 
end;
/


--- Пример 3. DML
declare
  v_cnt number;
begin
  update demo t 
     set t.name = 'new_'||t.name
   where t.id in (1, 2, 11); -- id = 11 нет.

  dbms_output.put_line('Count updated rows: '||sql%rowcount); 
end;
/

-- Пример 4. Commit тоже курсор (частая ошибка ДБД)
declare
  v_cnt number;
begin
  update demo t 
    set t.name = 'new_'||t.name
   where t.id in (1, 2, 11); -- id = 11 нет.
  commit; -- !
  
  dbms_output.put_line('Count updated rows: '||sql%rowcount); --?
end;
/

-- Пример 5. DDL
begin
   execute immediate 'truncate table demo'; -- DDL
   dbms_output.put_line('Count updated rows: '||sql%rowcount); --?
end;
/


----- ODBA. Количество открытых курсоров
select a.value,
       s.program,
       s.username,
       s.sid,
       s.serial#,
       s.client_identifier
  from v$sesstat a, v$statname b, v$session s
 where a.statistic# = b.statistic#
   and s.sid = a.sid
   and b.name = 'opened cursors current'
   and s.USERNAME = 'HR'
 order by 1 desc;


select sa.sql_text, count(*) as "OPEN CURSORS", user_name
  from v$open_cursor t
  left join v$sqlarea sa on sa.sql_id = t.sql_id
 where user_name = 'HR'
 group by sa.sql_text, user_name
 order by count(*) desc;

