create or replace package body guid_pack is

  ---- Определения для вызова JAVA-класса
  function java_gen_guid return varchar2 as
    language java name 'TimeBasedUUID.generateExternalFormattedUUIDForNow() return java.lang.String';

  function java_gen_guid_from_date
  (
    datetime varchar2
   ,format   varchar2
  ) return varchar2 as
    language java name 'TimeBasedUUID.generateExternalFormattedUUIDForDateTime(java.lang.String, java.lang.String) return java.lang.String';

  function java_read_date_from_guid(uid varchar2) return varchar2 as
    language java name 'TimeBasedUUID.readDateTimeTzFromUUID(java.lang.String) return java.lang.String';

  ---- API
  -- Получить ГУИД по текущему времени
  function get_new_guid return varchar2 is
  begin
    return java_gen_guid();
  end;

  -- Получить ГУИД по указанной дате/время
  function get_new_guid(pi_date date) return varchar2 is
  begin
    return java_gen_guid_from_date(to_char(pi_date,
                                           'dd.mm.YYYY hh24:mi:ss'),
                                   'dd.MM.yyyy HH:mm:ss');
  end;

  -- Получить Дату, указанную при генерации из ГУИДа
  function get_date_from_guid(pi_guid varchar2) return date deterministic is
  begin
    return cast(to_timestamp_tz(java_read_date_from_guid(pi_guid),
                                'dd.mm.YYYY hh24:mi:ss TZHTZM') at time zone
                'Europe/Moscow' as date);
  end;

end guid_pack;
/