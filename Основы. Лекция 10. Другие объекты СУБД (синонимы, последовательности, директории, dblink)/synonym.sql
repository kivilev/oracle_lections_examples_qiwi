----- Пример вызова функции через синоним
-- создадим функцию
create or replace function koryavoe_nazvanie_funkcii(val varchar2) return varchar2 is
begin
  return val||': результат выполнения корявой функции';
end koryavoe_nazvanie_funkcii;
/

-- создадим синоним на эту функции
create synonym my_good_name_func for koryavoe_nazvanie_funkcii;

-- обратимся к функции по синониму
select my_good_name_func('QIWI') res_func 
  from dual;

