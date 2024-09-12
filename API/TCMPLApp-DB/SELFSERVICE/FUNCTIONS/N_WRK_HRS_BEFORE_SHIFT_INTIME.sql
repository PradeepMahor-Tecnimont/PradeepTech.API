CREATE OR REPLACE FUNCTION "SELFSERVICE"."N_WRK_HRS_BEFORE_SHIFT_INTIME" (
    p_empno      In Varchar2,
    p_date       In Date,
    p_shift_code In Varchar2
) Return Number As

    Cursor c1(p_shift_in_time Number) Is
        Select
            *
        From
            (
                Select
                    (hh * 60) + mm punch_time,
                    odtype
                From
                    ss_integratedpunch
                Where
                    empno         = Trim(p_empno)
                    And pdate     = p_date
                    And falseflag = 1

                Order By pdate,
                    hhsort,
                    mmsort,
                    hh,
                    mm
            )
        Where
            punch_time < p_shift_in_time;

    Type typ_hrs Is
        Table Of c1%rowtype Index By Binary_Integer;
    tab_hrs                     typ_hrs;
    v_shift_in_time             Number;
    v_rec_count                 Number;
    v_wrk_hrs                   Number;
    v_punch_count_after_shiftin Number;
Begin
    v_wrk_hrs   := 0;
    If p_shift_code In ('OO', 'HH') Then
        Return 0;
    Else
        Select
            (timein_hh * 60) + timein_mn
        Into
            v_shift_in_time
        From
            ss_shiftmast
        Where
            shiftcode = ltrim(rtrim(p_shift_code));
    End If;
    Open c1(v_shift_in_time);
    Fetch c1 Bulk Collect Into tab_hrs Limit 100;
    Close c1;

    Select
        Count(*)
    Into
        v_punch_count_after_shiftin
    From
        (
            Select
                (hh * 60) + mm punch_time,
                odtype
            From
                ss_integratedpunch
            Where
                empno         = Trim(p_empno)
                And pdate     = p_date
                And falseflag = 1

            Order By pdate,
                hhsort,
                mmsort,
                hh,
                mm
        )
    Where
        punch_time >= v_shift_in_time;

    If tab_hrs.count = 0 Then
        Return 0;
    End If;

    v_rec_count := tab_hrs.count;
    --When odd punch found add extra element
    If (v_rec_count Mod 2) = 1 And v_punch_count_after_shiftin > 0 Then
        tab_hrs(v_rec_count + 1).punch_time := v_shift_in_time;
        tab_hrs(v_rec_count + 1).odtype     := 0;
        --If there are no punch after shiftin
        --and only one punch
    Elsif v_rec_count <= 1 Then
        Return 0;
    End If;

    For i In 1..tab_hrs.count
    Loop
        If i > 1 Then
            --Odd counter "i"
            If (i Mod 2) = 1 Then
                --For OnDuty application timing Continuity
                --(difference between CurrTime and PrevTime <= 60) 
                -- and (IsOdd punch) and (CurrIsOnDuty or PrevIsOnDuty)
                If (tab_hrs(i).odtype <> 0 Or tab_hrs(i - 1).odtype <> 0) And
                    (tab_hrs(i).punch_time - tab_hrs(i - 1).punch_time <= 60)
                Then
                    tab_hrs(i) := tab_hrs(i - 1);
                End If;
            End If;
            If (i Mod 2) = 0 Then
                v_wrk_hrs := v_wrk_hrs + (tab_hrs(i).punch_time - tab_hrs(i - 1).punch_time);
            End If;
        End If;
    End Loop;

    If v_shift_in_time > (12 * 60) Then --Second shift
        If p_date >= To_Date('27-Jun-2022', 'dd-Mon-yyyy') Then -- After 12:00  noon
            If v_wrk_hrs < 120 Then
                v_wrk_hrs := least(15, v_wrk_hrs);
            End If;

            --Else
            --v_wrk_hrs := least(15, v_wrk_hrs);
        End If;
    Else
        v_wrk_hrs := least(15, v_wrk_hrs);
    End If;
    Return v_wrk_hrs;
End n_wrk_hrs_before_shift_intime;
/