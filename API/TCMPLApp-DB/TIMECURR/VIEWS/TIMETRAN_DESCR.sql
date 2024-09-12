--------------------------------------------------------
--  DDL for View TIMETRAN_DESCR
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "TIMECURR"."TIMETRAN_DESCR" ("YYMM", "EMPNO", "COSTCODE", "PROJNO", "WPCODE", "ACTIVITY", "GRP", "HOURS", "OTHOURS", "COMPANY", "LOADED", "YYMM_INV", "PROJNAME", "COSTNAME", "EMPTYPE") AS 
  select a."YYMM",a."EMPNO",a."COSTCODE",a."PROJNO",a."WPCODE",a."ACTIVITY",a."GRP",a."HOURS",a."OTHOURS",a."COMPANY",a."LOADED",a."YYMM_INV",a.projno||' '||b.name as projname,a.costcode||' '||c.name as costname,d.emptype from timetran a,projmast b,costmast c, emplmast d where a.projno =b.projno and a.costcode = c.costcode and a.empno = d.empno

;
