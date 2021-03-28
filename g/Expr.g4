grammar Expr;
import CommonLexerRules;
/**起点*/
prog : stat+;

stat
    : expr NEWLINE                  #printExpr
    | ID '=' expr NEWLINE           #assign
    | NEWLINE                       #blank
    | 'clear' NEWLINE               #clear
    ;
expr
    : expr op=('*'|'/') expr        #MulDiv
    | expr op=('+'|'-') expr        #AddSub
    | INT                           #int
    | ID                            #id
    | '(' expr ')'                  #parens
    ;

MUL : '*';
DIV : '/';
ADD : '+';
SUB : '-';