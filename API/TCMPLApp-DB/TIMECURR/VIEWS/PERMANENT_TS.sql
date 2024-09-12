--------------------------------------------------------
--  DDL for View PERMANENT_TS
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "TIMECURR"."PERMANENT_TS" ("REMARKS", "NAME", "YYMM", "EMPNO", "PARENT", "ASSIGN", "PROJNO", "WPCODE", "ACTIVITY", "D1", "D2", "D3", "D4", "D5", "D6", "D7", "D8", "D9", "D10", "D11", "D12", "D13", "D14", "D15", "D16", "D17", "D18", "D19", "D20", "D21", "D22", "D23", "D24", "D25", "D26", "D27", "D28", "D29", "D30", "D31", "TOTAL", "GRP", "COMPANY") AS 
  (
SELECT 'Normal' Remarks,B.NAME,A."YYMM",A."EMPNO",A."PARENT",A."ASSIGN",A."PROJNO",A."WPCODE",A."ACTIVITY",A."D1",A."D2",A."D3",A."D4",A."D5",A."D6",A."D7",A."D8",A."D9",A."D10",A."D11",A."D12",A."D13",A."D14",A."D15",A."D16",A."D17",A."D18",A."D19",A."D20",A."D21",A."D22",A."D23",A."D24",A."D25",A."D26",A."D27",A."D28",A."D29",A."D30",A."D31",A."TOTAL",A."GRP",A."COMPANY" 
FROM TIME_DAILY  A ,EMPLMAST B 
WHERE A.EMPNO = B.EMPNO 
AND A.EMPNO IN (SELECT EMPNO FROM EMPLMAST WHERE EMPTYPE = 'R')
)
UNION
(
SELECT 'OT' Remarks,B.NAME,A."YYMM",A."EMPNO",A."PARENT",A."ASSIGN",A."PROJNO",A."WPCODE",A."ACTIVITY",A."D1",A."D2",A."D3",A."D4",A."D5",A."D6",A."D7",A."D8",A."D9",A."D10",A."D11",A."D12",A."D13",A."D14",A."D15",A."D16",A."D17",A."D18",A."D19",A."D20",A."D21",A."D22",A."D23",A."D24",A."D25",A."D26",A."D27",A."D28",A."D29",A."D30",A."D31",A."TOTAL",A."GRP",A."COMPANY" 
FROM TIME_ot  A ,EMPLMAST B 
WHERE A.EMPNO = B.EMPNO
AND A.EMPNO IN (SELECT EMPNO FROM EMPLMAST WHERE EMPTYPE = 'R')
)
;
