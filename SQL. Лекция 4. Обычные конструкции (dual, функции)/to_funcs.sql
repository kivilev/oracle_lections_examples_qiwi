-- Формат вывода даты на уровне сессии (SQLPLUS). IDE может вносить свои коррективы.
-- alter session set nls_date_format = 'DD-MON-YYYY HH24:MI:SS';

---- Пример. TO_DATE
select to_date('01.02.2019', 'dd.mm.yyyy') dt1,
       to_date('01.02.2019 23:32', 'dd.mm.yyyy hh24:mi') dt2,
       to_date('2019-12-15 12:22:27', 'yyyy-mm-dd hh24:mi:ss') dt3,
       to_date('01.01.19', 'dd.mm.yy') dt4_yy_19,
       to_date('01.01.19', 'dd.mm.rr') dt4_rr_19,
       to_date('01.01.54', 'dd.mm.yy') dt4_yy_54,
       to_date('01.01.54', 'dd.mm.rr') dt4_rr_54,-- до 49 года будет текущий век, после предыдущий
       to_date('01-ФЕВРАЛЬ-2019', 'DD-MON-YYYY', 'NLS_DATE_LANGUAGE = Russian') dt5
  from dual;

---- Пример. TO_CHAR (date -> char)
select to_char(sysdate, 'dd.mm.yyyy') dt1,
       to_char(sysdate, 'dd.mm.yyyy hh24:mi:ss') dt2,
       to_char(sysdate, 'yyyymmdd_hh24miss') dt3,
       to_char(sysdate, 'DAY-MON-YYYY.CC', 'nls_date_language = Korean') dt4,
       to_char(systimestamp, 'YYYY-MM-DD HH24:MI.SS.FF6') ts1
  from dual;

---- Пример. TO_NUMBER
alter session set nls_territory = 'Russia';
-- alter session set nls_territory = 'America';
select to_number('1,2') n1,
       to_number('1.22', '999999999.99') n2/*,
       to_number('-RUB100',
                 'L9G999D99',
                 'NLS_NUMERIC_CHARACTERS = '',.''
     NLS_CURRENCY            = ''RUB''') aus*/
  from dual;

---- Пример. TO_CHAR
alter session set nls_territory = 'America';
alter session set nls_territory = 'CIS';
select to_char(123123.2) c1
      , to_char(-10000,'L99G999D99') c2
  from dual;

