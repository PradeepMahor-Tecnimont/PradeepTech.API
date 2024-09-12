--------------------------------------------------------
--  DDL for View VU_DESGMAST
--------------------------------------------------------

  CREATE OR REPLACE VIEW "VU_DESGMAST" ("DESGCODE", "DESG", "ORD", "SUBCODE") AS 
  select "DESGCODE","DESG","ORD","SUBCODE" from commonmasters.desgmast
;
