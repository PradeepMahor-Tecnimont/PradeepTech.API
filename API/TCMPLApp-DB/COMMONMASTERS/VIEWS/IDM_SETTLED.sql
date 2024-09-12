--------------------------------------------------------
--  DDL for View IDM_SETTLED
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "COMMONMASTERS"."IDM_SETTLED" ("COMPANY_ID", "EMPLOYEE_ID", "LEAVEDATE") AS 
  (
SELECT '3002' AS company_id,
    '00000000000'
    ||empno AS employee_id,
    lastday AS leavedate
  FROM emplmast
  WHERE 
dol    IS NOT NULL  AND
 ( (emptype = 'R')  OR (emptype   = 'C'  AND (empno LIKE 'OC%' or empno like 'EC%')))
  )

;
