select t.*,
       value(t).n1
  from table(t_rows(
                      t_row(1, 11)
                    , t_row(2, 22)
                    )) t;


create or replace type t_row force is object(n1 number, n2 number);
/
create type t_rows is table of t_row;
/
