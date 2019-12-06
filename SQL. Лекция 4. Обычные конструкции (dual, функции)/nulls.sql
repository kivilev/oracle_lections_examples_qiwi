------- ПОКАЗЫВАТЬ В QIWI (dbms_lock)

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
-- Функция спит 5 сек и отдает +1 от последовательности
create or replace function get_new_id return number
is
begin
  dbms_lock.sleep(5);
  return del$my_seq.nextval;
end;
/

-- NVL.Если значение не задано, то генерим новое ID. 
-- значение у нас задано, поэтому логично, что выражение 2(get_new_id) выполняться не будет. 
select nvl(1, get_new_id())
   from dual;

-- можно получить
select del$my_seq.currval from dual;

-- COALESCE. Если значение не задано, то генерим новое ID. 
-- значение у нас задано, поэтому логично, что выражение 2(get_new_id) выполняться не будет. 
select coalesce(1, get_new_id())
   from dual;


