--------------------------------------------------------
--  DDL for Function GETODHH
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SELFSERVICE"."GETODHH" (p_AppNo IN Varchar2, p_Time IN Number) RETURN Number IS
		v_Button Number;
		v_ODRow SS_OnDutyApp%RowType;
		v_Count Number;
BEGIN
		Select count(*) InTo v_Count from SS_OnDutyApp Where App_No = Ltrim(Rtrim(p_Appno));
		If v_Count <> 1 Then
				Return 0;
		End If;
  	Select * Into v_ODRow from SS_OnDutyApp Where App_No = Ltrim(Rtrim(p_Appno));
  	If v_ODRow.ODType = 1 Then
				Return Nvl(v_ODRow.HH,0);
  	ElsIf v_ODRow.ODType = 2 Then
  			If p_Time = 1 Then
  					Return Nvl(v_ODRow.HH,0);
  			ElsIf p_Time = 2 Then
  					Return Nvl(v_ODRow.HH1,0);
  			End If;
  	ElsIf v_ODRow.ODType = 3 Then
				Return Nvl(v_ODRow.HH1,0);
  	ElsIf v_ODRow.ODType = 4 Then
  			If p_Time = 1 Then
  					Return Nvl(v_ODRow.HH,0);
  			ElsIf p_Time = 2 Then
  					Return Nvl(v_ODRow.HH1,0);
  			End If;
  	Else
  			If p_Time = 1 Then
  					Return Nvl(v_ODRow.HH,0);
  			ElsIf p_Time = 2 Then
  					Return Nvl(v_ODRow.HH1,0);
  			End If;
  	End If;
END;


/
