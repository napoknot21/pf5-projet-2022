open Regles
open Card

type nameGame = FC | SH | MO | BD

type configGame = {
    cols : (card Pile.t) list;
    reg : card list;
    dep : (card Pile.t) list; (* 'a == card*)
    hist : (string * string) Pile.t;
    score : int
}

type config = regle * configGame

(** Auxiliary functions *)
let init_list_pile_card (n: int) = 
    let rec aux tab i = match i with
        | 0 -> tab
        | _ -> aux (Pile.empty :: tab) (i-1)
    in aux [] n;;

let init_list_reg (n: int) = 
    let rec aux tab i = match i with
        | 0 -> tab
        | _ -> let card_empty = (-1,Trefle) in aux (card_empty :: tab) (i-1)
    in aux [] n;; 

(** Constructor for a ConfigGame *)
let make_configGame (cols: (card Pile.t) list) (reg: card list) (dep : (card Pile.t) list) (hist : (string*string) Pile.t) (score: int) = 
    { cols; reg; dep; hist; score}


(** Make a regle from a game name*)
let make_regle_from_game (game : nameGame) = match game with
    | FC -> make_regle 8 4 4 [7; 6; 7; 6; 7; 6; 7; 6] (Altern, Descend) (EqualType, Ascend) King As
    | SH -> make_regle 10 4 4 [5; 5; 5; 5; 5; 5; 5; 5; 5; 5] (EqualColor, Descend) (EqualType, Ascend) King As
    | MO -> make_regle 18 0 4 [3; 3; 3; 3; 3; 3; 3; 3; 3; 3; 3; 3; 3; 3; 3; 3; 3; 1] (EqualColor, Descend) (EqualType, Ascend) H_None As
    | BD -> make_regle 13 0 4 [4; 4; 4; 4; 4; 4; 4; 4; 4; 4; 4; 4; 4] (All, Descend) (EqualType, Ascend) H_None As;;

    (*
let make_config Game_from_rule (regle: regle) = {
    cols = init_list_pile_card regle.nb_cols;
    reg = if regle.nb_reg <= 0 then [] else init_list_reg regle.nb_reg;
    dep = init_list_pile_card regle.nb_dep;
    hist = Pile.empty;
    score = 0 };;
*)
let make_config (regle : regle) (configGame: configGame) = (regle, configGame);;
