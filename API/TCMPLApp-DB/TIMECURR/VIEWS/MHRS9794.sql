--------------------------------------------------------
--  DDL for View MHRS9794
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "TIMECURR"."MHRS9794" ("EMPNO", "NAME", "JOBTITLE", "YYMM", "PROJNO", "PARENT", "ASSIGN", "D1", "D2", "D3", "D4", "D5", "D6", "D7", "D8", "D9", "D10", "D11", "D12", "D13", "D14", "D15", "D16", "D17", "D18", "D19", "D20", "D21", "D22", "D23", "D24", "D25", "D26", "D27", "D28", "D29", "D30", "D31", "NHRS") AS 
  (
  (SELECT a.EMPNO,b.name,b.jobtitle,a.YYMM,a.PROJNO ,a.PARENT,a.ASSIGN,SUM(a.D1) d1,SUM(a.D2) d2   ,SUM(a.D3) d3,SUM(a.D4) d4 ,
SUM(a.D5) d5,SUM(a.D6) d6 ,SUM(a.D7) d7 ,SUM(a.D8) d8,SUM(a.D9) D9 ,SUM(a.D10) D10,SUM(a.D11) d11,SUM(a.D12) d12,SUM(a.D13) d13 ,SUM(a.D14) d14,
SUM(a.D15) d15 ,SUM(a.D16) d16,
SUM(a.D17) d17 ,SUM(a.D18) d18,SUM(a.D19) d19 ,SUM(a.D20) d20,SUM(a.D21) d21 ,SUM(a.D22) d22,SUM(a.D23) d23 ,SUM(a.D24) d24,SUM(a.D25) d25 ,
SUM(a.D26) d26,SUM(a.D27) d27 ,
SUM(a.D28) d28,SUM(a.D29) d29 ,SUM(a.D30) d30,SUM(a.D31) d31
,sum(a.TOTAL) nhrs FROM TIME_DAILY A,EMPLMAST B WHERE a.empno = b.empno and A.PROJNO LIKE '09794%' 
GROUP BY A.EMPNO,b.name,b.jobtitle,A.YYMM,A.PROJNO,A.PARENT,A.ASSIGN)
union
  (SELECT a.EMPNO,b.name,b.jobtitle,a.YYMM,a.PROJNO ,a.PARENT,a.ASSIGN,SUM(a.D1) d1,SUM(a.D2) d2   ,SUM(a.D3) d3,SUM(a.D4) d4 ,
SUM(a.D5) d5,SUM(a.D6) d6 ,SUM(a.D7) d7 ,SUM(a.D8) d8,SUM(a.D9) D9 ,SUM(a.D10) D10,SUM(a.D11) d11,SUM(a.D12) d12,SUM(a.D13) d13 ,SUM(a.D14) d14,
SUM(a.D15) d15 ,SUM(a.D16) d16,
SUM(a.D17) d17 ,SUM(a.D18) d18,SUM(a.D19) d19 ,SUM(a.D20) d20,SUM(a.D21) d21 ,SUM(a.D22) d22,SUM(a.D23) d23 ,SUM(a.D24) d24,SUM(a.D25) d25 ,
SUM(a.D26) d26,SUM(a.D27) d27 ,
SUM(a.D28) d28,SUM(a.D29) d29 ,SUM(a.D30) d30,SUM(a.D31) d31
,sum(a.TOTAL) nhrs FROM TIME_ot A,EMPLMAST B WHERE a.empno = b.empno and A.PROJNO LIKE '09794%' 
GROUP BY A.EMPNO,b.name,b.jobtitle,A.YYMM,A.PROJNO,A.PARENT,A.ASSIGN)
)
;
