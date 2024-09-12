--------------------------------------------------------
--  DDL for Table SS_MUSTER
--------------------------------------------------------

  CREATE TABLE "COMMONMASTERS"."SS_MUSTER" 
   (	"MNTH" CHAR(6), 
	"EMPNO" CHAR(5), 
	"SHIFT_4ALLOWANCE" CHAR(62), 
	"S_MRK" CHAR(62), 
	"W_TM" CHAR(186), 
	"O_TM" CHAR(186), 
	"LCO_TM" CHAR(186), 
	"LGO_TM" CHAR(186)
   ) ;
  GRANT SELECT ON "COMMONMASTERS"."SS_MUSTER" TO "SELFSERVICE";
