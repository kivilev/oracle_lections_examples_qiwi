------- TYPE и ROWTYPE (схема HR)

declare
  ------ type
  v_department_name   dep.name%type;
  v_department_name2  v_department_name%type;
  v_department_name3  dep.name%type := 'SOMEIT';
  v_department_name4  constant dep.name%type := 'IT';
  ------ rowtype
  v_department_row    dep%rowtype;
  v_department_row2   v_department_row%type;
  v_department_row3   v_department_row%rowtype;
begin
  -- type
  select t.name into v_department_name
    from dep t 
    where t.id = 1;

  select t.name into v_department_name2
    from dep t where t.id = 2;

  select t.name into v_department_name3
    from dep t where t.id = 3;

  dbms_output.put_line('Type. 1: '||v_department_name||
                              '. 2: '||v_department_name2 ||
                              '. 3: '||v_department_name3); 

  -- rowtype
  select t.*
    into v_department_row
    from dep t 
   where t.id = 1;

  select t.*
    into v_department_row2
    from dep t 
   where t.id = 2;

  select t.id, t.name
    into v_department_row3
    from dep t 
   where t.id = 3;
   
  dbms_output.put_line('Rowtype. 1: '||v_department_row.name||
                              '. 2: '||v_department_row2.name ||
                              '. 3: '||v_department_row3.name); 
end;
/

