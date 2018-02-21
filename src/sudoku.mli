(** Sudoku module *)

(** Cells of a sudoku (usually 81) *)
type x

(** Values the cells can take *)
type v

(** Mapping from cells to value *)
type instance

(** The empty sudoku *)
val empty : instance

(** The list of vars, i.e. all couples (x, y) \in [|1, 9|] *)
val vars : x list

(** The domain of a variable, must be [|1, n|] where n is a perfect square *)
val domain : x -> v list

(** [feasible x v i] asserts whether another variable on the same line, on the
    same column or in the same subsquare as [x] has the value [v] in
    instance [i] *)
val feasible : x -> v -> instance -> bool

(** [union i x v] writes value [v] in cell [x] of instance [i] *)
val union : instance -> x -> v -> instance

(** [consistent i] checks whether the instance is consistent. Very close from
    [feasible] *)
val consistent : instance -> bool

(** [print s] prints the grid of sudoku [s], with [n] if the cell is not
    filled *)
val print : instance -> unit

(** [load p] loads file from path [p] containing some variables instantiated
    and returns the associated instance and the list of remaining variables
    to process. If the instance is loaded, the backtrack function must be
    called with the resulting variables list. Not doing so will result in an
    error *)
val load : string -> instance * x list
