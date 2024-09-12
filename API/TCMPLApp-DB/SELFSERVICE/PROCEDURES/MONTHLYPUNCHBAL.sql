--------------------------------------------------------
--  DDL for Procedure MONTHLYPUNCHBAL
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "SELFSERVICE"."MONTHLYPUNCHBAL" (v_Month IN Varchar2,v_Year IN Varchar2) IS
		v_Cntr Number;
		Cursor C1 (c_PDate IN Date, c_EmpNo IN Varchar2)is 
		 Select Days, 
		 		IsLComeEGoApp(c_EmpNo,to_date(days||'-'||v_Month||'-'||v_Year,'dd-mm-yyyy')) As IsLComeApp,  
			  IsSLeaveApp(c_EmpNo,to_date(days||'-'||v_Month||'-'||v_Year,'dd-mm-yyyy')) As IsSLeaveApp,  
			  to_char(to_date(days||'-'||v_Month||'-'||v_Year,'dd-mm-yyyy'),'dd-Mon-yyyy') As MDate,  
			  to_char(to_date(days||'-'||v_Month||'-'||v_Year,'dd-mm-yyyy'),'Dy') As sDay,  
			  substr(s_mrk,((days-1) * 2)+1,2) ShiftCode,  
			  IsLeaveDepuTour(to_date(days||'-'||v_Month||'-'||v_Year,'dd-mm-yyyy'),trim(c_EmpNo)) as IsLOD,  
			  IsLastWorkDay(to_date(days||'-'||v_Month||'-'||v_Year,'dd-mm-yyyy')) as IsLastWorkDay,  
			  WorkedHrs1(trim(c_EmpNo),to_date(days||'-'||v_Month||'-'||v_Year,'dd-mm-yyyy'), DeCode(Get_Holiday(To_Date(days||'-'||v_Month||'-'||v_Year,'dd-mm-yyyy')),0,SubStr(s_mrk,((days-1) * 2)+1,2),'NOSHIFT')) as WrkHrs,  
			  AvailedLunchTime(c_EmpNo,to_date(days||'-'||v_Month||'-'||v_Year,'dd-mm-yyyy'),substr(s_mrk,((days-1) * 2)+1,2)) As AvailedLunchTime,  
			  OTPeriod(Trim(c_EmpNo),To_Date(days||'-'||v_Month||'-'||v_Year,'dd-mm-yyyy'), DeCode(Get_Holiday(To_Date(days||'-'||v_Month||'-'||v_Year,'dd-mm-yyyy')),0, SubStr(s_mrk,((days-1) * 2)+1,2),'NOSHIFT')) as OTPeriod  
			  from ss_days, ss_muster  
			  where Days <= to_Number(to_Char(Last_day(to_date('01-'||v_Month||'-'||v_Year,'dd-mm-YYYY')),'dd'))  
			  and trim(mnth) = trim(trim(v_Year) || trim(v_Month))  
			  and empno=trim(c_EmpNo) order by days ;

BEGIN
		v_Cntr := 1;
END;


/
