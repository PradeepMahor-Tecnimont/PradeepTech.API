--------------------------------------------------------
--  DDL for View PROJ_CLIENT
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "TIMECURR"."PROJ_CLIENT" ("PROJNO", "PROJNAME", "CLIENT", "ACTIVE") AS 
  (SELECT a.projno AS projno,
    a.name         AS projname,
    b.name         AS client ,
    a.active       AS active
  FROM commonmasters.proj_all a,
    clntmast b
  WHERE a.client = b.client(+)
  ) 
;
