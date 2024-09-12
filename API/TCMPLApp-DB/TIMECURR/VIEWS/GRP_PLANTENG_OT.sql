--------------------------------------------------------
--  DDL for View GRP_PLANTENG_OT
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "TIMECURR"."GRP_PLANTENG_OT" ("YYMM", "COSTCODE", "NEWCOSTCODE", "GRPNAME", "PROJNO", "NAME", "OTHOURS") AS 
  (SELECT a.yymm,
    a.costcode,
    b.newcostcode,
    c.name AS grpname,
    b.projno,
    b.name,
    SUM(NVL(a.othours,0)) AS OThours
  FROM timetran a,
    projmast b,
    costmast c
  WHERE b.newcostcode = c.costcode
  AND (c.costcode LIKE '40%'
  OR c.costcode LIKE '60%' )
  AND a.projno          = b.projno
  AND NVL(a.othours,0) <> 0
  AND A.COSTCODE       IN (select costcode from costmast where tma_grp = 'E')
  GROUP BY a.yymm,
    a.costcode,
    b.newcostcode,
    c.name,
    b.projno ,
    b.name
  ) 

;
