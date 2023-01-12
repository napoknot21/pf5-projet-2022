(** In Xpat2, the index of the game is a seed used to shuffle
    pseudo-randomly the cards.
    The shuffle function emulates this permutation generator.
    The input number is the seed (in 1..999_999_999).
    The output list is of size 52, and contains all numbers in 0..51
    (hence without duplicates).
*)
val randmax : int

val shuffle : int -> int list

val diff_pair : (int*int) -> (int*int) -> (int*int)

val pair_init : int -> int -> (int*int) list -> (int*int) list