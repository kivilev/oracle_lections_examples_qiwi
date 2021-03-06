----- ������. HASH-����������������� (�� ����������)
create table del$hash_order(
  order_id number,
  sernum varchar2(100),
  state_code varchar2(10)
)
partition by hash (order_id) 
interval 
(partition p1, partition p2, partition p3, partition p4);

-- ��������� ������
insert into del$hash_order(order_id, sernum, state_code)
values (1, '111', 'MA');

insert into del$hash_order(order_id, sernum, state_code)
values (2, '222', 'TX');

insert into del$hash_order(order_id, sernum, state_code)
values (3, '333', null);

insert into del$hash_order(order_id, sernum, state_code)
values (4, '444', 'ZZZ');

-- ������� ��������, � ����� ���� ����� ������
select * from del$hash_order partition (p1);
select * from del$hash_order partition (p2);
select * from del$hash_order partition (p3);
select * from del$hash_order partition (p4);

insert into del$hash_order
select level, level, level from dual connect by level <= 100;


