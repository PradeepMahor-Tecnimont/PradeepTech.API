Create Or Replace Function selfservice.n_otperiod_inlcude_2nd_shift(
    p_empno       In Varchar2,
    p_date        In Date,
    p_shift_code  In Varchar2,
    p_delta_hrs   In Number,
    p_compoff_hrs In Number Default 0
) Return Number Is

    v_ret_ot_hrs          Number;

    Type typ_tab_hrs Is
        Table Of Number Index By Binary_Integer;
    v_tab_hrs             typ_tab_hrs;
    cntr                  Number;
    thrs                  Varchar2(10);
    v_shift_out_time      Number;
    v_shift_in_time       Number;
    v_is_ot_applicable    Number;
    v_punchnos            Number;
    vtrno                 Char(5);
    v4ot                  Boolean := true;
    v_is_train_ot         Number;

    v_ot_start_time       Number;
    v_ot_end_time         Number;

    v_from_hrs            Number;
    v_to_hrs              Number;
    row_shift_mast        ss_shiftmast%rowtype;
    v_atual_shift_in_time Number;
Begin
    If p_shift_code = 'TN' Or p_shift_code = 'PA' Or p_shift_code = 'GE' Or p_shift_code = 'GV' Then
        Return 0;
    End If;
    If Trim(p_shift_code) In ('HH', 'OO') Then
        row_shift_mast.timein_hh := 0;
        row_shift_mast.timein_mn := 0;
    Else
        Select
            *
        Into
            row_shift_mast
        From
            ss_shiftmast
        Where
            shiftcode = Trim(p_shift_code);
    End If;
    --And nvl(ot_applicable, 0) = 1;

    If trunc(p_date) In (
            trunc(To_Date('21-FEB-2017', 'dd-MON-yyyy')),
            trunc(To_Date('28-SEP-2017', 'dd-MON-yyyy'))
        )
    Then
        Return 0;
    End If;

    If nvl(row_shift_mast.ot_applicable, 0) = 0 And trim(p_shift_code) <> 'HH' And trim(p_shift_code) <> 'OO' Then
        Return 0;
    End If;

    --Training

    v_is_train_ot         := n_ot_4_training(p_empno, p_date);
    If v_is_train_ot = ss.ss_false Then
        Return 0;
    End If;
    --Training

    If p_date < To_Date('1-Mar-2022', 'dd-Mon-yyyy') Then
        Return n_otperiod(
            p_empno,
            p_date,
            p_shift_code,
            p_delta_hrs,
            p_compoff_hrs
        );
    End If;

    v_atual_shift_in_time := (row_shift_mast.timein_hh * 60) + row_shift_mast.timein_mn;

    v_ret_ot_hrs          := 0;

    Select
        ((hh * 60) + mm) mins Bulk Collect
    Into
        v_tab_hrs
    From
        ss_integratedpunch
    Where
        empno         = ltrim(rtrim(p_empno))
        And pdate     = p_date
        And falseflag = 1
        And Trim(mach) <> 'WFH0'
    Order By
        pdate,
        hhsort,
        mmsort,
        hh,
        mm;
    If (v_tab_hrs.count Mod 2) <> 0 Then
        Return 0;
    End If;

    v_shift_out_time      := getshiftouttime(p_empno, p_date, p_shift_code, v4ot);

    v_shift_in_time       := getshiftintime(p_empno, p_date, p_shift_code);
    If p_shift_code In ('OO', 'HH') Then

        v_ot_start_time := 0;
        v_ot_end_time   := 1439;
    Elsif v_atual_shift_in_time > (12 * 60) Then
        v_ot_start_time := 0;
        v_ot_end_time   := v_shift_in_time;
    Else
        v_ot_start_time := v_shift_out_time;
        v_ot_end_time   := 1439;
    End If;

    v_ret_ot_hrs          := 0;
    For i In 1..v_tab_hrs.count
    Loop
        If Mod(i, 2) = 0 Then
            If v_tab_hrs(i) < v_ot_start_time Then
                Continue;
            End If;
            If v_tab_hrs(i - 1) > v_ot_end_time Then
                Exit;
            End If;

            v_from_hrs   := greatest(v_ot_start_time, v_tab_hrs(i - 1));

            v_to_hrs     := least(v_ot_end_time, v_tab_hrs(i));

            v_ret_ot_hrs := v_ret_ot_hrs + v_to_hrs - v_from_hrs;

        End If;
    End Loop;

    If p_shift_code <> 'OO' And p_shift_code <> 'HH' Then

        v_ret_ot_hrs := least(p_delta_hrs, v_ret_ot_hrs);

    Elsif p_shift_code = 'OO' Or p_shift_code = 'HH' Then

        v_ret_ot_hrs := v_ret_ot_hrs - availedlunchtime1(p_empno, p_date, p_shift_code);

    End If;

    If p_compoff_hrs = 1 Then
        If v_ret_ot_hrs >= 120 Then
            v_ret_ot_hrs := (floor(v_ret_ot_hrs / 60) * 60);
        Else
            v_ret_ot_hrs := 0;
        End If;
    Else
        If p_shift_code = 'OO' Or p_shift_code = 'HH' Then
            If v_ret_ot_hrs >= 240 Then
                v_ret_ot_hrs := (floor(v_ret_ot_hrs / 60) * 60);
            Else
                v_ret_ot_hrs := 0;
            End If;

        Else
            If v_ret_ot_hrs >= 120 Then
                v_ret_ot_hrs := 120;
            Else
                v_ret_ot_hrs := 0;
            End If;
        End If;
    End If;

    Return v_ret_ot_hrs;
End;