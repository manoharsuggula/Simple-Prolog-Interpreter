{
exception Lexer_exception of string
}


let integer = '0'|['1'-'9']['0'-'9']*
let var = ['A'-'Z' '_'] ['a'-'z' 'A'-'Z' '0'-'9' '_']*
let const = ['a'-'z'] ['a'-'z' 'A'-'Z' '0'-'9' '_']*
let special_char = [' ' '\t' '\n']+


rule scan = parse
  | eof          { Parser.EOF                        }
  | integer as s { Parser.INTEGER((int_of_string s)) }
  | var as s     { Parser.VARIABLE(s)                }
  | const as s   { Parser.CONSTANT(s)                }
  | special_char { scan lexbuf                       }
  | '('          { Parser.LPAREN                     }
  | ')'          { Parser.RPAREN                     }
  | '['          { Parser.LBRACKET                   }
  | ']'          { Parser.RBRACKET                   }
  | ':'          { Parser.COLON                      }
  | ":-"         { Parser.RULE_COND                  }
  | '-'          { Parser.SUBTRACT                   }
  | "\\="        { Parser.NOT_EQ                     }
  | '+'          { Parser.ADD                        }
  | '*'          { Parser.MULT                       }
  | '='          { Parser.EQ                         }
  | ','          { Parser.COMMA                      }
  | '.'          { Parser.DOT                        }
  | "'"          { Parser.APOSTROPHE                 }
  | ";"          { Parser.SEMICOLON                  }

{
}