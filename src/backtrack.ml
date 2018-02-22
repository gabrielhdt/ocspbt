module type ConstraintSatisfactionProblem = sig

  module type Variable = sig
    type t

    type set

    val init : set

    val empty : set

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
  end

  module Val : Value

  module Var : Variable

  module Inst : Instance

  val feasible : Var.t -> Val.t -> Inst.t -> bool

  val union : Inst.t -> Var.t -> Val.t -> Inst.t

  val domain : Var.t -> Val.set

  val mem : Var.t -> Inst.t -> bool

  val print : Inst.t -> unit
end

module Make (Csp : ConstraintSatisfactionProblem) = struct

  let rec bt_aux (v : Csp.Var.set) (a : Csp.Inst.t option) =
    let instance = match a with (* Extract instance *)
      | None -> failwith "何"
      | Some k -> k
    in
    if v = Csp.Var.empty
    then a (* If no more variable, everything is finished, return *)
    else let hd, tl = Csp.Var.next v in
      (* Loops over values of var [hd] to grow tree *)
      let rec loop values =
        if values = Csp.Val.empty
        then None (* No feasible new instance found *)
        else let x, rxs = Csp.Val.next values in
          if Csp.feasible hd x instance
          then match bt_aux tl (Some (Csp.union instance hd x)) with
            (* If the new instance is not feasible, try another value *)
            | None -> loop rxs
            | Some j -> Some j (* Good instance, return it *)
          else loop rxs
      in loop (Csp.domain hd)

  let bt v a =
    if Csp.Inst.consistent a = Csp.Inst.empty then
      let res = bt_aux v (Some a) in
      match res
      with None -> failwith "何?"
         | Some i -> i
    else failwith "initial instance not consistent"

  let rec cbj_aux (v : Csp.Var.set) (a : Csp.Inst.t option) =
    let instance = match a with None -> failwith "何？"
                              | Some k -> k
    in
    if v = Csp.Var.empty then a
    else let hd, tl = Csp.Var.next v in

      let rec loop values conflict no_bj =
        if values = Csp.Val.empty && not no_bj then None
        else let x, rxs = Csp.Val.next values
          and local_conflict = Csp.Inst.consistent instance in
          if local_conflict = Csp.Inst.empty
          then let child_conflict =
                 match cbj_aux tl (Some (Csp.union instance hd x))
                 with None -> failwith "error assigning child conflict"
                    | Some j -> j
            in if Csp.mem hd child_conflict
            then loop rxs (Csp.Inst.union conflict child_conflict) true
            else loop rxs child_conflict false
          else loop rxs (Csp.Inst.union conflict local_conflict) true

      in
      loop (Csp.domain hd) (Csp.Inst.empty) true

  let cbj v a =
    if Csp.Inst.consistent a = Csp.Inst.empty then
      let res = bt_aux v (Some a) in
      match res with None -> failwith "何？"
                   | Some i -> i
    else failwith "initial instance not consistent"
end
