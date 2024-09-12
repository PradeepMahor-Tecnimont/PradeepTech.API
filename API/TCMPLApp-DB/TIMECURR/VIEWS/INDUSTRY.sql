--------------------------------------------------------
--  DDL for View INDUSTRY
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "TIMECURR"."INDUSTRY" ("INDUSTRY", "INDNAME", "COMPANY", "PROJNO", "PRJNAME", "COSTCODE", "COSTNAME", "YYMM", "BOOKED") AS 
  (SELECT d.industry,
    e.name AS Indname,
    a.company,
    a.projno,
    c.name AS Prjname,
    a.costcode,
    b.name AS Costname,
    a.yymm ,
    SUM(NVL(a.hours,0))+SUM(NVL(a.othours,0)) booked
  FROM timetran a ,
    costmast b ,
    projmast c ,
    jobmaster d ,
    job_industry e
  WHERE a.costcode     = b.costcode
  AND a.projno         = c.projno
  AND substr(a.projno,1,5) = d.projno
  AND d.industry       = e.industry
  GROUP BY d.industry,
    e.name,
    a.company,
    a.projno,
    c.name,
    a.costcode,
    b.name,
    a.yymm
  )
;
