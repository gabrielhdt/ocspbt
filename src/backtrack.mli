(** Functorial interface to the csp solver using backtrack *)

(** Submodule of the CSP, handles variables *)
module type Variable = sig

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
module type Value = sig

  (** The type of values *)
  type t

  type set

  (** The empty set of values *)
  val empty : set

  val next : set -> t * set
end

(** Submodule of the CSP, handles a collection of variables with their
    associated values *)
module type Instance = sig

  (** Type of an instance *)
  type t

  (** The empty instance *)
  val empty : t

  (** [union s u] returns the union on instance [s] and instance [u] *)
  val union : t -> t -> t

  (** [consistent i] returns the instance of variables violating a
      constraint, or the empty set if any constraint is violated *)
  val consistent : t -> t

  (** [print i] offers a representation of instance [i] *)
  val print : t -> unit
end

(** Signature of a CSP, input of the functor *)
module type ConstraintSatisfactionProblem =
  sig

    module Var : Variable

    module Val : Value

    module Inst : Instance

    (** [feasible x v a] checks whether the instance [a] is consistent with
        constraint [x = v] *)
    val feasible : Var.t -> Val.t -> Inst.t -> bool

    (** [union a x v] returns a new instance of [a] with [x = v] *)
    val union : Inst.t -> Var.t -> Val.t -> Inst.t

    (** [domain x] returns the (discrete) domain on which [x] is defined *)
    val domain : Var.t -> Val.set

    (** [mem x i] returns whether variable [x] belongs to instance [i] *)
    val mem : Var.t -> Inst.t -> bool
  end

(** [Make(c)] returns appropriate functions to solve the csp problem [c] *)
module Make : functor (Csp : ConstraintSatisfactionProblem) ->
    sig
      (** [bt v a] executes backtrack of variables [v] from instance [a] *)
      val bt : Csp.Var.set -> Csp.Inst.t -> Csp.Inst.t

      (** [cbj v a] executes constraint backjumping on variables [v] from
          instance [a] *)
      val cbj : Csp.Var.set -> Csp.Inst.t -> Csp.Inst.t
    end
