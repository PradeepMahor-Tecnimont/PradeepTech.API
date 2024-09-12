--------------------------------------------------------
--  DDL for View DM_VU_USER_DESK_PC
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "SELFSERVICE"."DM_VU_USER_DESK_PC" ("DESKID", "ASSETID", "ASSET_TYPE", "DESCRIPTION", "EMPNO", "COMPNAME") AS 
  select "DESKID","ASSETID","ASSET_TYPE","DESCRIPTION","EMPNO","COMPNAME" from dms.DM_VU_USER_DESK_PC
;
