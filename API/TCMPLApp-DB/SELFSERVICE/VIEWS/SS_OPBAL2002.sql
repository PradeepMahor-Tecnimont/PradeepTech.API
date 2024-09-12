--------------------------------------------------------
--  DDL for View SS_OPBAL2002
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "SELFSERVICE"."SS_OPBAL2002" ("EMPNO", "BALDATE", "SL_BAL", "PL_BAL", "CL_BAL", "EX_BAL") AS 
  select "EMPNO","BALDATE","SL_BAL","PL_BAL","CL_BAL","EX_BAL" from ss_leavebal where baldate='1-jan-2002'
;
