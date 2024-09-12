--------------------------------------------------------
--  DDL for View TS_STATUS_EMP
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "TIMECURR"."TS_STATUS_EMP" ("YYMM", "ASSIGN", "EMPNO", "CNT", "REMARKS") AS 
  (
select yymm,ASSIGN,empno,count(*) cnt,'FILLED' REMARKS from time_mast where parent = assign and yymm = '201912' group by YYMM,ASSIGN,EMPNO
union
select yymm,ASSIGN,EMPNO,count(*) cnt ,'FILLED_ODD'  REMARKS from time_mast where parent <> assign and yymm = '201912' group by yymm,ASSIGN,EMPNO
union
select yymm,ASSIGN,EMPNO,count(*) cnt, 'NOTPOSTED'  REMARKS from time_mast where parent = assign and yymm = '201912'  AND nvl(POSTED,0) = 0 group by yymm,ASSIGN,EMPNO
union
select yymm,ASSIGN,EMPNO,count(*) ,'NOTPOSTED_ODD' REMARKS from time_mast where parent <> assign and yymm = '201912'  AND nvl(POSTED,0) = 0 group by yymm,ASSIGN,EMPNO
union
select yymm,ASSIGN,EMPNO,count(*), 'POSTED' REMARKS  from time_mast where parent = assign and yymm = '201912'  AND nvl(POSTED,0) = 1 group by yymm,ASSIGN,EMPNO
union
select yymm,ASSIGN,EMPNO,count(*) ,'POSTED_ODD' REMARKS from time_mast where parent <> assign and yymm = '201912'  AND nvl(POSTED,0) = 1 group by yymm,ASSIGN,EMPNO
)
;
