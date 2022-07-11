%{
    open Interpreter;;
%}

%token <int>    INTEGER
%token <string> CONSTANT
%token <string> VARIABLE
%token          EOF LPAREN RPAREN LBRACKET RBRACKET COLON RULE_COND SUBTRACT NOT_EQ ADD MULT EQ RTARROW COMMA DOT APOSTROPHE SEMICOLON 

%start filename
%start database
%start query
%type <Expression.database> database
%type <Expression.query> query
%type <string> filename

%%

query:
  clause_list DOT {Query($1)}

database:
  EOF {[]}
  | predicate_list EOF  {$1}

predicate_list:
  predicate   {[$1]}
  | predicate predicate_list  {($1)::$2}

predicate:
  clause DOT    {Fact(Head($1))}
  | clause RULE_COND clause_list DOT    {Rule(Head($1),Body($3))}

clause_list:
  clause     {[$1]}
  | clause COMMA clause_list  {$1::$3}

clause:
  CONSTANT      {Clause($1, [])}
  | CONSTANT LPAREN term_list RPAREN {Clause($1, $3)}

term_list:
  term     {[$1]}
  | term COMMA term_list  {$1::$3}

term:
  LPAREN term RPAREN {$2}
  | VARIABLE {Variable($1)}
  | INTEGER {Number($1)}
  | CONSTANT {Constant($1, [])}


filename:
  LBRACKET APOSTROPHE CONSTANT DOT CONSTANT APOSTROPHE RBRACKET DOT                         { $3 ^ "." ^ $5 }
;

%%