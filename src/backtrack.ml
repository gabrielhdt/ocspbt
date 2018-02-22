module type CSPS = sig

  module type VARS = sig
    type t

    type set

    val init : set

    val empty : set

    val next : set -> t * set
  end

  module type VALS = sig
    type t

    type set

    val empty : set

    val next : set -> t * set
  end

  module type INSTS = sig
    type t

    val empty : t
  end

  module Var : VARS

  module Val : VALS

  module Instance : INSTS

  val feasible : Var.t -> Val.t -> Instance.t -> bool

  val consistent : Instance.t -> bool

  val union : Instance.t -> Var.t -> Val.t -> Instance.t

  val domain : Var.t -> Val.set

  val print : Instance.t -> unit
end

module Make (Csp : CSPS) = struct

  let rec bt_aux (v : Csp.Var.set) (a : Csp.Instance.t option) =
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
    if Csp.consistent a then
      let res = bt_aux v (Some a) in
      match res
      with None -> failwith "何?"
         | Some i -> i
    else failwith "initial instance not consistent"
end
