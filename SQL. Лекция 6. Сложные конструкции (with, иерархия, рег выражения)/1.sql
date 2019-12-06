-- Задача. Посчитать количество воскресений в текущем году.

-- Ответ: 
-- получаем день недели, смотрим по названию, считаем сумму
select sum(decode(trim(to_char(dt, 'DAY', 'NLS_DATE_LANGUAGE=AMERICAN')), 'SATURDAY', 1, 0)) sum_saturday_days
  from (select trunc(sysdate, 'YYYY') + level - 1 dt -- с первого дня года
          from dual
        connect by level <= 366)
   -- промежуток 1 год
   where dt between trunc(sysdate, 'YYYY') and ADD_MONTHS(trunc(sysdate, 'YYYY'),12)-1
