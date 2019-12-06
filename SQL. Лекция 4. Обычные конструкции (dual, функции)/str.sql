----- Пример. Логируем сообщения
drop table msg;
drop sequence msg_seq;
create table msg
(
  id number not null,
  dtime timestamp default systimestamp,
  message varchar2(10)
);
create sequence msg_seq;

-- процедура логирования (1я версия)
create or replace procedure log_msg(p_message msg.message%type) is
pragma autonomous_transaction;
begin
  insert into msg (id, message) 
  values (msg_seq.nextval, p_message);
  commit;
end;
/

-- вставляем строку -> все ок
call log_msg('1234567890');

-- посмотрим что получилось
select * from msg t order by t.dtime desc;


------  2. Пробуем вставить новую строку но с длинной 11 символов => ошибка
-- Разработчик допустил ошибку и не ограничил размер вставляемого значения
call log_msg('09876543211');

-- процедура логирования (2я версия, исправленная)
create or replace procedure log_msg(p_message msg.message%type) is
pragma autonomous_transaction;
begin
  insert into msg (id, message) 
  values (msg_seq.nextval, substr(p_message, 1, 10));
  commit;
end;
/

-- повторно вызываем с той же строкой -> все ок, строка обрезалась до длинны 10
call log_msg('09876543211');
select * from msg t order by t.dtime desc;


------- 3. пробуем вставить строку -> ?
call log_msg('сообщение новое');


-- процедура логирования (3я версия, исправленная)
create or replace procedure log_msg(p_message msg.message%type) is
pragma autonomous_transaction;
begin
  insert into msg (id, message) 
  values (msg_seq.nextval, substrb(p_message, 1, 10));
  commit;
end;
/
select * from msg t order by t.dtime desc;

