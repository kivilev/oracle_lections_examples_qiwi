-- ************** DEMO. Кэширование ************************

drop table currency;
create table currency
(
  curr_id  number(10),
  iso_code char(3)
);

-- загрузили данными
insert into currency values (643, 'RUB');  
insert into currency values (810, 'RUR');
insert into currency values (840, 'USD');
commit;

--- Создаем спецификацию пакета
create or replace package my_currency_pack is
  -- внутренний тип
  type t_curr_code is table of currency.iso_code%type index by pls_integer;

  -- функция возвращающая код
  function get_code_by_curr_id(pi_curr_id currency.curr_id%type) return currency.iso_code%type;

end;
/


--- Создаем тело пакета
create or replace package body my_currency_pack is

  g_currency_array t_curr_code;

  -- функция возвращающая код
  function get_code_by_curr_id(pi_curr_id currency.curr_id%type) return currency.iso_code%type
  is
    v_out currency.iso_code%type := null;
  begin
    if g_currency_array.exists(pi_curr_id) then
      v_out := g_currency_array(pi_curr_id);
    end if;
    return v_out;
  end;

-- блок инициализации
begin
  -- кэшируем справочник
  for i in (select * from currency) loop
    g_currency_array(i.curr_id) := i.iso_code;
  end loop;
end;
/


------ Тестируем
begin
   dbms_output.put_line('643: '||my_currency_pack.get_code_by_curr_id(643) );  
   dbms_output.put_line('1: '  ||my_currency_pack.get_code_by_curr_id(1) );  
   dbms_output.put_line('840: '|| my_currency_pack.get_code_by_curr_id(840) );     
end;
/



--------- Пример 2. Сравнение с другими способами кэширования

-- до 1000 элементов
insert into currency
select id, code from (
select level id, level code
  from dual connect by level < 1000)
  where id not in (643, 810, 849);
commit;

----- Тестирование.
declare
 t1 number;
 t2 number;
 t3 number;
 t4 number; 
 N  number := 10000;
 v_res currency.iso_code%type;
begin
  t1 := dbms_utility.get_time();
  
  -- Обычная
  for i in 1..N loop
    v_res := my_currency_pack.get_code_by_curr_id_simple(trunc(dbms_random.value(1,1000)));
  end loop;
  
  t2 := dbms_utility.get_time();
  -- Result Cache
  for i in 1..N loop
    v_res := my_currency_pack.get_code_by_curr_id_rc(trunc(dbms_random.value(1,1000)));
  end loop;
  
  t3 := dbms_utility.get_time();
  -- Package
  for i in 1..N loop
    v_res := my_currency_pack.get_code_by_curr_id(trunc(dbms_random.value(1,1000)));
  end loop;
  
  t4 := dbms_utility.get_time();
  
  dbms_output.put_line('Usual: '||(t2-t1)/100||'. RC: '||(t3-t2)/100||'. Pkg: '||(t4-t3)/100 ); 
  
end;
/

---------- Проверка изменения
select my_currency_pack.get_code_by_curr_id(643) currency_code_pkg,
       my_currency_pack.get_code_by_curr_id_rc(643) currency_code_rc
  from dual;


/*
update currency t set t.iso_code = 'RRR'
  where t.curr_id = 643;
commit;
*/
