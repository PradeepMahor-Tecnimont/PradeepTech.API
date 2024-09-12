--------------------------------------------------------
--  DDL for View HOURS_TIMETRAN_FINAL
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "TIMECURR"."HOURS_TIMETRAN_FINAL" ("YYMM", "EMPNO", "NAME", "COSTCODE", "PROJNO", "HOURS", "OTHOURS", "TOT") AS 
  ( SELECT a.yymm,A.EMPNO,B.NAME,A.costcode,A.PROJNO,
SUM(A.HOURS) as hours,SUM(A.OTHOURS) as othours,SUM(A.HOURS)+SUM(A.OTHOURS) AS TOT
 FROM timetran A,EMPLMAST B,PROJMAST C
WHERE A.EMPNO = B.EMPNO AND A.PROJNO = C.PROJNO AND a.wpcode <> 4 and C.TCM_JOBS = 1  and c.reimb_job = 1
HAVING SUM(A.HOURS)+SUM(A.OTHOURS) > 240 GROUP BY a.yymm,A.EMPNO,B.NAME,A.costcode,A.PROJNO )

;
