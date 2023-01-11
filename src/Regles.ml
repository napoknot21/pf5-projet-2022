(** Regles générales des jeux *)

open Card

type order_colors = Altern | EqualColor | EqualType | All 
(* On va distinguer les cas ou les cartes auront la même couleur et 
   si les cartes doivent imperativement être de même type (EqualType)*)

type order_numbers = Ascend | Descend
(* L'ordre croissant ou décroissant*)

type head_list = King | All | H_None
(* Si la colonne (vide) doit peut être rempilie par un Roi, n'importe quelle carte, ou pas du tout *)

type regle = {
  nb_cols : int; (* nombre des cartes par colonnes *)
  nb_reg : int; (* number of registers *)
  nb_dep : int; (* number of depots => hard code to 4*) 
  nb_card_by_col : int list; (* tableaux d'entiers contennant la taille courante de chaque colone *)
  order_col : order_colors * order_numbers; (* type d'ordre pour les piles cartes => hardcode to _ * Descend *)
  order_dep : order_colors * order_numbers; (* type d'ordre pour les piles depot => hardcode to EqualType * Ascend *)
  first_card : head_list; (* cas colone vide => premiere card est un roi, n'importe quelle carte ou Aucune*)
}


let rec aux_length = function
  | [] -> 0
  | h::tail -> 1 + aux_length tail;;

(** Constructor *)
let make_regle nb_cols nb_reg nb_dep nb_card_by_col order_col order_dep first_card = 
  if (aux_length nb_card_by_col) <> nb_cols 
  then raise (Invalid_argument "Make_regle: nb_cols <> length of lst_cards")
  else { nb_cols; nb_reg; nb_dep; nb_card_by_col; order_col; order_dep; first_card };;


(** Auxiliary checks for color/types cards*)
let is_red_card (card : Card.card) = let r,s = card in (s = Coeur || s = Carreau);;

let is_black_card (card : Card.card) = let r,s = card in (s = Trefle || s = Pique);;

let is_same_type (card_a: Card.card) (card_b : Card.card) = 
  let r1,s1 = card_a and r2,s2 = card_b in s1 = s2;;

let get_rank (card : Card.card) = let r,s = card in r;;

(** Main functions *)
let check_order_color (order_c : order_colors) (card_a: Card.card) (card_b : Card.card) = match order_c with
  | Altern -> 
      (is_red_card card_a && is_black_card card_b) || (is_black_card card_a && is_red_card card_a)
  | EqualColor -> 
      (is_red_card card_a && is_red_card card_b) || (is_black_card card_a && is_black_card card_a)
  | EqualType -> 
      is_same_type card_a card_b
  | All -> true;;


let check_order_numbers (order_nb : order_numbers) (card_a : Card.card) (card_b : Card.card) = match order_nb with
  | Ascend -> (get_rank card_a = get_rank card_b + 1)
  | Descend -> (get_rank card_a + 1 = get_rank card_b);;


let check_col_by_rule (rule : regle) (card_a : Card.card) (card_b : Card.card) = match rule.order_col with
  | (order_c, order_n) -> check_order_color order_c card_a card_b && check_order_numbers order_n card_a card_b;;


let check_move_to_empty_col (rule : regle) (card : Card.card) = match rule.first_card with
  | King -> let r,s = card in (r = 13)
  | All -> true
  | H_None -> false