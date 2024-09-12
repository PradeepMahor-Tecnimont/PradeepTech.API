--------------------------------------------------------
--  DDL for View DIST_VU_HOD
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "ITINV_STK"."DIST_VU_HOD" ("EMPNO", "DEPT") AS 
  SELECT 
    hod empno,
    costcode dept 
FROM 
    
vu_costmast
union
select empno,dept from dist_user_dept
;
