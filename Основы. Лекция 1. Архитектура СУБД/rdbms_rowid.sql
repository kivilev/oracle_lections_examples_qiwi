create table mytab
(
n1 number,
v2 varchar2(100 char)
);

insert into mytab
select level, 't'||level from dual connect by level < 10;


select rowid, t.* 
  from mytab t;
  
select rowid, t.* 
  from mytab t
 where t.rowid = chartorowid('AAC4Q5AGEAAAACKAAA');
