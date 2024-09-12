--------------------------------------------------------
--  DDL for View SS_DESG_NAME
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "SELFSERVICE"."SS_DESG_NAME" ("EMPNO", "NAME", "GRADE", "DESG") AS 
  select a.empno,a.name,a.grade,b.desg from ss_emplmast a, ss_desgmast b where a.desgcode = b.desgcode and a.status = 1
order by empno
;
