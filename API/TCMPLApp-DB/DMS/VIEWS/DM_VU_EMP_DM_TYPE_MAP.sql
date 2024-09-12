--------------------------------------------------------
--  DDL for View DM_VU_EMP_DM_TYPE_MAP
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "DM_VU_EMP_DM_TYPE_MAP" ("EMPNO", "EMP_DM_TYPE", "DM_TYPE_DESC") AS 
  Select
    dtm.empno, dtm.emp_dm_type, dt.dm_type_desc
From
    dm_emp_dm_type_map dtm,
    dm_emp_dm_types    dt
Where
    dt.dm_type_code = dtm.emp_dm_type
;
