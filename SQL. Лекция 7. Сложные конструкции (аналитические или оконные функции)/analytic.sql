----- Схема HR. БД QW_DEV

-- Получить сумму по отделу. 
select sum(salary) over (partition by department_id) sum_salary_in_dept
     , t.department_id
     , t.salary
     , t.*
  from employees t
 order by t.department_id;

-- Отранжировать (получить порядковый номер) сотрудников внутри отдела по зп. Если зп одинаковая то перый, кого позже наняли
select row_number() over
        (partition by department_id order by salary, hire_date desc nulls last ) pos_in_dept
     , t.department_id
     , t.salary
     , t.hire_date
     , t.employee_id
  from employees t
 order by t.department_id;

-- Получить % зп сотрудника от ФОТ для всех
select round(t.salary / sum(t.salary) over () *100, 2) prcnt_salary_employee
     , t.salary
     , sum(t.salary) over () all_salary
     , t.*
  from employees t
 order by t.department_id, t.hire_date;
 
select row_number() over (partition by t.department_id order by t.hire_date) rn
     , count(*) over(partition by t.department_id) cnt
     , count(*) over() cnt_all
     , t.department_id
     , t.*
  from employees t
 order by t.department_id, t.hire_date;

-- Получить ID ветерана и ID новичка подразделения. (план запроса)
select employee_id,
       department_id,
       (case 
         when x.employee_id = veteran_id_in_dept and x.employee_id = rookie_id_id_dept then 'единственный сотрудник отдела'
         when x.employee_id = veteran_id_in_dept then 'ветеран'
         when x.employee_id = rookie_id_id_dept then 'новичек'
       end) whoareu
  from (select first_value(t.employee_id) over (partition by department_id order by hire_date asc nulls last ) veteran_id_in_dept
             , first_value(t.employee_id) over (partition by department_id order by hire_date desc nulls first ) rookie_id_id_dept
             --, last_value(t.employee_id) over (partition by department_id order by hire_date asc nulls first ) rookie_id_id_dept             
             , t.department_id
             , t.salary
             , t.hire_date
             , t.employee_id
          from employees t
         ) x
  where x.employee_id = x.veteran_id_in_dept 
     or x.employee_id = x.rookie_id_id_dept;


/*
 Пример QW. Схема QIWI. Таблица persons_auth_history. История изменений табл persons_auth.
   "Проектер", сделал так, что изменения сохраняются только OLD. NEW не сохраняются.
   Работать с такими данными просто ад. Особенно для воссоздания истории изменений.
   Применяется аналитика, для того чтобы получать корректную картинку.
*/ 

-- Исходный запрос.
select *
  from qiwi.persons_auth_history t
 where t.pah_prs_id = 380660962331
 order by t.pah_modify_date;

select *
  from qiwi.persons_auth t
 where t.prs_id = 380660962331;
 
-- Применяем аналитику. Есть дырки.
select pah_prs_creation_date old_creation_date
      ,lead(t.pah_prs_creation_date) over(partition by t.pah_prs_id order by pah_modify_date nulls last) new_creation_date
      
      ,t.pah_prs_state old_state
      ,lead(t.pah_prs_state) over(partition by t.pah_prs_id order by pah_modify_date nulls last) new_state
      
      ,t.pah_prs_role old_role
      ,lead(t.pah_prs_role) over(partition by t.pah_prs_id order by pah_modify_date nulls last) new_role
      
      ,t.pah_modify_date
      ,t.pah_prs_id
      ,t.pah_who_modified
      ,t.*
  from qiwi.persons_auth_history t
 where t.pah_prs_id = 380660962331
 order by t.pah_modify_date;

-- Та же аналитика + актуальная запись, чтоб устранить дырку
select old_creation_date
      ,nvl(new_creation_date, pa.prs_creation_date) new_creation_date
      ,old_state
      ,nvl(new_state, pa.prs_state) new_state
      ,old_role
      ,nvl(new_role, pa.prs_role) new_role
      ,t.*
  from (select pah_prs_creation_date old_creation_date
              ,lead(t.pah_prs_creation_date) over(partition by t.pah_prs_id order by pah_modify_date nulls last) new_creation_date
              ,t.pah_prs_state old_state
              ,lead(t.pah_prs_state) over(partition by t.pah_prs_id order by pah_modify_date nulls last) new_state
              ,t.pah_prs_role old_role
              ,lead(t.pah_prs_role) over(partition by t.pah_prs_id order by pah_modify_date nulls last) new_role
              ,t.*
          from qiwi.persons_auth_history t
         where t.pah_prs_id = 380660962331) t  
  left join qiwi.persons_auth pa on pa.prs_id = t.pah_prs_id and t.new_role is null
 order by t.pah_modify_date;
 

