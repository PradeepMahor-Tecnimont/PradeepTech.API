--------------------------------------------------------
--  DDL for View OFB_VU_COSTMAST
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "TCMPL_HR"."OFB_VU_COSTMAST" ("COSTCODE", "NAME", "ABBR", "HOD", "HOD_ABBR", "DY_HOD", "NOOFEMPS", "COSTGROUP", "GROUPS", "TM01_GRP", "TMA_GRP", "COST_TYPE", "ACTIVITY", "GROUP_CHART", "COSTGRP", "ITALIAN_NAME", "BU", "CHANGED_NEMPS", "INOFFICE", "SECRETARY", "COMP", "ACTIVE", "SDATE", "EDATE", "PHASE", "SAPCC", "CLOSED", "PARENT_COSTCODE") AS 
  SELECT 
    "COSTCODE","NAME","ABBR","HOD","HOD_ABBR","DY_HOD","NOOFEMPS","COSTGROUP","GROUPS","TM01_GRP","TMA_GRP","COST_TYPE","ACTIVITY","GROUP_CHART","COSTGRP","ITALIAN_NAME","BU","CHANGED_NEMPS","INOFFICE","SECRETARY","COMP","ACTIVE","SDATE","EDATE","PHASE","SAPCC","CLOSED","PARENT_COSTCODE"
FROM 
    commonmasters.costmast
;
  GRANT SELECT ON "TCMPL_HR"."OFB_VU_COSTMAST" TO "TCMPL_APP_CONFIG";
