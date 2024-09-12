--------------------------------------------------------
--  DDL for View MYNEWVIEW
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "TIMECURR"."MYNEWVIEW" ("EMPNO", "YYMM", "COSTCODE", "PROJNO", "HOURS", "OTHOURS", "PARENT", "NAME") AS 
  (SELECT timetran.empno,
    timetran.yymm,
    timetran.costcode,
    timetran.projno,
    hours,
    othours,
    emplmast.parent,
    emplmast.name
  FROM timetran ,
    emplmast
  WHERE timetran.empno = emplmast.empno
  )

;
