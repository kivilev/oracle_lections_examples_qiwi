-- TRUNC
select sysdate,
       systimestamp,
       trunc(sysdate),
       trunc(systimestamp),       
       --trunc(sysdate, 'ss'),
       trunc(sysdate, 'mi'),
       trunc(sysdate, 'hh24'),
       trunc(sysdate, 'dd'),
       trunc(sysdate, 'mm'),
       trunc(sysdate, 'yyyy'),
       trunc(sysdate, 'year')
  from dual;


-- ROUND (����������� �� ������������, ����� ���� ����������!!)
select round(to_date('01.01.2019 12:00:00','dd.mm.YYYY hh24:mi:ss')) up_date_if
     , round(to_date('01.01.2019 11:59:00','dd.mm.YYYY hh24:mi:ss')) lower_date_if
     , round(to_date('10.08.2019 11:59:00','dd.mm.YYYY hh24:mi:ss'), 'mm') first_day_month_if
     , round(to_date('16.08.2019 11:59:00','dd.mm.YYYY hh24:mi:ss'), 'month') first_day_month_if
     , round(sysdate, 'yyyy') first_day_year_if
     , round(sysdate, 'year') first_day_year_if
  from dual;


-- Extract
select extract(minute from systimestamp) min,-- ������ ��� TS
       extract(hour from systimestamp) hour,-- ������ ��� TS
       extract(day from sysdate) day,
       extract(month from sysdate) month,
       extract(year from sysdate) year
  from dual;


-- ������ �������
select sysdate current_date
       -- ������� � �������
       ,months_between(to_date('01.07.2019','dd.mm.YYYY'), to_date('01.01.2019','dd.mm.YYYY')) diff_months
       ,round(months_between(to_date('15.07.2019','dd.mm.YYYY'), to_date('01.01.2019','dd.mm.YYYY')),2) diff_months
       -- ���������� �������
       ,add_months(sysdate, 12) one_year_plus
       ,add_months(sysdate, -12) one_year_minus
       -- ��������� ���� �� ��������� �����
       ,next_day(sysdate, 'Monday') next_monday
       -- ��������� ���� ������
       ,last_day(sysdate) last_day_month
  from dual;


-- ��������
select trunc(sysdate,'yyyy') f_day_year -- ������ ���� ����
      , add_months(trunc(sysdate, 'yyyy'), 12) - 1 l_day_year  -- ��������� ���� ����
      , next_day(add_months(trunc(sysdate,'yyyy'), 12), 'Monday') first_monday -- ������ ����������� ���������� ������
      , trunc(months_between(trunc(sysdate), to_date('14.07.1983', 'dd.mm.YYYY')) / 12) full_years   
  from dual;



