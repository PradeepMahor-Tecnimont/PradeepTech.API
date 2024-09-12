--------------------------------------------------------
--  DDL for View PRJ_CC_TCM
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "TIMECURR"."PRJ_CC_TCM" ("PROJNO", "COSTCODE", "SAPCC", "YYMM", "TCMNO", "NAME", "HOURS", "OTHOURS", "TOTHOURS") AS 
  (
 SELECT 
    
    a.projno,
    a.costcode,
    D.SAPCC,
    a.yymm,
    b.tcmno,
    B.NAME,
    SUM(NVL(a.hours,0))  Hours,
   SUM(NVL(a.othours,0)) Othours,
    (SUM(NVL(a.hours,0)) + SUM(NVL(a.othours,0))) TOThours
  FROM timetran a,
    PROJMAST B,
    COSTMAST D,
    raphours c
  WHERE 
  A.PROJNO = B.PROJNO AND
  A.COSTCODE = D.COSTCODE AND
  a.yymm = c.yymm and c.yymm >= '201901' and 
  NVL(B.TCM_JOBS,0) = 1 
  GROUP BY
a.projno,
a.costcode,
D.SAPCC,
 a.yymm,
b.tcmno,
B.NAME
     )
;
