grammar Simple;

prog : classDef+ ; //类定义

classDef
    : 'class' ID '{' member+ '}'             //一个类具有若干个成员
     {System.out.println("class " + $ID.text);}
    ;

member
    : 'int' ID ';'                                  //字段定义
     {System.out.println("var " + $ID.text);}
    | 'int' f=ID '(' ID ')' '{' stat '}'            //方法定义
     {System.out.println("method=: " +$f.text);}
    ;

stat
    : expr ';'
     {System.out.println("found expr: " + $ctx.getText());}
    | ID '=' expr ';'
     {System.out.println("found assign: " + $ctx.getText());}
    ;

expr
    : INT
    | ID '(' INT ')'
    ;

INT : [0-9]+ ;

ID : [a-zA-Z]+ ;

WS : [ \r\n\t]+ -> skip;