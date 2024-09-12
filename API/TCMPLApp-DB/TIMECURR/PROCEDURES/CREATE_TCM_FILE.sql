--------------------------------------------------------
--  DDL for Procedure CREATE_TCM_FILE
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "TIMECURR"."CREATE_TCM_FILE" (
 p_processing_month in timetran.yymm%type
)
cursor c_timetran  is select * tm_timetran_rapper where yymm = p_processing_month;
as
begin
 
null;
 end;

/
