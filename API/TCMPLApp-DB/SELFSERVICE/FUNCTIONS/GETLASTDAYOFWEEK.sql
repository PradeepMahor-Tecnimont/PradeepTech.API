--------------------------------------------------------
--  DDL for Function GETLASTDAYOFWEEK
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SELFSERVICE"."GETLASTDAYOFWEEK" (p_PDate IN Date) RETURN Date IS
		v_WeekFDay Date;
		v_NextDate Date;
		v_LWDay Date;
		v_RetVal Date;
		ExitLoop Number := 0;
		v_LWDay1 Date;
		vn_LWDay Number;
		vn_NextDate Number;
BEGIN
		v_WeekFDay := p_PDate;
		v_NextDate := p_PDate;
		While ExitLoop < 1 Loop

  			Select GetLastWorkingDay(v_NextDate,'+') InTo v_LWDay from dual;
  			vn_LWDay  := To_Number(To_Char(v_LWDay,'d'));
  			vn_NextDate  := To_Number(To_Char(v_NextDate,'d'));
  			If vn_LWDay  < vn_NextDate  Then
  					If vn_LWDay = 1 Then
  							v_RetVal := v_LWDay;
  							ExitLoop := 10;
  					Else
		  					Select GetLastWorkingDay(v_LWDay,'-') InTo v_LWDay1 from dual;
		  					If v_LWDay1 <= v_WeekFDay Then
		  							Select GetLastWorkingDay(v_NextDate,'+') InTo v_WeekFDay from dual;
		  					Else
										v_RetVal := v_NextDate;
										ExitLoop := 10;
		  					End If;
		  			End If;
  			End If;
  			v_NextDate := v_LWDay;
		End Loop;
		Return v_RetVal;
END
;


/
