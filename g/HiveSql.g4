grammar HiveSql;
options{
	backtrack = true;   
	memoize = true;
	output=AST;
}
tokens{
	ROOT;
	INSERTLIST;
	INSERT;
	TARGETTABLE;
	SOURCETABLE;
	COLUMN;
	SELECT;
	SELECTLIST;
	FROM;
	WHERE;
	UNION;
	ALIAS;
	TABLEALIAS;
	COLUMNS;
	UnionAll;
	TABLENAME;
	SRCTABLE;
	
	WithQuery;
	PROJ;
	COLNAME;
	COLUMNALIAS;
	GROUP;
	ORDER;
	JOIN;
	LEFT;
	RIGHT;
	OUTER;
	INNER;
	SUBQUERY;
	SUBSELECT;
	SUBQUERYALIAS;
	JOINTYPE;
	JOINON;
	OUTER;
	OUTERTYPE;
	EXPR;
	OPERAND;
	ASTERISK;
	/* create */
	CREATE;
	TableProperties;
	Physical;
	ColumnDefConstraint;
	ColumnConstraint;
	DataType;
	TypeName;
	TypeParam;
	QUERYNAME;
	
	RENAME;
	OLDNAME;
	NEWNAME;
	DROP;
	
	Values;
	UPDATE;
	SETCLAUSE;
	UPDATESET;

	ALTER;
	INSERTALL;
	INTO;
	/* merge */
	MERGE;
	MERGEINSERT;
	MERGEUPDATE;
	MATCHED;
	NOTMATCHED;
	TABLEREFEREN;
	SETEXPR;
	/* expr */
	INExpr;
	IN;
	PAREN;
	NotNull;
	IsNull;
	INSERTVALUES;
	/* function */
	Function;
	FunctionName;
	FUNPARAM;
	
	/*constant*/
	String;
	Number;
	Integer;
	DBLINK;
	Partition;
	DELETE;
	LABEL;
	TIME;
}
@header {
	package com.carnation.sqlparser.ast;	
}
@lexer::header {  
	package com.carnation.sqlparser.ast;	
}
@members {
	protected void mismatch(IntStream input, int ttype, BitSet follow)throws RecognitionException{	
		throw new MismatchedTokenException(ttype, input);
	}
	public Object recoverFromMismatchedSet(IntStream input,RecognitionException e,BitSet follow)throws RecognitionException{
		throw e;
	}
}

@rulecatch {
	catch (RecognitionException ex) {
		throw ex;
	}
}
parse
	:	createTable
	->	^(CREATE createTable)
	|	createView
	->	^(CREATE createView)
	|	dropTable
	->	^(DROP dropTable)
	|	insertTableList
	->	^(INSERTLIST insertTableList )
	|	insertTable
	->	^(INSERT insertTable )
	|	select
	->  ^(SELECT select)
	;
/**
insertTableList
*/
insertTableList
	:	FROM a += table_references (',' a += table_references)*
		(insertList)*
	->	(insertList)* ^(FROM $a*)
	;
/**
insertTable
*/
insertTable
	:	subquery_factoring_clause? insertTables
	;
insertTables
	:	w = subquery_factoring_clause? INSERT (INTO)?(OVERWRITE)? (tableKey)?  tvm
		t_alias? ('(' b += col_name   (',' b+=col_name )* ')')? (PARTITION'('partitionId ')')*
 		(selects)?
 	->	^(TARGETTABLE ^(TABLE  tvm ^(TABLEALIAS t_alias)?)  ^(COLUMNS $b* )?) 
 			^(SELECT selects)? 	
		;		
insertList	
	:	subquery_factoring_clause? INSERT (INTO)?(OVERWRITE)? (tableKey)? tvm
		t_alias? ('(' b += col_name   (',' b+=col_name )* ')')? 
 		(SELECT distincts? select_list (
		where_clause ? 
		group_by_clause?
		(CLUSTER BY conditionExpr  | (DISTRIBUTE BY conditionExpr)? (SORT BY conditionExpr)?)?
		(LIMIT INTEGERS)?)?
	->	^(INSERT^(TARGETTABLE ^(TABLE  tvm ^(TABLEALIAS t_alias)?)  ^(COLUMNS $b* )?) 
 			^(SELECT ^(SUBQUERY ^(SELECTLIST distincts? select_list) 
				 ^(WHERE where_clause ^(EXPR EXPR[$where_clause.text]))? 
				 ^(GROUP group_by_clause ^(EXPR EXPR[$group_by_clause.text]))?	
		))?))
		;	
tableKey	:	TABLE;
selects
	:	select | '('!select')'!
	;
tvm	:	((id '.')?(a = id  '.'))? (b = id ) ('(' id ( ',' id )* ')')?
		((PARTITION'('partitionId (',' partitionId)*')')*(noexists)?)?	
	->	^(TABLENAME $b $a?)
		(partitionId)*
	;
partitionId
	:	col_name(('='| '= '  ) c=col_value)? (',' col_name(('='| '= '  ) d=col_value) )*
	->      ^(PARTITION   $c? $d*)
	|	a += col_name (',' a+= col_name  )*
	->      ^(PARTITION   $a+)
	// (','col_name('='col_value)?)* 	
	;
//partitionId
//	:       col_name('=' (c=col_value))?(','col_name('=' (d=col_value))?)*
//	->      ^(PARTITION $c? $d*)	
//	;
	
