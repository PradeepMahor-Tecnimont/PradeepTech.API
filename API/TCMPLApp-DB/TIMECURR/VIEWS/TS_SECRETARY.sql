--------------------------------------------------------
--  DDL for View TS_SECRETARY
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "TIMECURR"."TS_SECRETARY" ("EMPNO", "COSTCODE") AS 
  (
SELECT EMPNO,COSTCODE FROM TIME_SECRETARY

--UNION
--SELECT DY_HOD EMPNO ,COSTCODE FROM COSTMAST WHERE DY_HOD <> HOD  AND COSTCODE LIKE '02%' and active = 1
)
;
