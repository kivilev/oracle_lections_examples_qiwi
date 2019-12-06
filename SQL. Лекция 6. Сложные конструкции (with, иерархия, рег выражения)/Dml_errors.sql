drop table data_tab;

-- Создаем табличку с исходными данными
create table data_tab (
id     number not null,
v2_field varchar2(1),
num_field number(1)
);

alter table data_tab add constraint data_tab_pk primary key (id);
alter table data_tab add constraint data_tab_num_chk check (num_field in (0,1));

-- пробуем вставить строки
insert into data_tab
select level,
       decode(mod(level, 3), 0, '1', 1, 'z', 2, 'Я') v2_field,
       mod(level, 3) num_field
       --, level
       --, mod(level, 3)       
  from dual connect by level <= 10;
  
begin
   dbms_errlog.create_error_log('data_tab','errors_data_tab') ;
end;
/

insert into data_tab
select level,
       decode(mod(level, 3), 0, '1', 1, 'z', 2, 'Я') v2_field,
       mod(level, 3) num_field
       --, level
       --, mod(level, 3)       
  from dual connect by level <= 10
-- сохраняем ошибки в   
log errors into errors_data_tab reject limit unlimited;

select * from errors_data_tab;
select * from data_tab;
--drop table errors_data_tab
