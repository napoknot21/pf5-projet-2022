(** Regles des jeux *)

type game = Fc | Mo | Sh | Bd (** FreeCell, Midnigth O. , Seahaven, Baker's D.*)
type order = Upper | Under 
type nbColumns = int

type alternating = bool

type emptyAllowed = bool

type firstOnEmpty = Trefle | Pique | Coeur | Carreau

type firstInColumn = Trefle | Pique | Coeur | Carreau