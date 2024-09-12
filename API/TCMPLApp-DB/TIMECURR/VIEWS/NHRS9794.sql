--------------------------------------------------------
--  DDL for View NHRS9794
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "TIMECURR"."NHRS9794" ("EMPNO", "YYMM", "PROJNO", "PARENT", "ASSIGN", "D1", "D2", "D3", "D4", "D5", "D6", "D7", "D8", "D9", "D10", "D11", "D12", "D13", "D14", "D15", "D16", "D17", "D18", "D19", "D20", "D21", "D22", "D23", "D24", "D25", "D26", "D27", "D28", "D29", "D30", "D31", "NHRS") AS 
  (SELECT EMPNO,YYMM,PROJNO ,PARENT,ASSIGN,SUM(D1) d1,SUM(D2) d2   ,SUM(D3) d3,SUM(D4) d4 ,
SUM(D5) d5,SUM(D6) d6 ,SUM(D7) d7 ,SUM(D8) d8,SUM(D9) D9 ,SUM(D10) D10,SUM(D11) d11,SUM(D12) d12,SUM(D13) d13 ,SUM(D14) d14,SUM(D15) d15 ,SUM(D16) d16,
SUM(D17) d17 ,SUM(D18) d18,SUM(D19) d19 ,SUM(D20) d20,SUM(D21) d21 ,SUM(D22) d22,SUM(D23) d23 ,SUM(D24) d24,SUM(D25) d25 ,SUM(D26) d26,SUM(D27) d27 ,
SUM(D28) d28,SUM(D29) d29 ,SUM(D30) d30,SUM(D31) d31
,sum(TOTAL) nhrs FROM TIME_DAILY WHERE PROJNO LIKE '09794%' AND YYMM >= '201803' 
GROUP BY EMPNO,YYMM,PROJNO,PARENT,ASSIGN)

--union  all
--select '02320','201805','09794','0106','0160',1,2,3,4,5,6,7,8,9,10,
--11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32 from dual
;
