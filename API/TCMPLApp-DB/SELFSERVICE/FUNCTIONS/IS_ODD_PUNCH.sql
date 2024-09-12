--------------------------------------------------------
--  DDL for Function IS_ODD_PUNCH
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SELFSERVICE"."IS_ODD_PUNCH" 
  ( ppEmpNo IN Varchar2,
    ppDate IN Date,
    poffice IN varchar2 default null)
  RETURN  Number IS
  -- this function returns
  -- 0     if the number of punch per day is even number
  -- 0     if the number of punch is < 3
  -- 1     if the number of punch is > 3 and is an even number
  vCount  Number;
BEGIN 
    If Trim(pOffice) is not null then
      Select count(*) InTo vCount From SS_IntegratedPunch Where EmpNo = Trim(ppEmpNo) And
        PDate = ppDate And Mach in (Select MACH_NAME From SS_SWIPE_MACH_MAST where office = poffice
        and VALID_4_IN_OUT = 1 );
    Else
      Select count(*) InTo vCount From SS_IntegratedPunch Where EmpNo = Trim(ppEmpNo) And
        PDate = ppDate;
    End if;
    If Mod (vCount,2) <> 0 Then -- If not an even number
        Return 1;
    Else
        Return 0;
    End If;

    RETURN  vCount ;
EXCEPTION
   WHEN Others THEN
       Return vCount;
END;


/
