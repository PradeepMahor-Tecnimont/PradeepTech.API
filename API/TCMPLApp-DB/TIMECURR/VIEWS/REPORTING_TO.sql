--------------------------------------------------------
--  DDL for View REPORTING_TO
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "TIMECURR"."REPORTING_TO" ("EMPNO", "NAME", "MNGR", "MNGRNAME") AS 
  select a.empno,a.name,a.mngr,b.name as mngrname from emplmast a,emplmast b where a.mngr = b.empno order by a.mngr,a.empno

;
