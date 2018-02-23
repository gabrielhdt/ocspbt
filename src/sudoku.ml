(* Length of the side of a subsquare *)
let size = 3
let _s = size * size (* Convenience *)

(* Returns coordinates of subsquare of var *)
let group_of_var = function (l, c) -> l / size, c / size

module type Variable = sig
  type t
  type set
  val empty : set
  val init : set
  val next : set -> t * set
end

module type Value = sig
  type t
  type set
  val empty : set
  val next : set -> t * set
end

module type Instance = sig
  type t
  val empty : t
  val union : t -> t -> t
  val consistent : t -> t
  val print : t -> unit
end

(* [violate p1 v1 p2 v2] checks if cell [p1] with value [v1] violates a
 * constraint with cell [p2] having value [v2] *)
let violate p1 v1 p2 v2 =
  if p1 = p2 then false (* If same cell *)
  else let l1, c1 = p1 and l2, c2 = p2
    and g1 = group_of_var p1 and g2 = group_of_var p2 in
    v1 = v2 && (l1 = l2 || c1 = c2 || g1 = g2)

module Var = struct
  type t = int * int
  type set = t list

  let init =
    let rec loop l c acc =
      if (l, c) >= (_s - 1, _s - 1) then (_s - 1, _s - 1) :: acc
      else if c >= _s - 1 then loop (succ l) 0 ((l, c) :: acc)
      else loop l (succ c) ((l, c) :: acc)
    in
    loop 0 0 []

  let empty = []

  let next s = List.hd s, List.tl s
end

module Val = struct
  type t = int
  type set = t list
  let empty = []
  let next s = List.hd s, List.tl s
end

module Xmap = Map.Make(struct
    type t = Var.t
    let compare = compare
  end)

module Inst = struct
  type t = Val.t Xmap.t
  let empty = Xmap.empty
  let union s1 s2 = Xmap.fold (fun k elt acc -> Xmap.add k elt acc) s2 s1

  let consistent sudoku =
    Xmap.fold (fun key1 elt1 acc1 ->
        let violating_vars =
          Xmap.fold (fun key2 elt2 acc2 ->
              if violate key1 elt1 key2 elt2
              then Xmap.add key2 elt2 acc2 else acc2)
            sudoku Xmap.empty in
        union acc1 (Xmap.add key1 elt1 violating_vars)) sudoku Xmap.empty

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
end

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

let mem var inst = Xmap.mem var inst

let str2tuple s =
  let reg = Str.regexp " " in
  match Str.split reg s with
  | [line ; col] -> int_of_string line, int_of_string col
  | _ -> failwith "wrong key format, must be '<line> <column>'"

let load path =
  let json = Yojson.Basic.from_file path in
  let s2jsint = Yojson.Basic.Util.to_assoc json in
  let var2val = List.map (fun (s, jsint) ->
      str2tuple s, Yojson.Basic.Util.to_int jsint)
      s2jsint in
  let newinst = List.fold_left (fun acc elt -> Xmap.add (fst elt) (snd elt) acc)
      Xmap.empty var2val
  and var_to_remove = List.map (fun elt -> fst elt) var2val in
  let newvars = List.fold_left (fun acc elt ->
      if List.mem elt var_to_remove then acc else elt :: acc)
      [] Var.init
  in
  newinst, newvars
