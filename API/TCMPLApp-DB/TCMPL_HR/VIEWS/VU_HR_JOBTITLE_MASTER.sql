CREATE OR REPLACE FORCE EDITIONABLE VIEW "TCMPL_HR"."VU_HR_JOBTITLE_MASTER" ("JOBTITLE_CODE", "JOBTITLE") AS 
  Select
        jobtitle_code, jobtitle
    From
        timecurr.hr_jobtitle_master;