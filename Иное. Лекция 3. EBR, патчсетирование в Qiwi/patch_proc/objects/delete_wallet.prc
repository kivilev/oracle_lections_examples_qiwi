create or replace procedure delete_wallet(pi_wallet_id wallet.wallet_id%type) is
begin
  delete from wallet t where t.wallet_id = pi_wallet_id;
end;
/
