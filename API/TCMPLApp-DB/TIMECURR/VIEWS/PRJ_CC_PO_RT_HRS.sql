--------------------------------------------------------
--  DDL for View PRJ_CC_PO_RT_HRS
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "TIMECURR"."PRJ_CC_PO_RT_HRS" ("PROJNO", "COSTCODE", "SAPCC", "YYMM", "TCMNO", "NAME", "TCM_CC", "PURCHASEORDER", "TCM_PHASE", "CCDESC", "HOURS", "OTHOURS", "TOTHOURS", "RATE", "e_ep_type") AS 
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
    raphours c
  WHERE 
    A.PROJNO = B.PROJNO AND
  A.COSTCODE = D.COSTCODE AND
  a.yymm = c.yymm and c.yymm >= '202201' and 
  NVL(B.REIMB_JOB,0) = 1 
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



  UNION
  (
 SELECT 
    a.projno,
    a.costcode,
    D.SAPCC,
    a.yymm,
    b.tcmno,
    B.NAME,
    d.TCM_CC,
    '7500064665' PurchaseOrder,
      decode(B.TCM_ACTIVE ,0,D.TCM_PAS_PH ,1,D.TCM_ACT_PH )  TCM_Phase,
      d.name ccdesc,
    SUM(NVL(a.hours,0))  Hours,
   SUM(NVL(a.othours,0)) Othours,
    (SUM(NVL(a.hours,0)) + SUM(NVL(a.othours,0))) TOThours ,
    inv_rate(a.projno,a.costcode) Rate
  FROM timetran a,
    PROJMAST B,
    COSTMAST D,
    raphours c
  WHERE 
    A.PROJNO = B.PROJNO AND
  A.COSTCODE = D.COSTCODE AND
  a.yymm = c.yymm and c.yymm >= '202201' and 
 a.projno like '09107%' and a.wpcode <> 3
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



  UNION
  (
 SELECT 
    a.projno,
    a.costcode,
    D.SAPCC,
    a.yymm,
    b.tcmno,
    B.NAME,
    d.TCM_CC,
    '7500065425' PurchaseOrder,
      decode(B.TCM_ACTIVE ,0,D.TCM_PAS_PH ,1,D.TCM_ACT_PH )  TCM_Phase,
      d.name ccdesc,
    SUM(NVL(a.hours,0))  Hours,
   SUM(NVL(a.othours,0)) Othours,
    (SUM(NVL(a.hours,0)) + SUM(NVL(a.othours,0))) TOThours ,
    inv_rate(a.projno,a.costcode) Rate
  FROM timetran a,
    PROJMAST B,
    COSTMAST D,
    raphours c
  WHERE 
    A.PROJNO = B.PROJNO AND
  A.COSTCODE = D.COSTCODE AND
  a.yymm = c.yymm and c.yymm >= '202201' and 
 a.projno like '09107%' and a.wpcode = 3
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
 UNION
  (
 SELECT 
    a.projno,
    a.costcode,
    D.SAPCC,
    a.yymm,
    b.tcmno,
    B.NAME,
    d.TCM_CC,
    '7500073603' PurchaseOrder,
      decode(B.TCM_ACTIVE ,0,D.TCM_PAS_PH ,1,D.TCM_ACT_PH )  TCM_Phase,
      d.name ccdesc,
    SUM(NVL(a.hours,0))  Hours,
   SUM(NVL(a.othours,0)) Othours,
    (SUM(NVL(a.hours,0)) + SUM(NVL(a.othours,0))) TOThours ,
    inv_rate(a.projno,a.costcode) Rate
  FROM timetran a,
    PROJMAST B,
    COSTMAST D,
    raphours c
  WHERE 
    A.PROJNO = B.PROJNO AND
  A.COSTCODE = D.COSTCODE AND
  a.yymm = c.yymm and c.yymm >= '202201' and 
 a.projno like '09794%' 
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

 UNION
  (
 SELECT 
    a.projno,
    a.costcode,
    D.SAPCC,
    a.yymm,
    b.tcmno,
    B.NAME,
    d.TCM_CC,
    '7500082411' PurchaseOrder,
      decode(B.TCM_ACTIVE ,0,D.TCM_PAS_PH ,1,D.TCM_ACT_PH )  TCM_Phase,
      d.name ccdesc,
    SUM(NVL(a.hours,0))  Hours,
   SUM(NVL(a.othours,0)) Othours,
    (SUM(NVL(a.hours,0)) + SUM(NVL(a.othours,0))) TOThours ,
    inv_rate(a.projno,a.costcode) Rate
  FROM timetran a,
    PROJMAST B,
    COSTMAST D,
    raphours c
  WHERE 
    A.PROJNO = B.PROJNO AND
  A.COSTCODE = D.COSTCODE AND
  a.yymm = c.yymm and c.yymm >= '202201' and 
 a.projno like '09059%' 
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
 
 UNION
  (
 SELECT 
    a.projno,
    a.costcode,
    D.SAPCC,
    a.yymm,
    b.tcmno,
    B.NAME,
    d.TCM_CC,
    'PONOTRECVD' PurchaseOrder,
      decode(B.TCM_ACTIVE ,0,D.TCM_PAS_PH ,1,D.TCM_ACT_PH )  TCM_Phase,
      d.name ccdesc,
    SUM(NVL(a.hours,0))  Hours,
   SUM(NVL(a.othours,0)) Othours,
    (SUM(NVL(a.hours,0)) + SUM(NVL(a.othours,0))) TOThours ,
    inv_rate(a.projno,a.costcode) Rate
  FROM timetran a,
    PROJMAST B,
    COSTMAST D,
    raphours c
  WHERE 
    A.PROJNO = B.PROJNO AND
  A.COSTCODE = D.COSTCODE AND
  a.yymm = c.yymm and c.yymm >= '202201' and 
 a.projno like '09036%' 
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
UNION

  (
 SELECT 
    a.projno,
    a.costcode,
    D.SAPCC,
    a.yymm,
    b.tcmno,
    B.NAME,
    d.TCM_CC,
    'PONOTRECVD' PurchaseOrder,
      decode(B.TCM_ACTIVE ,0,D.TCM_PAS_PH ,1,D.TCM_ACT_PH )  TCM_Phase,
      d.name ccdesc,
    SUM(NVL(a.hours,0))  Hours,
   SUM(NVL(a.othours,0)) Othours,
    (SUM(NVL(a.hours,0)) + SUM(NVL(a.othours,0))) TOThours ,
    inv_rate(a.projno,a.costcode) Rate
  FROM timetran a,
    PROJMAST B,
    COSTMAST D,
    raphours c
  WHERE 
    A.PROJNO = B.PROJNO AND
  A.COSTCODE = D.COSTCODE AND
  a.yymm = c.yymm and c.yymm >= '202201' and 
 a.projno like '09064%' 
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

UNION
  (
 SELECT 
    a.projno,
    a.costcode,
    D.SAPCC,
    a.yymm,
    b.tcmno,
    B.NAME,
    d.TCM_CC,
    'PONOTRECVD' PurchaseOrder,
      decode(B.TCM_ACTIVE ,0,D.TCM_PAS_PH ,1,D.TCM_ACT_PH )  TCM_Phase,
      d.name ccdesc,
    SUM(NVL(a.hours,0))  Hours,
   SUM(NVL(a.othours,0)) Othours,
    (SUM(NVL(a.hours,0)) + SUM(NVL(a.othours,0))) TOThours ,
    inv_rate(a.projno,a.costcode) Rate
  FROM timetran a,
    PROJMAST B,
    COSTMAST D,
    raphours c
  WHERE 
    A.PROJNO = B.PROJNO AND
  A.COSTCODE = D.COSTCODE AND
  a.yymm = c.yymm and c.yymm >= '202201' and 
 a.projno like '09797%' 
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
  )
;
