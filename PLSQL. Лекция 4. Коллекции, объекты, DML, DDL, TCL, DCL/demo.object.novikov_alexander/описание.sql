drop table partners;
--drop type t_partner;
--drop type t_partner_category;
--drop type t_txn_acc;

--создание таблицы с объектными столбцами
create table partners (partner_obj t_partner);    
--создание таблицы в которой каждая строка является объектом типа t_partner
create table partners of t_partner; 
 
declare
  v_mvideo t_partner := t_partner(1, 'МВидео', 3, to_date('20.10.2019','dd.mm.yyyy'), to_date('20.10.2020','dd.mm.yyyy'), 'Электроника');
  v_perek t_partner := t_partner(1, 'Перекресток', 2, to_date('05.09.2017','dd.mm.yyyy'), to_date('05.09.2022','dd.mm.yyyy'), 'Продукты');
  
  v_temp t_partner;
  
begin
  dbms_output.put_line(v_mvideo.print);
  dbms_output.put_line(v_perek.print);
  
  v_perek.set_commission(5);
  dbms_output.put_line(v_perek.print);
  
  dbms_output.put_line(v_perek.parner_name);
  v_perek.commission_amount_prc := 6;
  
  v_perek.category_keywords := 'фрукты, овощи';
  v_perek.print_category_keywords;
  
  dbms_output.put_line('=========================');
  
  insert into partners
  values (v_mvideo);
  
  insert into partners
  values (v_perek);
  
  commit;
  
  --select * from partners
  --select value(p) from partners p
  
  select value(p)
    into v_temp
    from partners p
   where parner_name = 'Перекресток' and rownum = 1;
  
  dbms_output.put_line(v_temp.print);
  
end;

--select value(p).get_num_of_days from partners p

--применение изменений типа
alter type t_partner drop member procedure set_commission (pi_amount in number);
/
--логический указатель на конкретную строку
select ref(p) from partners p 


declare
  v_txn_1 t_txn_acc := t_txn_acc(1, 500);
  v_txn_2 t_txn_acc := t_txn_acc(1, 500);
begin
  if v_txn_1 = v_txn_2 then
    dbms_output.put_line('v_txn_1 и v_txn_2 одинаковые');
  else
    dbms_output.put_line('v_txn_1 и v_txn_2 разные');
  end if;
end;