dropTable
	:	DROP TABLE (exists)? tableName 
	->	^(TARGETTABLE   tableName)
	;
/**
	createView
**/
createView
	:	CREATE VIEW (noexists)? view_name 
		('('a+= columnDef(',' a+=columnDef)* ')')?
		(COMMENT view_comment)?
		(TBLPROPERTIES (properties))?
		AS (b = select| '('b = select')')
	->	^(TARGETTABLE ^(TABLE  view_name ^(COMMENT view_comment)?)^(COLUMNS $a+ )?) 
		^(SELECT $b)
	;
view_name
	:	(a = id  '.')? (b = id )
	->	^(TABLENAME $b $a?)
	;
view_comment
	:	TEXT
	;
	/**
	createTable*
	*/
createTable
	:	CREATE (TEMPORARY)? (EXTERNAL)? TABLE (noexists)? tableName
		('('a+= columnDef(',' a+=columnDef)* ')')?
  		(COMMENT table_comment)?
  		(PARTITIONED BY '('columnDef(','columnDef)* ')')?
  		(CLUSTERED BY '('col_names')' (SORTED BY '('col_names')')? INTO num_buckets BUCKETS)?
  		(SKEWED BY '('col_names')' ON '('(col_values)?')'(STORED AS DIRECTORIES)?)?
  		(
   		(ROW FORMAT row_format)? (STORED AS file_format)?
  		)?
  		(LIKE tableName)?
  		(LOCATION hdfs_path)?
  		(TBLPROPERTIES properties)?
  		(AS (b = select| '('b = select')'))?
  	->	^(TARGETTABLE ^(TABLE tableName ^(COMMENT table_comment)? ^(TEMPORARY)?)^(COLUMNS $a+)?)
  		//^(SOURCETABLE ^(TABLE tableName))?
  		^(SELECT $b)?	
  	;
  	/**
	select*
	*/
select	:	 subquery_factoring_clause? subquery
	;
subquery_factoring_clause
	:	WITH a+=withSubquery (',' a+=withSubquery)*
	->	^(WITH $a+ )
	;
withSubquery
	:	query_name AS '(' subquery ')'
	->	^(WithQuery ^(QUERYNAME query_name) subquery)
	;
query_name 
	:	tvm
	;			
setSelect
	:	(UNION ALL )
	->	^(UnionAll)
	|	UNION
	->	^(UNION)
	;
subquery
	:	subquerys (setSelect^ ((b +=  subquerys  ) |
		 ( '('! b += subquerys ')'! )))*
	|	'('subquerys')' (setSelect^ ((b +=  subquerys  ) |
		 ( '('! b += subquerys ')'! )))*
	|        WITH query_name AS '(' subquery ')' (',' WITH query_name AS '(' subquery ')')*  subquery
	;
subquerys
	:	subqueryss
	|	'('! subqueryss ')'!
	;
subqueryss
	:	SELECT STRAIGHT_JOIN? distincts? select_list 
		(FROM a += table_references (',' a += table_references)*)?
		where_clause ? 
		group_by_clause? exprGrouping?INTEGERS?
		(CLUSTER BY conditionExpr | (DISTRIBUTE BY conditionExpr)? (SORT BY conditionExpr)?)?
		windowOrder?
		(LIMIT INTEGERS)?
	->	^(SUBQUERY^(SELECTLIST distincts? select_list) ^(FROM $a*)?
			^(WHERE where_clause ^(EXPR EXPR[$where_clause.text]))? 
			^(GROUP group_by_clause ^(EXPR EXPR[$group_by_clause.text]))?	
		)
 	;
group_by_clause
	:	GROUP BY   a +=exprGrouping (',' a+=exprGrouping)* 
		(HAVING conditionExpr)?
	->	^(GROUP $a+ ^(HAVING conditionExpr)?)
	;
exprGrouping
	:	expr | grouping | simpleGrouping
	;
grouping
	:	GROUPING SETS '('a+= simpleGrouping (',' a+= simpleGrouping)*  ')'// e+=expr(','e+=expr)*
	->	^(GROUPING $a+)
	;
simpleGrouping
	:	groupExpr	
	|	(CUBE |  ROLLUP ) groupExpr(',' groupExpr)*
	|	'('	 ')'
	;
groupExpr
	:	'(' expr (','expr)*')'
	|	expr
	;
where_clause
	:	WHERE   conditionExpr
	;
expr
	:	conditionExpr
	;
conditionExpr
	:	conditionOr
	;
conditionOr 
	:	conditionAnd (OR^ conditionAnd)*
	;
conditionAnd
	:	conditonRelation (AND^ conditonRelation)*
	;
conditonRelation
	:	conditionNull conditonRelations^?
	;	
conditonRelations
	:	NOT? LIKE likeExpr =  conditionNull (ESCAPE escapeExpr = conditionNull)?
	->	^(LIKE NOT? $likeExpr  ^(ESCAPE  $escapeExpr)?)
	|	NOT? RLIKE likeExpr =  conditionNull (ESCAPE escapeExpr = conditionNull)?
	->	^(RLIKE NOT? $likeExpr  ^(ESCAPE  $escapeExpr)?)
	|	NOT? IN  ( '('('-')? inexpr+= exprAtom (','?'||'? ('-')?inexpr+=exprAtom)* ')')
	->	^(INExpr NOT? ^(IN $inexpr+))
	|	NOT? BETWEEN  e1= conditionNull AND e2=conditionNull
	->	^(BETWEEN NOT? ^(AND $e1 $e2))
	|  	NOT? REGEXP e1= conditionNull
	-> 	^(REGEXP NOT? $e1)
	;
