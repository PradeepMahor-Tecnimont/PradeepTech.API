--------------------------------------------------------
--  DDL for View DM_VU_EMP_DESK_MAP
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "DM_VU_EMP_DESK_MAP" ("EMPNO", "DESKID", "MODIFIED_ON", "MODIFIED_BY") AS 
  SELECT 
    "EMPNO","DESKID","MODIFIED_ON","MODIFIED_BY"
FROM 
    
dm_emp_desk_map
;
