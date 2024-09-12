--------------------------------------------------------
--  DDL for View ST_VU_PROJMAST
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "ITINV_STK"."ST_VU_PROJMAST" ("PROJNO", "PROJ_NO_5", "NAME", "ACTIVE", "TCMNO") AS 
  select projno, proj_no as proj_no_5 ,name, active, TCMNO from COMMONMASTERS.projmast
;
