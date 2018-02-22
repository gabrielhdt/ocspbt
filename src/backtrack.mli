(** Functorial interface to the csp solver using backtrack *)

(** Submodule of the CSP, handles variables *)
module type VARS = sig

  (** The type of variables *)
  type t

  (** Type of a group of variables *)
  type set

  (** The initial set of variables to instantiate *)
  val init : set

  (** The empty set of variables *)
  val empty : set

  (** [next s] returns a variable of the set [s] and  the remaining set *)
  val next : set -> t * set
end

(** Submodule of the CSP handling values of the variables *)
module type VALS = sig

  (** The type of values *)
  type t

  type set

  val emtpy : set

  val next : set -> t * set
end

(** Submodule of the CSP, handles a collection of variables with their
    associated values *)
module type INSTS = sig

  type t

  val empty : t
end

(** Signature of a CSP, input of the functor *)
module type CSPS =
  sig

    module Var : VARS

    module Val : VALS

    module Instance : INSTS

    (** [feasible x v a] checks whether the instance [a] is consistent with
        constraint [x = v] *)
    val feasible : Var.t -> Val.t -> Instance.t -> bool

    (** [consistent i] asserts whether instance [i] is consistent. Very close
        from [feasible] *)
    val consistent : Instance.t -> bool

    (** [union a x v] returns a new instance of [a] with [x = v] *)
    val union : Instance.t -> Var.t -> Val.t -> Instance.t

    (** [domain x] returns the (discrete) domain on which [x] is defined *)
    val domain : Var.t -> Val.set

    (** [print i] offers a representation of instance [i] *)
    val print : Instance.t -> unit
  end

(** [Make(c)] returns appropriate functions to solve the csp problem [c] *)
module Make : functor (Csp : CSPS) ->
    sig
      (** [bt v a] executes backtrack of variables [v] from instance [a] *)
      val bt : Csp.Var.set -> Csp.Instance.t -> Csp.Instance.t
    end
