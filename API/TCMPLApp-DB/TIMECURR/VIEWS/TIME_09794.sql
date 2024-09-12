--------------------------------------------------------
--  DDL for View TIME_09794
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "TIMECURR"."TIME_09794" ("YYMM", "EMPNO", "D1", "D2", "D3", "D4", "D5", "D6", "D7", "D8", "D9", "D10", "D11", "D12", "D13", "D14", "D15", "D16", "D17", "D18", "D19", "D20", "D21", "D22", "D23", "D24", "D25", "D26", "D27", "D28", "D29", "D30", "D31") AS 
  select yymm,empno,  
sum(d1) as d1,sum(d2) as d2,sum(d3) as d3,sum(d4) as d4,sum(d5) as d5,sum(d6) as d6,sum(d7) as d7,sum(d8) as d8,sum(d9) as d9,sum(d10) as d10,sum(d11) as d11
,sum(d12) as d12,sum(d13) as d13,sum(d14) as d14,sum(d15) as d15,sum(d16) as d16,sum(d17) as d17,sum(d18) as d18,sum(d19) as d19,sum(d20) as d20,sum(d21) as d21,sum(d22) as d22,
sum(d23) as d23,sum(d24) as d24,sum(d25) as d25,sum(d26) as d26,sum(d27) as d27,sum(d28) as d28,sum(d29) as d29,sum(d30) as d30,sum(d31) as d31 from  
(select yymm,empno,nvl(d1,0) as d1,nvl(d2,0) as d2,nvl(d3,0) as d3,nvl(d4,0) as d4,nvl(d5,0) as d5,nvl(d6,0) as d6,nvl(d7,0) as d7,nvl(d8,0) as d8,nvl(d9,0) as d9,nvl(d10,0) as d10,nvl(d11,0) as d11
,nvl(d12,0) as d12,nvl(d13,0) as d13,nvl(d14,0) as d14,nvl(d15,0) as d15,nvl(d16,0) as d16,nvl(d17,0) as d17,nvl(d18,0) as d18,nvl(d19,0) as d19,nvl(d20,0) as d20,nvl(d21,0) as d21,nvl(d22,0) as d22,
nvl(d23,0) as d23,nvl(d24,0) as d24,nvl(d25,0) as d25,nvl(d26,0) as d26,nvl(d27,0) as d27,nvl(d28,0) as d28,nvl(d29,0) as d29,nvl(d30,0) as d30,nvl(d31,0) as d31 from timecurr.time_daily 
where projno like '09794%' and wpcode = '1' union all
select yymm,empno,nvl(d1,0) as d1,nvl(d2,0) as d2,nvl(d3,0) as d3,nvl(d4,0) as d4,nvl(d5,0) as d5,nvl(d6,0) as d6,nvl(d7,0) as d7,nvl(d8,0) as d8,nvl(d9,0) as d9,nvl(d10,0) as d10,nvl(d11,0) as d11
,nvl(d12,0) as d12,nvl(d13,0) as d13,nvl(d14,0) as d14,nvl(d15,0) as d15,nvl(d16,0) as d16,nvl(d17,0) as d17,nvl(d18,0) as d18,nvl(d19,0) as d19,nvl(d20,0) as d20,nvl(d21,0) as d21,nvl(d22,0) as d22,
nvl(d23,0) as d23,nvl(d24,0) as d24,nvl(d25,0) as d25,nvl(d26,0) as d26,nvl(d27,0) as d27,nvl(d28,0) as d28,nvl(d29,0) as d29,nvl(d30,0) as d30,nvl(d31,0) as d31 from timecurr.time_ot 
where projno like '09794%' and wpcode = '1')
group by yymm,empno order by yymm,empno
;
