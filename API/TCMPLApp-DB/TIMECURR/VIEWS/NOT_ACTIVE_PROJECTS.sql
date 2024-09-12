--------------------------------------------------------
--  DDL for View NOT_ACTIVE_PROJECTS
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "TIMECURR"."NOT_ACTIVE_PROJECTS" ("CO", "PROJNO", "PROJNAME", "SDATE", "EXPTCDATE", "EMPNAME", "TCM_JOBS") AS 
  (select b.co,a.projno,b.name as projname,b.sdate,b.exptcdate,c.name as empname,b.tcm_jobs from
(select max(yymm) as yymm ,projno from timetran  group by projno )a,projmast b,emplmast c
 where B.ACTIVE = 1 AND b.prjmngr = c.empno and a.projno =b.projno and a.yymm < '200506')

;
