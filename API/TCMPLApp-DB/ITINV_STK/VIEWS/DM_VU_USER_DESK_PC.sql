--------------------------------------------------------
--  DDL for View DM_VU_USER_DESK_PC
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "ITINV_STK"."DM_VU_USER_DESK_PC" ("DESKID", "ASSETID", "ASSET_TYPE", "DESCRIPTION", "EMPNO", "COMPNAME") AS 
  select "DESKID","ASSETID","ASSET_TYPE","DESCRIPTION","EMPNO","COMPNAME" from dms.DM_vu_USER_DESK_PC
;
