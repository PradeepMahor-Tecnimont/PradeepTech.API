--------------------------------------------------------
--  DDL for View SS_VU_MANUAL_PUNCH
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "SELFSERVICE"."SS_VU_MANUAL_PUNCH" ("EMPNO", "HH", "MM", "SS", "PDATE", "DD", "MON", "YYYY", "HHSORT", "MMSORT", "FROMTAB", "TYPE", "ODTYPE", "MACH", "FALSEFLAG") AS 
  select "EMPNO","HH","MM","SS","PDATE","DD","MON","YYYY","HHSORT","MMSORT","FROMTAB","TYPE","ODTYPE","MACH","FALSEFLAG" from ss_integratedpunch
where mach<>'WFH0'
;
