(* The queens problem is modelled as follow:
 * each variable represents a line of the board,
 * the values are the column on which each queen is placed *)
type x = string

type v = int

module Xmap = Map.Make(struct
    type t = x
    let compare = compare
  end)

type instance = v Xmap.t

let empty = Xmap.empty

let vars = [ "l1" ; "l2" ; "l3" ; "l4" ]

(* [line_of_var x] returns the line associated to var [x] *)
let line_of_var var = int_of_string (Str.last_chars var 1)

(* Here same domain for all vars *)
let domain x = [ 1 ; 2 ; 3 ; 4 ]

(** [feasible v u i] checks whether instance contains a queen placed on line
    [u] for instance [i] i.e. checks if the column is free *)
let feasible var value inst =
  let col_check = Xmap.fold (fun _ elt acc -> acc && elt <> value) inst true
  and diag_check = Xmap.fold (fun key elt acc ->
      line_of_var key + elt <> line_of_var var + value &&
      line_of_var key - elt <> line_of_var var - value &&
      acc) inst true
  in col_check && diag_check

let union inst var value = Xmap.add var value inst

let print inst =
  print_string " ----" ; print_newline () ;
  for i = 1 to 4 do
    print_string "|" ;
    let col = Xmap.find ("l" ^ string_of_int i) inst in
    for j = 1 to col - 1 do
      print_string " "
    done ;
    print_string "x" ;
    for j = col + 1 to 4 do
      print_string " "
    done ;
    print_string "|" ; print_newline () ;
    print_string " ----" ; print_newline ()
  done
