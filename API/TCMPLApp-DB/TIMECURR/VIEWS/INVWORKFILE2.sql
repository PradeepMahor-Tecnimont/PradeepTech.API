--------------------------------------------------------
--  DDL for View INVWORKFILE2
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "TIMECURR"."INVWORKFILE2" ("YYMM", "TCMNO", "COSTCODE", "TLGCODE", "TLPCODE", "DLCODE", "ACTIVITY", "RATE_CODE", "HOURS", "SUBORDER_NO", "C_TYPE", "COMPANY") AS 
  select yymm,tcmno,costcode,tlgcode,tlpcode,dlcode,activity,rate_code,ticb_hrs+subc_hrs as hours,suborder_no,c_type,company from inv_workfile2

;
