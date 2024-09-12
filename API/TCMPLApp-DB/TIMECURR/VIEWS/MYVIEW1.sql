--------------------------------------------------------
--  DDL for View MYVIEW1
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "TIMECURR"."MYVIEW1" ("EMPNO", "YYMM", "COSTCODE", "PROJNO", "HOURS", "OTHOURS", "PARENT") AS 
  (select "EMPNO","YYMM","COSTCODE","PROJNO","HOURS","OTHOURS","PARENT" from myview where parent in (select costcode from costmast where tma_grp = 'E')
)
;
