declare
  -- Название блокировки $BLOCK$Схема$таблица с изменениями
  v_lockname   varchar2(128) := 'DEMO_LOCK';
  v_lockresult number;
  v_lockhandle varchar2(128);
  v_timeout    number := 5; -- ожидание 5 сек
begin
  --устанавливаем пользовательскую блокировку
  -- Получаем указатель на блокировку
  dbms_lock.allocate_unique(lockname => v_lockname, lockhandle => v_lockhandle);
  -- Запросим блокировку
  v_lockresult := dbms_lock.request(v_lockhandle, dbms_lock.x_mode, v_timeout);

  case v_lockresult
    when 0 then
      --всё хорошо, идем дальше, блокировку удалось захватить
      dbms_output.put_line('Блокировка пока не установлена. Устанавливаем'); 
    when 1 then
      raise_application_error(-20102,
                              'Ресурс ' || v_lockname || ' заблокирован! Таймаут = ' || v_timeout);
    else
      raise_application_error(-20102,
                              'Ошибка блокировки ресурса ' || v_lockname || ' код  = ' || v_lockresult);
  end case;

  -- ЧТО-ТО ДЕЛАЕМ -> спим 30 секунд
  dbms_lock.sleep(30);

  -- Освободим блокировку
  v_lockresult := dbms_lock.release(v_lockhandle);

exception
  when others then
    -- Освободим блокировку
    v_lockresult := dbms_lock.release(v_lockhandle);
    raise;
end;
/
