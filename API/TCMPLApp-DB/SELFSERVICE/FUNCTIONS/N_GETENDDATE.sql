--------------------------------------------------------
--  DDL for Function N_GETENDDATE
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SELFSERVICE"."N_GETENDDATE" (p_MM In Varchar2, p_YYYY In Varchar2) RETURN Date IS
	v_dDate Date;
	v_RetDate Date;
	v_WeekNo Number;
	v_Date Date;
BEGIN
	v_Date := To_Date('1-' || p_MM || '-' || p_YYYY, 'dd-mm-yyyy');
	v_dDate := Last_Day(v_Date);
	If To_Char(v_dDate,'DY') = 'SUN' Then
			Return v_dDate;
	Else
			Select To_Number(To_Char(v_dDate,'IW')) InTo v_WeekNo From Dual;

			Select Max(D_Date) InTo v_RetDate From SS_Days_Details 
				Where D_YYYY = To_Char(v_dDate,'yyyy') 
					And D_MM = LPad(To_Char(v_dDate,'MM'),2,'0')
					And To_Number(Wk_Of_Year) <> v_WeekNo; 

			Return v_RetDate;
	End If;
Exception
		When others then
			return null;
END;


/
