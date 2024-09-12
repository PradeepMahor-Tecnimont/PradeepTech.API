--------------------------------------------------------
--  DDL for Function AVAILEDLUNCHTIME1
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SELFSERVICE"."AVAILEDLUNCHTIME1" (
      p_EmpNo IN VARCHAR2, p_Date  IN DATE, p_SCode IN VARCHAR2) RETURN NUMBER IS


    CURSOR C1 IS  SELECT * FROM SS_IntegratedPunch WHERE EmpNo = ltrim(rtrim(p_EmpNo))
      AND PDate   = p_date and falseflag=1 ORDER BY PDate, hhsort,
        mmsort, hh, mm;
    Type TabHrsRec  IS record ( punch_hrs NUMBER);
    Type TabHrs IS TABLE OF TabHrsRec INDEX BY Binary_Integer;
    V_TabHrs TabHrs;
    vCntr       NUMBER;
    vParent     CHAR(4);
    vL_StartHrs NUMBER ;
    vL_EndHrs   NUMBER ;
    vFirstPunch NUMBER ;
    vLastPunch  NUMBER ;
    vLunchDura  NUMBER ;
    vNextPunch  NUMBER ;
BEGIN
  SELECT COUNT(*) INTO vCntr FROM ss_integratedpunch
  WHERE empno                         = p_empno
  AND pdate                           = p_date;
  IF IsLeaveDepuTour(p_Date, p_EmpNo) > 0 OR vCntr < 2 THEN
    RETURN 0;
  END IF;
  vCntr  := 1;
  FOR C2 IN C1
  LOOP
    V_TabHrs(vCntr).punch_Hrs := (C2.HH * 60) + C2.MM;
    --V_TabHrs(Cntr).TabMns := C2.MM;
    vCntr := vCntr + 1;
  END LOOP;
  SELECT parent INTO vParent FROM ss_emplmast WHERE empno = trim(p_empno);
  --if p_scode in ('XX', 'MM') Then
  IF trim(p_sCode) IN ('OO','HH') THEN
    vL_StartHrs   := 720;
    vL_EndHrs     := 840;
    vlunchdura    := 30;
  ELSE
    SELECT (StartHH *60) + StartMN,
      (EndHH        * 60) + EndMN
    INTO vL_StartHrs,
      vL_EndHrs
    FROM SS_LunchMast
    WHERE ShiftCode = Ltrim(RTrim(p_SCode))
    AND Parent      = Ltrim(RTrim(vParent));
    SELECT NVL(lunch_mn,0)
    INTO vLunchDura
    FROM ss_shiftmast
    WHERE shiftcode = p_scode;
  END IF;
  vCntr          := vCntr - 1;
  IF vL_StartHrs >= v_tabhrs(vCntr).Punch_hrs OR vL_StartHrs <= v_tabhrs(1).Punch_hrs THEN
    RETURN 0;
  END IF;
  IF vCntr                    = 2 THEN
    IF v_tabhrs(1).Punch_hrs <= vL_StartHrs AND v_tabhrs(2).Punch_hrs >= (vL_StartHrs + vLunchDura) THEN
      RETURN vLunchDura;
      --elsif v_tabhrs(1).Punch_hrs <= vL_StartHrs AND v_tabhrs(2).Punch_hrs <= (vL_StartHrs + vLunchDura) THEN
      --return (vL_StartHrs + vLunchDura) - v_tabhrs(2).Punch_hrs;
    ElsIf v_tabhrs(1).Punch_hrs <= vL_StartHrs AND v_tabhrs(2).Punch_hrs >= (vL_StartHrs ) THEN
      If v_tabhrs(2).Punch_hrs - (vL_StartHrs) <  vLunchDura THEN
        vLunchDura  := v_tabhrs(2).Punch_hrs - (vL_StartHrs);
      End If;
    END IF;
  END IF;
  IF v_tabhrs(1).punch_hrs                >= vL_StartHrs AND v_tabhrs(1).punch_hrs <= vL_EndHrs THEN
    IF v_tabhrs(1).punch_hrs       - vL_StartHrs < vLunchDura THEN
      RETURN v_tabhrs(1).punch_hrs - vL_StartHrs ;
    END IF;
  END IF;

  IF v_tabhrs(vCntr).punch_hrs                >= vL_StartHrs AND v_tabhrs(vCntr).punch_hrs <= vL_EndHrs THEN
    IF v_tabhrs(vCntr).punch_hrs       - vL_StartHrs < vLunchDura THEN
      RETURN v_tabhrs(vCntr).punch_hrs - vL_StartHrs ;
    END IF;
  END IF;

  FOR i IN 1 .. vCntr  LOOP
    IF i mod 2                                                    = 0 THEN
      IF i                                                        < vCntr THEN
        IF v_tabhrs(i).punch_Hrs                                 >= vL_StartHrs AND v_tabhrs(i).punch_Hrs <= vL_EndHrs THEN
          vNextPunch := Least(v_tabhrs(i + 1).punch_hrs, vL_EndHrs);

          IF (vNextPunch - v_tabhrs(i).punch_hrs) >= vLunchDura THEN
            RETURN 0;
            exit;
          ElsIf (vNextPunch - v_tabhrs(i).punch_hrs) > 0 AND (vNextPunch - v_tabhrs(i).punch_hrs) < vLunchDura THEN
            RETURN vLunchDura - (vNextPunch - v_tabhrs(i).punch_hrs);
            Exit;
          END IF;
        END IF;
      END IF;
    END IF;
  END LOOP;
  RETURN vLunchDura;
  --END ;
  -- v_RetVal   Number := 0;
  -- vParent    Varchar2(4);
  -- vStartHH    Number := 0;
  -- vStartMN    Number := 0;
  -- vEndHH     Number := 0;
  -- vEndMN     Number := 0;
  -- vFirstPunch  Number := 0;
  -- vLastPunch   Number := 0;
  --BEGIN
  --
  -- vFirstPunch := FirstLastPunch1(I_EmpNo,I_PDate,0);
  -- vLastPunch := FirstLastPunch1(I_EmpNo,I_PDate,1);
  --
  /*Select FirstLastPunch1(I_EmpNo,I_PDate,0), FirstLastPunch1(I_EmpNo,I_PDate,1)
  InTo vFirstPunch, vLastPunch
  From Dual;*/
  /*If I_PDate <= To_Date('27-Jul-2003') Then*/
  --   If Ltrim(Rtrim(I_SCode)) = 'OO' Or Ltrim(Rtrim(I_SCode)) = 'HH' Then
  --     If vFirstPunch < 720 And vLastPunch > 820 Then
  --       v_RetVal := 30;
  --     End If;
  --     Return v_RetVal;
  --   End If;
  --   Select Assign InTo vParent From SS_EmplMast Where EmpNo = Ltrim(RTrim(I_EmpNo));
  --   Select StartHH, StartMN, EndHH, EndMN
  --    InTo vStartHH, vStartMN, vEndHH, vEndMN
  --    From SS_LunchMast Where ShiftCode = Ltrim(RTrim(I_SCode)) And Parent = Ltrim(RTrim(vParent));
  --   If vFirstPunch >= (vEndHH * 60) + vEndMN Then
  --     Return 0;
  --   ElsIf vLastPunch <= (vStartHH * 60) + vStartMN Then
  --     Return 0;
  --   ElsIf vFirstPunch <= (vStartHH * 60) + vStartMN And vLastPunch >= ((vEndHH * 60) + vEndMN) Then
  --     Return ((vEndHH * 60) + vEndMN) - ((vStartHH * 60) + vStartMN);
  --   ElsIf (vFirstPunch > (vStartHH * 60) + vStartMN) And (vFirstPunch < (vEndHH * 60) + vEndMN) And vLastPunch >= (vEndHH * 60) + vEndMN Then
  --     Return ((vEndHH * 60) + vEndMN) - vFirstPunch;
  --   ElsIf (vFirstPunch < (vStartHH * 60) + vStartMN) And (vLastPunch < (vEndHH * 60) + vEndMN) And vLastPunch >= (vStartHH * 60) + vStartMN Then
  --     Return vLastPunch - ((vStartHH * 60) + vStartMN);
  --   ElsIf (vFirstPunch > (vStartHH * 60) + vStartMN) And (vLastPunch < (vEndHH * 60) + vEndMN) Then
  --     Return vLastPunch - vFirstPunch;
  --   ElsIf NVL(LTrim(rTrim(vFirstPunch)),0) = 0 Then
  --     Return 0;
  --   ElsIf IsLeaveDepuTour(I_PDate, I_EmpNo) > 0 Then
  --     Return 0;
  --   Else
  --     Return 30;
  --   End If;
  /*Else
  If I_SCode = 'OO' Or I_SCode = 'HH' Then
  vStartHH := 12;
  vStartMN := 0;
  vEndHH   := 13;
  vEndMN   := 40;
  Else
  Select Assign InTo vParent From SS_EmplMast Where EmpNo = Ltrim(RTrim(I_EmpNo));
  Select StartHH, StartMN, EndHH, EndMN
  InTo vStartHH, vStartMN, vEndHH, vEndMN
  From SS_LunchMast Where ShiftCode = Ltrim(RTrim(I_SCode)) And Parent = Ltrim(RTrim(vParent));
  End If;
  If vFirstPunch >= (vEndHH * 60) + vEndMN Then
  Return 0;
  ElsIf vLastPunch <= (vStartHH * 60) + vStartMN Then
  Return 0;
  ElsIf vFirstPunch <= (vStartHH * 60) + vStartMN And vLastPunch >= ((vEndHH * 60) + vEndMN) Then
  If I_SCode = 'OO' Or I_SCode = 'HH' Then
  v_RetVal := ((vEndHH * 60) + vEndMN) - ((vStartHH * 60) + vStartMN);
  Select Least(v_RetVal,30) InTo v_RetVal From Dual;
  Return v_RetVal;
  Else
  Return ((vEndHH * 60) + vEndMN) - ((vStartHH * 60) + vStartMN);
  End If;
  ElsIf (vFirstPunch > (vStartHH * 60) + vStartMN) And (vFirstPunch < (vEndHH * 60) + vEndMN) And vLastPunch >= (vEndHH * 60) + vEndMN Then
  If I_SCode = 'OO' Or I_SCode = 'HH' Then
  v_RetVal := ((vEndHH * 60) + vEndMN) - vFirstPunch;
  Select Least(v_RetVal,30) InTo v_RetVal From Dual;
  Return v_RetVal;
  Else
  Return ((vEndHH * 60) + vEndMN) - vFirstPunch;
  End If;
  ElsIf (vFirstPunch < (vStartHH * 60) + vStartMN) And (vLastPunch < (vEndHH * 60) + vEndMN) And vLastPunch >= (vStartHH * 60) + vStartMN Then
  If I_SCode = 'OO' Or I_SCode = 'HH' Then
  v_RetVal := vLastPunch - ((vStartHH * 60) + vStartMN);
  Select Least(v_RetVal,30) InTo v_RetVal From Dual;
  Return v_RetVal;
  Else
  Return vLastPunch - ((vStartHH * 60) + vStartMN);
  End If;
  ElsIf (vFirstPunch > (vStartHH * 60) + vStartMN) And (vLastPunch < (vEndHH * 60) + vEndMN) Then
  If I_SCode = 'OO' Or I_SCode = 'HH' Then
  v_RetVal := vLastPunch - vFirstPunch;
  Select Least(v_RetVal,30) InTo v_RetVal From Dual;
  Return v_RetVal;
  Else
  Return vLastPunch - vFirstPunch;
  End If;
  ElsIf NVL(LTrim(rTrim(vFirstPunch)),0) = 0 Then
  Return 0;
  ElsIf IsLeaveDepuTour(I_PDate, I_EmpNo) > 0 Then
  Return 0;
  Else
  Return 30;
  End If;
  End If;  */
EXCEPTION
WHEN OTHERS THEN
  RETURN 30;
END;


/
