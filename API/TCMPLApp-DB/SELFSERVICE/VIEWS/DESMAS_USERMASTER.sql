--------------------------------------------------------
--  DDL for View DESMAS_USERMASTER
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "SELFSERVICE"."DESMAS_USERMASTER" ("EMPNO", "DESKID", "COSTCODE", "DEP_FLAG") AS 
  SELECT  "EMPNO","DESKID","COSTCODE","DEP_FLAG"
    
FROM dms.dm_usermaster
;
