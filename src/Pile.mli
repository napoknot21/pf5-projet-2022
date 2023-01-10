(** Structure de la pile *)

val empty : 'a list

val length : 'a list -> int

val pushBack : 'a -> 'a list -> 'a list

val pushFront : 'a -> 'a list -> 'a list

val pushList : 'a list -> 'a list -> 'a list

val pop : 'a list -> 'a * 'a list

val popN : 'a list -> int -> 'a list * 'a list

val subStack : 'a list -> int -> 'a list * 'a list

val of_list : 'a list -> 'a list

val to_list : 'a list -> 'a list

val to_string : 'a list -> string