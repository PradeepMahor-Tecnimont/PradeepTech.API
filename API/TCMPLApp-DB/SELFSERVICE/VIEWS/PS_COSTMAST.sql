--------------------------------------------------------
--  DDL for View PS_COSTMAST
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "SELFSERVICE"."PS_COSTMAST" ("COSTCODE", "NAME", "ABBR", "HOD", "HOD_ABBR", "DY_HOD", "NOOFEMPS", "COSTGROUP", "GROUPS", "TM01_GRP", "TMA_GRP", "COST_TYPE", "ACTIVITY", "GROUP_CHART", "COSTGRP", "ITALIAN_NAME", "BU", "CHANGED_NEMPS", "SECRETARY") AS 
  select "COSTCODE","NAME","ABBR","HOD","HOD_ABBR","DY_HOD","NOOFEMPS","COSTGROUP","GROUPS","TM01_GRP","TMA_GRP","COST_TYPE","ACTIVITY","GROUP_CHART","COSTGRP","ITALIAN_NAME","BU","CHANGED_NEMPS","SECRETARY" from commonmasters.costmast
;
