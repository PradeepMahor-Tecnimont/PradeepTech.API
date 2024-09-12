--------------------------------------------------------
--  DDL for View DDDD_U_23
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "TIMECURR"."DDDD_U_23" ("REMARKS", "YYMM", "EMPNO", "ASSIGN", "PROJNO", "ADJ", "ACTUAL_1", "ACTUAL_2", "ESTIMATE_1", "ESTIMATE_2") AS 
  (
select 'Normal' Remarks ,a."YYMM",a."EMPNO",a."ASSIGN",a."PROJNO",a."ADJ",a."ACTUAL_1",a."ACTUAL_2",a."ESTIMATE_1",a."ESTIMATE_2" from dddd_23 a 
union
select 'OT' Remarks ,b."YYMM",b."EMPNO",b."ASSIGN",b."PROJNO",b."ADJ_OT",b."ACTUAL_1_OT",b."ACTUAL_2_OT",b."ESTIMATE_1_OT",b."ESTIMATE_2_OT" from dddd_o_23 b 
)
;
