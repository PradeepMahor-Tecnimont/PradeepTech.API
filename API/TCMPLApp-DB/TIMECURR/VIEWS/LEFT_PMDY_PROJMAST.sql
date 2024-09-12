--------------------------------------------------------
--  DDL for View LEFT_PMDY_PROJMAST
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "TIMECURR"."LEFT_PMDY_PROJMAST" ("PROJNO", "NAME", "PRJDYMNGR") AS 
  (SELECT PROJNO,
    NAME,
    PRJDYMNGR
  FROM projmast
  WHERE cdate IS NULL
  AND prjdymngr IN
    (SELECT empno FROM emplmast WHERE dol IS NOT NULL
    )
  AND SUBSTR(projno,6,2) NOT IN ('LA','LB','LC','LD','LM','00','52')
  )
;
