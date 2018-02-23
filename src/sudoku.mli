(** Sudoku module *)

module type Variable = sig

  (** Each variable is a cell of the sudoku *)
  type t

  type set

  val empty : set

  val init : set

  val next : set -> t * set
end

module type Value = sig

  (** Value written in a cell *)
  type t

  type set

  val empty : set

  val next : set -> t * set
end

module type Instance = sig

  (** Mapping from cells to values *)
  type t

  (** The empty instance *)
  val empty : t

  val union : t -> t -> t

  (** [consistent q] returns variables violating a constraint in problem [q],
      here if a variable has the same value as another one on the same row
      or the same column or the same subsquare *)
  val consistent : t -> t

  (** [print i] prints the sudoku grid of instance [i] *)
  val print : t -> unit
end

module Var : Variable

module Val : Value

module Inst : Instance

(** [domain v] returns the columns available for cell [v] *)
val domain : Var.t -> Val.set

(** [feasible x v i] asserts whether another variable on the same line, on the
    same column or in the same subsquare as [x] has the value [v] in
    instance [i] *)
val feasible : Var.t -> Val.t -> Inst.t -> bool

(** [union i x v] writes value [v] in cell [x] of instance [i] *)
val union : Inst.t -> Var.t -> Val.t -> Inst.t

(** [mem c s] returns whether the cell [c] has already been written in
 *  instance [s] *)
val mem : Var.t -> Inst.t -> bool

(** [load p] loads file from path [p] containing some variables instantiated
    and returns the associated instance and the list of remaining variables
    to process. If the instance is loaded, the backtrack function must be
    called with the resulting variables list. Not doing so will result in an
    error *)
val load : string -> Inst.t * Var.set
