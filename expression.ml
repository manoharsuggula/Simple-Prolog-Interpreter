exception NotFound


type const = string
type var = string
type argument = Variable of var | Number of int | Constant of const * (argument list)
type environment = (var * argument) list
type clause = Clause of const * (argument list)
type head = Head of clause
type body = Body of (clause list)
type predicate = Fact of head | Rule of head * body
type database = predicate list
type query = Query of (clause list)


let rec existsInList x y = match y with
    [] -> false
  | h::t -> (x = h) || (existsInList x t)
;;

let rec listUnion l1 l2 = match l1 with
    [] -> l2
  | h::t -> if (existsInList h l2) then listUnion t l2
            else ((h)::(listUnion t l2))
;;

let rec variablesInArgument (a:argument) : var list = 
    match a with
        Variable(v) -> [v]
        | Constant(c,l) -> List.fold_left listUnion [] (List.map variablesInArgument l)
        | _ -> []
;;

let variablesInClause (clause: clause) : var list = 
    match clause with
    | Clause(c, l) -> variablesInArgument (Constant(c,l))
;;

let variablesInQuery (query: query) : var list =
    match query with
    Query(q) -> List.fold_left listUnion [] (List.map variablesInClause q) 
;;

let get1char () =
    let argumentio = Unix.tcgetattr Unix.stdin in
    let () =
        Unix.tcsetattr Unix.stdin Unix.TCSADRAIN
            { argumentio with Unix.c_icanon = false } in
    let res = input_char stdin in
    Unix.tcsetattr Unix.stdin Unix.TCSADRAIN argumentio;
    res

let rec getSolution (env:environment) (vars:var list) =
    match vars with
    | [] -> []
    | (v::vs) ->
        let rec occurs l =
            match l with
             [] -> raise NotFound
            | (x::xs) -> if (fst x) = v then x else occurs xs in
            try
                occurs (env)::getSolution env vs
            with NotFound -> getSolution env vs
;;

let rec print_argument (a:argument) = 
    match a with
    | Variable(v) -> Printf.printf " %s " v
    | Number(n) -> Printf.printf " %d " n
    | Constant(s,l) -> Printf.printf " %s " s
;;

let rec prinSolution (env:environment) = 
    match env with 
         [] -> Printf.printf "true"
         | [(v,t)] -> (
             Printf.printf "%s =" v;
             print_argument t;
         )
         | (v,t)::xs -> (
            Printf.printf "%s =" v;
            print_argument t;
            Printf.printf ", ";
            prinSolution xs;
         )
;;