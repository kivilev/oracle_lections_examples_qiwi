
ALTER SESSION SET CURRENT_SCHEMA=HR;

ALTER SESSION SET NLS_LANGUAGE=American;
ALTER SESSION SET NLS_TERRITORY=America;

--
-- create tables, sequences and constraint
--

@@hr_cre

-- 
-- populate tables
--

@@hr_popul

--
-- create indexes
--

@@hr_idx

--
-- create procedural objects
--

@@hr_code

--
-- add comments to tables and columns
--

@@hr_comnt

--
-- gather schema statistics
--

@@hr_analz

spool off
