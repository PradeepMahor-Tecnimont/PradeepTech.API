--------------------------------------------------------
--  DDL for View MYVIEW3
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "TIMECURR"."MYVIEW3" ("EMPNO", "YYMM", "COSTCODE", "PROJNO", "HOURS", "OTHOURS", "PARENT") AS 
  (
select "EMPNO","YYMM","COSTCODE","PROJNO","HOURS","OTHOURS","PARENT" from myview2 where 
costcode not in (select costcode from costmast where tma_grp = 'E'
)
)
;
