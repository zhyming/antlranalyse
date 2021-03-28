//公共词法规则， 以lexer grammar开头
lexer grammar CommonLexerRules;
//匹配整数
INT : '0' | [1-9][0-9]*;
//匹配标识符
ID : [a-zA-Z];
//换行
NEWLINE : '\r'? '\n';
//丢弃空白
WS : [ \t]+ -> skip;