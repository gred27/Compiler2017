{
 open Parser
 exception Eof
 exception LexicalError
 let comment_depth = ref 0
 let keyword_tbl = Hashtbl.create 31
 let _ = List.iter (fun (keyword, tok) -> Hashtbl.add keyword_tbl keyword tok)
                   [
                    ("int", INT);
                    ("if", IF);
                    ("else",ELSE);
                    ("while", WHILE);
                    ("do"   , DO);
                    ("print", PRINT);
                    ("read", READ)
                  ] 
} 

let blank = [' ' '\n' '\t' '\r']+
let id = ['a'-'z' 'A'-'Z']['a'-'z' 'A'-'Z' '0'-'9' '_']*
let number = ['0'-'9']+

rule start =
 parse blank { start lexbuf }
<<<<<<< HEAD
     | "/*" 	{ comment_depth :=1; comment lexbuf; start lexbuf }
     | "int"	{ INT }
     | "if"		{ IF }
     | "else" 	{ ELSE }
     | "while"	{ WHILE }
     | "do"		{ DO }
     | "read" 	{ READ }
     | "print"	{ PRINT }
     | '+'		{ PLUS }
     | '-'		{ MINUS }
     | '*'		{ STAR }
     | '/'		{ SLASH }
     | "=="		{ EQUALEQUAL }
     | '='		{ EQUAL}
     | "<="		{ LE }
     | '<'		{ LT }
     | ">="		{ GE }
     | '>'		{ GT }
     | '!'		{ NOT }
     | "&&"		{ AND }
     | "||"		{ OR }
     | ';'		{ SEMICOLON }
     | '{'		{ LBRACE }
     | '}'		{ RBRACE }
     | '[' 		{ LBLOCK }
     | ']'		{ RBLOCK }
     | '(' 		{ LPAREN }
     | ')'		{ RPAREN }
     | number 	{ NUM (int_of_string (Lexing.lexeme lexbuf)) }
     | id		{ ID (Lexing.lexeme lexbuf) }
     | eof 	  	{ EOF }
=======
     | "/*" { comment_depth :=1; comment lexbuf; start lexbuf }
     | number { NUM (int_of_string (Lexing.lexeme lexbuf)) }
     | id { let id = Lexing.lexeme lexbuf
            in try Hashtbl.find keyword_tbl id
               with _ -> ID id
            }
     | "+"   { PLUS }
     | "-"   { MINUS }
     | "*"   { STAR }
     | "/"   { SLASH }
     | "!"   { NOT }
     | "=="  { EQUALEQUAL }
     | "="   { EQUAL }
     | "<="  { LE }
     | ">="  { GE }
     | "<"   { LT }
     | ">"   { GT }
     | "]"   { RBLOCK }
     | "["   { LBLOCK }
     | ";"   { SEMICOLON }
     | "("   { LPAREN }
     | ")"   { RPAREN }
     | "{"   { LBRACE }
     | "}"   { RBRACE } 
     | "&&"  { AND }
     | "||"  { OR }
     | eof   { EOF}
>>>>>>> 77e96d5ec238c61a9ffa7648fdf95d4114072be2
     | _ { raise LexicalError }

and comment = parse
     "/*" {comment_depth := !comment_depth+1; comment lexbuf}
   | "*/" {comment_depth := !comment_depth-1;
           if !comment_depth > 0 then comment lexbuf }
   | eof {raise Eof}
   | _   {comment lexbuf}
