(** Variable of the problem *)
type x

(** Type of values of the variables *)
type v

(** Instanciation of the problem *)
type instance

(** The empty instance *)
val empty : instance

(** List of vars in the problem *)
val vars : x list

(** [domain v] returns the list of values that can be taken by [v] *)
val domain : x -> v list

(** [feasible x v i] asserts whether instance [i] accepts variable [x] with
    values [v] *)
val feasible : x -> v -> instance -> bool

(** [union i v] returns a new instance with the new value *)
val union : instance -> x -> v -> instance

(** [print i] offers a representation of instance [i] *)
val print : instance -> unit
