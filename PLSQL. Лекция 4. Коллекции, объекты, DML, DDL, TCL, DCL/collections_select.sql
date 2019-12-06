------ DEMO. Выборка из SELECT 
/*
create or replace type t_my_obj is object (n1 number, n2 number);
/
create or replace type t_my_obj_arr is table of t_my_obj;
/
*/

declare
  type t_rec is record(
    n1 number,
    n2 number);
  type t_arr is table of t_rec;
  type t_map is table of number index by varchar2(200 char);--map  
  
  v_arr  t_arr;
  v_arr2 t_my_obj_arr;
  v_map  t_map;
begin
  ------ 1. Обычный запрос с сохранением bulk collect into -> внутренний тип + record
  select level, level
    bulk collect into v_arr
    from dual
  connect by level <= 5;

  dbms_output.put_line('Count(block type + record): '||v_arr.count());

  ------ 2. Обычный запрос с сохранением bulk collect into -> внутренний тип + record
  select t_my_obj(level, level)
    bulk collect into v_arr2
    from dual
  connect by level <= 6;

  dbms_output.put_line('Count(schema type + object): '||v_arr2.count());

  ------ 3. Запрос сохранением into c multiset
  select cast(
              multiset(
                       select t_my_obj(level, level)
                         from dual connect by level <= 7
                      ) 
                    as t_my_obj_arr)
    into v_arr2
    from dual;

  dbms_output.put_line('Count(schema type + object). Multicast: '||v_arr2.count());

  ------ 4. Cursor + loop
  for rec in (select level key, level value
                from dual
              connect by level <= 8) loop
    v_map(rec.key) := rec.value;
  end loop;
  dbms_output.put_line('Count(block type + record). Cursor in loop: '||v_map.count());
   
end;
/
