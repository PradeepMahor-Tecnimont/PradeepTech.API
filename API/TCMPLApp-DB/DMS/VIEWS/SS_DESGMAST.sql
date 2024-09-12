--------------------------------------------------------
--  DDL for View SS_DESGMAST
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "SS_DESGMAST" ("DESGCODE", "DESG", "ORD", "SUBCODE") AS 
  select "DESGCODE","DESG","ORD","SUBCODE" from commonmasters.desgmast
;
