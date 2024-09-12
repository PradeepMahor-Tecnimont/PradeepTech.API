--------------------------------------------------------
--  DDL for View ST_EMPLMAST_VU
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "ITINV_STK"."ST_EMPLMAST_VU" ("EMPNO", "NAME", "PARENT") AS 
  select empno,name,parent from commonmasters.emplmast where status=1
;
