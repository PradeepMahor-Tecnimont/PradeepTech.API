--------------------------------------------------------
--  DDL for View OFB_VU_DESGMAST
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "TCMPL_HR"."OFB_VU_DESGMAST" ("DESGCODE", "DESG", "ORD", "SUBCODE") AS 
  SELECT 
    "DESGCODE","DESG","ORD","SUBCODE"
FROM 
    
commonmasters.desgmast
;
  GRANT SELECT ON "TCMPL_HR"."OFB_VU_DESGMAST" TO "TCMPL_APP_CONFIG";
