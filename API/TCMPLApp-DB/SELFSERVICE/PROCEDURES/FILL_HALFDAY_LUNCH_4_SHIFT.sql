--------------------------------------------------------
--  DDL for Procedure FILL_HALFDAY_LUNCH_4_SHIFT
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "SELFSERVICE"."FILL_HALFDAY_LUNCH_4_SHIFT" 
(
  pFromShift IN VARCHAR2  
) AS 
  Cursor c_ShiftMast IS Select ShiftCode from ss_shiftmast Where shiftcode <> pFromShift;
BEGIN
  For c1 in c_ShiftMast Loop
      FILL_HALFDAYMAST_4_SHIFT( PFROMSHIFT => PFROMSHIFT,  PTOSHIFT => c1.ShiftCode  );
      FILL_LUNCHMAST_4_SHIFT(   PFROMSHIFT => PFROMSHIFT,  PTOSHIFT => c1.ShiftCode  );
  End Loop;
END FILL_HALFDAY_LUNCH_4_SHIFT;


/
