open Regles

type nameGame = FC | SH | MO | BD
type RegCase = CARD | C_NONE

type configGame {
    cols : (Card.card Pile.t) list;
    reg : Card.card list;
    dep : (Card.card Pile.t) list;
    hist : (string * string) Pile.t;
    score : int
}


let make_config rule nameGame = match nameGame with
    | FC -> 


let make_regle game = match game with
    | FC -> {nb_reg = 4; nb_cols = 8; lst_card = (Card.card) Pile.empty; order = (Altern, Ascend); first_card = King; depot =  }

let make_config depot cols reg hist score = { depot; cols; reg; hist; score }
