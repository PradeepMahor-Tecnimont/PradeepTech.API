CREATE OR REPLACE FORCE EDITIONABLE VIEW "TCMPL_HR"."VU_HR_JOBDISCIPLINE_MASTER" ("JOBDISCIPLINE_CODE", "JOBDISCIPLINE") AS 
  Select
        jobdiscipline_code, jobdiscipline
    From
        timecurr.hr_jobdiscipline_master;