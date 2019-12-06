/*
drop table del$v2_unicode;
create table del$v2_unicode
(  
  v2_byte   varchar2(10 byte),
  v2_char   varchar2(10 char)
);
*/

-- вставляем одинаковое значение "приве" -> все ок! 5 символов
insert into del$v2_unicode(v2_byte, v2_char) values ('приве','приве');
commit;

-- при попытке вставить 6 символов получаем ошибку. 6*2 = 12.
-- ORA-12899: value too large for column "QIWI"."DEL$V2_UNICODE"."V2_BYTE" (actual: 12, maximum: 10)
insert into del$v2_unicode(v2_byte) values ('привет');
commit;

-- при попытке вставить 6 символов получаем ошибку. 6*2 = 12.
-- ORA-12899: value too large for column "QIWI"."DEL$V2_UNICODE"."V2_BYTE" (actual: 12, maximum: 10)
insert into del$v2_unicode(v2_char) values ('привет');
commit;

select * from del$v2_unicode;

