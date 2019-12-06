---- DEMO. Нехватка PGA. ODBA

create or replace type t_my_obj force is object(
  f1 number,
  f2 varchar2(4000 char),
  f3 varchar2(4000 char),
  f4 varchar2(4000 char),
  f5 varchar2(4000 char)
);
/

create or replace type t_my_arr is table of t_my_obj;
/

declare
  v_objs t_my_arr;
begin
  print_pga_usage();

  select t_my_obj(level,
                  rpad(level, 4000, 'Я'),
                  rpad(level, 4000, 'Я'),
                  rpad(level, 4000, 'Я'),
                  rpad(level, 4000, 'Я'))
    bulk collect
    into v_objs
    from dual
  connect by level <= 10000;

  print_pga_usage();
 
end;
/

-- процедура возращающая значение использованной PGA
create or replace procedure print_pga_usage
is
  v_size  number;
begin
  select round(p.pga_alloc_mem / 1024)
    into v_size
    from v$session s, v$process p
   where p.addr = s.paddr
     and s.sid = sys_context('USERENV', 'SID');
  dbms_output.put_line(v_size||' Kb');
end;
/


/*
ORA-04036: PGA memory used by the instance exceeds PGA_AGGREGATE_LIMIT
ORA-06512: at line 4
*/


/*
 -- SYS
 SELECT name, sum(value/1024) "Value - KB"
   FROM v$statname n,
        v$session s,
        v$sesstat t
  WHERE s.sid=t.sid
    AND n.statistic# = t.statistic#
    AND s.type = 'USER'
    AND s.username is not NULL
    AND n.name in ('session pga memory', 'session pga memory max', 
        'session uga memory', 'session uga memory max')
  GROUP BY name
 /

*/
