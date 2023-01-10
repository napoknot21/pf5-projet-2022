type game = Fc | Mo | Sh | Bd 
(* FreeCell, Midnigth O. , Seahaven, Baker's D.*)

type order_colors = Altern | EqualColor | EqualType | All 
(* On va distinguer les cas ou les cartes auront la même couleur et 
   si les cartes doivent imperativement être de même type (EqualType)*)

type order_numbers = Ascend | Descend
(* L'ordre croissant ou décroissant*)

type head_list = King | All | H_None
(* Si la colonne doit être contenir un Roi en tête, n'importe quelle carte, etc*)

type regle = {
  nb_reg : int; (* number of registers *)
  nb_cols : int; (* nombre des cartes par colonnes *)
  lst_cards : int list;  (* list de cartes par colonne *)
  order = order_colors * order_numbers; (* Si l'ordre est croissant avec les cartes intercalées, etc*)
  first_card : head_list (* Type de colone => premiere card est un roi, n'importe quelle carte ou Aucune*)
  depot = int;
}

val make_regle : int -> int -> int list -> order_colors * order_numbers -> head_list -> int -> registers -> regle

val check_order_color : order_colors * order_numbers -> Card.card -> Card.card -> bool

val check_order_numbers : order_colors * order_numbers -> Card.card -> Card.card -> bool
