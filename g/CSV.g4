grammar CSV;

file : header row+;

header : row;

row : filed (',' filed)* '\r'? '\n';

filed
    : TEXT      #text
    | STRING    #string
    |           #empty
    ;
//除开，" \r \n的符号
TEXT : ~[ ,\r\n"]+;

STRING : '"' ('""'|~'"')* '"';

WS : [ \t]+ -> skip;