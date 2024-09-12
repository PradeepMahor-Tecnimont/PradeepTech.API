--------------------------------------------------------
--  DDL for View NG_TAB_TIMETRAN
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "TIMECURR"."NG_TAB_TIMETRAN" ("YYMM", "EMPNO", "COSTCODE", "PROJNO", "WPCODE", "ACTIVITY", "GRP", "HOURS", "COMPANY", "LOADED", "YYMM_INV", "PARENT", "REASONCODE") AS 
  select yymm, empno, costcode, projno, wpcode,activity, grp, hours, company, loaded, 
yymm_inv, parent, reasoncode from timetran
where yymm >= '202004' and yymm <= '202103'
union
select yymm, empno, costcode, projno, wpcode,activity, grp, hours, company, loaded, 
yymm_inv, parent, null reasoncode from time2019.timetran 
where yymm >= '201904' and yymm <= '202003'
;
