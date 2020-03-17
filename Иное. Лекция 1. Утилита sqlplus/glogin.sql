--
-- Copyright (c) 1988, 2005, Oracle.  All Rights Reserved.
--
-- NAME
--   glogin.sql
--
-- DESCRIPTION
--   SQL*Plus global login "site profile" file
--
--   Add any SQL*Plus commands here that are to be executed when a
--   user starts SQL*Plus, or uses the SQL*Plus CONNECT command.
--
-- USAGE
--   This script is automatically run
--
SET PAGESIZE 100
SET LINESIZE 150
SET SQLPROMPT "sqlplus _USER'@'_CONNECT_IDENTIFIER> "
DEFINE _EDITOR = "C:\Program Files\Notepad++\notepad++.exe"
SET AUTOCOMMIT OFF
--set timing on