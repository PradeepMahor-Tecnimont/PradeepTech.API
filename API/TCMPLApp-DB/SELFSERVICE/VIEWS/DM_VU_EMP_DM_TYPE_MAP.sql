--------------------------------------------------------
--  DDL for View DM_VU_EMP_DM_TYPE_MAP
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "SELFSERVICE"."DM_VU_EMP_DM_TYPE_MAP" ("EMPNO", "EMP_DM_TYPE", "DM_TYPE_DESC") AS 
  SELECT 
    "EMPNO","EMP_DM_TYPE","DM_TYPE_DESC"
FROM 
    
dms.dm_vu_emp_dm_type_map
;
