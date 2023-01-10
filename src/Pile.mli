(** Structure de la pile *)

(** Empty stack *)
val empty : 'a list

(** The stack length *)
val length : 'a list -> int

(** Add an 'a element to the stack's head *)
val pushBack : 'a -> 'a list -> 'a list

(** Add an 'a element at the end of the stack *)
val pushFront : 'a -> 'a list -> 'a list

(** Add a list of 'a element to the stack's head *)
val pushList : 'a list -> 'a list -> 'a list

(** Retrieve and remove the head element of the stack*)
val pop : 'a list -> 'a * 'a list

(** Retrieve and remove a list of N element of the head stack*)
val popN : 'a list -> int -> 'a list * 'a list

(** Retrieve and remove a list of N element of the head stack getting a subStack*)
val subStack : 'a list -> int -> 'a list * 'a list

(** Add all elements of a list in an empty Pile*)
val of_list : 'a list -> 'a list

(** Retrieve all the elements of a Pile *)
val to_list : 'a list -> 'a list

(** Convert a stack into a string representation *)
val to_string : 'a list -> string