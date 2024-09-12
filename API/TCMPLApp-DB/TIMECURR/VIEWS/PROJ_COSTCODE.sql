--------------------------------------------------------
--  DDL for View PROJ_COSTCODE
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "TIMECURR"."PROJ_COSTCODE" ("PROJNO", "COSTCODE", "TOTHRS") AS 
  (SELECT PROJNO,COSTCODE,SUM(HOURS)+SUM(OTHOURS) TOTHRS  FROM TIMETRAN_COMBINE  
GROUP BY PROJNO,COSTCODE)
;
