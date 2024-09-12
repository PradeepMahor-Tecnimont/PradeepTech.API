--------------------------------------------------------
--  DDL for View VIEW2
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "SELFSERVICE"."VIEW2" ("EMPNO", "DESKID", "MODIFIED_ON", "MODIFIED_BY") AS 
  SELECT 
    "EMPNO","DESKID","MODIFIED_ON","MODIFIED_BY"
FROM 
    
dms.dm_emp_desk_map
;
