--------------------------------------------------------
--  DDL for View SS_PUNCH
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "SS_PUNCH" ("EMPNO", "HH", "MM", "PDATE", "FALSEFLAG", "DD", "MON", "YYYY", "MACH", "SS") AS 
  select "EMPNO","HH","MM","PDATE","FALSEFLAG","DD","MON","YYYY","MACH","SS" from selfservice.ss_punch
;
