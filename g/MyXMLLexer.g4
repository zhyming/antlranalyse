lexer grammar MyXMLLexer;
//默认模式 -- 标签外
OPEN        : '<'               -> pushMode(INSIDE);
COMMENT     : '<!--' .*? '-->'  -> skip;
EntityRef   : '&' [a-z]+ ';';
TEXT        : ~('<'|'&')+;      //匹配除< & 以外字符

// --------- 标签内 ---------------
mode INSIDE;
CLOSE       : '>'               -> popMode; //回到默认模式
SLASH_CLOSE : '/>'              -> popMode;
EQUALS      : '=';
STRING      : '"' .*? '"';
SlashName   : '/' NAME;
NAME        : ALPHA (ALPHA|DIGIT)*;
S           : [ \t\r\n]         -> skip;

fragment
ALPHA       : [a-zA-A];

fragment
DIGIT       : [0-9];