conditionNull
	:	conditionCompare conditionNulls^?//(keyWordIs keyWordNot? keyWordNull)?
	;
conditionNulls
	:	IS NOT NULL
	->	^(NotNull)
	|	IS NULL 
	->	^(IsNull)
	;
conditionCompare
	:	arithmeticExpr (('='^ | '=='^ | '= '^ | '!='^ | '!= '^ | '<'^ | '< '^ | '>'^ | '> '^ | '<='^ | '<= '^ | '<>'^ | '<> '^ | '>='^ | '>= '^ | '! ='^ | '< ='^| '> ='^) arithmeticExpr)*
	;
arithmeticExpr
	:	arithmeticMultDivMod (('+'^ | '-'^ | '||'^) arithmeticMultDivMod)* 
	;
arithmeticMultDivMod
	:	arithmeticPlusMinus (('*' | '/' | '&' | '%' )^ arithmeticPlusMinus)* 
	;
arithmeticPlusMinus
	:	'+'^ arithmeticPlusMinus
	|	'-'^ arithmeticPlusMinus
	|	caseExpr
	|	PRIOR? exprAtom	
	|	exprAtom (START  ( TO END  )?)
	|	exprAtom ('@' ( LOCAL | (time_zone) exprAtom))?
	|	NOT^ exprAtom
	;
caseExpr
	:	CASE  (caseExprs = expr)? whenExpr+ (ELSE elseExpr=expr)? END
	->	^(CASE  $caseExprs? whenExpr+ ^(ELSE $elseExpr )?)
	;
whenExpr
	:	('(')? WHEN e1 = expr (')')? THEN e2=expr
	->	^(WHEN $e1 $e2)
	;
exprAtom
	:	literal	literal* 
	|	( 
		(subquery | '('!  subquery ')'! )
		)
	|	functionExpr
	|	dateExpr
	|	col_name
	|	colons
	|	EXISTS '('subquery ')'
	->	^(EXISTS subquery)
	|	'(' e+= expr(','e+= expr)* ')'
	->	^(PAREN $e+)
	|	caseExpr
	|	ifExpr
	|	NULL
	;
literal 
	:	numberic dateTime? //danwei
	|	character
	|	interval_date
	;
numberic
	:	numbers
	->	^(Number numbers)
	|	INTEGERS
	->	^(Integer INTEGERS)
	;
numbers	:	FLOATS
	|	INTEGER 	dot 	INTEGER ( 'e'  INTEGER)?
	;
character
	:	TEXT
	;
interval_date
	:	INTERVAL (('('?INTEGERS')'? | TEXT ) ('-' INTEGERS)? time_expr?)?
		(((YEAR | MONTH | DAY | MINUTE | HOUR) ('(' numberic ')')?)
	|	SECOND ('(' numberic (',' numberic)? ')')?)
		(TO (YEAR | MONTH  | DAY | HOUR | MINUTE | (SECOND ('(' numberic ')')?)))? 
	;
time_expr
	:	'(' INTEGERS (':' INTEGERS)* ':'? ('.' INTEGERS)? ')'
	;
dateExpr
	:	DATETIME
	|	DATE character
	|	TIMESTAMP character
	;
colons
	:	VARCOLON
	;
functionExpr 
	:	f=function ('()' | '(' p=parameter ')') ('[' parameter ']')?  ( dateTime)? (((FOR ( BUD|SUBJECT_NAME) IN )) ('()'| ('('rows_between?select_list?')')))?
	->	^(Function ^(FunctionName $f) $p?)
	;
rows_between
	:	ROWS BETWEEN id* AND id*;
function 
	:      specialfunction
	|      (id ('.' id ('.' id)?)?) 
	|	LEFT | RIGHT
	|	DENSE_RANK
	;

specialfunction
	:  ROW_NUMBER_OVER
	|  DENSE_RANK_OVER
	|  (AVG | MAX | SUM | MIN | COUNT | LEAD | LAG | FIRST_VALUE ) (LEFTKH parameter RIGHTKH OVER)?
	|  RANK_OVER
	;

//	 : KEEP '(' DENSE_RANK (LAST|FIRST) ORDER BY sort ( ','sort )* ')'
//	 ;
sort  : expr (ASC|DESC)? (NULLS (FIRST| LAST))?
 	;

parameter
	:	a ='*' 
	->	^(ASTERISK $a )
	|	distincts? p+= parameterAtom (USING expr)? (',' p+=parameterAtom (USING expr)?)* 
	->	^(FUNPARAM distincts? $p+)
	|	q=id AS data_type  //cast(b.inure_time as  date) | cast(b.expire_start as  number(8,4))|......
	->	^(FUNPARAM ^(COLNAME $q))
	|       analyticClause?windowOrder?windowSort?
	|       function
	|       caseExpr
	;
parameterAtom
	:	expr (AS (data_type|expr))?
	|	(dateTime FROM dateTime expr?)?
	;
dateTime
	:	numericDataType
	|	SYSDATE
	|	YEAR |DAY | MONTH|HOUR|MINUTE|SECOND| DATE
	;
