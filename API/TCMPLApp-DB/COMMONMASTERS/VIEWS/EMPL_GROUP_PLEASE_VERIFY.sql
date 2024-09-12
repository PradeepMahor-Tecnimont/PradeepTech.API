--------------------------------------------------------
--  DDL for View EMPL_GROUP_PLEASE_VERIFY
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "COMMONMASTERS"."EMPL_GROUP_PLEASE_VERIFY" ("ASSIGN", "EMPNO", "NAME", "EMPTYPE", "COMPANY") AS 
  SELECT ASSIGN,
    EMPNO,
    NAME,
    EMPTYPE,
    COMPANY
  FROM time2012.emplmast
  WHERE STATUS    = 1
  AND PARENT     <> '0187'
  AND ASSIGN NOT IN ('0236','0232','0238')
  AND OFFICE NOT IN ('CA','DE','BS','IS')

;
