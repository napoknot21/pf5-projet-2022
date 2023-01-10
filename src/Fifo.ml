(** A FIFO structure (First-In First-Out),
    implemented in functional style
    (NB: the Queue module of OCaml stdlib is imperative)

    NB: l'implémentation fournie initialement ci-dessous est inefficace,
    l'améliorer (tout en restant fonctionnel). Par exemple on peut utiliser
    une paire de listes pour implémenter ['a t].

*)

type 'a t = 'a list * 'a list (* head of list = first out *)

let empty = ([], []);;

let isEmpty (l: 'a t ) = match l with
  | ([], []) -> true
  | (_,_) -> false;;

let push (x: 'a) (l : 'a t ) = match l with
  | (l1, l2) -> (l1, x::l2);;

let rec pushList (x: 'a list) (l : 'a t) = match x with
  | [] -> l
  | h::tail -> pushList (tail) (push h l);;  

let pop (q : 'a t ) = match q with 
  | ([],[]) -> raise Not_found
  | (h::tail,l2)-> h, (tail,l2)
  | ([], l2) -> match List.rev l2 with
    | [] -> assert false 
    | h::tail -> h, (tail,[]);;

let of_list (l: 'a list) = pushList l empty;;

let to_list (l: 'a t) = match l with | (l1,l2) -> l1 @ List.rev l2;;
