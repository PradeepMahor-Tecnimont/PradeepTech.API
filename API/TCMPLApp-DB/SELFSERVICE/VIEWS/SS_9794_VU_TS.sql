--------------------------------------------------------
--  DDL for View SS_9794_VU_TS
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "SELFSERVICE"."SS_9794_VU_TS" ("YYMM", "EMPNO", "D1", "D2", "D3", "D4", "D5", "D6", "D7", "D8", "D9", "D10", "D11", "D12", "D13", "D14", "D15", "D16", "D17", "D18", "D19", "D20", "D21", "D22", "D23", "D24", "D25", "D26", "D27", "D28", "D29", "D30", "D31") AS 
  Select
    yymm,
    empno,
    Sum(d1) d1,
    Sum(d2) d2,
    Sum(d3) d3,
    Sum(d4) d4,
    Sum(d5) d5,
    Sum(d6) d6,
    Sum(d7) d7,
    Sum(d8) d8,
    Sum(d9) d9,
    Sum(d10) d10,
    Sum(d11) d11,
    Sum(d12) d12,
    Sum(d13) d13,
    Sum(d14) d14,
    Sum(d15) d15,
    Sum(d16) d16,
    Sum(d17) d17,
    Sum(d18) d18,
    Sum(d19) d19,
    Sum(d20) d20,
    Sum(d21) d21,
    Sum(d22) d22,
    Sum(d23) d23,
    Sum(d24) d24,
    Sum(d25) d25,
    Sum(d26) d26,
    Sum(d27) d27,
    Sum(d28) d28,
    Sum(d29) d29,
    Sum(d30) d30,
    Sum(d31) d31
  From
    timecurr.time_09794
 Group By
    yymm,
    empno
;
