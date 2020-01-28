-- **************** DEMO. Сокрытие кода ****************

-- Создадим тестовые объекты.
create or replace package wrap_demo_pack is
  function license_limit return number;
end;
/

create or replace package body wrap_demo_pack is
  function license_limit return number
  is
  begin
    return 2;
  end;
end;
/

------------------ Пример 1. Утилита WRAP

-- Шаг 1. Сохраняет pakcage body в каталог

-- Шаг 2. Обфусцируем исходники
wrap iname=wrap_demo_pack.bdy oname=wrap_demo_pack.bdy.wrap

-- Шаг 3. Накатыавем на БД

-- Проверяем
begin
  dbms_output.put_line('Result: '||wrap_demo_pack.license_limit());
end;
/  

-- https://codecrete.net/UnwrapIt/



------------------ Пример 2. Пакет dbms_ddl

---- 1. Получаем исходный код + врапируем
declare
  v_sql varchar2(32000 char);
begin
  v_sql := dbms_metadata.get_ddl('PACKAGE_BODY', 'WRAP_DEMO_PACK');
  v_sql := replace(v_sql, 'EDITIONABLE', '');

  dbms_ddl.create_wrapped(v_sql);
end;
/

---- Проверяем
begin
  dbms_output.put_line('Result: '||wrap_demo_pack.license_limit());
end;
/  
