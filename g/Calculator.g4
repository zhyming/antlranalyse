grammar Calculator;

cal : exp;

exp
    : exp MUL exp       #Mul
    | exp DIV exp       #DIV
    | exp ADD exp       #Add
    | exp SUB exp       #Sub
    | INT               #Int
    ;

MUL : '*';
DIV : '/';
ADD : '+';
SUB : '-';

INT : '0' | [1-9][0-9]*;
NEWLINE : '\r'?'\n';

WS : [ \t\r\n]+ -> skip;