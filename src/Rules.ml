(** Regles des jeux *)

type game = Fc | Mo | Sh | Bd (** FreeCell, Midnigth O. , Seahaven, Baker's D.*)

type sec_color = Altern | Same

type alternating = bool

type emptyAllowed = bool

type firstOnEmpty = Trefle | Pique | Coeur | Carreau

type firstInColumn = Trefle | Pique | Coeur | Carreau