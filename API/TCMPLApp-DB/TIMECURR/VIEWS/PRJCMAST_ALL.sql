--------------------------------------------------------
--  DDL for View PRJCMAST_ALL
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "TIMECURR"."PRJCMAST_ALL" ("COSTCODE", "PROJNO", "YYMM", "HOURS") AS 
  (SELECT "COSTCODE","PROJNO","YYMM","HOURS" FROM PRJCMAST UNION SELECT "COSTCODE","PROJNO","YYMM","HOURS" FROM EXPTPRJC )

;
