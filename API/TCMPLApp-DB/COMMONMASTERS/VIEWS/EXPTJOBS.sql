--------------------------------------------------------
--  DDL for View EXPTJOBS
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "COMMONMASTERS"."EXPTJOBS" ("PROJNO", "NAME", "ACTIVE", "BU", "ACTIVEFUTURE", "FINAL_PROJNO") AS 
  SELECT  PROJNO ,
     NAME ,
     ACTIVE ,
     BU ,
     ACTIVEFUTURE ,
     FINAL_PROJNO 
  FROM timecurr.exptjobs
;
