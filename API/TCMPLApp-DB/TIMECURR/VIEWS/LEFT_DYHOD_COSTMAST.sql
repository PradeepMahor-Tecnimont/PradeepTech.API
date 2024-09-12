--------------------------------------------------------
--  DDL for View LEFT_DYHOD_COSTMAST
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "TIMECURR"."LEFT_DYHOD_COSTMAST" ("COSTCODE", "NAME", "NOOFEMPS", "EMPNAME", "HOD", "DY_HOD") AS 
  (SELECT a.COSTCODE,
    A.NAME,
    A.NOOFEMPS,
    b.name AS EMPNAME,
    A.hod,
    A.DY_HOD
  FROM COSTMAST a,
    EMPLmast b
  WHERE a.DY_HOD = B.EMPNO
  AND A.DY_HOD  IN
    (SELECT EMPNO FROM EMPLMAST WHERE DOL IS NOT NULL
    )
  AND ( A.COSTCODE LIKE '01%'
  OR A.COSTCODE LIKE '02%'
  OR A.COSTCODE LIKE '03%')
  )
;
