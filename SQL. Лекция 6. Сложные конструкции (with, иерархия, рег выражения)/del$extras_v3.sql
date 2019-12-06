
create or replace view del$extras_v3 as
select ext_table.txn_id txn_id
        , en.ext_name ext_name
        , ext_table.ext_value ext_value
     from ( select /*+ index (es ext_val_str_txn_inx) */
                   t.txn_id txn_id
                 , et.ext_n_id
                 , et.ext_value ext_value
              from txn2 t
               left join ext_val_str es on (es.txn_id = t.txn_id and trunc (t.txn_date) = es.txn_date)
                 , table (ext_values_pack.to_table (es.txn_str)) et
          ) ext_table
left join ext_names en on ext_table.ext_n_id = en.exn_id
where txn_id = 397167308;


select  /*+ PUSH_PRED(t)*/txn_id
        , en.ext_name ext_name
        , ext_table.ext_value ext_value
  from (select to_number(substr(param_str, 1, instr(param_str, '=') - 1)) ext_n_id,
               substr(param_str, instr(param_str, '=') + 1) ext_value,
               txn_id
          from (select level lvl,
                       regexp_substr(ext_value, '[^;]+', 1, level) param_str,
                       txn_id
                  from (select /*+ index (es ext_val_str_txn_inx) */
                               t.txn_id txn_id
                             , es.txn_str ext_value
                          from txn2 t
                          left join ext_val_str es on (es.txn_id = t.txn_id and trunc (t.txn_date) = es.txn_date)                         
                        ) t
                connect by instr(ext_value, ';', 1, level - 1) > 0)
         where param_str is not null) ext_table
  join ext_names en on ext_table.ext_n_id = en.exn_id
  where txn_id = 397167308;




-- Итоговый
select *
  from (select to_number(substr(param_str, 1, instr(param_str, '=') - 1)) ext_n_id,
               substr(param_str, instr(param_str, '=') + 1) param1_value
          from (select level lvl,
                       regexp_substr(str, '[^;]+', 1, level) param_str
                  from (select '37865=true;11215=29061800673;3910=app1.mobw.ru;3915=mobw;' str -- экстра :)
                          from dual) t
                connect by instr(str, ';', 1, level - 1) > 0)
         where param_str is not null) ext_table
  join ext_names en
    on ext_table.ext_n_id = en.exn_id



-- вариант. Просто
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
                
                
