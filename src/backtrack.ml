module type CSPS = sig
  type x

  type v

  type instance

  val empty : instance

  val vars : x list

  val feasible : x -> v -> instance -> bool

  val union : instance -> x -> v -> instance

  val domain : x -> v list

  val print : instance -> unit
end

module Make (Csp : CSPS) = struct

  let rec bt (v : Csp.x list) (a : Csp.instance option) =
    let instance = match a with (* Extract instance *)
      | None -> failwith "何"
      | Some k -> k
    in
    match v with
    | [] -> a (* If no more variable, everything is finished, return *)
    | hd :: tl ->
        (* Loops over values of var [hd] to grow tree *)
        let rec loop = function
          | [] -> None (* No feasible new instance found *)
          | x :: rxs ->
              if Csp.feasible hd x instance
              then match bt tl (Some (Csp.union instance hd x)) with
                (* If the new instance is not feasible, try another value *)
                | None -> loop rxs
                | Some j -> Some j (* Good instance, return it *)
              else loop rxs
        in loop (Csp.domain hd)
end
