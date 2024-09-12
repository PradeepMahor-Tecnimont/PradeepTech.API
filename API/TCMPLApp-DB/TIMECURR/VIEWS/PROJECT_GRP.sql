--------------------------------------------------------
--  DDL for View PROJECT_GRP
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "TIMECURR"."PROJECT_GRP" ("PROJ_NO", "NAME", "SDATE", "CDATE", "ACTIVE", "PRJMNGR", "PRJDYMNGR", "TCMNO") AS 
  (select distinct substr(projno,1,5) as proj_no ,name,sdate,cdate,active,prjmngr,
prjdymngr,tcmno from projmast )

;
