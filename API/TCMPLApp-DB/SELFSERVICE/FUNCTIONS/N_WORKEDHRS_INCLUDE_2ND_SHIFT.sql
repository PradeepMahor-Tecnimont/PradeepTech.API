Create Or Replace Function "SELFSERVICE"."N_WORKEDHRS_INCLUDE_2ND_SHIFT"(
    p_empno      In Varchar2,
    p_date       In Date,
    p_shift_code In Varchar2
) Return Number Is
    Cursor c1(cp_shift_in_time Number) Is

        Select
            (hh * 60) + mm punch_time,
            odtype
        From
            ss_integratedpunch
        Where
            empno         = Trim(p_empno)
            And pdate     = p_date
            And falseflag = 1

        Order By
            pdate,
            hhsort,
            mmsort,
            hh,
            mm;

    Type typ_hrs Is
        Table Of c1%rowtype Index By Binary_Integer;
    tab_hrs            typ_hrs;
    v_shift_in_time    Number;
    v_rec_count        Number;
    v_wrk_hrs          Number;

    Type tabhrs Is
        Table Of Number Index By Binary_Integer;
    Type tabodappl Is
        Table Of Number Index By Binary_Integer;
    v_tabhrs           tabhrs;
    v_tabodappl        tabodappl;
    cntr               Number;
    thrs               Varchar2(10);
    totalhrs           Number;
    v_i_hh             Number;
    v_i_mm             Number;
    v_o_hh             Number;
    v_o_mm             Number;
    v_intime           Number;
    v_outtime          Number;
    v_count            Number;
    v_availedlunchtime Number := 0;
    v_first_punch_min  Number;
    v_morning_wrk_hrs  Number;
    v_prev_punchtime   Number;
Begin
    v_morning_wrk_hrs  := 0;
    If p_shift_code = 'OO' And p_shift_code = 'HH' Then
        v_shift_in_time := 0;

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
    Fetch c1 Bulk Collect Into tab_hrs Limit 200;
    Close c1;

    If tab_hrs.count <= 1 Then
        Return 0;
    End If;

    v_morning_wrk_hrs  := n_wrk_hrs_before_shift_intime(p_empno, p_date, p_shift_code);

    v_wrk_hrs          := 0;
    For i In 1..tab_hrs.count
    Loop
        If i > 1 Then
            --Odd counter "i"
            If (i Mod 2) = 1 Then
                --For OnDuty application timing Continuity
                --(difference between CurrTime and PrevTime <= 60) 
                -- and (IsOdd punch) and (CurrIsOnDuty or PrevIsOnDuty)
                /*If (tab_hrs(i).odtype <> 0 Or tab_hrs(i - 1).odtype <> 0) And
                    (tab_hrs(i).punch_time - tab_hrs(i - 1).punch_time <= 60)
                Then
                    tab_hrs(i) := tab_hrs(i - 1);
                End If;
                */
                Null;
            End If;
            If (i Mod 2) = 0 Then
                If tab_hrs(i).punch_time < v_shift_in_time Then
                    Continue;
                End If;
                v_prev_punchtime := greatest(v_shift_in_time, tab_hrs(i - 1).punch_time);
                v_wrk_hrs        := v_wrk_hrs + (tab_hrs(i).punch_time - v_prev_punchtime);
            End If;
        End If;
    End Loop;

    v_availedlunchtime := availedlunchtime1(p_empno, p_date, p_shift_code);
    totalhrs           := v_wrk_hrs - v_availedlunchtime + v_morning_wrk_hrs;
    Return greatest(nvl(totalhrs, 0), 0);
Exception
    When Others Then
        Return 0;
End;
/