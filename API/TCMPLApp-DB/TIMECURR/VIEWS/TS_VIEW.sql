--------------------------------------------------------
--  DDL for View TS_VIEW
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "TIMECURR"."TS_VIEW" ("YYMM", "EMPNO", "PARENT", "ASSIGN", "LOCKED", "APPROVED", "POSTED", "APPR_ON", "GRP", "TOT_NHR", "TOT_OHR", "COMPANY", "REMARK", "EXCEED", "NAME") AS 
  (SELECT A."YYMM",A."EMPNO",A."PARENT",A."ASSIGN",A."LOCKED",A."APPROVED",A."POSTED",A."APPR_ON",A."GRP",A."TOT_NHR",A."TOT_OHR",A."COMPANY",A."REMARK",A."EXCEED",B.NAME FROM TIME_MAST A,EMPLMAST B WHERE A.EMPNO = B.EMPNO)
;
