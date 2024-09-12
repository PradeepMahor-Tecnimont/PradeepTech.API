--------------------------------------------------------
--  DDL for Function IS_GRADE_X
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SELFSERVICE"."IS_GRADE_X" (param_empno in varchar2) RETURN number AS 
  vCount Number;
BEGIN
  Select count(*) Into vCount from ss_emplmast 
    where empno=param_empno and grade like 'X%'
    and status = 1;
  RETURN vCount;
END IS_GRADE_X;


/
