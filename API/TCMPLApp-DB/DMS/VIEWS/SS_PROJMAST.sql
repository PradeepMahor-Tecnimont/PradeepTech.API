--------------------------------------------------------
--  DDL for View SS_PROJMAST
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "SS_PROJMAST" ("PROJNO", "NAME", "CLIENT", "SDATE", "EXPTCDATE", "CDATE", "COSTCODE", "PRJMNGR", "PRJDYMNGR", "ORIGINAL", "REVISED", "PROJTYPE", "TYPE", "TMAGRP", "ABBR", "ACTIVE", "TCM_JOBS", "TCM_GRP", "PRJOPER", "TCMNO", "REIMB_JOB", "EOU_JOB", "EXCL_BILLING", "EXCL_DELTA_BILLING", "BU", "PROJ_NO", "BLOCK_BOOKING", "CO") AS 
  select "PROJNO","NAME","CLIENT","SDATE","EXPTCDATE","CDATE","COSTCODE","PRJMNGR","PRJDYMNGR","ORIGINAL","REVISED","PROJTYPE","TYPE","TMAGRP","ABBR","ACTIVE","TCM_JOBS","TCM_GRP","PRJOPER","TCMNO","REIMB_JOB","EOU_JOB","EXCL_BILLING","EXCL_DELTA_BILLING","BU","PROJ_NO","BLOCK_BOOKING","CO" from commonmasters.projmast
;
