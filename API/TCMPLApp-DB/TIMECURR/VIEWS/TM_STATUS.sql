--------------------------------------------------------
--  DDL for View TM_STATUS
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "TIMECURR"."TM_STATUS" ("EMPNO", "NAME", "ASSIGN", "YYMM", "REM", "REMARKS") AS 
  (
  select empno,name,assign,yymm,1 as Rem,'ToSubmit' as remarks from emplmast where assign = '0226' and status = 1 and emptype in ('R','C','S')
union
select empno,name,assign,yymm,1 as Rem,'Submitted' as remarks from emplmast where assign = '0226' and status = 1 and emptype in ('R','C','S') and empno in (select empno from 
time_mast where yymm = '201709' and assign = '0226')
union
select empno,name,assign,yymm,1 as Rem,'Locked' as remarks from emplmast where assign = '0226' and status = 1 and emptype in ('R','C','S') and empno in (select empno from 
time_mast where yymm = '201709' and assign = '0226' and locked = 1)
union
select empno,name,assign,yymm,1 as Rem,'Approved' as remarks from emplmast where assign = '0226' and status = 1 and emptype in ('R','C','S') and empno in (select empno from 
time_mast where yymm = '201709' and assign = '0226' and approved = 1)
union
select empno,name,assign,yymm,1 as Rem,'Posted' as remarks from emplmast where assign = '0226' and status = 1 and emptype in ('R','C','S') and empno in (select empno from 
time_mast where yymm = '201709' and assign = '0226' and posted = 1)
)
;
