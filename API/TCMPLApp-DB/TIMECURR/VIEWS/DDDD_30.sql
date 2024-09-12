--------------------------------------------------------
--  DDL for View DDDD_30
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "TIMECURR"."DDDD_30" ("YYMM", "EMPNO", "ASSIGN", "PROJNO", "ADJ", "ACTUAL_1", "ACTUAL_2", "ESTIMATE_1", "ESTIMATE_2") AS 
  (
 select yymm,empno,assign,projno, 
 decode(wpcode,4,nvl(d1,0)+nvl(d2,0)+nvl(d3,0)+nvl(d4,0)+nvl(d5,0)+nvl(d6,0)+nvl(d7,0)+nvl(d8,0)+nvl(d9,0)+nvl(d10,0)+nvl(d11,0)+nvl(d12,0)+
 nvl(d13,0)+nvl(d14,0)
 +nvl(d15,0)+nvl(d16,0)+nvl(d17,0)+nvl(d18,0)+nvl(d19,0)+nvl(d20,0)+nvl(d21,0)+nvl(d22,0)+nvl(d23,0)+nvl(d24,0)+nvl(D25,0)+nvl(d26,0)+nvl(d27,0)+nvl(d28,0)+nvl(d29,0)
 +nvl(d30,0)+nvl(d31,0),0) Adj ,
 decode(wpcode,1,nvl(d1,0)+nvl(d2,0)+nvl(d3,0)+nvl(d4,0)+nvl(d5,0)+nvl(d6,0)+nvl(d7,0)+nvl(d8,0)+nvl(d9,0)+nvl(d10,0)+nvl(d11,0)+nvl(d12,0)+nvl(d13,0)+nvl(d14,0)
 +nvl(d15,0)+nvl(d16,0)+nvl(d17,0)+nvl(d18,0)+nvl(d19,0)+nvl(d20,0)+nvl(d21,0)+nvl(d22,0)+nvl(d23,0)+nvl(d24,0)+nvl(D25,0)+nvl(d26,0)
 +nvl(d27,0)+nvl(d28,0)+nvl(d29,0)+nvl(d30,0),0) Actual_1,
 decode(wpcode,2,nvl(d1,0)+nvl(d2,0)+nvl(d3,0)+nvl(d4,0)+nvl(d5,0)+nvl(d6,0)+nvl(d7,0)+nvl(d8,0)+nvl(d9,0)+nvl(d10,0)+nvl(d11,0)+nvl(d12,0)+nvl(d13,0)+nvl(d14,0)
 +nvl(d15,0)+nvl(d16,0)+nvl(d17,0)+nvl(d18,0)+nvl(d19,0)+nvl(d20,0)+nvl(d21,0)+nvl(d22,0)+nvl(d23,0)+nvl(d24,0)+nvl(D25,0)+nvl(d26,0)
 +nvl(d27,0)+nvl(d28,0)+nvl(d29,0)+nvl(d30,0),0) Actual_2 ,
 decode(wpcode,1,nvl(d31,0),0) Estimate_1,
 decode(wpcode,2,nvl(d31,0) , 0) Estimate_2
 from time_daily 
 where  projno LIKE '09794%'
 )
 UNION
 (
 select yymm,empno,assign,projno, 
 decode(wpcode,4,nvl(d1,0)+nvl(d2,0)+nvl(d3,0)+nvl(d4,0)+nvl(d5,0)+nvl(d6,0)+nvl(d7,0)+nvl(d8,0)+nvl(d9,0)+nvl(d10,0)+nvl(d11,0)+nvl(d12,0)+
 nvl(d13,0)+nvl(d14,0)
 +nvl(d15,0)+nvl(d16,0)+nvl(d17,0)+nvl(d18,0)+nvl(d19,0)+nvl(d20,0)+nvl(d21,0)+nvl(d22,0)+nvl(d23,0)+nvl(d24,0)+nvl(D25,0)+nvl(d26,0)+nvl(d27,0)+nvl(d28,0)+nvl(d29,0)
 +nvl(d30,0)+nvl(d31,0),0) Adj ,
 decode(wpcode,1,nvl(d1,0)+nvl(d2,0)+nvl(d3,0)+nvl(d4,0)+nvl(d5,0)+nvl(d6,0)+nvl(d7,0)+nvl(d8,0)+nvl(d9,0)+nvl(d10,0)+nvl(d11,0)+nvl(d12,0)+nvl(d13,0)+nvl(d14,0)
 +nvl(d15,0)+nvl(d16,0)+nvl(d17,0)+nvl(d18,0)+nvl(d19,0)+nvl(d20,0)+nvl(d21,0)+nvl(d22,0)+nvl(d23,0)+nvl(d24,0)+nvl(D25,0)+nvl(d26,0)
 +nvl(d27,0)+nvl(d28,0)+nvl(d29,0)+nvl(d30,0),0) Actual_1,
 decode(wpcode,2,nvl(d1,0)+nvl(d2,0)+nvl(d3,0)+nvl(d4,0)+nvl(d5,0)+nvl(d6,0)+nvl(d7,0)+nvl(d8,0)+nvl(d9,0)+nvl(d10,0)+nvl(d11,0)+nvl(d12,0)+nvl(d13,0)+nvl(d14,0)
 +nvl(d15,0)+nvl(d16,0)+nvl(d17,0)+nvl(d18,0)+nvl(d19,0)+nvl(d20,0)+nvl(d21,0)+nvl(d22,0)+nvl(d23,0)+nvl(d24,0)+nvl(D25,0)+nvl(d26,0)
 +nvl(d27,0)+nvl(d28,0)+nvl(d29,0)+nvl(d30,0),0) Actual_2 ,
 decode(wpcode,1,nvl(d31,0),0) Estimate_1,
 decode(wpcode,2,nvl(d31,0) , 0) Estimate_2
 from time_OT 
 where  projno LIKE '09794%'
 )
;
