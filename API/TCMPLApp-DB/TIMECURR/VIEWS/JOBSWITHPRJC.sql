--------------------------------------------------------
--  DDL for View JOBSWITHPRJC
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "TIMECURR"."JOBSWITHPRJC" ("PROJNO", "PRJNAME", "CO", "SDATE", "EXPTCDATE", "COSTCODE", "JOBCATEGORY", "YYMM", "TOTHOURS") AS 
  (select a.projno,a.name as PrjName,A.CO,a.sdate,a.exptcdate,a.costcode,c.name as JobCategory,b.yymm,sum(nvl(b.hours,0))as Tothours
from projmast a, prjcmast b ,costmast c
where a.active =1 and a.projno = b.projno and a.costcode = c.costcode and b.yymm > '200506' group by a.projno,a.name,A.CO,a.sdate,a.exptcdate,a.costcode,c.name,b.yymm )

;
