create or replace trigger wallet_b_iud_stmt_restrict
  before insert or update or delete
  on wallet 
begin
  wallet_api_pack.restrict_trigger_body();
end wallet_b_iud_stmt_restrict;
/