--------------------------------------------------------
--  DDL for Function AVAILEDLUNCHTIME1_COPY
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SELFSERVICE"."AVAILEDLUNCHTIME1_COPY" (
    p_empno   In        Varchar2,
    p_date    In        Date,
    p_scode   In        Varchar2
) Return Number Is

    Cursor c1 Is
    Select
        *
    From
        ss_integratedpunch
    Where
        empno = Ltrim(Rtrim(p_empno))
        And pdate      = p_date
        And falseflag  = 1
    Order By
        pdate,
        hhsort,
        mmsort,
        hh,
        mm;

    Type tab_hrs_rec Is Record (
        punch_hrs           Number
    );
    Type tab_hrs Is
        Table Of tab_hrs_rec Index By Binary_Integer;
    v_tab_hrs           tab_hrs;
    v_cntr              Number;
    v_parent            Char(4);
    v_lunch_start_hrs   Number;
    v_lunch_end_hrs     Number;
    v_first_punch       Number;
    v_last_punch        Number;
    v_lunch_dura        Number;
    v_next_punch        Number;
    v_act_lunch_hrs     Number;
Begin
    Select
        Count(*)
    Into v_cntr
    From
        ss_integratedpunch
    Where
        empno = p_empno
        And pdate = p_date;

    If isleavedeputour(
        p_date,
        p_empno
    ) > 0 Or v_cntr < 2 Then
        Return 0;
    End If;

    v_cntr   := 1;
    For c2 In c1 Loop
        v_tab_hrs(v_cntr).punch_hrs   := ( c2.hh * 60 ) + c2.mm;
    --V_tab_hrs(Cntr).TabMns := C2.MM;

        v_cntr                        := v_cntr + 1;
    End Loop;

    Select
        parent
    Into v_parent
    From
        ss_emplmast
    Where
        empno = Trim(p_empno);
  --if p_scode in ('XX', 'MM') Then

    If Trim(p_scode) In (
        'OO',
        'HH'
    ) Then
        v_lunch_start_hrs   := 720;
        v_lunch_end_hrs     := 840;
        v_lunch_dura        := 30;
    Else
        Select
            ( starthh * 60 ) + startmn,
            ( endhh * 60 ) + endmn
        Into
            v_lunch_start_hrs,
            v_lunch_end_hrs
        From
            ss_lunchmast
        Where
            shiftcode = Ltrim(Rtrim(p_scode))
            And parent = Ltrim(Rtrim(v_parent));

        Select
            Nvl(lunch_mn, 0)
        Into v_lunch_dura
        From
            ss_shiftmast
        Where
            shiftcode = p_scode;

    End If;

    v_cntr   := v_cntr - 1;
    If v_lunch_start_hrs >= v_tab_hrs(v_cntr).punch_hrs Or v_lunch_start_hrs <= v_tab_hrs(1).punch_hrs Then
        Return 0;
    End If;

    If v_cntr = 2 Then
        If v_tab_hrs(1).punch_hrs <= v_lunch_start_hrs And v_tab_hrs(2).punch_hrs >= ( v_lunch_start_hrs + v_lunch_dura ) Then
            Return v_lunch_dura;
      --elsif v_tab_hrs(1).Punch_hrs <= v_lunch_start_hrs AND v_tab_hrs(2).Punch_hrs <= (v_lunch_start_hrs + v_lunch_dura) THEN
      --return (v_lunch_start_hrs + v_lunch_dura) - v_tab_hrs(2).Punch_hrs;
        Elsif v_tab_hrs(1).punch_hrs <= v_lunch_start_hrs And v_tab_hrs(2).punch_hrs >= ( v_lunch_start_hrs ) Then
            If v_tab_hrs(2).punch_hrs - ( v_lunch_start_hrs ) < v_lunch_dura Then
                v_lunch_dura := v_tab_hrs(2).punch_hrs - ( v_lunch_start_hrs );
            End If;
        End If;
    End If;

    If v_tab_hrs(1).punch_hrs >= v_lunch_start_hrs And v_tab_hrs(1).punch_hrs <= v_lunch_end_hrs Then
        If v_tab_hrs(1).punch_hrs - v_lunch_start_hrs < v_lunch_dura Then
            Return v_tab_hrs(1).punch_hrs - v_lunch_start_hrs;
        End If;
    End If;

    --When last punch is between Lunch Start Time and Lunch Duration

    If v_tab_hrs(v_cntr).punch_hrs >= v_lunch_start_hrs And v_tab_hrs(v_cntr).punch_hrs <= v_lunch_end_hrs Then
        For i In 1..v_cntr Loop 
        --
            If i Mod 2 = 0 Then
                Continue;
            End If;
            If v_tab_hrs(i).punch_hrs > v_lunch_end_hrs Then
                Exit;
            End If;
            If v_tab_hrs(i).punch_hrs >= v_lunch_start_hrs Then
                v_act_lunch_hrs := Nvl(v_act_lunch_hrs, 0) + v_tab_hrs(i + 1).punch_hrs - v_tab_hrs(i).punch_hrs;
            Else
                If v_tab_hrs(i + 1).punch_hrs >= v_lunch_start_hrs Then
                    v_act_lunch_hrs := v_tab_hrs(i + 1).punch_hrs - v_lunch_start_hrs;
                End If;
            End If;

        End Loop;

        Return Least(v_act_lunch_hrs, v_lunch_dura);
        /*
        If v_tab_hrs(v_cntr).punch_hrs - v_lunch_start_hrs < v_lunch_dura Then
            Return v_tab_hrs(v_cntr).punch_hrs - v_lunch_start_hrs;
        End If;
        */
    End If;

    For i In 1..v_cntr Loop 
    --

     If i Mod 2 = 0 Then
        If i < v_cntr Then
            If v_tab_hrs(i).punch_hrs >= v_lunch_start_hrs And v_tab_hrs(i).punch_hrs <= v_lunch_end_hrs Then
                v_next_punch := Least(v_tab_hrs(i + 1).punch_hrs, v_lunch_end_hrs);
                If ( v_next_punch - v_tab_hrs(i).punch_hrs ) >= v_lunch_dura Then
                    Return 0;
                    Exit;
                Elsif ( v_next_punch - v_tab_hrs(i).punch_hrs ) > 0 And ( v_next_punch - v_tab_hrs(i).punch_hrs ) < v_lunch_dura Then
                    Return v_lunch_dura - ( v_next_punch - v_tab_hrs(i).punch_hrs );
                    Exit;
                End If;

            End If;

        End If;

    End If;
    End Loop;

    Return v_lunch_dura;
  --END ;
  -- v_RetVal   Number := 0;
  -- v_parent    Varchar2(4);
  -- vStartHH    Number := 0;
  -- vStartMN    Number := 0;
  -- vEndHH     Number := 0;
  -- vEndMN     Number := 0;
  -- v_first_punch  Number := 0;
  -- v_last_punch   Number := 0;
  --BEGIN
  --
  -- v_first_punch := FirstLastPunch1(I_EmpNo,I_PDate,0);
  -- v_last_punch := FirstLastPunch1(I_EmpNo,I_PDate,1);
  --
  /*Select FirstLastPunch1(I_EmpNo,I_PDate,0), FirstLastPunch1(I_EmpNo,I_PDate,1)
  InTo v_first_punch, v_last_punch
  From Dual;*/
  /*If I_PDate <= To_Date('27-Jul-2003') Then*/
  --   If Ltrim(Rtrim(I_SCode)) = 'OO' Or Ltrim(Rtrim(I_SCode)) = 'HH' Then
  --     If v_first_punch < 720 And v_last_punch > 820 Then
  --       v_RetVal := 30;
  --     End If;
  --     Return v_RetVal;
  --   End If;
  --   Select Assign InTo v_parent From SS_EmplMast Where EmpNo = Ltrim(RTrim(I_EmpNo));
  --   Select StartHH, StartMN, EndHH, EndMN
  --    InTo vStartHH, vStartMN, vEndHH, vEndMN
  --    From SS_LunchMast Where ShiftCode = Ltrim(RTrim(I_SCode)) And Parent = Ltrim(RTrim(v_parent));
  --   If v_first_punch >= (vEndHH * 60) + vEndMN Then
  --     Return 0;
  --   ElsIf v_last_punch <= (vStartHH * 60) + vStartMN Then
  --     Return 0;
  --   ElsIf v_first_punch <= (vStartHH * 60) + vStartMN And v_last_punch >= ((vEndHH * 60) + vEndMN) Then
  --     Return ((vEndHH * 60) + vEndMN) - ((vStartHH * 60) + vStartMN);
  --   ElsIf (v_first_punch > (vStartHH * 60) + vStartMN) And (v_first_punch < (vEndHH * 60) + vEndMN) And v_last_punch >= (vEndHH * 60) + vEndMN Then
  --     Return ((vEndHH * 60) + vEndMN) - v_first_punch;
  --   ElsIf (v_first_punch < (vStartHH * 60) + vStartMN) And (v_last_punch < (vEndHH * 60) + vEndMN) And v_last_punch >= (vStartHH * 60) + vStartMN Then
  --     Return v_last_punch - ((vStartHH * 60) + vStartMN);
  --   ElsIf (v_first_punch > (vStartHH * 60) + vStartMN) And (v_last_punch < (vEndHH * 60) + vEndMN) Then
  --     Return v_last_punch - v_first_punch;
  --   ElsIf NVL(LTrim(rTrim(v_first_punch)),0) = 0 Then
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
  Select Assign InTo v_parent From SS_EmplMast Where EmpNo = Ltrim(RTrim(I_EmpNo));
  Select StartHH, StartMN, EndHH, EndMN
  InTo vStartHH, vStartMN, vEndHH, vEndMN
  From SS_LunchMast Where ShiftCode = Ltrim(RTrim(I_SCode)) And Parent = Ltrim(RTrim(v_parent));
  End If;
  If v_first_punch >= (vEndHH * 60) + vEndMN Then
  Return 0;
  ElsIf v_last_punch <= (vStartHH * 60) + vStartMN Then
  Return 0;
  ElsIf v_first_punch <= (vStartHH * 60) + vStartMN And v_last_punch >= ((vEndHH * 60) + vEndMN) Then
  If I_SCode = 'OO' Or I_SCode = 'HH' Then
  v_RetVal := ((vEndHH * 60) + vEndMN) - ((vStartHH * 60) + vStartMN);
  Select Least(v_RetVal,30) InTo v_RetVal From Dual;
  Return v_RetVal;
  Else
  Return ((vEndHH * 60) + vEndMN) - ((vStartHH * 60) + vStartMN);
  End If;
  ElsIf (v_first_punch > (vStartHH * 60) + vStartMN) And (v_first_punch < (vEndHH * 60) + vEndMN) And v_last_punch >= (vEndHH * 60) + vEndMN Then
  If I_SCode = 'OO' Or I_SCode = 'HH' Then
  v_RetVal := ((vEndHH * 60) + vEndMN) - v_first_punch;
  Select Least(v_RetVal,30) InTo v_RetVal From Dual;
  Return v_RetVal;
  Else
  Return ((vEndHH * 60) + vEndMN) - v_first_punch;
  End If;
  ElsIf (v_first_punch < (vStartHH * 60) + vStartMN) And (v_last_punch < (vEndHH * 60) + vEndMN) And v_last_punch >= (vStartHH * 60) + vStartMN Then
  If I_SCode = 'OO' Or I_SCode = 'HH' Then
  v_RetVal := v_last_punch - ((vStartHH * 60) + vStartMN);
  Select Least(v_RetVal,30) InTo v_RetVal From Dual;
  Return v_RetVal;
  Else
  Return v_last_punch - ((vStartHH * 60) + vStartMN);
  End If;
  ElsIf (v_first_punch > (vStartHH * 60) + vStartMN) And (v_last_punch < (vEndHH * 60) + vEndMN) Then
  If I_SCode = 'OO' Or I_SCode = 'HH' Then
  v_RetVal := v_last_punch - v_first_punch;
  Select Least(v_RetVal,30) InTo v_RetVal From Dual;
  Return v_RetVal;
  Else
  Return v_last_punch - v_first_punch;
  End If;
  ElsIf NVL(LTrim(rTrim(v_first_punch)),0) = 0 Then
  Return 0;
  ElsIf IsLeaveDepuTour(I_PDate, I_EmpNo) > 0 Then
  Return 0;
  Else
  Return 30;
  End If;
  End If;  */
Exception
    When Others Then
        Return 30;
End;


/
