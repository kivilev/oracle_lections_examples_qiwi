--------------------- DEMO. JSON. --------------
drop table json$demo;
create table json$demo
(
 id number not null, 
 json_data varchar2(4000 char)
);

-- проверка на JSON (!)
alter table json$demo add constraint json$demo_ch check (json_data is json);

insert into json$demo values (1, '{ "demo1": 1 }');
insert into json$demo values (2, '{ "nedemo1": 221 }');
insert into json$demo values (3, '{ какая то шляпа }');
insert into json$demo values (4, '{
  "array": [
    1,
    2,
    3
  ],
  "boolean": true,
  "color": "#82b92c",
  "number": 123,
  "string": "Hello World",
  "demo1": 2
}');
commit;

-- 1) Проверка на наличие элемента (фильтрация) + получение 
select json_value(json_data, '$.nedemo1') nedemo1_val
  from json$demo
 WHERE json_exists(json_data, '$.nedemo1');

select json_value(json_data, '$.demo1') demo1_val
  from json$demo t
 WHERE json_exists(json_data, '$.demo1');


-- 2) Пример посложней. Аналог того, что разбирали в XML
with t as (
  select '{
  "messages": {
    "message": [
      {
        "id": "1",
        "subject": "My Subject1",
        "attachments": [
            {
              "type": "archive",
              "file_name": "my.zip"
            },
            {
              "type": "music",
              "file_name": "my_song.mp3"
            },
            {
              "type": "music",
              "file_name": "моя песня.mp3"
            }
          ]
      },
      {
        "id": "2",
        "subject": "My Subject2",
        "attachments": [
          {
            "type": "video",
            "file_name": "video.mp4"
          }
        ]        
      },
      {
        "id": "3",
        "subject": "My Subject3. No attachments"
        
      }
    ]
  }
}' json_data
    from dual
)
select message_id, subject, atype, file_name
  from t
      -- сообщения
      , json_table(t.json_data, '$.messages.message[*]'
                   columns message_id  number path '$.id',
                           subject     varchar2(200 char) path '$.subject',
                   -- вложения
                   nested path '$.attachments[*]'
                       columns (atype varchar2 path '$.type',
                                file_name varchar2 path '$.file_name'))j;
                                

