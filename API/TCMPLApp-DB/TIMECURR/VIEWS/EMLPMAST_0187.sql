--------------------------------------------------------
--  DDL for View EMLPMAST_0187
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "TIMECURR"."EMLPMAST_0187" ("EMPNO", "NAME", "DOL", "PAYROLL", "STATUS", "PARENT", "ASSIGN") AS 
  (
SELECT EMPNO,NAME,DOL ,PAYROLL,STATUS,PARENT,ASSIGN FROM EMPLMAST WHERE (PARENT = '0187' OR ASSIGN = '0187' ) 
AND EMPTYPE IN ('R','C')  and dol is not null 
)
;
