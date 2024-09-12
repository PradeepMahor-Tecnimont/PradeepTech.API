--------------------------------------------------------
--  DDL for View DD27
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "TIMECURR"."DD27" ("YYMM", "EMPNO", "ASSIGN", "PROJNO", "ADJ", "ACTUAL") AS 
  (select yymm,empno,assign,projno, decode(wpcode,4,d27+d28+d29+d30+d31,0) Adj ,
 decode(wpcode,1,d1+d2+d3+d4+d5+d6+d7+d8+d9+d10+d11+d12+d13+d14+d15+d16+d17+d18+d19+d20+d21+d22+d23+d24+D25+d26,2,d1+d2+d3+d4+d5+d6+d7+d8+d9+d10+d11+d12+d13+d14+d15+d16+d17+d18+d19+d20+d21+d22+d23+d24+D25+d26,0) 
 Actual  from time_daily
 where  projno LIKE '09794%' )
;
