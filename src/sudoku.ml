type x = int * int

type v = int

module Xmap = Map.Make(struct
    type t = x
    let compare = compare
  end)

type instance = v Xmap.t

let empty = Xmap.empty

(* Length of the side of a subsquare *)
let size = 3
let _s = size * size (* Convenience *)

(* Builds a list of all vars *)
let vars =
  let rec loop l c acc =
    if (l, c) >= (_s - 1, _s - 1) then (_s - 1, _s - 1) :: acc
    else if c >= _s - 1 then loop (succ l) 0 ((l, c) :: acc)
    else loop l (succ c) ((l, c) :: acc)
  in
  loop 0 0 []

(* Returns coordinates of subsquare of var *)
let group_of_var = function (l, c) -> l / size, c / size

let domain x =
  let rec loop k acc = if k > _s then acc else loop (succ k) (k :: acc) in
  loop 1 []

let union inst var value = Xmap.add var value inst

let feasible var value inst =
  let vl, vc = var in
  let cross = Xmap.filter (fun k _ ->
      match k with (kl, kc) -> kc = vc || kl = vl
    ) inst in
  let square = let groupind = group_of_var var in Xmap.filter (fun k elt ->
      group_of_var k = groupind) inst in
  Xmap.fold (fun _ elt acc -> elt <> value && acc) square true &&
  Xmap.fold (fun _ elt acc -> elt <> value && acc) cross true

let consistent sudoku =
  Xmap.fold (fun k elt acc ->
      let sudoku_nok = Xmap.remove k sudoku in
      feasible k elt sudoku_nok && acc) sudoku true

let print sudoku =
  print_endline "Resulting すどく" ;
  for line = 0 to _s - 1 do
    for col = 0 to _s - 1 do
      if Xmap.mem (line, col) sudoku
      then Printf.printf "%d" (Xmap.find (line, col) sudoku)
      else Printf.printf "n" ;
      if (col + 1) mod size = 0 then print_string " "
    done ;
    print_newline () ;
    if (line + 1) mod size = 0 then print_newline ()
  done
