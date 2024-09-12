--------------------------------------------------------
--  DDL for Procedure N_CFWDDELTAHRS1
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "SELFSERVICE"."N_CFWDDELTAHRS1" (p_EmpNo IN Varchar2, p_PDate IN Date, p_SaveTot In Number,
													p_DeltaHrs Out Number, p_CFwdDeltaHrs Out Number,
													p_LCAppCntr Out Number) IS

-- p_SaveTot - if '1' Then totals of Last Complete Week of the month are stored in the database.
-- p_SaveTot - if '0' Then totals of Last Complete Week of the month are retrived from the database.
    vLWD_DeltaHrs       Number;
BEGIN
    PN.N_CFWD_LWD_DeltaHrs(p_EmpNo,p_PDate, p_SaveTot, p_DeltaHrs, p_CFwdDeltaHrs, p_LCAppCntr);
Exception
		When NO_DATA_FOUND Then
													p_DeltaHrs := 0;
													p_CFwdDeltaHrs := 0;
													p_LCAppCntr :=0;

END
;


/
