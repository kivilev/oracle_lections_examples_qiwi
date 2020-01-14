-- ************* DEMO. DDL-триггеры **************

--- Пример 1. Срабатывает при удалении объекта. Простой триггер
create or replace trigger my_ddl_trigger
before drop on schema
begin
  dbms_output.put_line('----- my_ddl_trigger -----');
  dbms_output.put_line(' ...... '); 
  dbms_output.put_line('---------------------------');
end;
/

create sequence my_seq1;
drop sequence my_seq1;


----- Пример 2. Добавили вывод свойств + Запретили удаление сиквенса
create or replace trigger my_ddl_trigger
before drop on schema
begin
  dbms_output.put_line('----- my_ddl_trigger -----');
  -- свойства
  dbms_output.put_line('Object type: ' || ORA_DICT_OBJ_TYPE ||utl_tcp.crlf||
                       'User login:  ' || ORA_LOGIN_USER    ||utl_tcp.crlf||
                       'Event type:  ' || ORA_SYSEVENT      ||utl_tcp.crlf||
                       'DB name:     ' || ORA_DATABASE_NAME);
  
  -- Ограничиваем удаление объектов в схеме 
  if upper(ora_dict_obj_type) = 'SEQUENCE' and upper(ora_dict_obj_name) = 'MY_SEQ2' then
    raise_application_error(-20100, 'Can''t drop sequence my_seq2!');
  end if;
   
  dbms_output.put_line('-------------------------');
end;
/

create sequence my_seq1;
drop sequence my_seq1;
create sequence my_seq2;
drop sequence my_seq2;


----- Пример 3. DROP или CREATE + Выводим SQL-текст
create or replace trigger my_ddl_trigger
before drop or create on schema
declare
  v_sqls dbms_standard.ora_name_list_t;
  v_res  number;
begin
  dbms_output.put_line('----- my_ddl_trigger -----');
  -- свойства
  dbms_output.put_line('Object type: ' || ORA_DICT_OBJ_TYPE ||utl_tcp.crlf||
                       'User login:  ' || ORA_LOGIN_USER    ||utl_tcp.crlf||
                       'Event type:  ' || ORA_SYSEVENT      ||utl_tcp.crlf||
                       'DB name:     ' || ORA_DATABASE_NAME);
  
  -- выведем sql-текст 
  v_res := ora_sql_txt(sql_text => v_sqls);
  if v_sqls is not empty then
    for i in v_sqls.first..v_sqls.last loop
      dbms_output.put_line(v_sqls(i));
    end loop;
  end if;
    
  dbms_output.put_line('-------------------------');
end;
/

create sequence my_seq1;
drop sequence my_seq1;

