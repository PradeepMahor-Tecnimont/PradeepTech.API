--------------------------------------------------------
--  DDL for Function PUNCHCOUNT
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SELFSERVICE"."PUNCHCOUNT" 
  ( parEmpNo VARCHAR2,
    parDate Date)
  RETURN  Number IS
-- ---------   ------  -------------------------------------------
--
--
--
-- This function returns the nunber of punch counts on a particular day
-- 
--
-- 
-- ---------   ------  -------------------------------------------       
    vCount Number;
BEGIN 
    Select Count(*) InTo vCount From SS_IntegratedPunch Where
        EmpNo = Trim(parEmpNo) And PDate = parDate;
    RETURN vCount ;
EXCEPTION
   WHEN Others THEN
       Return 0;
END;


/
