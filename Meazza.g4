grammar Meazza;

CONST : 'const';

UNSIGNED : 'unsigned' ;

CLASS : 'class';

INT_POST : 'LL' | 'UL' ;

ID : ID_head ID_tail*;

INT_DATA : [0-9]+ ;

LBRACE : '(';

RBRACE : ')';

LBLOCK : '[' ;

RBLOCK : ']' ;

FLOAT_DATA : INT_DATA'.'INT_DATA ('E'INT_DATA)?;

CHAR_DATA : [\'] (CCHAR | Translate) [\'];

STRING_DATA: [\"] ( SCHAR | Translate)* [\"];


Translate : [\\][/\\\'\"\?nr];

fragment
CCHAR : ~['\\\r\n];

fragment
SCHAR : ~["\\\r\n];

LINE_COMMENT : '//' ~[\r\n]* -> channel(HIDDEN);

BLOCK_COMMENT : '/*' .*? '*/' -> channel(HIDDEN);

fragment
ID_head: [_a-zA-Z];

fragment
ID_tail: [_a-zA-Z0-9];

WS : [ \n\t\r]+ -> skip;

r : prog;

prog : ( var_declaration | func_declaration | class_declaration | comment)+;

comment : LINE_COMMENT | BLOCK_COMMENT;

var_declaration : type ID  ('=' expression)? ';';

raw_declaration : type ID ';';

type : type_name array* ;

array : '['']';

type_name : ID;

const_expression : INT_DATA (INT_POST)?
                 | FLOAT_DATA
                 | nullData = 'null'
                 | boolData = 'true'
                 | boolData = 'false'
                 | CHAR_DATA
                 | STRING_DATA
                 ;

func_declaration: type ID'('parameters?')' compound_statement;

parameters : parameter (',' parameter)* ;

parameter : type ID;

compound_statement : '{' (statement | var_declaration)* '}';

statement : compound_statement
          | var_declaration
          | if_statement
          | for_statement
          | while_statement
          | jump_statement
          | normal_statement;

if_statement : 'if''(' expression ')' statement ('else'statement)? ;

for_statement : 'for'  '('exp1 = expression? ';' exp2 = expression? ';' exp3 = expression? ')' statement ;

while_statement : 'while' '('expression')' statement;

jump_statement : (op = 'break' | op = 'continue' | op = 'return' expression?) ';';

normal_statement : expression? ';' ;

expression : const_expression
           | ID
           | <assoc = left> ID fop = '(' (expression(',' expression)*)? fop = ')'
           | <assoc = left> uop = 'new' (type_name) ('[' expression ']')* array*
           | <assoc = left> expression op = '.' expression
           | <assoc = left> expression (op = '[' expression']')+
           | <assoc = left> oop = '(' expression ')'
           | <assoc = right> uop = ('-' | '~' | '!') expression
           | <assoc = right> expression uop = ('++' | '--')
           | <assoc = right> uop = ('++' | '--') expression
           | <assoc = left> expression op =('*' | '/' | '%') expression
           | <assoc = left> expression op = ('+' | '-') expression
           | <assoc = left> expression op = ('<<' | '>>') expression
           | <assoc = left> expression op = ('>' | '<' | '>=' | '<=') expression
           | <assoc = left> expression op = ('==' | '!=') expression
           | <assoc = left> expression op = '&' expression
           | <assoc = left> expression op = '^' expression
           | <assoc = left> expression op = '|' expression
           | <assoc = right> expression op = '&&' expression
           | <assoc = right> expression op = '||' expression
           | <assoc = right> expression op = '=' expression
           ;

class_declaration:  'class' ID '{' raw_declaration* '}' ;
