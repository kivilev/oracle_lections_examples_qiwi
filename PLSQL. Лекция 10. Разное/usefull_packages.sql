-- ******************* DEMO. Полезные пакеты **********************


create or replace procedure sleep(p_sec number) is
begin
   dbms_session.sleep(p_sec);
end;
/   

-------- 1) DBMS_APPLICATION_INFO
-- Пример с установкой версии клиента и смены действия
declare
  v_payments_count number := 3;
  v_txn_id         number := 0;
begin
  dbms_application_info.set_client_info(client_info => 'app-java-processing');
  dbms_application_info.set_module(module_name => 'процессинг платежей', action_name => '');
  
  -- обрабатываем в цикле платежи со сменой информации о выполняемом действии
  for i in 1..v_payments_count loop
    v_txn_id := trunc(dbms_random.value(100000000, 999999999));      
       
    dbms_application_info.set_action(action_name => 'создание платежа. txn_id: '||v_txn_id);
       sleep(2);
    dbms_application_info.set_action(action_name => 'определение лимитов. txn_id: '|| v_txn_id);
       sleep(2);
    dbms_application_info.set_action(action_name => 'проведение платежа. txn_id: '|| v_txn_id);    
       sleep(2);  
  end loop;      
  
  dbms_application_info.set_module(module_name => null, action_name => null);-- чистим инфу
end;
/


-- Прогресс выполнения в программе/скрипте
declare
  v_rindex    binary_integer := dbms_application_info.set_session_longops_nohint;
  v_slno      binary_integer;
  v_totalwork number := 50;
  v_obj       binary_integer;
  
  procedure inc_step(p_i number) is
  begin
    dbms_application_info.set_session_longops(rindex      => v_rindex,
                                              slno        => v_slno,
                                              op_name     => 'Обработка транзакций',
                                              target      => v_obj,
                                              context     => 0,
                                              sofar       => p_i,
                                              totalwork   => v_totalwork,
                                              target_desc => 'транзакция',
                                              units       => 'транзакций');
  end;
  
begin
  for i in 1..v_totalwork loop
    -- что-то делаем
    dbms_session.sleep(seconds => 0.5);
    --
    inc_step(i);--+1 шаг
  end loop;  
end;
/

-- информация в представлениях v$session, v$sesssion_longops

-------------- 2)  DBMS_ASSERT 
declare
  v_schema_name all_users.username%type := 'HR';
  v_object_name all_objects.object_name%type := 'CURRENCY';
  v_res         varchar2(200 char);
begin
  -- есть ли такая схема
  v_res := dbms_assert.schema_name(v_schema_name);
  dbms_output.put_line('schema_name: '|| v_res); 
  
  -- есть ли такой объект  
  v_res := dbms_assert.sql_object_name(v_object_name);
  dbms_output.put_line('sql_object_name: '|| v_res); 
  
  -- и другие функции  
exception 
  when dbms_assert.invalid_schema_name then
    dbms_output.put_line('Не правильное имя схемы');
    raise;
  when dbms_assert.invalid_object_name then
    dbms_output.put_line('Не правильное имя объекта');
    raise;
end;
/


-------------- 3) DBMS_CRYPTO  (XE, EE)
-- grant execute on sys.dbms_crypto to hr;
-- Пример из доки
declare
   input_string       varchar2 (200) :=  'Secret Message. Секретное сообщение';
   output_string      varchar2 (200);
   encrypted_raw      raw (2000);             -- stores encrypted binary text
   decrypted_raw      raw (2000);             -- stores decrypted binary text
   num_key_bytes      number := 256/8;        -- key length 256 bits (32 bytes)
   key_bytes_raw      raw (32);               -- stores 256-bit encryption key
   encryption_type    pls_integer :=          -- total encryption type
                            dbms_crypto.encrypt_aes256
                          + dbms_crypto.chain_cbc
                          + dbms_crypto.pad_pkcs5;
   iv_raw             raw (16);
