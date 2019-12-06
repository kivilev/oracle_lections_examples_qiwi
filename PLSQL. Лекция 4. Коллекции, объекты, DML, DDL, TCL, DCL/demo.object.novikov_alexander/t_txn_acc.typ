create or replace type t_txn_acc is object
(
  id_txn     number,
  txn_amount number,
  map member function equal return number
) --not instantiable not final
/
create or replace type body t_txn_acc
as
   map member function equal
     return number
   is
   begin
     return self.id_txn;
   end;
end;
/
