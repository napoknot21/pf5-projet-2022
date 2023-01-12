open Regles
open Card

type nameGame = FC | SH | MO | BD

type configGame = {
    cols : (card Pile.t) list;
    reg : card list;
    dep : (card Pile.t) list;
    hist : (string * string) Pile.t;
    score : int
}

type config = regle * configGame

val make_configGame : (card Pile.t) list -> card list -> (card Pile.t) list -> (string*string) Pile.t -> int -> configGame

val make_regle_from_game : nameGame -> regle

(*val make_configGame_from_rule : regle -> configGame *)

val make_config : regle -> configGame -> (regle * configGame)