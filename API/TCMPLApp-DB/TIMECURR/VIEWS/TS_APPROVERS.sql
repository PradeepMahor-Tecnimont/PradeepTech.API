--------------------------------------------------------
--  DDL for View TS_APPROVERS
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "TIMECURR"."TS_APPROVERS" ("EMPNO", "COSTCODE") AS 
  (
SELECT EMPNO,COSTCODE FROM TIME_HOD
UNION
SELECT EMPNO,COSTCODE FROM TIME_DYHOD
--UNION
--SELECT DY_HOD EMPNO ,COSTCODE FROM COSTMAST WHERE DY_HOD <> HOD  AND COSTCODE LIKE '02%' and active = 1
)
;
