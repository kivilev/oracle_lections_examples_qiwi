create or replace package change_source_pack is

  -- Author  : D.KIVILEV
  -- Created : 17.07.2019 15:14:48
  -- Purpose : API по работе с таблицей CHANGE_SOURCE

  -- Создание новой записи
  function create_change_source(pi_cs_alias       change_source.cs_alias%type,
                                pi_cs_description change_source.cs_description%type,
                                pi_cst_id         change_source.cst_id%type,
                                pi_cs_external_id change_source.cs_external_id%type)
    return change_source.cs_id%type;

  -- Обновление существующей записи (по CS_ID)
  procedure update_change_source(pi_cs_id          change_source.cs_id%type,
                                 pi_cs_description change_source.cs_description%type);

  -- Обновление существующей записи (по EXT_ID)
  procedure update_change_source(pi_cs_external_id change_source.cs_external_id%type,
                                 pi_cs_description change_source.cs_description%type);

  -- Удаление существующей записи
  procedure delete_change_source(pi_cs_id change_source.cs_id%type);

  --------------- TRIGGERS BODY --------------------
  -- Тело триггера аудита (после изменения)
  procedure change_source_tr_body_dml(pi_oper_type operation_type.ot_name%type,
                                      pi_new_rec   change_source%rowtype := null,
                                      pi_old_rec   change_source%rowtype := null);

  -- Триггер запрещающий менять без API
  procedure change_source_tr_body_restrict;

end change_source_pack;
/
create or replace package body change_source_pack is

  g_is_api boolean := false; -- Происходит ли изменение через API

  -- Создание новой записи
  function create_change_source(pi_cs_alias       change_source.cs_alias%type,
                                pi_cs_description change_source.cs_description%type,
                                pi_cst_id         change_source.cst_id%type,
                                pi_cs_external_id change_source.cs_external_id%type)
    return change_source.cs_id%type is
    v_cs_id change_source.cs_id%type;
  begin
    g_is_api := true;

    -- Редко изменяемый справочник, можем позволить себе брать максимум
    select nvl(max(t.cs_id), 0) + 1 into v_cs_id from change_source t;

    -- вставляем запись
    insert into change_source
      (cs_id, cs_alias, cs_description, cst_id, cs_external_id)
    values
      (v_cs_id,
       pi_cs_alias,
       pi_cs_description,
       pi_cst_id,
       pi_cs_external_id);

    g_is_api := false;

    return v_cs_id;
  exception
    when others then
      g_is_api := false;
      reraise;
  end;

  -- Обновление существующей записи (по CS_ID)
  procedure update_change_source(pi_cs_id          change_source.cs_id%type,
                                 pi_cs_description change_source.cs_description%type) is
    v_rowid rowid;
  begin
    g_is_api := true;

    -- блочим
    select t.rowid
      into v_rowid
      from change_source t
     where t.cs_id = pi_cs_id
       for update nowait;

    -- обновляем
    update change_source t
       set t.cs_description = nvl(pi_cs_description, t.cs_description)
     where t.rowid = v_rowid;

    g_is_api := false;

  exception
    when no_data_found then
      g_is_api := false;
      raise_application_error(-20101,'Не найдена запись с cs_id: '||pi_cs_id);
    when others then
      g_is_api := false;
      reraise;
  end;

  -- Обновление существующей записи (по EXT_ID)
  procedure update_change_source(pi_cs_external_id change_source.cs_external_id%type,
                                 pi_cs_description change_source.cs_description%type) is
    v_cs_id change_source.cs_id%type;
  begin
    g_is_api := true;

    -- блочим
    select t.cs_id
      into v_cs_id
      from change_source t
     where t.cs_external_id = lower(pi_cs_external_id)
       for update nowait;

    update_change_source(pi_cs_id          => v_cs_id,
                         pi_cs_description => pi_cs_description);

    g_is_api := false;

  exception
    when no_data_found then
      g_is_api := false;
      raise_application_error(-20101,'Не найдена запись с external_id: '||pi_cs_external_id);
    when others then
      g_is_api := false;
      reraise;
  end;

  -- Удаление существующей записи
  procedure delete_change_source(pi_cs_id change_source.cs_id%type) is
  begin
    g_is_api := true;

    -- удаляем
    delete from change_source t where t.cs_id = pi_cs_id;

    g_is_api := false;

  exception
    when others then
      g_is_api := false;
      reraise;
  end;

  --------------- TRIGGERS BODY --------------------
  -- Тело триггера аудита (после изменения)
  procedure change_source_tr_body_dml(pi_oper_type operation_type.ot_name%type,
                                      pi_new_rec   change_source%rowtype := null,
                                      pi_old_rec   change_source%rowtype := null) is
    v_sf_id           system_fingerprint.sf_id%type;
    v_cs_id           change_source.cs_id%type;
    v_operation_types common_pack.t_num_tab_ind_by_v2;
  begin
    -- Получаем отпечаток системы
    v_sf_id := change_event_pack.get_fingerprint();

    -- заполнение справочника операций
    v_operation_types := common_pack.get_operation_type_dict();

    case pi_oper_type
      when common_pack.c_oper_insert then
        v_cs_id := pi_new_rec.cs_id;
      when common_pack.c_oper_update then
        v_cs_id := pi_new_rec.cs_id;
      when common_pack.c_oper_delete then
        v_cs_id := pi_old_rec.cs_id;
      else
        raise_application_error(-20003, 'Unknown DML-operation type');
    end case;

    insert into change_source_aud
      (csa_id,
       sf_id,
       csa_change_date,
       ot_id,
       cs_id,
       new_cs_id,
       old_cs_id,
       new_cs_alias,
       old_cs_alias,
       new_cs_description,
       old_cs_description,
       new_cst_id,
       old_cst_id,
       new_cs_external_id,
       old_cs_external_id)
    values
      (change_source_aud_seq.nextval,
       v_sf_id,
       sysdate,
       v_operation_types(pi_oper_type),
       v_cs_id,
       pi_new_rec.cs_id,
       pi_old_rec.cs_id,
       pi_new_rec.cs_alias,
       pi_old_rec.cs_alias,
       pi_new_rec.cs_description,
       pi_old_rec.cs_description,
       pi_new_rec.cst_id,
       pi_old_rec.cst_id,
       pi_new_rec.cs_external_id,
       pi_old_rec.cs_external_id);
  end;

  -- Триггер запрещающий менять без API
  procedure change_source_tr_body_restrict is
  begin
    -- Пропускаем, если разрешены ручные изменения или работа происходит через API
    if change_event_pack.is_permiss_manual_change() or g_is_api then
      return;
    else
      raise_application_error(-20101, 'Manual change forbidden');
    end if;
  end;

end;
/
