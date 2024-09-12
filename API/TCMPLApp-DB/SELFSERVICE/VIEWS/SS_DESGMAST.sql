--------------------------------------------------------
--  DDL for View SS_DESGMAST
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "SELFSERVICE"."SS_DESGMAST" ("DESGCODE", "DESG", "ORD", "SUBCODE") AS 
  select "DESGCODE","DESG","ORD","SUBCODE" from commonmasters.desgmast
;
  GRANT SELECT ON "SELFSERVICE"."SS_DESGMAST" TO "TCMPL_APP_CONFIG";
