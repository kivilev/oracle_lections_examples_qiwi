------- ���������� � QIWI (dbms_lock)

select nvl(null, 2) nvl_null,
       nvl(1, 2) nvl_notnull,
       -- nvl2
       nvl2(null, 'notnull', 'isnull') nvl2_null,
       nvl2('3', 'notnull', 'isnull') nvl2_notnull,
       -- nullif
       nullif(2, 3) nullif_noteq,
       nullif(2, 2) nullif_eq,
       -- coalesce
       coalesce(1, 2, 3) coalesce_1pos,
       coalesce(null, 2, 3) coalesce_2pos,
       coalesce(null, null, 3) coalesce_3pos
  from dual;

-------------------------- NVL vs COALESCE
drop sequence del$my_seq;
create sequence del$my_seq;
-- ������� ���� 5 ��� � ������ +1 �� ������������������
create or replace function get_new_id return number
is
begin
  dbms_lock.sleep(5);
  return del$my_seq.nextval;
end;
/

-- NVL.���� �������� �� ������, �� ������� ����� ID. 
-- �������� � ��� ������, ������� �������, ��� ��������� 2(get_new_id) ����������� �� �����. 
select nvl(1, get_new_id())
   from dual;

-- ����� ��������
select del$my_seq.currval from dual;

-- COALESCE. ���� �������� �� ������, �� ������� ����� ID. 
-- �������� � ��� ������, ������� �������, ��� ��������� 2(get_new_id) ����������� �� �����. 
select coalesce(1, get_new_id())
   from dual;


