open Regles

type config {
    depot : int Farray.t; (* Un Farray de type int *)
    cols : (Card.card Pile.t) list; (* Un Farray de piles type card*)
    reg : Card.card list;
    hist : (string * string) list;
    score : int
}

type game = FC | SH | MO | BD

let empty = {
    depot = Farray 4 0;
    cols = [];
    reg = [];
    hist = [];
    score = 0
}

let make_regle game = match game with
    | FC -> {nb_reg = 4; nb_cols = 8; lst_card = (Card.card) Pile.empty; order = (Altern, Ascend); first_card = King; depot =  }

let make_config depot cols reg hist score = { depot; cols; reg; hist; score }
