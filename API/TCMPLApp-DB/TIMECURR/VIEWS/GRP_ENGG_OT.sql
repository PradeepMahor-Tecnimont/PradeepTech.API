--------------------------------------------------------
--  DDL for View GRP_ENGG_OT
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "TIMECURR"."GRP_ENGG_OT" ("YYMM", "COSTCODE", "NEWCOSTCODE", "PROJNO", "NAME", "OTHOURS") AS 
  (SELECT a.yymm,
    a.costcode,
    b.newcostcode,
    b.projno,
    b.name,
    SUM(NVL(a.othours,0)) othours
  FROM timetran a,
    projmast b
  WHERE a.projno        = b.projno
  AND NVL(a.othours,0) <> 0
  AND A.COSTCODE       IN 
(select costcode from costmast where tma_grp = 'E')
  GROUP BY a.yymm,
    a.costcode,
    b.newcostcode,
    b.projno ,
    b.name
  ) 

;
