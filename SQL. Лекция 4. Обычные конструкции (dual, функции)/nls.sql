--- ДЛЯ ЧИСТОТЫ ЭКСПЕРИМЕНТА ВЫПОЛНЯЕМ В SQLPLUS
alter session set nls_date_format = 'DD/MM/YY';
select sysdate from dual;

alter session set nls_date_format = 'DD.MM.YYYY';

alter session set NLS_LANG = 'RUSSIAN_RUSSIA.WIN1251';
alter session set NLS_LANG = 'AMERICAN_CIS.UTF8';

begin
      raise;
end;
/
