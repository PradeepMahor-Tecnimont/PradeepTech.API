--------------------------------------------------------
--  DDL for View ST_IT_ENGR_VU
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "ITINV_STK"."ST_IT_ENGR_VU" ("EMPNO", "NAME") AS 
  select empno, name from st_emplmast_vu where parent in ('0106','0107','0119')
;
