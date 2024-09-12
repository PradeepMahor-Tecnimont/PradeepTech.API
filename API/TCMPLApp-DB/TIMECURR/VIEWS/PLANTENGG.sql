--------------------------------------------------------
--  DDL for View PLANTENGG
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "TIMECURR"."PLANTENGG" ("YYMM", "COSTCODE", "NAME", "HOURS", "OVERTIME", "TOTAL") AS 
  (SELECT A.YYMM,
    A.COSTCODE,
    B.NAME,
    SUM(NVL(HOURS,0))                      AS HOURS,
    SUM(NVL(OTHOURS,0))                    AS OVERTIME,
    SUM(NVL(HOURS,0)) +SUM(NVL(OTHOURS,0)) AS TOTAL
  FROM TIMETRAN A,
    COSTMAST B
  WHERE A.COSTCODE = B.COSTCODE
  AND A.COSTCODE  IN (select costcode from costmast where tma_grp = 'E')
  GROUP BY A.YYMM,
    A.COSTCODE,
    B.NAME
  ) 

;
