--------------------------------------------------------
--  DDL for Function GEN_NUMBERS
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SELFSERVICE"."GEN_NUMBERS" 
(
  param_num IN NUMBER  
) 
RETURN 
array 
pipelined
as
BEGIN
  for i in 1 .. param_num loop
    pipe row(i);
  end loop;
END GEN_NUMBERS;


/
