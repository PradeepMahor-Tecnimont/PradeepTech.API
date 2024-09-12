--------------------------------------------------------
--  DDL for Procedure GETSHIFT
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "SELFSERVICE"."GETSHIFT" (I_EmpNo In Varchar2, I_Date In Date,
										O_ShiftCode OUT Varchar2, O_SInTime OUT Varchar2,
										O_SOutTime Out Varchar2) IS
		VDay Number;
		VMonYear Varchar2(6);
		IsLOD Number;
BEGIN
  	Select To_Number(To_Char(I_Date,'dd')), To_Char(I_Date,'yyyymm') into VDay, VMonYear From Dual;
  	Select substr(s_mrk,((VDay-1) * 2)+1,2) shiftcode, IsLeaveDepuTour(I_Date,trim(I_EmpNo))  
  		Into O_ShiftCode , IsLOD from ss_muster where mnth = trim(VMonYear) and empno=trim(I_EmpNo);
  	Select TimeIn_HH||':'||TimeIn_MN, TimeOut_HH||':'||TimeOut_MN Into O_SInTime,O_SOutTime
  		from SS_ShiftMast where ShiftCode = O_ShiftCode;

Exception
	when no_data_found Then
		O_ShiftCode := '';
		O_SInTime := '';
		O_SOutTime := '';
END






















;


/
