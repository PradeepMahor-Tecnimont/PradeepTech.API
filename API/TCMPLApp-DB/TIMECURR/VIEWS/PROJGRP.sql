--------------------------------------------------------
--  DDL for View PROJGRP
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "TIMECURR"."PROJGRP" ("PROJ_NO", "NAME", "SDATE", "CDATE", "ACTIVE", "PRJMNGR", "PRJDYMNGR", "TCMNO", "TCM_JOBS", "PRJOPER") AS 
  (select distinct substr(projno,1,5) as proj_no ,name,sdate,cdate,active,prjmngr,
prjdymngr,tcmno , TCM_JOBS,PRJOPER from projmast where substr(projno,6,2) in (select phase from job_phases where timesheet = 1) )
;
