%{

%}
%token <int> NUM
%token <string> ID
%token INT PLUS MINUS STAR SLASH EQUAL EQUALEQUAL LE LT GE GT NOT AND OR IF ELSE WHILE DO READ PRINT SEMICOLON
%token LBRACE RBRACE LBLOCK RBLOCK LPAREN RPAREN EOF

%left SEMICOLON
%left OR
%left AND
%left LT LE GT GE EQUALEQUAL
%left PLUS MINUS
%left STAR SLASH 
%right NOT 
%nonassoc RPAREN
%nonassoc ELSE


%start program
%type <S.program> program

%left SEMICOLON
%nonassoc DO
%nonassoc no_else
%nonassoc ELSE
%right EQUAL
%left AND 
%left OR
%left EQUALEQUAL LE LT GE GT
%left PLUS MINUS
%left STAR SLASH
%nonassoc unary_minus
%nonassoc LBLOCK
%right NOT
%%



program:
    block EOF { $1 }
    ;

block:
    LBRACE decls stmts RBRACE 	{ ($2,$3) }
    ;

decls:
<<<<<<< HEAD
	|	decls decl 				{ $1@[$2] }
   	| 	{ [] }
    ;

decl:
	| tp ID SEMICOLON			{ ($1,$2) }
	;

tp: 
	| INT 						{ S.TINT }
	| INT LBLOCK NUM RBLOCK		{ S.TARR($3) }
	;

stmts:
	|	stmts stmt				{ $1@[$2] }
  	| 	{ [] }
    ;

stmt:
	|	lv EQUAL exp SEMICOLON						{ S.ASSIGN ($1, $3) }
	|	lv PLUS PLUS SEMICOLON						{ S.ASSIGN ($1, (S.ADD(S.LV($1), S.NUM(1)))) }
	|	IF LPAREN exp RPAREN stmt %prec no_else		{ S.IF ($3, $5, S.BLOCK([],[])) }
	|	IF LPAREN exp RPAREN stmt ELSE stmt 		{ S.IF ($3, $5, $7) }
	|	WHILE LPAREN exp RPAREN stmt 				{ S.WHILE ($3, $5) }
	|	DO stmt WHILE LPAREN exp RPAREN SEMICOLON	{ S.DOWHILE ($2, $5) }
	|	READ LPAREN ID RPAREN SEMICOLON				{ S.READ ($3) }
	|	PRINT LPAREN exp RPAREN SEMICOLON			{ S.PRINT ($3) }
	|	block										{ S.BLOCK ($1) }
	;

lv: 
	| ID					{ S.ID ($1) }
	| ID LBLOCK exp RBLOCK	{ S.ARR ($1,$3) }
	;

exp: 
	|	NUM							{ S.NUM ($1) }
	|	lv							{ S.LV ($1) }
	|	exp PLUS exp				{ S.ADD ($1, $3) }
	|	exp MINUS exp 				{ S.SUB ($1, $3)}
	|	exp STAR exp 				{ S.MUL ($1, $3) }
	|	exp	SLASH exp 				{ S.DIV ($1, $3) }
	| 	MINUS exp %prec unary_minus	{ S.MINUS ($2) }	
	|	exp EQUALEQUAL exp			{ S.EQ ($1, $3) }
	|	exp LT exp					{ S.LT ($1, $3) }
	| 	exp LE exp 					{ S.LE ($1, $3) }
	|	exp GT exp 					{ S.GT ($1, $3) }
	|	exp GE exp 					{ S.GE ($1, $3) }
	|	NOT exp						{ S.NOT ($2) }
	| 	exp OR exp					{ S.OR ($1, $3)}
	|	exp AND exp					{ S.AND ($1, $3)}
	|	LPAREN exp RPAREN			{ $2 }
	;
=======
   | decls decl  { $1@[$2]  }
   |  { [] }
    ;

decl:
   | typ ID SEMICOLON { ($1,$2) }
    ;

typ:
   | INT LBLOCK NUM RBLOCK { S.TARR ($3) }
   | INT   { S.TINT }
    ;

stmts:
   | stmts stmt { $1@[$2]  }
   |  { [] }
    ;

stmt:
  | lv EQUAL exp SEMICOLON { S.ASSIGN ($1,$3) }
  | lv PLUS PLUS SEMICOLON { S.ASSIGN ($1,S.ADD(S.LV $1, S.NUM 1)) }
  | IF LPAREN exp RPAREN stmt ELSE stmt { S.IF ($3,$5,$7) }
  | IF LPAREN exp RPAREN stmt { S.IF ($3,$5,S.BLOCK ([],[])) }
  | WHILE LPAREN exp RPAREN stmt { S.WHILE ($3,$5) }
  | DO stmt WHILE LPAREN exp RPAREN SEMICOLON { S.DOWHILE ($2,$5) }
  | READ LPAREN ID RPAREN SEMICOLON { S.READ $3 }
  | PRINT LPAREN exp RPAREN SEMICOLON { S.PRINT $3 }
  | block { S.BLOCK $1 }
  ;

lv:
  | ID { S.ID $1 }
  | ID LBLOCK exp RBLOCK { S.ARR ($1, $3) }
  ;

exp:
  | exp PLUS exp  { S.ADD ($1,$3) }
  | exp MINUS exp { S.SUB ($1,$3) }
  | exp STAR exp  { S.MUL ($1,$3) }
  | exp SLASH exp { S.DIV ($1,$3) }
  | MINUS exp { S.MINUS $2 }
  | lv { S.LV $1 }
  | NUM { S.NUM $1 }
  | NOT exp { S.NOT $2 }
  | exp EQUALEQUAL exp { S.EQ ($1,$3) }
  | exp LT exp { S.LT ($1,$3) } 
  | exp LE exp { S.LE ($1,$3) } 
  | exp GT exp { S.GT ($1,$3) } 
  | exp GE exp { S.GE ($1,$3) } 
  | exp OR exp { S.OR ($1,$3) }
  | exp AND exp { S.AND ($1,$3) }
  | LPAREN exp RPAREN { $2 }
%%

let parse_error s = print_endline s
>>>>>>> 77e96d5ec238c61a9ffa7648fdf95d4114072be2
