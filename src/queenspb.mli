(** CSP model of the queens problem *)

module type Variable = sig

  (** Each variable is a line *)
  type t

  type set

  val empty : set

  val init : set

  val next : set -> t * set
end

module type Value = sig

  (** The value of a variable is the column on which the queen is *)
  type t

  type set

  val empty : set

  val next : set -> t * set
end

module type Instance = sig

  (** Mapping from line to column *)
  type t

  (** The empty instance *)
  val empty : t

  val union : t -> t -> t

  (** [consistent q] returns variables violating a constraint in problem [q]
      i.e. the couple of vars if two vars are on same column or same
      diagonal *)
  val consistent : t -> t

  (** [print i] prints the board of instance [i] *)
  val print : t -> unit
end

module Var : Variable

module Val : Value

module Inst : Instance

(** [domain v] returns the columns available for line [v] *)
val domain : Var.t -> Val.set

(** [feasible x v i] returns true iff in instance [i] the queen on line [x]
    and column [v] has no other queen neither on the line nor on the column
    nor on the diagonals *)
val feasible : Var.t -> Val.t -> Inst.t -> bool

(** [union i v u] returns the instance [i] on line variable [v] with column
    value [u] *)
val union : Inst.t -> Var.t -> Val.t -> Inst.t

(** [mem l q] returns whether a queen has been placed on line [l] in problem
    [q] *)
val mem : Var.t -> Inst.t -> bool
