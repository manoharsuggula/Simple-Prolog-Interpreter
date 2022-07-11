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


val existsInList : 'a -> 'a list -> bool

val listUnion : 'a list -> 'a list -> 'a list

val variablesInArgument : argument -> var list 
    
val variablesInClause : clause -> var list 
    
val variablesInQuery : query -> var list 

val get1char : unit -> char

val getSolution : environment -> var list -> (var * argument) list

val print_argument : argument -> unit
    
val prinSolution : environment -> unit