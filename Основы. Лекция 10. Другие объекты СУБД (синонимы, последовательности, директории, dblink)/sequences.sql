-- drop sequence my_seq;
-- drop sequence my_seq_nocache;
create sequence my_seq increment by 1 cache 100;
create sequence my_seq_nocache increment by 1 nocache;
create sequence my_seq_sess session;-- Только в 12с!

select my_seq.currval from dual;
select my_seq.nextval from dual;

------------- Сравнение: с кэшем без кэша
declare
  v_id number;
  s1   number;
  s2 number;
  s3 number;
begin
  s1 := dbms_utility.get_time();
  for i in 1..100000 loop
    v_id := my_seq_nocache.nextval;
  end loop;
  
  s2 := dbms_utility.get_time();
  
  for i in 1..100000 loop
    v_id := my_seq.nextval;
  end loop;
  
  s3 := dbms_utility.get_time();  
  dbms_output.put_line('Time. nocache: '||(s2-s1)/100||' s. cache 100: '||(s3-s2)/100||' s.'); 
  
end;
/  

------------- Сравнение: генерация в sql или pl/sql
declare
  v_id number;
  s1   number;
  s2 number;
  s3 number;
begin
  s1 := dbms_utility.get_time();
  for i in 1..100000 loop
    select my_seq.nextval into v_id from dual;
  end loop;
  
  s2 := dbms_utility.get_time();

  for i in 1..100000 loop
    v_id := my_seq.nextval;
  end loop;
  
  s3 := dbms_utility.get_time();  
  dbms_output.put_line('Time sql: '||(s2-s1)/100||' s. Time pl/sql: '||(s3-s2)/100||' s.'); 
  
end;
/  

------------- Создание таблицы с автоинкрементом
create table client
(
  client_id number(30) generated always as identity(start with 100 increment by 2 cache 3),
  full_name varchar2(400 char) not null
);  

insert into client(full_name) select 'full_name_'||level  from dual connect by level <= 100;
commit;

select * from client;

-- Удаляем хитро
drop table client cascade constraints purge;

select * from user_sequences
select  iseq$$_90209.nextval from dual;
