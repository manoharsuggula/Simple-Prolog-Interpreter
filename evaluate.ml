let evaluate () =
  try
    let cin =
      (if Array.length Sys.argv > 1 then
        open_in Sys.argv.(1)
      else
        stdin)
    in
    let _ = print_string "| ?- "
    in
    let _ = flush stdout
    in
    let filename = (let input = Lexing.from_channel cin in
        Parser.filename Lexer.scan input)
    in
    let file_handle = open_in filename 
    in
    let database = (let lexbuf = Lexing.from_channel file_handle in 
      Parser.database Lexer.scan lexbuf)
    in
    let _ = print_string "true.\n\n" in
    let lexbuf = Lexing.from_channel stdin in
    while true do
    print_string "| ?- ";
    flush stdout;
    let query = Parser.query Lexer.scan lexbuf in
    flush stdout;
    match (Interpreter.resolveQuery database query) with
    true -> print_string "\n"
    | false -> print_string "false.\n\n"  
    done
  with _ ->  print_string "\nBye \n"

    
let _ = evaluate () 