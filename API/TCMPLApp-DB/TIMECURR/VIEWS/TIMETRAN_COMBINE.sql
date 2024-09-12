--------------------------------------------------------
--  DDL for View TIMETRAN_COMBINE
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "TIMECURR"."TIMETRAN_COMBINE" ("YYMM", "EMPNO", "COSTCODE", "PROJNO", "WPCODE", "ACTIVITY", "GRP", "HOURS", "OTHOURS") AS 
  (SELECT yymm,
    empno,
    costcode,
    projno,
    wpcode,
    activity,
    grp,
    hours,
    othours
  FROM timetran
  WHERE yymm >= '201904'
  )
  UNION
    (SELECT yymm,
    empno,
    costcode,
    projno,
    wpcode,
    activity,
    grp,
    hours,
    othours
  FROM timetran1819
  WHERE yymm >= '201804'
  )
  UNION
   (SELECT yymm,
    empno,
    costcode,
    projno,
    wpcode,
    activity,
    grp,
    hours,
    othours
  FROM timetran1718
  WHERE yymm >= '201704'
  )
;
