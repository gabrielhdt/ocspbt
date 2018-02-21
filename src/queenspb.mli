(** CSP model of the queens problem *)

(** Each variable corresponds to a line of the board *)
type x

(** Values represents the column *)
type v

(** Mapping from line to columns *)
type instance

(** The empty instance *)
val empty : instance

(** List of line representations *)
val vars : x list

(** [domain v] returns the columns available for line [v] *)
val domain : x -> v list

(** [feasible x v i] returns true iff in instance [i] the queen on line [x]
    and column [v] has no other queen neither on the line nor on the column
    nor on the diagonals *)
val feasible : x -> v -> instance -> bool

(** [consistent q] @returns if queens problem q is consistent *)
val consistent : instance -> bool

(** [union i v u] returns the instance [i] on line variable [v] with column
    value [u] *)
val union : instance -> x -> v -> instance

(** [print i] prints the board of instance [i] *)
val print : instance -> unit
