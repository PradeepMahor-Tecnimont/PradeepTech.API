--------------------------------------------------------
--  DDL for View IDM_DOL
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "COMMONMASTERS"."IDM_DOL" ("COMPANY_ID", "EMPLOYEE_ID", "DOL") AS 
  (
  SELECT '3002' AS company_id,
    '00000000000'
    ||Empno As Employee_Id,
    Dol From Emplmast Where Emptype In ('R','C') And Dol Is Not Null And 
    parent <> '0187'
)
;
