--------------------------------------------------------
--  DDL for View VU_DESGMAST
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "ITINV_STK"."VU_DESGMAST" ("DESGCODE", "DESG", "ORD", "SUBCODE") AS 
  SELECT 
    "DESGCODE","DESG","ORD","SUBCODE"
FROM 
    
commonmasters.desgmast
;
