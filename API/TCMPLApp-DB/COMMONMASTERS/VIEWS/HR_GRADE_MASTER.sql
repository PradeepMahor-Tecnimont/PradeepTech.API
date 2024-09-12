--------------------------------------------------------
--  DDL for View HR_GRADE_MASTER
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "COMMONMASTERS"."HR_GRADE_MASTER" ("GRADE_ID", "GRADE_DESC") AS 
  select "GRADE_ID","GRADE_DESC" from TIMECURR.hr_grade_master
;
  GRANT SELECT ON "COMMONMASTERS"."HR_GRADE_MASTER" TO "SELFSERVICE" WITH GRANT OPTION;
