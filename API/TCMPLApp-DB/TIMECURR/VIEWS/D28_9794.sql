--------------------------------------------------------
--  DDL for View D28_9794
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "TIMECURR"."D28_9794" ("YYMM", "EMPNO", "ASSIGN", "PROJNO", "WPCODE", "ACTIVITY", "ACTUAL", "EXPECT") AS 
  (select yymm,empno,assign,projno,wpcode,activity, sum(d1+d2+d3+d4+d5+d6+d7+d8+d9+d10+d11+d12+d13+d14+d15+d16+d17+d18+d19+d20+d21+d22+d23+d24+d25+D26+D27+D28) Actual,
 sum(d29+d30+d31) Expect from time_daily where projno like '09794%' 
 group by yymm,empno,assign,projno,wpcode,activity )
;
