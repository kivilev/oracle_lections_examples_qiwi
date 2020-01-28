create or replace package body wrap_demo_pack is
  function license_limit return number
  is
  begin
    return 2;
  end;
end;
/
