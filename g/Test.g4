grammar Test;

float : INT ('.' INT)?
      | '.' INT
      ;

INT   :  [1-9][0-9]*
      | '0'?;