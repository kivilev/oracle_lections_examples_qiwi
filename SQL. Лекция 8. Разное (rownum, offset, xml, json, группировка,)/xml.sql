--------- XML. Буууу!!

--- 1) Извлечение данных
select value(t).getStringVal() xml_node_as_str,
       extractValue(value(t), 'message') message_text,
       extractValue(value(t), 'message/text()') message_text,
       extractValue(value(t), 'message/@id') id,
       extractValue(value(t), 'message/@class') class
  from table(XMLSequence(xmltype('<messages>
                                      <message>MyMessage 1</message>
                                      <message>MyMessage 2</message>
                                      <message id="id3" class="last">MyMessage 3</message>
                                  </messages>').extract('*/message'))) t;

--- 2) Создание таблицы с Xmltype
drop table xml$demo;
create table xml$demo
(
  id  number(20) not null,
  val xmltype
);

insert into xml$demo values (1, '<messages><message>Mess 1</message></messages>');
insert into xml$demo values (2, xmltype('<messages><message>Mess 21</message><message> Mess 22</message></messages>'));
insert into xml$demo values (3, xmltype('<messages></messages>'));
commit;

select d.id,
       extractValue(value(t), 'message') message_text
  from xml$demo d, table(XMLSequence(d.val.extract('*/message')))(+) t; --(+)


--- 3) XMLTable.

with t as (
select xmltype(
'<messages>
    <message id="1">
        <subject>My Subject1</subject>
        <attachments>
          <attachment type="archive">my.zip</attachment>
          <attachment type="music">my_song.mp3</attachment>
          <attachment type="music">моя песня.mp3</attachment>
        </attachments>
    </message>
    <message id="2">
        <subject>My Subject2</subject>
        <attachments>
          <attachment type="video">video.mp4</attachment>
        </attachments>
    </message>
    <message id="3">
        <subject>My Subject3. No attachments</subject>        
    </message>
</messages>') data from dual
)
select message.message_id, message.subject, atts.*
  from t
     -- парсим каждое сообщение
     , XMLTable('/messages/message' 
                passing (t.data) 
                columns message_id  number path '@id'
                      , subject     varchar2(200 char) path 'subject' 
                      , attachments XMLType path 'attachments/attachment')(+) message
     -- парсим каждое вложение
     , XMLTable('/attachment' 
                passing (message.attachments) 
                columns atype       varchar2(20 char) path '@type'
                      , file_name   varchar2(200 char) path 'text()' )(+) atts;


