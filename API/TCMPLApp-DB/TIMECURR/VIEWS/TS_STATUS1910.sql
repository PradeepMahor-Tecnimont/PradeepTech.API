--------------------------------------------------------
--  DDL for View TS_STATUS1910
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "TIMECURR"."TS_STATUS1910" ("YYMM", "ASSIGN", "CNT", "REMARKS") AS 
  (
select yymm,ASSIGN,count(*) cnt,'FILLED' REMARKS from time_mast where parent = assign and yymm = '201910' group by YYMM,ASSIGN
union
select yymm,ASSIGN,count(*) cnt ,'FILLED_ODD'  REMARKS from time_mast where parent <> assign and yymm = '201910' group by yymm,ASSIGN
union
select yymm,ASSIGN,count(*) cnt, 'NOTPOSTED'  REMARKS from time_mast where parent = assign and yymm = '201910'  AND nvl(POSTED,0) = 0 group by yymm,ASSIGN
union
select yymm,ASSIGN,count(*) ,'NOTPOSTED_ODD' REMARKS from time_mast where parent <> assign and yymm = '201910'  AND nvl(POSTED,0) = 0 group by yymm,ASSIGN
union
select yymm,ASSIGN,count(*), 'POSTED' REMARKS  from time_mast where parent = assign and yymm = '201910'  AND nvl(POSTED,0) = 1 group by yymm,ASSIGN
union
select yymm,ASSIGN,count(*) ,'POSTED_ODD' REMARKS from time_mast where parent <> assign and yymm = '201910'  AND nvl(POSTED,0) = 1 group by yymm,ASSIGN
)
;
