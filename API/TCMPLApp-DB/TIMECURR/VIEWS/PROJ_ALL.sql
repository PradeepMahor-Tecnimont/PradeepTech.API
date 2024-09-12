--------------------------------------------------------
--  DDL for View PROJ_ALL
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "TIMECURR"."PROJ_ALL" ("PROJNO", "NAME", "ACTIVE", "BU") AS 
  (SELECT PROJNO,NAME,ACTIVE,BU FROM PROJMAST where active = 1  UNION (
SELECT PROJNO,NAME,ACTIVE,BU FROM EXPTJOBS where active = 1 OR ACTIVEFUTURE = 1))

;
