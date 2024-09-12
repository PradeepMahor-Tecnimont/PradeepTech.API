--------------------------------------------------------
--  DDL for View DEPUTATION_HRS
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "TIMECURR"."DEPUTATION_HRS" ("PARENT", "NAME", "YYMM", "EMPNO", "COSTCODE", "PROJNO", "WPCODE", "ACTIVITY", "GRP", "HOURS", "OTHOURS", "COMPANY", "LOADED", "YYMM_INV") AS 
  select b.parent,b.name,a."YYMM",a."EMPNO",a."COSTCODE",a."PROJNO",a."WPCODE",a."ACTIVITY",a."GRP",a."HOURS",a."OTHOURS",a."COMPANY",a."LOADED",a."YYMM_INV" from timetran a,emplmast b where a.empno = b.empno and (a.costcode in ('0232','0245','0289','0290','0291','0292') OR a.wpcode = '2') order by b.parent,a.empno
;
