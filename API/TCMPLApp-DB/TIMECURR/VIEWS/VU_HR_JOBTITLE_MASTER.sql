CREATE OR REPLACE FORCE EDITIONABLE VIEW "TIMECURR"."VU_HR_JOBTITLE_MASTER" ("JOBTITLE_CODE", "JOBTITLE") AS 
  Select
        jobtitle_code, jobtitle
    From
        hr_jobtitle_master;