
--======= 1. Генерация строк с использованием connect by =======
---- простая генерация 5 строк
select level
  from dual 
connect by level <= 5;
  
----чуть посложней
-- какое число будет выведено?
with t as 
(
  select level
    from dual 
 connect by level <= 10
)
select count(*) 
  from t, t;

--====== 2. Разбиение строки на строки множества ===============

select regexp_substr(str, '[^,]+', 1, level) str
  from (select 'str1,str2,str3' str  -- входная строка
          from dual) t
connect by instr(str, ',', 1, level - 1) > 0;

-- Вариант. еще один
select substr(param1, 1, instr(param1, '=') - 1) param1_id,
       substr(param1, instr(param1, '=') + 1)    param1_value,
       substr(param2, 1, instr(param2, '=') - 1) param2_id,
       substr(param2, instr(param2, '=') + 1)    param2_value,
       substr(param3, 1, instr(param3, '=') - 1) param3_id,
       substr(param3, instr(param3, '=') + 1)    param3_value
  from (select max(decode(lvl, 1, str)) param1,
               max(decode(lvl, 2, str)) param2,
               max(decode(lvl, 3, str)) param3
          from (select level lvl, regexp_substr(str, '[^;]+', 1, level) str
                  from (select '37865=true;11215=29061800673;3910=app1.mobw.ru;3915=mobw;' str -- экстра :)
                          from dual) t
                connect by instr(str, ';', 1, level - 1) > 0));
               

-- ===== 3. Чисто поржать ======================
select level
       , t.*
       , sys_connect_by_path (s, '/' ) 
  from (select 'A' s
          from dual
        union all
        select 'B' s
          from dual) t
connect by level <= 4;