numericDataType
	:	INTEGER | INT |SMALLINT
	|	(( DECIMAL| NUMBER ) ( '(' INTEGERS (',' INTEGERS)*')')?)
	;
analyticClause
	:	(PARTITION BY expr(',' expr)*)
	|	(DISTRIBUTE BY expr(',' expr)*)
	;
windowOrder
	:	ORDER BY orderOption (',' orderOption)*
	;
orderOption
	:	expr (ASC|DESC)?NULLS?(FIRST|LAST)?
	|	ORDER OF exprAtom
	;
windowSort
	:	SORT BY sortOption (',' sortOption)*
	;
sortOption: 	expr (ASC|DESC)?
	;
time_zone
	:	TIME ZONE
	;
table_references
	:	NATURE? table_reference	
		((join_type^  (table_references) joinOnExpr)*
		| (join_type^ )table_reference)*
	|	joinTable
	|	tableFunction
	;
tableFunction
	:	TABLE '(' expr')'
	;
joinTable
	:	table_reference (t_alias? NATURE? join_type^?   table_references
		 (((onExpr) | (USING '(' col_name (',' col_name)* ')')))*
		 	)*
	;
onExpr	:	ON conditionExpr
	->	^(ON conditionExpr ^(EXPR EXPR[$conditionExpr.text]))
	;
joinOnExpr
	:	joinOnExprs
	->	^(JOINON joinOnExprs ^(EXPR EXPR[$joinOnExprs.text]))
	;
joinOnExprs
	:	ON conditionExpr | USING '(' col_name (',' col_name)* ')'
	;
join_type
	:	join_types?	JOIN
	->	^(JOIN ^(JOINTYPE join_types? ) )
	;
join_types
	:	INNER^ 
	|	CROSS^
	|	(outerType  SEMI? OUTER?)
	->	^(OUTERTYPE outerType  ^(OUTER OUTER)?)
	;
outerType
	:	LEFT^
	| 	RIGHT^ 
	| 	FULL^
	;
table_reference
	:	ONLY? tableName ((DISTRIBUTE BY)|(windowOrder))?(AS? t_alias)? literalClause*
	->	^(SRCTABLE  tableName ^(TABLEALIAS t_alias)? ^( LATERAL literalClause )? )
	|	'(' a = subquery ')' (AS? t_alias)? (literalClause*)?
	->	^(SUBSELECT  subquery  ^(SUBQUERYALIAS t_alias)? ^( LATERAL literalClause )? ^(EXPR EXPR[$a.text]))
	|	'('! joinTable ')'!
	|	tableFunction t_alias?
	->	^(SRCTABLE ^(TABLENAME EXPR[$tableFunction.text]) ^(TABLEALIAS t_alias)?)
	;
literalClause
	:	LATERAL VIEW  ( EXPLODE | JSON_TUPLE )  '(' select_list ')'  col_name AS c += c_alias (',' c +=c_alias)*
	->	^(COLUMNS select_list ) ^(ALIAS $c+)  
 	;	
 distincts
 	:	ALL^ | DISTINCT^
 	;
 select_list
 	:	select_list_atom (',' !select_list_atom )*
 	|	e = atomArterisk
	->	^(COLUMN ^(ASTERISK $e) ^(EXPR EXPR[$e.text]))
	
	;
select_list_atom
	:	a =  atomArterisk 
	->	^(COLUMN ^(ASTERISK $a )^(EXPR EXPR[$atomArterisk.text]))
	|	( expr ( AS? c_alias?  )?)
	->	^(COLUMN  expr   ^(COLUMNALIAS c_alias)? ^(EXPR EXPR[$expr.text]))
	;
atomArterisk
	:	tableName '.' '*' ('['INTEGERS']')?
	|	'*'
	;	
c_alias :	id | AS
	;
t_alias	:	id
	;
hdfs_path
 	:	 TEXT	
 	;
 file_format
 	 : SEQUENCEFILE
 	 | TEXTFILE
 	 | RCFILE
 	 | ORC
 	 | PARQUET
 	 | INPUTFORMAT input_format_classname OUTPUTFORMAT output_format_classname
 	 ;
input_format_classname
	:	id
	;
output_format_classname
	:	id
	;		
 row_format
  	: DELIMITED (FIELDS TERMINATED BY TEXT (ESCAPED BY TEXT)?)? (COLLECTION ITEMS TERMINATED BY TEXT)?
        (MAP KEYS TERMINATED BY TEXT)? (LINES TERMINATED BY TEXT)?
  	| SERDE serde_name (WITH SERDEPROPERTIES '('(properties)')')?
 	;
serde_name
	:	id
	;
col_names
	:	col_name(','col_name)*
	|	col_name(ASC|DESC)(','col_name(ASC|DESC))*
	;
col_values
	:	col_value(','col_value)*
	|	'('col_name','col_value')'(',''('col_name','col_value')')*
	;
col_value
	:	id | TEXT
	;			
num_buckets 
	:	INTEGERS;	
id	:	INTEGERS
	|	('e'|'E'|'e1'|'E1'|'e2'|'E2'|'e3'|'E3' | 'e4'|'E4' |'e5'| 'E5' |'e6' | 'E6')
	|	UNQUOTED_ID
	|	DECLAREVAR
	|	a=QUOTED_ID{
			String str = $a.text.replaceAll("\"","");
			$a.setText(str);
		}
	|	reserveWord
	;
