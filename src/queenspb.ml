(* The queens problem is modelled as follow:
 * each variable represents a line of the board,
 * the values are the column on which each queen is placed *)

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

let violate l1 c1 l2 c2 =
  not (l1 <> l2 && c1 <> c2 && l1 + c1 <> l2 + c2 && l1 - c1 <> l2 - c2)

module Var = struct
  type t = int

  type set = t list

  let init = [ 1 ; 2 ; 3 ; 4 ]

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

  let consistent qpb =
    Xmap.fold (fun key1 elt1 acc1 ->
        let violating_vars =
          Xmap.fold (fun key2 elt2 acc2 ->
              if violate key1 elt1 key2 elt2
              then Xmap.add key2 elt2 acc2 else acc2)
            qpb Xmap.empty in
        union acc1 (Xmap.add key1 elt1 violating_vars)) qpb Xmap.empty

  let print inst =
    print_string " ----" ; print_newline () ;
    for i = 1 to 4 do
      print_string "|" ;
      let col = Xmap.find i inst in
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
end

(** [feasible v u i] checks whether instance contains a queen placed on line
    [u] for instance [i] i.e. checks if the column is free *)
let feasible var value qpb =
  Xmap.fold (fun key elt acc ->
      not (violate var value key elt) && acc) qpb true

let union inst var value = Xmap.add var value inst

(* Here same domain for all vars *)
let domain (x : Var.t) = ([ 1 ; 2 ; 3 ; 4 ] : Val.set)

let mem var inst = Xmap.mem var inst
