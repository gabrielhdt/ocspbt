(** Functorial interface to the csp solver using backtrack *)

(** Signature of a CSP, input of the functor *)
module type CSPS =
  sig
    (** Variables which are defined in a domain *)
    type x

    (** Values of the variables *)
    type v

    (** Instantation of the csp *)
    type instance

    (** The empty instance *)
    val empty : instance

    (** List of variables in the problem *)
    val vars : x list

    (** [feasible x v a] checks whether the instance [a] is consistent with
        constraint [x = v] *)
    val feasible : x -> v -> instance -> bool

    (** [consistent i] asserts whether instance [i] is consistent. Very close
        from [feasible] *)
    val consistent : instance -> bool

    (** [union a x v] returns a new instance of [a] with [x = v] *)
    val union : instance -> x -> v -> instance

    (** [domain x] returns the (discrete) domain on which [x] is defined *)
    val domain : x -> v list

    (** [print i] offers a representation of instance [i] *)
    val print : instance -> unit
  end

(** [Make(c)] returns appropriate functions to solve the csp problem [c] *)
module Make : functor (Csp : CSPS) ->
    sig
      (** [bt v a] executes backtrack of variables [v] from instance [a] *)
      val bt : Csp.x list -> Csp.instance -> Csp.instance
    end
