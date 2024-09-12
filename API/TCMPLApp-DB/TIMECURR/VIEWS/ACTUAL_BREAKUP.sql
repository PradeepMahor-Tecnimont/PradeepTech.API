--------------------------------------------------------
--  DDL for View ACTUAL_BREAKUP
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "TIMECURR"."ACTUAL_BREAKUP" ("COSTCODE", "YYMM", "PROJ_TYPE", "TOTHOURS") AS 
  (SELECT A.COSTCODE,a.yymm,B.BU AS proj_type,SUM(NVL(A.HOURS,0))+SUM(NVL(A.OTHOURS,0)) AS TOTHOURS
FROM TIMETRAN A,PROJMAST B ,costmast c
WHERE A.PROJNO = B.PROJNO and b.bu <> 'DEP' AND A.YYMM > '200203' and a.costcode = c.costcode and c.tma_grp = 'E'
 GROUP BY A.COSTCODE,a.yymm,B.BU)

;
