open Expression;;
open Env;;


let unifyClauses (c1:clause) (c2:clause) (env:environment) : environment = 
    let newC1 = applyEnv env c1
    in
    let newC2 = applyEnv env c2
    in
    let newEnv = (buildEnv (newC1) (newC2))
    in
    env @ newEnv

let rec solveQuery (database:database) (q:query) (env:environment) (vars:var list) : (bool) =
    match q with
        Query([]) -> (
            prinSolution (getSolution env vars);
            flush stdout;
            let choice = ref (get1char()) in
            while(!choice <> '.' && !choice <> ';') do
                Printf.printf "\nEnter correct action(./;) ";
                flush stdout;
                choice := get1char();
            done;
            Printf.printf "\n";
            if !choice = '.' then true
            else false
        )
        | Query(cl_query::qs) -> match cl_query with
            _ -> 
            let rec iter db = 
                match db with
                    [] -> false
                    | (pred::rest) -> match pred with
                        Fact(Head(cl_database)) -> (
                            try 
                                let e = unifyClauses cl_database cl_query env in
                                match (solveQuery database (Query qs) e vars) with
                                    true -> true
                                    | _ -> iter rest
                            with Not_Unifiable -> iter rest
                        )
                        | Rule(Head(cl_database), Body(body_list)) -> (
                            try
                                let e = unifyClauses cl_database cl_query env in
                                match (solveQuery database (Query(body_list @ qs)) e vars) with
                                    true -> true
                                    | _ -> iter rest
                            with Not_Unifiable -> iter rest
                        )

        in iter database
;;

let resolveQuery (database: database) (query: query) = solveQuery database query [] (variablesInQuery query)