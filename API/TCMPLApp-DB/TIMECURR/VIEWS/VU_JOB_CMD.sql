--------------------------------------------------------
--  DDL for View VU_JOB_CMD
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "TIMECURR"."VU_JOB_CMD" ("EMPNO", "PERSONID", "NAME", "APPLICATION", "ROLE") AS 
  (
select empno,personid,name,'Jobform' Application,'CMD' Role from emplmast where DIROP = 1  and emptype in ('R','C','S','F','O')
)
;
