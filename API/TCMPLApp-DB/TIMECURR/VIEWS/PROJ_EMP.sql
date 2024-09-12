--------------------------------------------------------
--  DDL for View PROJ_EMP
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "TIMECURR"."PROJ_EMP" ("YYMM", "EMPNO") AS 
  SELECT DISTINCT yymm,
    empno
  FROM timetran
  WHERE projno = '0962709' AND YYMM >= '201004'
  ORDER BY empno,
    yymm

;
