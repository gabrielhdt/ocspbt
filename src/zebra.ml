module type Variable =
sig
  type t
  type set
  val empty : set
  val init : set
  val next : set -> t * set
end

module type Value =
sig
  type t
  type set
  val empty : set
  val next : set -> t * set
end

module type Instance =
sig
  type t
  val empty : t
  val union : t -> t -> t
  val consistent : t -> t
  val print : t -> unit
end

module Var = struct
  type t = HouseColour | HousePosition | Profession | Nationality | Drink |
           Animal
  type set = t list
  let empty = []
  let next s = List.hd s, List.tl s
end

module Val = struct
  type colour = Red | Blue | Yellow | White | Green
  type profession = Painter | Sculptor | Diplomat | Doctor | Violonist
  type nationality = English | Spanish | Japanese | Norwegian | Italian
  type drink = Tea | Fruit | Coffee | Milk | Wine
  type animal = Dog | Snail | Fox | Horse | Zebra
  type t =
    | HouseColour of colour
    | Profession of profession
    | Nationality of nationality
    | Drink of drink
    | Animal of animal
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
end

(** Here, a list of constraints *)
let violate var1 val1 var2 val2 =
  match var1, var2 with
  | Var.Nationality, Var.HouseColour -> ()
  | Var.Nationality, Var.Animal -> ()
  | Var.Nationality, Var.Profession ->
  | Var.Nationality, Var.Drink ->
  | Var.HouseColour, Var.Drink ->
  | Var.HouseColour, Var.HousePosition ->
  | Var.Profession, Var.Animal ->
  | Var.Profession, Var.HouseColour ->
  | Var.Drink, Var.HousePosition ->
  | Var.Nationality