begin
   dbms_output.put_line ( 'Original string: ' || input_string);
   
   key_bytes_raw := dbms_crypto.randombytes (num_key_bytes);
   iv_raw        := dbms_crypto.randombytes (16);
   encrypted_raw := dbms_crypto.encrypt
      (
         src => utl_i18n.string_to_raw (input_string,  'AL32UTF8'),
         typ => encryption_type,
         key => key_bytes_raw,
         iv  => iv_raw
      );

    dbms_output.put_line('Crypted string: '||encrypted_raw); 

    decrypted_raw := dbms_crypto.decrypt
      (
         src => encrypted_raw,
         typ => encryption_type,
         key => key_bytes_raw,
         iv  => iv_raw
      );

   output_string := utl_i18n.raw_to_char (decrypted_raw, 'AL32UTF8');

   dbms_output.put_line ('Decrypted string: ' || output_string); 
end;
/

-------------- 4) DBMS_HPROF
---1. Генерируем процедуры с непредсказуемой задержкой
declare
  v_procs varchar2(32000 char);
begin          
  -- создаем N-процедур
  for v in (  select 'create or replace procedure '||proc_name||' is'||chr(13)||
                     'begin '||chr(13)||
                     '  sleep('||ms||');'||chr(13)||
                     'end;' sqll,
                     chr(9)||proc_name || '();'||chr(13) proc_name_in_script    
                from (select 'test_proc_' || level proc_name,
                             trunc(dbms_random.value(1, 5)) ms
                        from dual
                      connect by level <= trunc(dbms_random.value(4, 10)))) loop
  
    execute immediate v.sqll;
    v_procs := v_procs||v.proc_name_in_script;
  
  end loop;           
  
  dbms_output.put_line(v_procs); 
  
  execute immediate '
create or replace procedure test_main_proc is
begin
'||v_procs||'
end;  
  ';  
end;
/

--- 2. Тестируем нашу процедуру
begin
  -- вкл профилирование
  dbms_hprof.start_profiling(location => 'HPROFILER_DIR', filename => 'my_profiler.trc');
  -- тестируемая процедура
  test_main_proc();
  -- выкл профилинивароние
  dbms_hprof.stop_profiling();
end;
/

--- 3. Обрабатываем трейс
-- docker exec -it oracle18xe /bin/bash
-- cd /opt/oracle/diag/hprofiler
-- plshprof my_profiler.trc
-- cp ./my_profiler.html /opt/oracle/oradata
-- C:\Users\d.kivilev\Qiwi\dbs\oracle18xe


--dbms_parallel_execute 

-------------- 5) DBMS_UTILITY
declare
  v_arr dbms_utility.number_array;
  t1    number;
  v_len   number;
  v2  dbms_utility.uncl_array;
  v_str  varchar2(4000 char);
begin
  -- время
  t1 := dbms_utility.get_time();
  sleep(1);
  dbms_output.put_line(dbms_utility.get_time() - t1);
  
  -- компиляция в схеме только невалидных объектов
  dbms_utility.compile_schema(schema => user, compile_all => false);
  
  -- разбивка строки с запятыми в коллекцию
  dbms_utility.comma_to_table('tab1, tab2, tab3', v_len, v2);
  for i in v2.first..v2.last loop
    dbms_output.put_line(trim(v2(i))); 
  end loop;

  -- коллекцию в строку
  dbms_utility.table_to_comma(v2, v_len, v_str);
  dbms_output.put_line('Coll to str: '||v_str);  

end;
/

declare
  a varchar2(100 char);
  b varchar2(100 char);
  c varchar2(100 char);   
  dblink_n varchar2(100 char);   
  t1   number;
  v    number;
  i    number := 0;  
begin 
  -- парсим объекты
  dbms_utility.name_tokenize('hr.demo_pack.demo_func@dblink_name', a => a, b => b, c => c, dblink => dblink_n, nextpos => v);
  dbms_output.put_line(a||' - '||b||' - '||c||' - '||dblink_n); 
  
  t1 := dbms_utility.get_cpu_time();
  loop
    v := dbms_random.value(1,2);
    exit when i <= 100;
    i := i+1;
  end loop;
  dbms_output.put_line('CPU time: '||(dbms_utility.get_cpu_time()-t1));
end;
/





