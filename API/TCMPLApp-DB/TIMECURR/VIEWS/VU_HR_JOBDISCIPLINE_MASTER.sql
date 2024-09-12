CREATE OR REPLACE FORCE EDITIONABLE VIEW "TIMECURR"."VU_HR_JOBDISCIPLINE_MASTER" ("JOBDISCIPLINE_CODE", "JOBDISCIPLINE") AS 
  Select
        jobdiscipline_code, jobdiscipline
    From
        hr_jobdiscipline_master;