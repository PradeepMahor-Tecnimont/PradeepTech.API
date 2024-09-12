--------------------------------------------------------
--  DDL for View ENGG_GRP_WISE
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "TIMECURR"."ENGG_GRP_WISE" ("YYMM", "PROJNO", "COSTCODE", "NEWCOSTCODE", "TOTHRS") AS 
  (
select a.yymm,a.projno,a.costcode,b.newcostcode,sum(nvl(hours,0))+sum(nvl(othours,0)) TOTHRS from timetran a,projmast b ,COSTMAST C
where a.projno = b.projno AND A.COSTCODE = C.COSTCODE  AND C.TMA_GRP = 'E'
group by a.yymm,a.projno,a.costcode,b.newcostcode )
;
