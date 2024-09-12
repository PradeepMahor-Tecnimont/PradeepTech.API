--------------------------------------------------------
--  DDL for View TOTHRS
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "TIMECURR"."TOTHRS" ("YYMM", "EMPNO", "PROJNO", "COSTCODE", "WPCODE", "HOURS", "OTHOURS", "TOTHOURS") AS 
  SELECT A.YYMM,A.EMPNO,A.PROJNO,A.COSTCODE,A.WPCODE,SUM(NVL(A.HOURS,0)) hours,SUM(NVL(A.OTHOURS,0))othours,
SUM(NVL(A.HOURS,0)) + SUM(NVL(A.OTHOURS,0)) TOTHOURS FROM TIMETRAN A,PROJMAST B WHERE A.YYMM > '200605'
AND A.PROJNO = B.PROJNO AND B.TCM_JOBS = 1
 GROUP BY A.YYMM,A.EMPNO,A.PROJNO,A.COSTCODE,A.WPCODE ORDER BY A.YYMM,A.EMPNO,A.PROJNO,A.COSTCODE,A.WPCODE

;
