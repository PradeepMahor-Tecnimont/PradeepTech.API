--------------------------------------------------------
--  DDL for View EMPTYPEMAST
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "COMMONMASTERS"."EMPTYPEMAST" ("EMPTYPE", "EMPDESC", "EMPREMARKS", "TM", "PRINTLOGO", "SORTORDER") AS 
  select "EMPTYPE","EMPDESC","EMPREMARKS","TM","PRINTLOGO","SORTORDER" from timecurr.emptypemast
;
  GRANT SELECT ON "COMMONMASTERS"."EMPTYPEMAST" TO "SELFSERVICE" WITH GRANT OPTION;
