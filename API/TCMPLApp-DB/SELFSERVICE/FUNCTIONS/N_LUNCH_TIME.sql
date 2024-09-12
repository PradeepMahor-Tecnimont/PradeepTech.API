--------------------------------------------------------
--  DDL for Function N_LUNCH_TIME
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SELFSERVICE"."N_LUNCH_TIME" 
(
  P_EMPNO IN VARCHAR2  
, P_DATE IN DATE  
, P_SCODE IN VARCHAR2  
) RETURN NUMBER AS 
	Cursor C1 is select * from SS_IntegratedPunch 
		where EmpNo = ltrim(rtrim(p_EmpNo))
		and PDate = p_date order by PDate,hhsort,mmsort,hh,mm;
	Type TabHrsRec is record (punch_hrs number);
	Type TabHrs  is table of TabHrsRec index by Binary_Integer;
	V_TabHrs TabHrs;
	vCntr Number;
  vParent char(4);
	vL_StartHrs 			Number ;
	vL_EndHrs 				Number ;
	vFirstPunch 	Number ;
	vLastPunch 		Number ;
  vLunchDura    Number ;
BEGIN
	vCntr := 1;
	For C2 in C1 Loop
		V_TabHrs(vCntr).punch_Hrs := (C2.HH * 60) + C2.MM;
		--V_TabHrs(Cntr).TabMns := C2.MM;
		vCntr := vCntr + 1;
	End Loop;
  select parent into vParent from ss_emplmast where empno = trim(p_empno);

  Select (StartHH *60) + StartMN, (EndHH * 60) + EndMN 
    InTo vL_StartHrs, vL_EndHrs
    From SS_LunchMast Where ShiftCode = Ltrim(RTrim(p_SCode)) And Parent = Ltrim(RTrim(vParent));
  select Nvl(lunch_mn,0) into vLunchDura from ss_shiftmast where shiftcode = p_scode;

  If vCntr < 3 Then
    return vLunchDura;
----------->>>> Return    
  End If;
  vCntr := vCntr - 1;
  If v_tabhrs(1).punch_hrs >= vL_StartHrs and v_tabhrs(1).punch_hrs >= vL_EndHrs Then
    If v_tabhrs(1).punch_hrs - vL_StartHrs < vLunchDura Then
      Return v_tabhrs(1).punch_hrs - vL_StartHrs ;
    End If;
  End If;
  for i in 1 .. vCntr Loop
    If i mod 2 = 0 then
      If i < vCntr Then
        If v_tabhrs(i).punch_Hrs >= vL_StartHrs and v_tabhrs(i).punch_Hrs <= vL_EndHrs Then

          If (v_tabhrs(i + 1).punch_hrs - v_tabhrs(i).punch_hrs) >= vLunchDura Then 
            Return 0;
          ElsIf (v_tabhrs(i + 1).punch_hrs - v_tabhrs(i).punch_hrs) >= 0 And (v_tabhrs(i + 1).punch_hrs - v_tabhrs(i).punch_hrs) < vLunchDura Then 
            Return vLunchDura - (v_tabhrs(i + 1).punch_hrs - v_tabhrs(i).punch_hrs);
          End If;
        End If;
      End If;
    end if;
  End Loop;
  return vLunchDura;
END N_LUNCH_TIME;


/
