(** In Xpat2, the index of the game is a seed used to shuffle
    pseudo-randomly the cards.
    The shuffle function emulates this permutation generator.
    The input number is the seed (between 1 and 999_999_999).
    The output list is of size 52, and contains all numbers in 0..51
    (hence without duplicates).

*)
(* The numbers manipulated below will be in [0..randmax[ *)
open Fifo
let randmax = 1_000_000_000

(* Converting an integer n in [0..randmax[ to an integer in [0..limit[ *)
let reduce n limit =
  Int.(of_float (to_float n /. to_float randmax *. to_float limit))


(** DESCRIPTION DE L'ALGORITHME DE GENERATION DES PERMUTATIONS

a) Créer tout d'abord les 55 premières paires suivantes:
  * premières composantes : 0 pour la premiere paire,
    puis ajouter 21 modulo 55 à chaque fois
  * secondes composantes : graine, puis 1, puis les "différences"
    successives entre les deux dernières secondes composantes.
    Par "différence" entre a et b on entend
      - Ou bien (a-b) si b<=a
      - Ou bien (a-b+randmax) si a<b

b) Trier ces 55 paires par ordre croissant selon leurs premières composantes,
   puis séparer entre les 24 premières paires et les 31 suivantes.
   Pour les 31 paires, leurs secondes composantes sont à mettre dans
   une FIFO f1_init, dans cet ordre (voir `Fifo.of_list` documenté dans
   `Fifo.mli`). De même pour les 24 paires, leurs secondes composantes sont
   à mettre dans une FIFO f2_init, dans cet ordre.

c) Un *tirage* à partir de deux FIFO (f1,f2) consiste à prendre
   leurs premières valeurs respectives n1 et n2 (cf `Fifo.pop`),
   puis calculer la "différence" de n1 et n2 (comme auparavant),
   nommons-la d. Ce d est alors le résultat du tirage, associé
   à deux nouvelles FIFO constituées des restes des anciennes FIFO
   auxquelles on a rajouté respectivement n2 et d (cf `Fifo.push`).

d) On commence alors par faire 165 tirages successifs en partant
   de (f1_init,f2_init). Ces tirages servent juste à mélanger encore
   les FIFO qui nous servent d'état de notre générateur pseudo-aléatoire,
   les entiers issus de ces 165 premiers tirages ne sont pas considérés.

e) La fonction de tirage vue précédemment produit un entier dans
   [0..randmax[. Pour en déduire un entier dans [0..limit[ (ou limit est
   un entier positif quelconque), on utilisera alors la fonction `reduce`
   fournie plus haut.
   Les tirages suivants nous servent à créer la permutation voulue des
   52 cartes. On commence avec une liste des nombres successifs entre 0 et 51.
   Un tirage dans [0..52[ nous donne alors la position du dernier nombre
   à mettre dans notre permutation. On enlève alors le nombre à cette position
   dans la liste. Puis un tirage dans [0..51[ nous donne la position
   (dans la liste restante) de l'avant-dernier nombre de notre permutation.
   On continue ainsi à tirer des positions valides dans la liste résiduelle,
   puis à retirer les nombres à ces positions tirées pour les ajouter devant
   la permutation, jusqu'à épuisement de la liste. Le dernier nombre retiré
   de la liste donne donc la tête de la permutation.

   NB: /!\ la version initiale de ce commentaire donnait par erreur
   la permutation dans l'ordre inverse).

Un exemple complet de génération d'une permutation (pour la graine 1)
est maintenant donné dans le fichier XpatRandomExemple.ml, étape par étape.

*)

(* For now, we provide a shuffle function that can handle a few examples.
   This can be kept later for testing your implementation. *)

let shuffle_test = function
  | 1 ->
     [13;32;33;35;30;46;7;29;9;48;38;36;51;41;26;20;23;43;27;
      42;4;21;37;39;2;15;34;28;25;17;16;18;31;3;0;10;50;49;
      14;6;24;1;22;5;40;44;11;8;45;19;12;47]
  | 12 ->
     [44;9;28;35;8;5;3;4;11;25;43;2;27;1;24;40;17;41;47;18;
      10;34;39;7;36;29;15;19;30;37;48;45;0;21;12;46;22;13;16;
      33;31;38;23;6;14;49;26;50;20;32;42;51]
  | 123 ->
     [16;51;44;27;11;37;33;50;48;13;17;38;7;28;39;15;4;5;3;6;
      42;25;19;34;20;49;23;0;8;26;30;29;47;36;9;24;40;45;14;
      22;32;10;1;18;12;31;35;2;21;43;46;41]
  | 1234 ->
     [36;37;44;26;9;10;23;30;29;18;4;35;15;50;33;43;28;2;45;
      6;3;31;27;20;7;51;39;5;14;8;38;17;49;0;40;42;13;19;34;
      1;46;22;25;24;12;48;16;21;32;11;41;47]
  | 12345 ->
     [10;12;6;23;50;29;28;24;7;37;49;32;38;30;31;18;13;2;15;4;
      5;47;16;1;0;35;43;40;42;44;46;39;48;20;36;34;8;14;33;11;
      25;45;41;19;3;17;21;51;26;22;27;9]
  | 123456 ->
     [1;7;39;47;5;15;50;49;37;44;29;10;4;23;17;20;0;11;24;14;
      28;35;3;48;8;41;19;46;13;12;36;34;27;9;33;22;43;32;25;30;
      38;6;31;16;51;21;26;18;45;40;42;2]
  | 1234567 ->
     [19;17;31;6;4;14;9;36;35;30;39;40;50;48;42;37;12;3;25;1;
      43;27;5;20;10;51;11;44;46;38;16;22;26;23;21;28;15;7;47;
      13;18;29;32;0;49;34;8;45;24;33;2;41]
  | 22222 ->
     [43;17;21;40;42;47;0;35;23;18;11;29;41;10;45;7;15;25;13;
      51;6;12;33;24;8;34;50;2;30;28;37;3;4;39;49;31;32;14;44;
      22;46;48;9;1;36;5;27;26;38;20;16;19]
  | 222222 ->
     [42;48;16;9;22;21;45;12;40;44;29;31;24;27;33;38;14;15;49;
      37;0;26;10;1;47;4;50;34;23;8;3;2;19;32;13;43;51;6;39;35;
      18;30;11;7;46;17;20;5;41;36;25;28]
  | 2222222 ->
     [17;45;5;4;33;23;10;42;39;3;24;46;6;29;44;27;0;43;2;7;20;
      14;34;8;11;18;15;28;25;49;40;47;48;21;41;9;31;30;36;12;
      51;1;35;26;50;38;32;19;13;37;22;16]
  | 999_999_999 ->
     [22;1;0;21;20;44;23;43;38;11;4;2;19;27;36;9;49;7;18;14;
      46;10;25;35;39;48;51;40;33;13;42;16;32;50;24;47;26;6;34;
      45;5;3;41;15;12;31;17;28;8;29;30;37]
  | _ -> failwith "shuffle : unsupported number (TODO)"


(***********************Auxiliary functions************************)

(** if the pair (a,b) is greater than (u,v) <=> a >= u*)
let greater_than (x: int*int) (y: int*int) = match x,y with
   | (a,b),(u,v) -> a >= u;;


let diff_pair (x: int*int) (y: int*int) = match x,y with
   | (a,b),(u,v) -> 
      if b >= v then (((u+21)mod 55) , b-v) 
      else (((u+21)mod 55) , (b-v)+randmax);;


let rec append_list (x : (int*int) list) (y: (int*int) list) = match x with
   | [] -> y
   | h::tail -> h::(append_list tail y);;


let rev_list (lst : (int*int) list) = 
   let rec aux list_origin list_rev = match list_origin with
      | [] -> list_rev
      | h::tail -> aux tail (h::list_rev)
   in aux lst [];;


let rec split_lists (x: (int*int) list) (y: (int*int) list) (l: (int*int) list) = match l with
   | [] -> (x,y)
   | h::tail -> split_lists (h::y) x tail;; 


let rec lists_merge (x: (int*int) list) (y: (int*int) list) = match x,y with
   | [],l | l,[] -> l
   | h1::tail1, h2::tail2 -> 
      if (greater_than h1 h2) then h1 :: lists_merge tail1 y 
      else h2 :: lists_merge x tail2;;


(**return a int*int list rev*)
let rec sort_merge (lst: (int*int) list)  = match lst with
   | [] | [_] -> lst
   | _ -> let lst1, lst2 = split_lists [] [] lst in
         lists_merge (sort_merge lst1) (sort_merge lst2);;


let popList list (i : int) =
   let rec aux lst lstNew  (index : int) = match lst with
      | [] -> -1,lst
      | h::tail -> if index = 0 then h,List.rev lstNew @ tail
         else aux tail (h::lstNew) (index-1)
   in aux list [] i;;


(***********************Main funcitons************************)

(** Partie a*)
let rec pair_init (i : int) (graine: int) (pair_list: (int*int) list) = match i with
   | 0 -> pair_list
   | i -> (
      match pair_list with
         | [] -> pair_init (i-1) graine ([(0, graine)] @ pair_list)
         | [a] -> pair_init (i-1) graine ([(21, 1)] @ pair_list)
         | h1::h2::tail -> pair_init (i-1) graine ([(diff_pair h2 h1)] @ pair_list)
   );;


(** Partie b*)
let sep_list (pair_list : (int*int) list) =
   let pair_list_sorted = sort_merge pair_list in
   let part_list = List.partition (fun (x,y) -> x < 24) pair_list_sorted in
   match part_list with
      | (a,b) -> (List.split(a), List.split (b));;


(** Partie c*)
let distribution_fifo list_tup = match list_tup with
   | ((a,b), (u,v)) -> (Fifo.of_list (v), Fifo.of_list (b));;


(** Partie d*)
let differences_fifo pair = match pair with
   | (f1, f2) -> 
      let (val1, f1_t) = Fifo.pop f1 in 
      let (val2, f2_t) = Fifo.pop f2 in 
      let difference_t = 
         if (val1 >= val2) then (val1 - val2) 
         else (val1 - val2)+randmax in
      (Fifo.push val2 f1_t, Fifo.push difference_t f2_t), difference_t;;


(** partie e*)
let rec dessin_fifo pair_fifo rep = match rep, (differences_fifo pair_fifo) with
   | 0, (fifos, _) -> fifos
   | n, (fifos, _) -> dessin_fifo fifos (n-1);; 


let rec final_dessin pair_fifo rep perm array_init = match rep with
   | 0 -> perm
   | n -> (
      match (differences_fifo pair_fifo) with
         | (fifos, diff) ->  (
            match (popList array_init (reduce diff rep)) with
               | (h, res_list) -> final_dessin (fifos) (rep-1) (h::perm) (res_list)
            )   
      )      ;;
            

let array_init = List.init 52 (fun a -> a);;

let shuffle n =
   let first_p = pair_init 55 n [] in
   let sep_l = sep_list first_p in
   let fifo_p = distribution_fifo sep_l in
   let fifo_shuf = dessin_fifo fifo_p 164 in 
   final_dessin (fifo_shuf) (52) [] (array_init);;
