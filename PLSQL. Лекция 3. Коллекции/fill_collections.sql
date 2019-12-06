------------- Инициализация
-- ============ Тип уровня схемы
create or replace type t_my_obj force is object
(
  n1 number,
  n2 number
)
; -- object
/ 
create or replace type t_tab_rec force is table of t_my_obj; -- тип коллекции
/

declare
  v_tab1      t_tab_rec := t_tab_rec(t_my_obj(44,55), t_my_obj(55,66));    
begin
  dbms_output.put_line(v_tab1.count); 
end;

declare
  type t_rec        is record( n1 number, n2 number); -- record
  type t_tab_rec is table of t_rec;                          -- тип коллекции
  v_tab1      t_tab_rec := t_tab_rec();              -- переменная коллекции
begin
  v_tab1.extend(1);
  v_tab1(v_tab1.LAST).n1 := 1;
  v_tab1(v_tab1.LAST).n2 := 2;  
end;
/


------------- Заполнение из SQL
-- ============ Тип уровня PL/SQL кода.
declare
  type t_rec is record(
    n1 number,
    n2 number); -- record
  type t_tab_rec is table of t_rec; -- тип коллекции
  v_tab t_tab_rec; -- переменная коллекции
begin
  select level, level
    bulk collect
    into v_tab
    from dual
  connect by level <= 10;
end;
/

-- Тип уровня схемы
create or replace type t_my_obj force is object
(
  n1 number,
  n2 number
)
; -- object
/ 
create or replace type t_tab_rec force is table of t_my_obj; -- тип коллекции
/

declare
  v_tab t_tab_rec;
begin
  select t_my_obj(level, level)
    bulk collect
    into v_tab
    from dual
  connect by level <= 10;
end;
/
