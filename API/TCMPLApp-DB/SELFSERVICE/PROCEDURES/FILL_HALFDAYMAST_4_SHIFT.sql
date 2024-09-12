--------------------------------------------------------
--  DDL for Procedure FILL_HALFDAYMAST_4_SHIFT
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "SELFSERVICE"."FILL_HALFDAYMAST_4_SHIFT" 
(
  pFromShift IN VARCHAR2, pToShift VARCHAR2
) AS 
  Cursor c_HalfDayMast IS Select 
    SHIFTCODE,PARENT,HDAY1_STARTHH,HDAY1_STARTMM,HDAY1_ENDHH,HDAY1_ENDMM,HDAY2_STARTHH,HDAY2_STARTMM,HDAY2_ENDHH,HDAY2_ENDMM
    From SS_HALFDAYMAST Where shiftcode=Trim(pfromshift);
BEGIN

    For c1 in c_HalfDayMast Loop
      Begin
          Insert INTO ss_halfdaymast (SHIFTCODE,PARENT,HDAY1_STARTHH,HDAY1_STARTMM,HDAY1_ENDHH,HDAY1_ENDMM,HDAY2_STARTHH,HDAY2_STARTMM,HDAY2_ENDHH,HDAY2_ENDMM) 
          Values (Upper(Trim(pToShift)) ,c1.PARENT ,c1.HDAY1_STARTHH ,c1.HDAY1_STARTMM ,c1.HDAY1_ENDHH ,c1.HDAY1_ENDMM ,c1.HDAY2_STARTHH ,c1.HDAY2_STARTMM ,c1.HDAY2_ENDHH ,c1.HDAY2_ENDMM);
      Exception When OTHERS Then 
        Null;
      End;
    End Loop;
END FILL_HALFDAYMAST_4_SHIFT;


/
