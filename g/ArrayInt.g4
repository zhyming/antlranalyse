grammar ArrayInt;

init
    : '{' value (',' value)* '}'
    | '{' '}'
    ;

value
    : init
    | INT
    ;

INT : '0' | [1-9][0-9]*;

WS : [ \t\r\n]+ -> skip;