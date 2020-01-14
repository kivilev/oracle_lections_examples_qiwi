----- DEMO. Использование триггера для Аудита/Логирования

--- 1) Основная табличка
drop table wallet;
create table wallet
(
  wallet_id number(30) not null,   -- PK
  balance   number(20,2) not null, -- Баланс
  note      varchar2(100 char)     -- Примечание
);
alter table wallet add constraint wallet_pk primary key (wallet_id);


--- 2) Таблица аудита
drop table wallet_aud;
create table wallet_aud
(
  wallet_aud_id     number not null,
  -- тех поля
  change_dtime      timestamp default systimestamp not null,
  operation_type    char(1) not null,
  who_os_user       varchar2(200 char),
  who_oracle_user   varchar2(200 char),
  who_ip            varchar2(200 char),
  -- бизнесовые поля
  wallet_id         number(30) not null,
  balance_new       number(20,2),  --! Без NOT NULL
  balance_old       number(20,2),
  note_new          varchar2(100 char),
  note_old          varchar2(100 char)
);
create index wallet_aud_idx on wallet_aud (wallet_id);
alter table wallet_aud add constraint wallet_aud_ch check (operation_type in ('I', 'U', 'D'));
--
drop sequence wallet_aud_seq;
create sequence wallet_aud_seq cache 100;

----  3) Создаем триггер (After, для каждой строки)
create or replace trigger wallet_a_iud_audit
after insert or update or delete on wallet  -- на все операции
for each row -- для каждой строки
declare
  v_cmd wallet_aud.operation_type%type;
begin
  -- определяем операцию
  v_cmd := (case when inserting then 'I' 
                 when updating then 'U' 
            else 'D' end);
  -- вставка в табл аудита
  insert into wallet_aud
  select wallet_aud_seq.nextval,
         systimestamp,
         v_cmd,
         sys_context('userenv', 'os_user'),
         sys_context('userenv', 'session_user'),
         nvl(sys_context('userenv', 'ip_address'), 'localhost'),
         -- бизнесовые поля
         nvl(:new.wallet_id, :old.wallet_id),
         :new.balance,
         :old.balance,
         :new.note,
         :old.note
    from dual;           
end;
/


--------- Тестируем
-- вставка
insert into wallet values (1, 0, 'первый кошель'); 

-- обновлние
update wallet t
   set t.balance = 100
 where t.wallet_id = 1;

-- merge
merge into wallet o
using(select level wallet_id, level balance 
        from dual connect by level <= 3) n
 on (o.wallet_id = n.wallet_id)
when matched then update
    set o.balance = o.balance * 2
       ,o.note = 'обновлен в merge'
when not matched then insert 
    (wallet_id, balance, note)
    values (n.wallet_id, n.balance, 'вставлен из merge');

-- удаляем
delete wallet t 
  where t.wallet_id = 1;

select * from wallet_aud order by change_dtime desc; 




