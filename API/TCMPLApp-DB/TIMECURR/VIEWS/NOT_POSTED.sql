--------------------------------------------------------
--  DDL for View NOT_POSTED
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "TIMECURR"."NOT_POSTED" ("YYMM", "EMPNO", "NAME", "PARENT", "ASSIGN", "LOCKED", "APPROVED", "POSTED", "APPR_ON", "GRP", "TOT_NHR", "TOT_OHR", "COMPANY", "REMARK", "EXCEED") AS 
  (SELECT a.YYMM,
    a.EMPNO,
    b.name,
    a.PARENT,
    a.ASSIGN,
    a.LOCKED,
    a.APPROVED,
    a.POSTED,
    a.APPR_ON,
    a.GRP,
    a.TOT_NHR,
    a.TOT_OHR,
    a.COMPANY,
    a.REMARK,
    a.EXCEED
  FROM time_mast a,
    emplmast b
  WHERE a.empno   = b.empno
  AND a.posted    = 0)
;
