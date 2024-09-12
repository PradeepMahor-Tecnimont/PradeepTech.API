--------------------------------------------------------
--  DDL for View PRJ_CC_TCM_UPD
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "TIMECURR"."PRJ_CC_TCM_UPD" ("PROJNO", "COSTCODE", "SAPCC", "YYMM", "TCMNO", "NAME", "TCM_CC", "PURCHASEORDER", "TCM_PHASE", "HOURS", "OTHOURS", "TOTHOURS", "RATE") AS 
  (
 SELECT 
    
    a.projno,
    a.costcode,
    D.SAPCC,
    a.yymm,
    b.tcmno,
    B.NAME,
    d.TCM_CC,
    D.PO PurchaseOrder,
    decode(nvl(B.TCM_ACTIVE,0) ,0,'PASSIVE','ACTIVE') TCM_Phase,
    SUM(NVL(a.hours,0))  Hours,
   SUM(NVL(a.othours,0)) Othours,
    (SUM(NVL(a.hours,0)) + SUM(NVL(a.othours,0))) TOThours ,
    inv_rate(a.projno,a.costcode) Rate
  FROM timetran a,
    PROJMAST B,
    COSTMAST D,
    raphours c
  WHERE 
  (
  A.PROJNO = B.PROJNO AND
  A.COSTCODE = D.COSTCODE AND
  a.yymm = c.yymm and c.yymm >= '201901' and 
  NVL(B.REIMB_JOB,0) = 1 
  ) 
  OR A.PROJNO LIKE '09107%'
  
  GROUP BY
a.projno,
a.costcode,
D.SAPCC,
 a.yymm,
b.tcmno,
B.NAME,
d.TCM_CC,
D.PO,
nvl(B.TCM_ACTIVE,0)
     )
;
