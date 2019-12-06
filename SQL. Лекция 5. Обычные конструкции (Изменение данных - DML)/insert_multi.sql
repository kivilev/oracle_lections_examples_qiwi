-- ======================== DEMO. INSERT FIRST/ALL
drop table contact_raw;
drop table email;
drop table phone;
drop table person;
drop sequence email_seq;
drop sequence phone_seq;


------- Входные сырые данные
create table contact_raw
( 
  contact_ext_id varchar2(100 char),
  contact_type   varchar2(10 char),
  contact_value  varchar2(100 char),
  ext_person_id  varchar2(100 char),
  notes          varchar2(1000 char)
);

-- сырые данные
insert into contact_raw values ('ext_cont_id1', 'email', 'email1@gmail.com', 'ext_person_id_11', 'Примечание1');
insert into contact_raw values ('ext_cont_id2', 'phone', '+79999990001', 'ext_person_id_11', 'Примечание2');
insert into contact_raw values ('ext_cont_id3', 'phone', '+79999990002', 'ext_person_id_22', 'Примечание3');
insert into contact_raw values ('ext_cont_id4', 'email', 'email12@gmail.com', 'ext_person_id_33', 'Примечание4');

------- Персоны 
create table person
(
  id            NUMBER(30) not null,
  full_name     VARCHAR2(100 CHAR),
  ext_person_id VARCHAR2(100 CHAR)
);
alter table person add constraint person_pk primary key (id);
alter table person add constraint person_ext_person_id_uq unique (ext_person_id);

insert into person(id, full_name, ext_person_id) values (11, 'Персона 11', 'ext_person_id_11');
insert into person(id, full_name, ext_person_id) values (22, 'Персона 22', 'ext_person_id_22');
insert into person(id, full_name, ext_person_id) values (33, 'Персона 33', 'ext_person_id_33');

------- Email'ы персоны
create table email
(
  id        NUMBER(20) not null,
  person_id NUMBER(30),
  email     VARCHAR2(100 CHAR),
  notes     VARCHAR2(1000 CHAR)
);
alter table email add constraint email_pk primary key (id);
alter table email add constraint email_person_id_fk foreign key (person_id) references person (id);

------- Телефоны персоны
create table phone
(
  id        NUMBER(20) not null,
  person_id NUMBER(30),
  phone     VARCHAR2(100 CHAR),
  notes     VARCHAR2(1000 CHAR)
);
alter table phone add constraint phone_pk primary key (id);
alter table phone add constraint phone_person_id_fk foreign key (person_id) references person (id);

create sequence phone_seq start with 100;-- для различия стартуем с 100
create sequence email_seq;

-------- Функция, которая отдаст значение сиквенса для конкретного типа
create or replace function get_next_id(p_contact_type varchar2) return number 
is
pragma udf; -- указание, что ф-я будет юзаться в основнов в SQL.
begin
  return (case p_contact_type 
           when 'email' then email_seq.nextval
           when 'phone' then phone_seq.nextval
          end);
end;
/

--------------- Результирующий запрос
insert all
 -- email
 when contact_type = 'email'
   then into email(id, person_id, email, notes) values (email_seq.nextval, internal_person_id, contact_value, notes)
 -- phone
 when contact_type = 'phone'
   then into phone(id, person_id, phone, notes) values (phone_seq.nextval, internal_person_id, contact_value, notes)
select r.contact_type,
       r.contact_value,
       r.ext_person_id,
       r.notes,
       p.id internal_person_id,
       p.full_name
  from contact_raw r
  join person p on p.ext_person_id = r.ext_person_id;

insert all
 -- email
 when contact_type = 'email'
   then into email(id, person_id, email, notes) values (get_next_id(contact_type), internal_person_id, contact_value, notes)
 -- phone
 when contact_type = 'phone'
   then into phone(id, person_id, phone, notes) values (get_next_id(contact_type), internal_person_id, contact_value, notes)
select r.contact_type,
       r.contact_value,
       r.ext_person_id,
       r.notes,
       p.id internal_person_id,
       p.full_name
  from contact_raw r
  join person p on p.ext_person_id = r.ext_person_id;

select * from phone;
select * from email;

--select email_seq.currval, phone_seq.currval from dual;


--truncate table phone;
--truncate table email;

select email_seq.nextval,email_seq.currval, email_seq.nextval, email_seq.currval from dual
connect by level <= 5;