col_comment 
	:	TEXT
	;
table_comment 
	:	TEXT
	;	
columnDef
	:	col_name (data_type)? (COMMENT col_comment)?
		->^(COLUMN col_name ^(DATATYPE data_type)?^(COMMENT col_comment)?)
	;
col_name
	:	 id '.'  COUNT
	|       ((c = id '.')? a = id '.' )? b = id ('(' d='+'		 ')')? ('['INTEGERS']')?
	->	^(COLNAME $b $c? $a? ^(JOIN $d)?)
	;
properties
	:property_name'='property_value(','property_name'='property_value)*
	;
property_name
	:	id
	;
property_value
	:	id
	;	
tableName
	:	(a = id  '.')? (b = id )
	->	^(TABLENAME $b $a?)
	; 
reserveWord
	: 	TINYINT | SMALLINT | INT | BOOLEAN | FLOAT | DOUBLE | STRING | BINARY | LINES
	|	ROW | DESC | ASC| BIGINT | TIMESTAMP | DECIMAL | UNIONTYPE | SORT | UPDATED
	|	LIKE | VIEW | DATE | VARCHAR | NULL | NO | ROWID | YEAR | MONTH | DAY | HOUR | TIME
	|	VALUE | LIMIT | LOCATION | TYPE | DEGREE | NUMBER | SYSDATE | DEMAND | RULES | KEY|UPDATE
	| 	READ|DELETE|DIMENSION|ENABLE|DATATYPE|MINUTE|INDEX|MAP |EXPLODE
	|	FORMAT | STORE | BUILD | PRECEDING | UNBOUNDED | FOLLOWING | REPLACE
	| 	DISTRIBUTE | MODEL | SETS | ORDER | ALL | COLNAME | TABLENAME | COMMENT | BUD | SUBJECT_NAME | FROM_UNIXTIME | OVER | NOW | CURRENT_TIMESTAMP | UNIX_TIMESTAMP | SECOND
		;
data_type
  	:	typeName ('('a+= typeParam (','a+= typeParam)* ')')? (WITH LOCAL? TIME ZONE )?
	->	^(TypeName typeName ^(TypeParam $a+)?)?
	|	interval_date
	|	AS expr
	;
typeParam
	:	INTEGERS 
	;
typeName	
 	 : TINYINT
  	 | SMALLINT
	 | INT
	 | BIGINT
 	 | BOOLEAN
 	 | FLOAT
 	 | DOUBLE
 	 | STRING
 	 | BINARY
	 | TIMESTAMP
 	 | DECIMAL
 	 | VARCHAR
 	 | CHAR
 	 | VARCHAR2s
 	 | INTEGER
 	 ;
noexists : IF NOT EXISTS;
exists	:	IF EXISTS;

ifExpr	:	IF '(' a = expr ',' b = expr ',' c = expr ')'
	->	^(IF $a $b $c) 
	;
dot 	:	'.'	
	;
RLIKE	:	R L I K E;
OVERWRITE
	:	O V E R W R I T E;
LIMIT	:	L I M I T;
SORT	:	S O R T;
DISTRIBUTE
	:	D I S T R I B U T E;
NULLS	:	N U L L S;
IN	:	I N;
USING	:	U S I N G;
ESCAPE	:	E S C A P E;
OR	:	O R;
AND	:	A N D;
MINUS	:	M I N U S;
INTERSECT
	:	I N T E R S E C T;
UNION	:	U N I O N;
IS	:	I S;
NULL	:	N U L L;
ALL	:	A L L;
DISTINCT:	D I S T I N C T;
MAP	:	M A P;
VARCHAR	:	V A R C H A R;
ORDER	:	O R D E R;
GROUP	:	G R O U P;
WHERE	:	W H E R E;
SUBQUERY:	S U B Q U E R Y;
FROM	:	F R O M;
LIKE	:	L I K E;
OUTPUTFORMAT
	:	O U T P U T F O R M A T;
INPUTFORMAT
	:	I N P U T F O R M A T;
SEQUENCEFILE
	:	S E Q U E N C E F I L E;	
TEXTFILE:	T E X T F I L E;	
RCFILE	:	R C F I L E;
ORC	:	O R C;
PARQUET :       P A R Q U E T;	
SERDE	:	S E R D E;
LINES	:	L I N E S;
KEYS	:	K E Y S;
COLLECTION
	:	C O L L E C T I O N;
ITEMS	:	I T M E S;
ESCAPED	:	E S C A P E D;
TERMINATED
	:	T E R M I N A T E D;
FIELDS	:	F I E L D S;
DELIMITED
	:	D E L I M I T E D;
TBLPROPERTIES
	:	T B L P R O P E R T I E S;
LOCATION:	L O C A T I O N;
WITH	:	W I T H;
SERDEPROPERTIES
	:	S E R D E P R O P E R T I E S;
ROW 	:	R O W;
FORMAT	:	F O R M A T;
STORED	:	S T O R E D;
AS	:	A S;
DIRECTORIES
	:	D I R E C T O R I E S;
ON 	:	O N;
SKEWED 	:	S K E W E D;
BUCKETS :	B U C K E T S;
INTO	:	I N T O;
DESC	:	D E S C;
ASC 	:	A S C;
SORTED	:	S O R T E D;
CLUSTERED 
	:	C L U S T E R E D;
