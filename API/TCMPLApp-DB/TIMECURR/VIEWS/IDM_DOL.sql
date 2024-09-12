--------------------------------------------------------
--  DDL for View IDM_DOL
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "TIMECURR"."IDM_DOL" ("COMPANY_ID", "EMPLOYEE_ID", "DOL") AS 
  (
  SELECT '3002' AS company_id,
    '00000000000'
    ||Empno As Employee_Id,
    dol from emplmast where emptype in ('R','C') and dol is not null
)
;
