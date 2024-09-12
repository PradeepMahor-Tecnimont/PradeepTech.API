--------------------------------------------------------
--  DDL for Procedure FILL_LUNCHMAST_4_SHIFT
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "SELFSERVICE"."FILL_LUNCHMAST_4_SHIFT" (pFromShift IN Varchar2, pToShift In Varchar2 )AS 
  CURSOR c_ShiftMast IS Select SHIFTCODE,PARENT,STARTHH,STARTMN,ENDHH,ENDMN From 
  SS_LUNCHMAST Where shiftcode=Trim(pFromShift);
BEGIN
  For c1 in c_ShiftMast Loop
      Begin
          Insert InTo SS_LunchMast (SHIFTCODE,PARENT,STARTHH,STARTMN,ENDHH,ENDMN) 
            Values (pToShift,c1.PARENT,c1.STARTHH,c1.STARTMN,c1.ENDHH,c1.ENDMN);
          Commit;
      Exception WHEN OTHERS then
        null;
      End;
  End Loop;
END FILL_LUNCHMAST_4_SHIFT;


/