COLNAME	:	C O L N A M E;
JOIN 	:	J O I N;
SUM     :	S U M;
MAX     :	M A X;
AVG     :	A V G;
MIN     :	M I N;
LAG     :	L A G;
LEAD    :	L E A D;
COUNT   :	C O U N T;
FIRST_VALUE 
	:	F I R S T '_' V A L U E;
LEFTKH  :	'(';
RIGHTKH :	')';
DATATYPE 
	:	D A T A T Y P E;
COLUMN 	:	C O L U M N;
PARTITIONED 
	:	P A R T I T I O N E D;
BY 	:	B Y;
TABLENAME  
	:T A B L E N A M E;
CREATE 	: C R E A T E;
TABLE 	: T A B L E;
EXTERNAL	:	E X T E R N A L;
IF	:	I F;
NOT	: N O T;
EXISTS : E X I S T S;
COMMENT : C O M M E N T;
TINYINT :	T I N Y I N T;
SMALLINT : S M A L L I N T;
INT 	: I N T;
BIGINT : B I G I N T;
BOOLEAN : B O O L E A N;
FLOAT : F L O A T;
DOUBLE : D O U B L E;
STRING : S T R I N G;
BINARY 	: B I N A R Y;
TIMESTAMP : T I M E S T A M P;
DECIMAL : D E C I M A L;
UNIONTYPE : U N I O N T Y P E;
MODEL
	: M O D E L;
DIMENSION	
	: D I M E N S I O N;
UPDATED	:U P D A T E D;
MEASURES
	:M E A S U R E S;
RULES	:R U L E S;
UPSERT	:U P S E R T;
//BUFFER_POOL
//	:	('b'|'B')('u'|'U')('f'|'F')('f'|'F')('e'|'E')('r'|'R')('_')('p'|'P')('o'|'O')('o'|'O')('l'|'L')
//	;	
VARCHAR2s
	:	('v'|'V')('a'|'A')('r'|'R')('c'|'C')('h'|'H')('a'|'A')('r'|'R')('2')
	;
ROW_NUMBER_OVER
	:       ('r'|'R')('o'|'O')('w'|'W')('_')('n'|'N')('u'|'U')('m'|'M')('b'|'B')('e'|'E')('r'|'R')('(')(')')(' ')*('o'|'O')('v'|'V')('e'|'E')('r'|'R')
	;
RANK_OVER 
	:       ('r'|'R')('a'|'A')('n'|'N')('k'|'K')('(')(')')(' ')*('o'|'O')('v'|'V')('e'|'E')('r'|'R')
	;
DENSE_RANK
	:	('D'|'d')('E'|'e')('N'|'n')('S'|'s')('E'|'e')('_')('R'|'r')('A'|'a')('N'|'n')('K'|'k')
	;
DENSE_RANK_OVER
	:	('D'|'d')('E'|'e')('N'|'n')('S'|'s')('E'|'e')('_')('R'|'r')('A'|'a')('N'|'n')('K'|'k')('(')(')')(' ')*('o'|'O')('v'|'V')('e'|'E')('r'|'R')
	;
QUERY : Q U E R Y;
SCOPE: S C O P E;
REWRITE : R E W R I T E;
PREBUILT 
	:	 P R E B U I L T;
	CLUSTER : C L U S T E R ;
	WITHOUT:W I T H O U T;
REDUCED :	 R E D U C E D;
MATERIALIZED  //materialized
	:	 M A T E R I A L I Z E D 
	;
//PRECISION
//	:	P R E C I S I O N
//	;
//CURSOR :	C U R S O R ;
//NEVER 	:	N E V E R;
// FAST	:	F A S T;
// MASTER	:	M A S T E R;
ROLLBACK:	R O L L B A C K;
SEGMENT :	 S E G M E N T;
DEMAND	:	D E M A N D;
COMPLETE:	C O M P L E T E;
REFRESH	:	R E F R E S H;
CLOB	:	C L O B;	
INITRANS:	I N I T R A N S;
MAXTRANS:	M A X T R A N S;
PCTFREE	:	P C T F R E E;
BUILD 	:	 B U I L D;
IMMEDIATE 
	:	 I M M E D I A T E;
DEFERED	:	D E F E R E D;
SELECT:
      S E L E C T ;
UNIQUE:
      U N I Q U E ;
FOR:
      F O R ;
UPDATE:
      U P D A T E ;
OF:
      O F ;
NOWAIT	:	
      N O W A I T ;
WAIT:
      W A I T ;
CASE:
      C A S E ;
NOW:	
      N O W;
WHEN:
      W H E N ;
THEN:
      T H E N ;
ELSE:
      E L S E ;
END:
      E N D ;
LOCAL:
      L O C A L ;
TIME:
      T I M E ;
ZONE:
      Z O N E ;
     CHUNK 
	:	 C H U N K;
	READS:R E A D S;
//ELEMENT	:	 E L E M E  N T;
NESTED	:	 N E S T E D;
TYPE	:	T Y P E;
VALUE	:	V A L U E;
RETURN 	:	 R E T U R N;
VARRAY	:	V A R R A Y;
//PCTVERSION 
//	:	P C T V E R S I O N;
LOCATOR	:	L A C A T O R;

	
DBTIMEZONE:
      D B T I M E Z O N E ;
