create or replace type t_partner under t_partner_category
(
  id_prt                number,
  parner_name           varchar2(200 char),
  commission_amount_prc number,
  from_date             date,
  till_date             date,

  constructor function t_partner( --конструктор
    pi_id_prt                number,
    pi_parner_name           varchar2,
    pi_commission_amount_prc number default 0,
    pi_from_date             date default null,
    pi_till_date             date default null,
    pi_category_name         varchar2
  ) return self as result,

  overriding member function print return varchar2,
  member function get_num_of_days return number,
  member procedure set_commission (pi_amount in number),
  member procedure print_category_keywords
)
NOT FINAL
/
create or replace type body t_partner
as
  constructor function t_partner(
    pi_id_prt                number,
    pi_parner_name           varchar2,
    pi_commission_amount_prc number default 0,
    pi_from_date             date,
    pi_till_date             date,
    pi_category_name         varchar2
    ) return self as result
  is
  begin
    self.id_prt := pi_id_prt;
    self.parner_name := pi_parner_name;
    self.commission_amount_prc := pi_commission_amount_prc;
    self.from_date := pi_from_date;
    self.till_date := pi_till_date;
    (self as t_partner_category).set_category_name(pi_category_name);
    return;
  end;

  overriding member function print
    return varchar2
  is
  begin
    return (self as t_partner_category).print || ' Партнер: ' || self.parner_name || ' Комиссия: ' || to_char(self.commission_amount_prc) || '%';
  end;
  
  member procedure print_category_keywords
  is
  begin
    --dbms_output.put_line((self as t_partner_category).category_keywords);
    dbms_output.put_line((self as t_partner_category).get_category_keywords);
  end; 
  
  member function get_num_of_days
    return number
  is
  begin
    return round(self.till_date - self.from_date);
  end;

  member procedure set_commission (pi_amount in number)
  is
  begin
    self.commission_amount_prc := pi_amount;
    dbms_output.put_line('=== Комиссия партнера ' || self.parner_name || ' изменена на ' || self.commission_amount_prc || '% ===');
  end;

end;
/
