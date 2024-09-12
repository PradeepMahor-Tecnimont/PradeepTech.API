--------------------------------------------------------
--  DDL for Function GETDISCREPANCYCNT
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SELFSERVICE"."GETDISCREPANCYCNT" (v_appno in varchar2) RETURN Number IS
v_len number := 0;
BEGIN
  select length(discrepancy) into v_len from ss_leaveapp where app_no = v_appno and discrepancy is not null;
  if v_len <= 8 then 
  	return 0;
  else
  	return 1;
  end if;
  exception 
  	when no_Data_found then
  	return 0;
  	when others then
  	return 0;
END;


/
