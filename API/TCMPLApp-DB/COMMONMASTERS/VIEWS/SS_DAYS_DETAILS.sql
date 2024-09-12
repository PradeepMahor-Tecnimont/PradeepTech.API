--------------------------------------------------------
--  DDL for View SS_DAYS_DETAILS
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "COMMONMASTERS"."SS_DAYS_DETAILS" ("D_DATE", "D_DD", "D_MM", "D_YYYY", "D_MON", "D_DAY", "WK_OF_YEAR") AS 
  Select "D_DATE","D_DD","D_MM","D_YYYY","D_MON","D_DAY","WK_OF_YEAR" from SelfService.SS_Days_details WITH READ ONLY
;