//SESSIONTIMEZONE:
//      S E S S I O N T I M E Z O N E ;
ONLY:
      O N L Y ;
INNER:
      I N N E R ;
LEFT:
      L E F T ;
RIGHT:
      R I G H T ;
FULL:
      F U L L ;
OUTER:
      O U T E R ;
SEMI:	
	S E M I;
CROSS:
      C R O S S ;
NATURE:
      N A T U R E ;
SAMPLE:
      S A M P L E ;
PARTITION:
      P A R T I T I O N ;
SUBPARTITION:
      S U B P A R T I T I O N ;
READ:
      R E A D ;
CHECK:
      C H E C K ;
OPTION:
      O P T I O N ;
CONSTRAINT:
      C O N S T R A I N T ;
HAVING:
      H A V I N G ;
SIBLINGS:
      S I B L I N G S ;
FIRST:
      F I R S T ;
LAST:
      L A S T ;
START:
      S T A R T ;
CONNECT:
      C O N N E C T ;
BETWEEN:
      B E T W E E N ;
REGEXP 	:	R E G E X P;
SUBSTITUTABLE
	:	S U B S T I T U T A B L E;
GLOBAL:
      G L O B A L ;
TEMPORARY:
      T E M P O R A R Y ;
INSERT:
      I N S E R T ;
EXIST:
      E X I S T ;
TO:
      T O ;   
INTERVAL:
      I N T E R V A L ;
YEAR:
      Y E A R ;
MONTH:
      M O N T H ;
      PRIOR
      	:	P R I O R;
DAY:
      D A Y ;
HOUR:
      H O U R ;
MINUTE:
      M I N U T E ;
SECOND:
      S E C O N D ;
DATE:
      D A T E ;
MULTISET:
      M U L T I S E T ;
KEY:
      K E Y ;
PRIMARY:
      P R I M A R Y ;
DELETE:
      D E L E T E ;
CHAR:
      C H A R ;
CHARACTER:
      C H A R A C T E R ;
VARCHARACTER:
      V A R C H A R A C T E R ;
INDEX:
      I N D E X ;
COMMIT:
      C O M M I T ;
ROWS:
      R O W S ;
PRESERVE:
      P R E S E R V E ;
INCLUDING:
      I N C L U D I N G ;
OVERFLOW:
      O V E R F L O W ;
AT:
      A T ;
K_LESS:
      L_ E_ S_ S_ ;
VALUES:
      V A L U E S ;
TABLESPACE:
      T A B L E S P A C E ;
ENABLE:
      E N A B L E ;
DISABLE:
      D I S A B L E ;
STORAGE:
      S T O R A G E ;
ORGANIZETION:
      O R G A N I Z E T I O N ;
LOGGING:
      L O G G I N G ;
ROWID:
      R O W I D ;
REFERENCES:
      R E F E R E N C E S ;
NOLOGGING:
      N O L O G G I N G ;
SET:
      S E T ;
CASCADE:
      C A S C A D E ;
CACHE:
      C A C H E ;
NOCACHE:
      N O C A C H E ;
MONITORING:
      M O N I T O R I N G ;
NOMONITORING:
      N O M O N I T O R I N G ;
PARALLEL:
      P A R A L L E L ;
NOPARALLEL:
      N O P A R A L L E L ;
//ROWDEPENDENCIES:
//     R O W D E P E N D E N C I E S ;
//NOROWDEPENDENCIES:
//      N O R O W D E P E N D E N C I E S ;
VOLIDATE:
      V O L I D A T E ;
NOVOLIDATE:
      N O V O L I D A T E ;
KEEP:
      K E E P ;
DROP:
      D R O P ;
MOVEMENT:
      M O V E M E N T ;
RANGE:
      R A N G E ;
LIST:
      L I S T ;
HASH:
      H A S H ;
STORE:
      S T O R E ;
LOB:
      L O B ;
MAXVALUE:
      M A X V A L U E ;
HEAP:
      H E A P ;
LEVELS:
      L E V E L S ;
SUBPARTITIONS:
      S U B P A R T I T I O N S ;
SUBTITUTABLE:
      S U B T I T U T A B L E ;
INITIAL:
      I N I T I A L ;
NEXT:
      N E X T ;
//MAPPING:
//      M A P P I N G ;
//NOMAPPING:
//      N O M A P P I N G ;
//COMPRESS:
//      C O M P R E S S ;
//NOCOMPRESS:
//      N O C O M P R E S S ;
//MINEXTENTS:
//      M I N E X T E N T S ;
//MAXEXTENTS:
//      M A X E X T E N T S ;
OVER:
      O V E R ;
VARYING:
      V A R Y I N G ;

NUMBER:
      N U M B E R ;
RENAME:
      R E N A M E ;
VIEW:
      V I E W ;
REPLACE:
      R E P L A C E ;
NO:
      N O ;
FORCE:
      F O R C E ;
VALIDATE:
      V A L I D A T E ;
NOVALIDATE:
      N O V A L I D A T E ;
RELY:
      R E L Y ;
NORELY:
      N O R E L Y ;
SYSDATE:
      S Y S D A T E ;
SYSTIMESTAMP:
      S Y S T I M E S T A M P ;
ALTER:
      A L T E R ;
FOREIGN:
      F O R E I G N ;
GROUPING:
      G R O U P I N G ;
SETS:
      S E T S ;
MERGE:
      M E R G E ;
