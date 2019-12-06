------ Скорость выполнения регулярок

-- Две процедуры по проверке строка на число. PL/SQL
declare
  v_t1  pls_integer;
  v_t2  pls_integer;
  v_t3  pls_integer;
  v_tmp number;
  v_n   number := 1000000;

  -- Регулярное выражение
  function check_num_regexp(p_string varchar2) return number is
  begin
    return(case when regexp_like(p_string, '^\d+$') then 0 else 1 end);
  end;

  -- pl/sql translate
  function check_num_translate(p_string varchar2) return number is
  begin
    return case when translate(p_string, '?0123456789', '?') is not null then 1 else 0 end;
  end;

begin
  
  v_t1 := dbms_utility.get_time();

  for cc in 1 .. v_n loop
    v_tmp := check_num_regexp(case
                                when mod(cc, 2) = 0 then
                                 'V' || cc
                                else
                                 '' || cc
                              end);
  end loop;

  v_t2 := dbms_utility.get_time();
  
  for cc in 1 .. v_n loop
    v_tmp := check_num_translate(case
                                   when mod(cc, 2) = 0 then
                                    'V' || cc
                                   else
                                    '' || cc
                                 end);
  end loop;
  
  v_t3 := dbms_utility.get_time();

  dbms_output.put_line('Regexp: '||(v_t2-v_t1)||'. Translate: '||(v_t3-v_t2));   

end;
/

--------------- SQL ------------------------
-- Регулярное выражение
create or replace function check_num_regexp(p_string varchar2) return number is
pragma udf;
begin
  return(case when regexp_like(p_string, '^\d+$') then 0 else 1 end);
end;
/

-- pl/sql translate
create or replace function check_num_translate(p_string varchar2) return number is
pragma udf;
begin
  return case when translate(p_string, '?0123456789', '?') is not null then 1 else 0 end;
end;
/

--- 
select count(check_num_regexp(case
                                when mod(level, 2) = 0 then
                                 'V' || level
                                else
                                 '' || level
                              end)) cnt
  from dual
connect by level <= 1000000;


select count(check_num_translate(case
                                when mod(level, 2) = 0 then
                                 'V' || level
                                else
                                 '' || level
                              end)) cnt
  from dual
connect by level <= 1000000;



