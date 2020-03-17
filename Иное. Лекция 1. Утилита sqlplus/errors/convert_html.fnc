create or replace function convert_html(pi_url varchar2) return varchar2 is
begin
  return replace(pi_url, '&nbsp', ' ');
end;
/