MATCHED:
      M A T C H E D ;
DEGREE:
      D E G R E E ;
PARTITIONS:
      P A R T I T I O N S ;
CUBE	:	C U B E;
ROLLUP	:	R O L L U P;
MINEXTENDS 
	:	M I N E X T E N D S;
MAXEXTENDS
	:	M A X E X T E N D S;
UNLIMITED	:U M L I M I T E D;
PCTINCREASE
	:	P C T I N C R E A S E ;
FREELIST:	F R E E L I S T;
FREELISTS
	:	F R E E L I S T S;
GROUPS	:	G R O U P S;
RECYCLE	:	R E C Y C L E;	
PCTUSED	:	P C T U S E D;
UNBOUNDED 
	:	U N B O U N D E D ;
// CURRENT :	C U  R R E N T;
FOLLOWING 
	:	F O L L O W I N G;
PRECEDING
	:	P R E C E D I N G;	
BYTE	:	B Y T E;
INTEGER	:	I N T E G E R;

STRAIGHT_JOIN
	:	S T R A I G H T '_'  J O I N;
EXPLODE
	: E X P L O D E
	;
LATERAL
	: L A T E R A L 
	;
JSON_TUPLE
	: J S O N '_' T U P L E
	;
BUD	:	B U D;
SUBJECT_NAME
	:	
	S U B J E C T '_' N A M E
	;
FROM_UNIXTIME
	:
	F R O M '_' U N I X T I M E
	;
UNIX_TIMESTAMP
	:
	U N I X '_' T I M E S T A M P
	;
CURRENT_TIMESTAMP
	:
	C U R R E N T '_' T I M E S T A M P
	;

//_L _E _S _S

fragment L_:('L'|'l');
fragment E_:('E'|'e');
fragment S_:('S'|'s');



fragment A:('a'|'A');
fragment B:('b'|'B');
fragment C:('c'|'C');
fragment D:('d'|'D');
fragment E:('e'|'E');
fragment F:('f'|'F');
fragment G:('g'|'G');
fragment H:('h'|'H');
fragment I:('i'|'I');
fragment J:('j'|'J');
fragment K:('k'|'K');
fragment L:('l'|'L');
fragment M:('m'|'M');
fragment N:('n'|'N');
fragment O:('o'|'O');
fragment P:('p'|'P');
fragment Q:('q'|'Q');
fragment R:('r'|'R');
fragment S:('s'|'S');
fragment T:('t'|'T');
fragment U:('u'|'U');
fragment V:('v'|'V');
fragment W:('w'|'W');
fragment X:('x'|'X');
fragment Y:('y'|'Y');
fragment Z:('z'|'Z');
/**
	Lexer
*/
FLOATS
	:	'0'..'9'+ ('.' '0'..'9'* EXPONENT? | EXPONENT)
	;
EXPONENT
	:	('e' | 'E') ('+' | '-')? ('0'..'9')+
	; 
DATETIME
	:	DATE TEXT
	;
TEXT	:	'N'? '\'' 
			(
				'\'\'' | ~('\'')
			)*
		'\''
	|	'#' '{' (UNQUOTED_ID)* '}'
	;
//UNITS 	:	 ('a'..'z' | 'A'..'Z' | '0'..'9' |'$' | '#' | '_'|'%')*;
INTEGERS	:	 ( '0'..'9' + )
	;
UNQUOTED_ID
	:	('0'..'9' | 'a'..'z' | 'A'..'Z'  |  '_' | '%'| '@' | '$') ('a'..'z' | 'A'..'Z' | '0'..'9' | '_' | '$' | '#' | '%')* 
	;
VARCOLON
	:	':'('a'..'z' | 'A'..'Z' | '0'..'9' | '_' )*
	;
DECLAREVAR
	:	('$''{' UNQUOTED_ID VARCOLON'}');	
//INTVAR	:	('0'..'9'+);	
QUOTED_ID
	:	'"' 
			( ~('"'))*
		'"'
	;
fragment CHINESE	
	:	'\u4e00'..'\u9fa5'
	;
fragment PUNCTUATION
	:	'\uffe5' | '\uff0c' | '\u3002' | '\u3001' | '\uff1b' | '\uff1a' | '\uff1f' | '\uff01' | '\u2018' | '\u2019' 
	| 	'\u201c' | '\u201d' | '\uff05' | '\uff3b' | '\uff3d' | '\uff5b' | '\uff5d' | '\uff5c' | '\u2236' | '\uff02'
	|	'\uff40' | '\uff07' | '\u3003' | '\u3014' | '\u3015' | '\u3016' | '\u3017' | '\u300e' | '\u300f' | '\u300c'
	|	'\u300d' | '\uff0e' | '\u2016' | '\uff5e' | '\u008a' | '\u02c9' | '\u3008' | '\u3009' | '\uff08' | '\uff09'
	|	'\u2026' | '\u2014' | '\u00b7' | '\u300a' | '\u300b' | '\u3010' | '\u3011'
	;
WHITESPACE	:	(' ' | '\t' | '\b' | '\f' | '\r' | '\n')+ {$channel = HIDDEN;} 
	;
COMMENTS	:	'/*' ( options {greedy=false;} : . )* '*/' {$channel = HIDDEN;}
	;
LINECOMMENT
	:	'--' ~('\n'|'\r')* '\r'? '\n' {$channel = HIDDEN;}
	;
