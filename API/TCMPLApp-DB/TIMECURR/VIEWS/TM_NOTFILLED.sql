--------------------------------------------------------
--  DDL for View TM_NOTFILLED
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "TIMECURR"."TM_NOTFILLED" ("EMPNO", "NAME", "ASSIGN", "PROS_MONTH") AS 
  (
  select a.empno,a.name,a.assign,b.PROS_MONTH  from emplmast a , TSCONFIG b where
a.status = 1 and
a.emptype in ('R','C','S') and 
a.assign like '02%' and 
a.empno not like 'W%'  and 
a.empno not like 'N%'   and 
a.assign  <> '0238'  and
a.empno ||a.assign||b.PROS_MONTH not in 
(select c.empno||c.assign||c.yymm  from time_mast c, tsconfig d  where c.yymm = d.PROS_MONTH  )
)
;
