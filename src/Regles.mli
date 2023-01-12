type order_colors = Altern | EqualColor | EqualType | All 
(* On va distinguer les cas ou les cartes auront la même couleur et 
   si les cartes doivent imperativement être de même type (EqualType)*)

type order_numbers = Ascend | Descend
(* L'ordre croissant ou décroissant*)

type head_list = As | King | All | H_None
(* Si la colonne doit être contenir un Roi en tête, n'importe quelle carte, etc*)

type regle = {
  nb_cols : int; (* nombre des cartes par colonnes *)
  nb_reg : int; (* number of registers *)
  nb_dep : int; (* number of depots => hard code to 4*) 
  nb_card_by_col : int list; (* tableaux d'entiers contennant la taille courante de chaque colone *)
  order_col : order_colors * order_numbers; (* type d'ordre pour les piles cartes => hardcode to _ * Descend *)
  order_dep : order_colors * order_numbers; (* type d'ordre pour les piles depot => hardcode to EqualType * Ascend *)
  first_card_col : head_list;
  first_card_dep : head_list (* cas colone vide => premiere card est un roi, n'importe quelle carte ou Aucune*)
  (*cards_reg : int*) (* Nombres de cartes dans les registre à l'état*)
}

val make_regle : int -> int -> int -> int list -> order_colors * order_numbers -> order_colors * order_numbers -> head_list -> head_list -> regle

val check_order_color : order_colors -> Card.card -> Card.card -> bool

val check_order_numbers : order_numbers -> Card.card -> Card.card -> bool

val is_same_type : Card.card -> Card.card -> bool

val get_rank : Card.card -> int

val check_order_color : order_colors -> Card.card -> Card.card -> bool

val check_order_numbers : order_numbers -> Card.card -> Card.card -> bool

val check_col_by_rule : regle -> Card.card -> Card.card -> bool

val check_move_to_empty_col : regle -> Card.card -> bool