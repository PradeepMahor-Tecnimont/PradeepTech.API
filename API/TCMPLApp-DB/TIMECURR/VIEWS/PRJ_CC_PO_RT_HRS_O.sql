--------------------------------------------------------
--  DDL for View PRJ_CC_PO_RT_HRS_O
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "TIMECURR"."PRJ_CC_PO_RT_HRS_O" ("PROJNO", "COSTCODE", "SAPCC", "YYMM", "TCMNO", "NAME", "TCM_CC", "PURCHASEORDER", "TCM_PHASE", "CCDESC", "HOURS", "OTHOURS", "TOTHOURS", "RATE", "e_ep_type") AS 
  (
 select projno,
        costcode,
        SAPCC,
        yymm,
        tcmno,
        NAME,
        TCM_CC,
        PurchaseOrder,
        TCM_Phase,
        CCDesc,
        Hours,
        Othours,
        TOThours ,
        Rate,
        rap_reports_gen.get_e_ep_type(projno) e_ep_type
from (
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
      decode(B.TCM_ACTIVE ,0,D.TCM_PAS_PH ,1,D.TCM_ACT_PH )  TCM_Phase,
      d.name CCDesc,
    SUM(NVL(a.hours,0))  Hours,
   SUM(NVL(a.othours,0)) Othours,
    (SUM(NVL(a.hours,0)) + SUM(NVL(a.othours,0))) TOThours ,
    inv_rate(a.projno,a.costcode) Rate
  FROM timetran a,
    PROJMAST B,
    COSTMAST D,
    raphours c,
    EMPLMAST E
  WHERE 
    A.PROJNO = B.PROJNO AND
  A.COSTCODE = D.COSTCODE AND
  a.yymm = c.yymm and c.yymm >= '202001' and 
  NVL(B.REIMB_JOB,0) = 1 
  AND A.EMPNO = E.EMPNO
  AND E.EMPTYPE = 'O'
    GROUP BY
a.projno,
a.costcode,
D.SAPCC,
 a.yymm,
b.tcmno,
B.NAME,
d.TCM_CC,
D.PO,
  decode(B.TCM_ACTIVE ,0,D.TCM_PAS_PH ,1,D.TCM_ACT_PH ) ,
  d.name 
  
  )
  )
  )
;
