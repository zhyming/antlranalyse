grammar JSON;
//https://www.json.org/json-zh.html
//json文件可以是对象或者数组
json
    : object
    | array
    ;
//对象由花括号包围的键值对pair组成，多个键值对以逗号分开
//也可以是一个空的花括号
object
    : '{' pair (',' pair)* '}'      #AnObject
    | '{' '}'                       #EmptyObject
    ;
//键值对以string为键值
pair : STRING ':' value;

//数组有中括号包围，里面的值以逗号分隔
//或者空的中括号
array
    : '[' value (',' value)* ']'        #ArrayOfValues
    | '[' ']'                           #EmptyArray
    ;
//一个值可以是以双引号包围的字符串、数字、true、false、null、一个对象、一个数组
value
    : STRING        #String
    | NUMBER        #Atom
    | 'true'        #Atom                   //关键字
    | 'false'       #Atom
    | 'null'        #Atom
    | object        #ObjectValue            //尾递归调用
    | array         #ArrayValue             //尾递归调用
    ;

STRING : '"' (ESC | ~["\\])* '"';
fragment ESC : '\\' (["\\/bfnrt] | UNICODE);
fragment UNICODE : 'u' HEX HEX HEX HEX;
fragment HEX : [0-9a-fA-F];

NUMBER
    : '-'? INT '.' [0-9]+ EXP?               //1.35 1.35E-9  0.3 4.5
    | '-'? INT EXP                           //2E45 -3E2
    | '-'? INT                               //223 -111
    ;

fragment INT : '0' | [1-9] [0-9]*;
//在中括号中 - 表达的意思是范围，所以需要加斜杠进行转义来表达字面意思
fragment EXP : [Ee] [+\-]? INT;            //\-是对 - 的转义，因为在中括号【】中，- 标识范围

//忽略空格
WS : [ \t\r\n]+ -> skip;
