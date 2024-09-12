--------------------------------------------------------
--  DDL for View DOUBLE_BOOK
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "TIMECURR"."DOUBLE_BOOK" ("YYMM", "EMPNO", "COSTCODE") AS 
  (select yymm,empno,costcode from timetran group by yymm,empno,costcode)
;
