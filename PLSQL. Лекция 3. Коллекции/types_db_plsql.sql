------- DEMO. Уровень объявления типа

-- ====== Объявление типов

-- Тип уровня схемы
create or replace type t_schema_level is table of number;
/

-- Тип уровня Pl/sql-блока
declare
  type t_plsql_level is table of number;
begin
  null;
end;
/


-- ====== Использование типов

declare
  v_arr t_schema_level;
begin
  null;
end;
/

declare
  type t_plsql_level is table of number;
  v_arr t_plsql_level;
begin
  null;
end;
/


