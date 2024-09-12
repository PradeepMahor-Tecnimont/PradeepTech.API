--------------------------------------------------------
--  DDL for Function ISLASTWORKDAY1
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SELFSERVICE"."ISLASTWORKDAY1" (p_EmpNo IN Varchar2, p_Date IN Date) RETURN Number IS 
		v_ShiftCode Varchar2(30);
		i Number;
		day1 varchar2(30);
BEGIN
	  Select GetShift1(p_EmpNo,p_Date) InTo v_ShiftCode From Dual;
	  If Ltrim(Rtrim(v_ShiftCode)) = 'HH' Or Ltrim(Rtrim(v_ShiftCode)) = 'OO' Then
	  		return 0;
	  Else
			  For i In 1..8 Loop
	  				Select GetShift1(p_EmpNo,p_Date+i) InTo v_ShiftCode From Dual;
	  				day1 := to_Char(p_Date+i,'day');
			  		If Ltrim(Rtrim(day1)) = 'sunday' Then
			  				Return 1;
			  		End If;
			  		If Ltrim(Rtrim(v_ShiftCode)) <> 'HH' And Ltrim(Rtrim(v_ShiftCode)) <> 'OO' Then
			  				Return 0;
			  		End If;
			  End Loop;
		End If;
END;


/
