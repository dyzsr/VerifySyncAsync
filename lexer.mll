{
open Lexing
open Parser

exception SyntaxError of string

let next_line lexbuf =
  let pos = lexbuf.lex_curr_p in
  lexbuf.lex_curr_p <-
    { pos with pos_bol = lexbuf.lex_curr_pos;
               pos_lnum = pos.pos_lnum + 1
    }
}

(* part 1 *)
let int =  '-'? ['0'-'9'] ['0'-'9']*

(* part 2 *)
let digit = ['0'-'9']
let frac = '.' digit*
let exp = ['e' 'E'] ['-' '+']? digit+
let float = digit* frac? exp?

(* part 3 *)
let white = [' ' '\t']+
let newline = '\n' | '\r' | "\r\n" 
let id = ['a'-'z' 'A'-'Z'] ['a'-'z' 'A'-'Z' '0'-'9' '_']*


rule token = parse
| white    { token lexbuf }
| newline  { next_line lexbuf; token lexbuf }
| "halt" { NOTHING }
| "yield" {PAUSE}  
| "loop" {LOOP}
| "signal" {SIGNAL}
| "emit" {EMIT}
| "await" {AWAIT}
| "async" {ASYNC}
| "assert" {ASSERT}
| "when" {WHEN}
| "if" {PRESENT}
| "run" {RUN}
| "trap" {TRAP}
| "exit" {EXIT}
| "emp" { EMPTY }
| "require" {REQUIRE}
| "ensure" {ENSURE}
| "module" {MODULE}
| "hiphop" {HIPHOP}
| "inout" {INOUT}
| "out" {OUT}
| "end" {END}
| "in" {IN}
| "then" {THEN}
| "else" {ELSE}
| "TRUE" { TRUE }
| "FALSE" { FALSE }
| "true" { TRUEE (bool_of_string (Lexing.lexeme lexbuf))}
| "false" { FALSEE (bool_of_string (Lexing.lexeme lexbuf))}
| "count" { COUNT }
| ">=" {GTEQ}
| "<=" {LTEQ}
| '>' {GT}
| '<' {LT}
| '=' {EQ}
| "/\\" {CONJ}

| ">=" {GTEQ}
| "<=" {LTEQ}

| '(' { LPAR }
| ')' { RPAR }
| '{' { LBRACK  }
| '}' { RBRACK }
| ';' { SIMI }
| int      { INTE (int_of_string (Lexing.lexeme lexbuf)) }
| '.' { CONCAT }
| "||" { PAR }
| 'X' {NEXT}
| 'U' {UNTIL}
| id as str { VAR str }
| "|-" {ENTIL}
| "\\/" {DISJ}
| '+' { PLUS }
| '-' { MINUS }
| '~' {NEGATION}
| '[' { LBrackets }
| ']' { RBrackets }
| '#' { SHARP }
| ',' { COMMA }

| '^' { POWER }
| '*' {KLEENE}

| "<>" {FUTURE}  

| "->" {IMPLY}
| '!' {LTLNOT}
| '?' {QUESTION}
| ':' { COLON }
| "&&" {LILAND}
| "||" {LILOR}

| "/*@" {LSPEC}
| "@*/" {RSPEC}
| eof { EOF }

(*


| 'w' {OMEGA}
| "if" {IF}
| "else" {ELSE}
| "abort" {ABORT} 

| "[]" {GLOBAL}
| "include" {INCLUDE}
| '"'      { read_string (Buffer.create 17) lexbuf }


| '|' { CHOICE }

| '"' { read_string (Buffer.create 17) lexbuf }

| '[' { LBrackets }
| ']' { RBrackets }
| '{' { LBRACK  }
| '}' { RBRACK }










*)
| _ { raise (SyntaxError ("Unexpected char: " ^ Lexing.lexeme lexbuf)) }


(* part 5 
and read_string buf =
  parse
  | '"'       { STRING (Buffer.contents buf) }
  | '\\' '/'  { Buffer.add_char buf '/'; read_string buf lexbuf }
  | '\\' '\\' { Buffer.add_char buf '\\'; read_string buf lexbuf }
  | '\\' 'b'  { Buffer.add_char buf '\b'; read_string buf lexbuf }
  | '\\' 'f'  { Buffer.add_char buf '\012'; read_string buf lexbuf }
  | '\\' 'n'  { Buffer.add_char buf '\n'; read_string buf lexbuf }
  | '\\' 'r'  { Buffer.add_char buf '\r'; read_string buf lexbuf }
  | '\\' 't'  { Buffer.add_char buf '\t'; read_string buf lexbuf }
  | [^ '"' '\\']+
    { Buffer.add_string buf (Lexing.lexeme lexbuf);
      read_string buf lexbuf
    }
  | _ { raise (SyntaxError ("Illegal string character: " ^ Lexing.lexeme lexbuf)) }
  | eof { raise (SyntaxError ("String is not terminated")) }

  *)
