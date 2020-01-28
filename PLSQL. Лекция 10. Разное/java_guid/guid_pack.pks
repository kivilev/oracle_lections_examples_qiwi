create or replace package guid_pack is

  -- Author  : D.KIVILEV
  -- Created : 24.08.2018 12:57:19
  -- Purpose : API по работе с GUID

  -- Получить ГУИД по текущему времени
  function get_new_guid return varchar2;

  -- Получить ГУИД по указанной дате/время
  function get_new_guid(pi_date date) return varchar2;

  -- Получить Дату, указанную при генерации из ГУИДа
  function get_date_from_guid(pi_guid varchar2) return date deterministic;

end guid_pack;
/