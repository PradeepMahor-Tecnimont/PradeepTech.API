CREATE OR REPLACE FORCE EDITIONABLE VIEW "TCMPL_HR"."VU_HR_JOBGROUP_MASTER" ("JOB_GROUP_CODE", "JOB_GROUP") AS 
  Select
        job_group_code, job_group
    From
        timecurr.hr_jobgroup_master;