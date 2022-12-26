(** A FIFO structure (First-In First-Out),
    implemented in functional style
    (NB: the Queue module of OCaml stdlib is imperative)

    NB: l'implémentation fournie initialement ci-dessous est inefficace,
    l'améliorer (tout en restant fonctionnel). Par exemple on peut utiliser
    une paire de listes pour implémenter ['a t].

*)

type 'a t = 'a list (* head of list = first out *)

let empty = [];;

let push x q = x::q;;

let pop q = match q with 
  | x::q' -> x, q' 
  | [] -> raise Not_found

let of_list l =
  let rec aux list_origin list_rev = match list_origin with
    | [] -> list_rev
    | e::rest -> aux rest (e::list_rev)
  in aux l [];;  

let to_list l = l
