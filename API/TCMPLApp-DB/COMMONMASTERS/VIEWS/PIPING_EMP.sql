--------------------------------------------------------
--  DDL for View PIPING_EMP
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "COMMONMASTERS"."PIPING_EMP" ("COMPANY", "EMPNO", "NAME", "PARENT") AS 
  SELECT COMPANY,
    EMPNO,
    NAME,
    PARENT
  FROM TIMECURR.EMPLMAST
  WHERE PARENT = '0221'
WITH READ ONLY
;
