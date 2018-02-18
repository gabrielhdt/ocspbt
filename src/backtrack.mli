(** Signature of a CSP *)
module type S =
  sig
    (** Variables which are defined in a domain *)
    type x

    (** Values of the variables *)
    type v

    (** Instantation of the csp *)
    type instance

    (** [feasible x v a] checks whether the instance [a] is consistent with
        constraint [x = v] *)
    val feasible : x -> v -> instance -> bool

    (** [union a x v] returns a new instance of [a] with [x = v] *)
    val union : instance -> x -> v -> instance

    (** [domain x] returns the domain on which [x] is defined *)
    val domain : x -> v list
  end

(** [Make c] returns appropriate functions to solve the csp problem [c] *)
module Make : functor (Rules : S) ->
    sig
      (** [bt v a] executes backtrack of variables [v] from instance [a] *)
      val bt : Rules.x list -> Rules.instance option -> Rules.instance option
    end
