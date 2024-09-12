--------------------------------------------------------
--  DDL for Function CFWD_DHRS_WEEK
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SELFSERVICE"."CFWD_DHRS_WEEK" (v_LastDayHrs IN Number, p_isLWD IN Number,
												p_SumDHrs IN Number) RETURN Number IS
		v_RetVal Number;
		v_PenaltyHrs Number;
		v_ActDHRs Number;
BEGIN
		If p_SumDHrs >= 0 Or v_LastDayHrs >= 0 Then
				Return 0;
		End If;
		If p_isLWD = 1 Then
				If v_LastDayHrs <= p_SumDHrs Then
						Return p_SumDHrs;
				Else
						v_ActDHrs := p_SumDHrs + (v_LastDayHrs * -1);
						If v_ActDHrs >= 0 Then
								Return 0;
						End If;
 				  	v_PenaltyHrs := Floor(v_ActDHrs*-1/60);
				  	If v_ActDHrs * -1 > v_PenaltyHrs * 60 Then
				  			v_PenaltyHrs := v_PenaltyHrs + 1;
				  	End If;
				  	If v_PenaltyHrs*60 + p_SumDHrs >= 0 Then
				  			Return 0;
				  	Else
				  			Return v_PenaltyHRs * 60 + p_SumDHrs;
				  	End If;
				End If;
		End If;
END;


/
