--------------------------------------------------------
--  DDL for View PROJECTS
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "TIMECURR"."PROJECTS" ("PROJNO", "NAME") AS 
  select projno,name from projmast

;
