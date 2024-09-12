--------------------------------------------------------
--  DDL for View TS_NOTFILLED
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "TIMECURR"."TS_NOTFILLED" ("EMPNO", "NAME", "EMPTYPE", "PARENT", "ASSIGN", "CONTRACT_END_DATE", "EMAIL", "DOL") AS 
  (
select empno,name,emptype,parent,assign,CONTRACT_END_DATE,EMAIL,dol from emplmast where emptype in ('R','C','S')  and empno not in 
(select empno from time_mast where yymm = (select pros_month from TSCONFIG)) AND STATUS = 1 AND ASSIGN LIKE '02%' and empno not like 'W%'  and empno not like 'N%'   and assign  <> '0238' 
)
;
