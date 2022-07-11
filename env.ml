open Expression;;

exception Not_Unifiable

let rec _applyEnv (env:environment) (a:argument) : argument =
    match a with
    Constant(c,l) -> Constant(c, List.map (_applyEnv env) l)
    | Number(_) -> a
    | Variable(v) -> 
        match env with
            [] -> a
            | s::xs -> if fst s = v then snd s else _applyEnv xs a
;;

let rec applyEnv (env: environment) (cl: clause) =
    match cl with
     Clause(c, ts) -> Clause(c, List.map (_applyEnv env) ts)
;;


let rec _buildEnv (t1:argument) (t2:argument) : environment =
    match (t1,t2) with
    | (Variable(v1) , Variable(v2)) -> if v1 = v2 then [] else [(v1, Variable(v2))]
    | (Variable(v1) , Constant(c,l)) -> [(v1,t2)]
    | (Constant(c,l) , Variable(v2)) -> [(v2,t1)]
    | (Constant(c1,l1) , Constant(c2,l2)) -> 
        if c1 <> c2 || (List.length l1 <> List.length l2) then raise Not_Unifiable
        else
            let func env tt = env @ (_buildEnv (_applyEnv env (fst tt)) (_applyEnv env (snd tt))) in 
            List.fold_left func [] (List.combine l1 l2)
    | _ -> raise Not_Unifiable
;;

let buildEnv (Clause(c1,l1):clause) (Clause(c2,l2):clause) : environment =
    _buildEnv (Constant(c1,l1)) (Constant(c2,l2))
;;