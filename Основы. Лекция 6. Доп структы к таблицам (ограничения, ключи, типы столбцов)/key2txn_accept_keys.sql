---- Пример, не очень хорошо созданной таблицы. qiwi.key2txn_accept_keys
create table key2txn_accept_keys
(
  accept_key_id          number(24) not null,
  partition_day          number(8) not null,
  remit_id               number(20) not null,
  recipient_account_type varchar2(8),
  recipient_account      varchar2(400),
  date_create            date not null,
  date_expire            date not null,
  date_action            date not null,
  accept_key             varchar2(30) not null,
  remit_state_id         number(3) not null,
  date_ins               date not null,
  date_last_upd          date not null
)
partition by range (partition_day);


-- create/recreate indexes 
create unique index key2txn_accept_keyq#key_id on key2txn_accept_keys (accept_key_id);

create index key2txn_accept_keyq#part on key2txn_accept_keys (partition_day);
create index key2txn_accept_keyq#remit_id on key2txn_accept_keys (remit_id) nologging  local;
create index key2txn_accept_keys#key on key2txn_accept_keys (accept_key) nologging  local;
create index key2txn_accept_keysq#state on key2txn_accept_keys (remit_state_id) nologging  local;

-- create/recreate primary, unique and foreign key constraints 
alter table key2txn_accept_keys add constraint key2txn_accept_keys_pkq primary key (accept_key_id);
