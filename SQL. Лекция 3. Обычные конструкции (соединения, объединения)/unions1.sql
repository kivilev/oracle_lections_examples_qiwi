create table A(a number);
create table B(b number);

insert into A values(1); 
insert into A values(2); 
insert into A values(3); 
insert into A values(3);
insert into A values(null);

insert into B values(2); 
insert into B values(3); 
insert into B values(3);
insert into B values(4);
insert into B values(null);

commit;

--- UNION
select * from A
union
select * from B;

--- UNION ALL
select * from A
union all
select * from B;

--- INTERSECT
select * from A
intersect
select * from B;

--- MINUS
select * from A
minus
select * from B;

