----- Внимание! Этот код сделан в качестве примера. Для реальной ситуации, нужно продумывать более тщательно рег выражения
-- create or replace type t_string is table of varchar2(2000 char);

---- Пример 1. Почтовые коды. Нужно 6 символов.
select value(t) postcode
  from table(t_string('123456', 'gsdj232', '3423', '654321', 'шляпа!')) t
 where regexp_like(value(t), '^[[:digit:]]{6}$');

---- Пример 2. Фильтр валидных карт. 
with cards as
 (select '1234 3334 3434 1232' card_no,
         'большинство карт' description
    from dual
  union all
  select '1234 3334 3434 1232 23' card_no,
         'великий могучий сбер'
    from dual
  union all
  select '1234 3334 3434 12323' card_no, 
         'шляпа с фронтов :)'
    from dual)
select t.card_no, t.description
  from cards t
 where regexp_like(t.card_no,
                   '^[[:digit:]]{4} [[:digit:]]{4} [[:digit:]]{4} [[:digit:]]{4}($| [[:digit:]]{2}$)');

---- Пример 3. "Чистка" телефонного номера и приведения к формату +7. Цифр дб 11
with cards as
 (select '+79139384646' phone,
         'формат +7. норм' description
    from dual
  union all
  select '8-923-122-3423' card_no,
         'формат с 8, разделители'
    from dual
  union all
  select 'тел. 8(383)343-55-93' card_no, 
         'городоской. с символами.'
    from dual
    union all
  select '234234sdf2~' card_no, 
         'шляпа'
    from dual)
select --regexp_replace(t.phone, '[^[:digit:]]?','') step1 -- удалили все символы, кроме цифр
      --,
      regexp_replace(regexp_replace(t.phone, '[^[:digit:]]?',''), '^8|^+7','+7') final_step -- меняем коды на +7.
      ,t.description
  from cards t
 where length(regexp_replace(t.phone, '[^[:digit:]]?','')) = 11;-- отсеиваем не подходящие по кол-ву телефоны
 
---- Пример 4. Поиск ключевых слов. 
select regexp_count(value(t),
                    'наркотики|оружие|обнал|ствол',
                    1,
                    'i') found_count,
       value(t)     notes      
  from table(t_string('Вот тебе деньги за нАркотики и обналичку',
                      'обнал тема!',
                      'спасибо бро за ствол!',                      
                      'деньги за дубовый ствол', -- отправитель ошибся вместо "стол", написал "ствол"
                      'частный перевод')) t




