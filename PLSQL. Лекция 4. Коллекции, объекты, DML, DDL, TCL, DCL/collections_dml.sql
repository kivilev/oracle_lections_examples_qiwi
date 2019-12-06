/*
drop table my_tab;
drop sequence my_seq;

create table my_tab
(
 id number,
 v1 varchar2(100 char)
);

create or replace type t_rowids force is table of varchar2(100);
/
create or replace type t_numbers force is table of number;
/

create sequence my_seq;
*/

declare
  v_id  my_tab.id%type;  
  v_str my_tab.v1%type;    
begin
  -- Единичный INSERT
  insert into my_tab
    values (my_seq.nextval, 'строка-'||my_seq.currval)
  returning id, v1 into v_id, v_str;
  
  dbms_output.put_line('NEW. id: '|| v_id||'. str: '||v_str);   
end;
/


--------- UDPATE
truncate table my_tab;
insert into my_tab values(1, 'строка-1');
insert into my_tab values(2, 'строка-2');
insert into my_tab values(3, 'строка-3');
insert into my_tab values(4, 'строка-4');
insert into my_tab values(5, 'строка-5');
commit;

-- выполняем блок
declare
  v_upd_rowids t_rowids;
  v_upd_ids    t_numbers;
  v_rowid      rowid;
  v_str        my_tab.v1%type;
begin

  update my_tab t
     set t.v1 = 'измененные строки-'||t.id
   where t.id in (3, 4, 5)
  returning rowid, t.id 
  bulk collect into v_upd_rowids, v_upd_ids;
   
  --- проходим по измененым записям
  if v_upd_ids is not empty then
    for i in v_upd_ids.first..v_upd_ids.last loop
      dbms_output.put_line('UPD. id: '|| v_upd_ids(i)||'. rowid: '||v_upd_rowids(i));       
    end loop;
  end if;
  
  --- 1 строка
  update my_tab t
     set t.v1 = 'новое значение'
   where t.id = 1
  returning rowid, t.v1 
       into v_rowid, v_str;
  dbms_output.put_line('UPD 1 row. Rowid: '||v_rowid||'. Str: '||v_str
  );       
       
end;
/

---------- DELETE
declare
  v_upd_rowids t_rowids;
  v_upd_ids    t_numbers;
  type t_strings is table of varchar2(200 char);
  v_upd_str    t_strings;  
begin

  delete from my_tab t
   where t.id in (3, 4, 5)
  returning rowid, t.id, t.v1
  bulk collect into v_upd_rowids, v_upd_ids, v_upd_str;
   
  --- проходим по измененым записям
  for i in v_upd_ids.first..v_upd_ids.last loop
    dbms_output.put_line('DEL. id: '|| v_upd_ids(i)||'. rowid: '||v_upd_rowids(i)||'. str: '||v_upd_str(i));       
  end loop;

  rollback;
end;
/


