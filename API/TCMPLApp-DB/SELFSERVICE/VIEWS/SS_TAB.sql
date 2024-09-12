--------------------------------------------------------
--  DDL for View SS_TAB
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "SELFSERVICE"."SS_TAB" ("TNAME", "TABTYPE", "CLUSTERID") AS 
  select "TNAME","TABTYPE","CLUSTERID" from tab where tname like 'SS_%'
;
