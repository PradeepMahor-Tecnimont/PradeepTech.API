--------------------------------------------------------
--  DDL for View BOOKEDHOURS
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "TIMECURR"."BOOKEDHOURS" ("YYMM", "EMPNO", "HOURS") AS 
  (select yymm,empno,sum(NVL(HOURS,0)) Hours from timetran  where wpcode <> 4  group by yymm,empno  )
;
