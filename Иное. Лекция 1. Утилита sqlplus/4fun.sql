----------------------------------------
-- get the last SQL*Plus output in HTML
----------------------------------------

set termout off

set markup HTML ON HEAD " -
 -
" -
BODY "" -
TABLE "border='1' align='center' summary='Script output'" -
SPOOL ON ENTMAP ON PREFORMAT OFF

spool myoutput.html

select * from employees;
/

spool off
set markup html off spool off
set termout on
host start firefox myoutput.html
exit;
