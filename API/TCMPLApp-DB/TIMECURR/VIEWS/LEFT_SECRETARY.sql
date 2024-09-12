--------------------------------------------------------
--  DDL for View LEFT_SECRETARY
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "TIMECURR"."LEFT_SECRETARY" ("COSTCODE", "NAME", "HOD", "EMPNO", "EMPNAME", "NOOFEMPS") AS 
  (
  SELECT a.COSTCODE,
    A.NAME,
    A.HOD,
    B.EMPNO,
    b.name AS EMPNAME,
    a.NOOFEMPS
   
  FROM COSTMAST a,
    EMPLmast b
  WHERE a.SECRETARY = B.EMPNO
  AND a.SECRETARY  IN
    (
    SELECT EMPNO FROM EMPLMAST WHERE DOL IS NOT NULL
    )
)
;
