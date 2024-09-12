--------------------------------------------------------
--  DDL for View TM_MULTIPLE
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "TIMECURR"."TM_MULTIPLE" ("YYMM", "EMPNO", "COSTCODE", "PROJNO", "WPCODE", "ACTIVITY", "GRP", "HOURS", "OTHOURS", "COMPANY", "LOADED", "YYMM_INV", "PARENT") AS 
  (
select "YYMM","EMPNO","COSTCODE","PROJNO","WPCODE","ACTIVITY","GRP","HOURS","OTHOURS","COMPANY","LOADED","YYMM_INV","PARENT" from timetran where empno||YYMM in ( 
select EMPNO||YYMM from time_mast where posted = 1  AND YYMM >= '201704' group by   empno,YYMM having count(*) > 1
)
)
;
