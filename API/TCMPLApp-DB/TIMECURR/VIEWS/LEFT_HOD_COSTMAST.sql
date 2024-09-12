--------------------------------------------------------
--  DDL for View LEFT_HOD_COSTMAST
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "TIMECURR"."LEFT_HOD_COSTMAST" ("COSTCODE", "NAME", "NOOFEMPS", "EMPNAME") AS 
  (SELECT a.COSTCODE,
    A.NAME,
    A.NOOFEMPS,
    b.name AS EMPNAME
  FROM COSTMAST a,
    EMPLmast b
  WHERE a.HOD = B.EMPNO
  and a.noofemps <> 0 
  AND A.HOD  IN
    (SELECT EMPNO FROM EMPLMAST WHERE DOL IS NOT NULL
    )
 AND ( A.COSTCODE LIKE '01%' OR  A.COSTCODE LIKE '02%' OR  A.COSTCODE LIKE '03%') 
  )
;
