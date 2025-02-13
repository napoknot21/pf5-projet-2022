
open XpatLib

type game = Freecell | Seahaven | Midnight | Baker
type exit_code = Success | Error of int | Insoluble

type mode =
  | Check of string (* filename of a solution file to check *)
  | Search of string (* filename where to write the solution *)

type config = { 
  mutable game : game;
  mutable seed: int;
  mutable mode: mode
}

let config = { game = Freecell; seed = 1; mode = Search "" }

let getgame = function
  | "FreeCell"|"fc" -> Freecell
  | "Seahaven"|"st" -> Seahaven
  | "MidnightOil"|"mo" -> Midnight
  | "BakersDozen"|"bd" -> Baker
  | _ -> raise Not_found

let split_on_dot name =
  match String.split_on_char '.' name with
  | [string1;string2] -> (string1,string2)
  | _ -> raise Not_found

let set_game_seed name =
  try
    let (sname,snum) = split_on_dot name in
    config.game <- getgame sname;
    config.seed <- int_of_string snum
  with _ -> failwith ("Error: <game>.<number> expected, with <game> in "^
                      "FreeCell Seahaven MidnightOil BakersDozen")

(* TODO : La fonction suivante est à adapter et continuer *)
(*
let make_regles config = match config.game with
  | FreeCell -> Regles.make_regle 8 4 4 (List.init 8 (fun x -> if x mod 2 = 0 then 7 else 6)) (Regles.Altern, Regles.Descend) (Regles.EqualType, Regles.Ascend) Regles.King Regles.As
  | Seahaven -> Regles.make_regle 10 4 4 (List.init 10 (fun x -> 5)) (Regles.EqualColor, Regles.Descend) (Regles.EqualType, Regles.Ascend) Regles.King Regles.As
  | Midnight -> Regles.make_regle 18 0 4 (List.init 18 (fun x -> if x = 17 then 1 else 3)) (Regles.EqualColor, Regles.Descend) (Regles.EqualType, Regles.Ascend) Regles.H_None Regles.As
  | Baker -> Regles.make_regle 13 0 4 (List.init 13 (fun x->4)) (Regles.All, Regles.Descend) (Regles.EqualType, Regles.Ascend) Regles.H_None Regles.As

*)

let treat_game conf =
  let permut = XpatRandom.shuffle conf.seed in
  Printf.printf "Voici juste la permutation de graine %d:\n" conf.seed;
  List.iter (fun n -> print_int n; print_string " ") permut;
  print_newline ();
  List.iter (fun n -> Printf.printf "%s " (Card.to_string (Card.of_num n)))
    permut;
  print_newline ();
  print_string "C'est tout pour l'instant. TODO: continuer...\n";
  exit 0

let main () =
  Arg.parse
    [
      ("-check", String (fun filename -> config.mode <- Check filename),
        "<filename>:\tValidate a solution file");
     
      ("-search", String (fun filename -> config.mode <- Search filename),
        "<filename>:\tSearch a solution and write it to a solution file")
    
        ]
    set_game_seed (* pour les arguments seuls, sans option devant *)
    "XpatSolver <game>.<number> : search solution for Xpat2 game <number>";
  treat_game config

let _ = if not !Sys.interactive then main () else ()
