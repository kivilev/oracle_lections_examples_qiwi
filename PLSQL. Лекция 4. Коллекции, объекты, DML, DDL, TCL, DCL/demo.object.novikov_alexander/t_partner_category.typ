create or replace type t_partner_category is object
(
  category_name     varchar2(1000 char),
  category_keywords varchar2(1000 char),
  constructor function t_partner_category(
    pi_category_name varchar2,
    pi_category_keywords varchar2
  ) return self as result,
  member function print return varchar2,
  member procedure set_category_name(pi_category_name varchar2),
  member function get_category_keywords return varchar2
) not final
/
create or replace type body t_partner_category
as

  constructor function t_partner_category(
    pi_category_name    varchar2,
    pi_category_keywords varchar2
    ) return self as result
  is
  begin
    self.category_name := pi_category_name;
    self.category_keywords := pi_category_keywords;
    return;
  end;

  member function print
  return varchar2
  is
  begin
    return 'Категория: ' || self.category_name;
  end;

  member procedure set_category_name(pi_category_name varchar2)
  is
  begin
    self.category_name := pi_category_name;
  end;

  member function get_category_keywords
    return varchar2
  is
  begin
    return self.category_keywords;
  end;

end;
/
