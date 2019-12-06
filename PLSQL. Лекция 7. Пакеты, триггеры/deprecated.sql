create or replace package my_old_pack  as
  pragma deprecate(my_old_pack, 'package "my_old_pack" has been deprecated, use "my_new_pack" instead.');

  procedure foo;
end;
/


create or replace procedure call_old_pack_proc
is
begin
   my_old_pack.foo;
end;
/


--alter session set plsql_warnings='ENABLE:(6019,6020,6021,6022)';

