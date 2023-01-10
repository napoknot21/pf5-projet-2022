(** Pile *)

type 'a t = 'a list


let empty = [];;

let rec length p = match p with 
  | [] -> 0;;
  | h::tail -> 1 + length tail;;

let pushBack x p = x :: p;; (** Default push function *)

let pushFront x p = List.rev (x::(List.rev p));;

let rec pushList l p = match l with
  | [] -> p
  | h::tail -> pushList tail (pushBack h p);;

let pop p = match p with
  | [] -> raise Not_found
  | h::tail -> h, tail

(** get the first n element of the stack*)
let popN p n =
  let rec aux pile index l =
    if n <= 0 then (l, pile)
    else
      let h, tail = pop pile in
      aux tail (index-1) (h::l)
  in aux p n [];;

let subStack p n = let list,tail = popN p n in (of_list list, tail);;

let of_list p = pushList p [];;

let to_list = match p with
  | [] -> []
  | _ -> List.rev p;;

let to_string (f : 'a -> string) p = 
  let rec aux pile string_res = match p with
    | [] -> string_res
    | h::tail -> aux tail (string_res ^ "; " ^ f h)
  in match p with
    | [] -> "[]"
    | h::tail -> "[" ^ (f h) ^ (aux tail "") ^ "]";;

