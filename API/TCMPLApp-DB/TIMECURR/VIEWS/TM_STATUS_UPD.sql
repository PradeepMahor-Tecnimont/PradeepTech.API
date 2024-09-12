--------------------------------------------------------
--  DDL for View TM_STATUS_UPD
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "TIMECURR"."TM_STATUS_UPD" ("EMPNO", "NAME", "ASSIGN", "YYMM", "REM", "REMARKS") AS 
  (
select a.empno,a.name,a.assign, b.pros_month AS yymm,1 as Rem,'Eligible' as remarks from emplmast a,tsconfig b where
a.status = 1 and a.emptype in ('R','C','S') and a.assign like '02%'
union
select a.empno,a.name,a.assign, b.yymm AS yymm,1 as Rem,'Filled' as remarks from emplmast a,time_mast b ,tsconfig c where
A.EMPNO = B.EMPNO AND A.assign = B.ASSIGN  and A.status = 1  and b.yymm = c.pros_month
union
select A.empno,A.name,A.assign,b.yymm,NVL(B.LOCKED,0) as Rem,'Locked' as remarks from emplmast A,TIME_MAST B ,tsconfig c  where 
A.EMPNO = B.EMPNO AND A.assign = B.ASSIGN  and A.status = 1 and A.emptype in ('R','C','S') AND NVL(B.LOCKED,0) = 1
 and b.yymm = c.pros_month
union
select A.empno,A.name,A.assign,b.yymm,NVL(B.APPROVED,0) as Rem,'Approved' as remarks from emplmast A,TIME_MAST B ,tsconfig c where
A.EMPNO = B.EMPNO AND A.assign = B.ASSIGN  and A.status = 1 and A.emptype in ('R','C','S') AND NVL(B.APPROVED,0) = 1
 and b.yymm = c.pros_month
union
select A.empno,A.name,A.assign,b.yymm,NVL(B.POSTED,0) as Rem,'Posted' as remarks from emplmast A, TIME_MAST B ,tsconfig c where 
A.EMPNO = B.EMPNO AND A.assign = B.ASSIGN  and A.status = 1 and A.emptype in ('R','C','S') AND NVL(B.POSTED,0) = 1
 and b.yymm = c.pros_month
 
)
;
