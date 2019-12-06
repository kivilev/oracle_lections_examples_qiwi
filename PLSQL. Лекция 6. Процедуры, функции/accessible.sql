-- ******************** DEMO. ACCESSIBLE BY (только в 12+) *********************

------ функция для которой нужно ограничить доступ
create or replace function get_admin_secret_key
return varchar2
accessible by (procedure change_user, procedure delete_user)
is
  v_out varchar2(100);
begin
  dbms_output.put_line('-- inside get_admin_secret_key --');   
  dbms_obfuscation_toolkit.MD5(input_string => 'key1', checksum_string => v_out);
  return v_out;
end;
/

------ лигитимная процедура 1
create or replace procedure change_user(pi_user_id number)
is
  v_hash varchar2(1000);
begin
  dbms_output.put_line('Changing user: '||pi_user_id||'...');
  v_hash := get_admin_secret_key();
  -- ... что-то делаем ...
  dbms_output.put_line('successfull end.');   
end;
/

------ лигитимная процедура 2
create or replace procedure delete_user(pi_user_id number)
is
  v_hash varchar2(1000);
begin
  dbms_output.put_line('Deleting user: '||pi_user_id||'...');
  v_hash := get_admin_secret_key();
  -- ... что-то делаем ...
  dbms_output.put_line('successfull end.');   
end;
/

----- процедура взломщика :)
create or replace procedure hacker
is
  v_hash varchar2(1000);
begin
  v_hash := get_admin_secret_key();
end;
/

---- вызываем

call change_user(100);
call delete_user(999);
call hacker();





