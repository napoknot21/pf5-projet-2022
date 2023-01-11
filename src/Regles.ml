(** Regles des jeux *)

open Card

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
  order : order_colors * order_numbers; (* Si l'ordre est croissant avec les cartes intercalées, etc*)
  first_card : head_list; (* Type de colone => premiere card est un roi, n'importe quelle carte ou Aucune*)
  depot : int
}

let rec aux_length lst_cards = match lst_cards with
  | [] -> 0
  | h::tail -> 1 + aux_length tail;;

(** Constructor *)
let make_regle nb_reg nb_cols lst_cards order first_card depot = 
  if (aux_length lst_cards) > nb_cols 
  then raise (Invalid_argument "Make_regle: nb_cols < length of lst_cards")
  else { nb_reg; nb_cols; lst_cards; order ; first_card; depot };;


(** Auxiliary checks for color/types cards*)
let is_red_card card = let r,s = card in (s = Coeur || s = Carreau);;

let is_black_card card = let r,s = card in (s = Trefle || s = Pique);;

let is_same_type card_a card_b = 
  let r1,s1 = card_a and r2,s2 = card_b in s1 = s2;;

let get_rank card = let r,s = card in r;;

(** Main functions *)
let check_order_color order_c card_a card_b = match order_c with
  | Altern -> 
      (is_red_card card_a && is_black_card card_b) || (is_black_card card_a && is_red_card card_a)
  | EqualColor -> 
      (is_red_card card_a && is_red_card card_b) || (is_black_card card_a && is_black_card card_a)
  | EqualType -> 
      is_same_type card_a card_b
  | All -> true;;

let check_order_numbers order_nb card_a card_b = match order_nb with
  | Ascend -> (get_rank card_a = get_rank card_b + 1)
  | Descend -> (get_rank card_a + 1 = get_rank card_b);;
