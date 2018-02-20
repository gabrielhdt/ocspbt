
type x

type v

type instance

val empty : instance

val vars : x list

val domain : x -> v list

val feasible : x -> v -> instance -> bool

val union : instance -> x -> v -> instance

val print : instance -> unit
