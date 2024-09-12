--------------------------------------------------------
--  DDL for Function N_DELTAHRS
--------------------------------------------------------

Create Or Replace Function selfservice.n_deltahrs_include_2nd_shift(
    p_empno       In Varchar2,
    p_date        In Date,
    p_shiftcode   In Varchar2,
    p_penalty_hrs In Number
) Return Number Is

    v_count      Number := 0;
    v_retval     Number := 0;
    v_wrkhrs     Number := 0;

    v_esthrs     Number := 0;

    v_otime      Number := 0;
    v_itime      Number := 0;
    vfirstpunch  Number;
    vlastpunch   Number;
    x            Number;
    v_isleave    Number;
    vlcomeegohrs Number;
    vpunchcount  Number;
Begin
    Select
        Count(*)
    Into
        vpunchcount
    From
        ss_integratedpunch
    Where
        empno         = Trim(p_empno)
        And pdate     = trunc(p_date)
        And falseflag = 1;
    If ltrim(rtrim(p_shiftcode)) = 'OO' Or ltrim(rtrim(p_shiftcode)) = 'HH' Or vpunchcount < 2 Then
        Return v_retval;
    End If;
    v_count := 0;

    Select
        Count(*)
    Into
        v_count
    From
        ss_depu
    Where
        bdate <= p_date
        And edate >= p_date
        And empno     = p_empno
        And hod_apprl = 1
        And hrd_apprl = 1;

    Select
        Count(*)
    Into
        v_isleave
    From
        ss_leaveledg
    Where
        empno                            = ltrim(rtrim(p_empno))
        And bdate <= p_date
        And nvl(edate, bdate) >= p_date
        And (hd_date Is Null Or (hd_part = 1 And hd_date <> p_date))
        And (adj_type                    = 'LA' Or adj_type = 'LC');

    If v_count > 0 Or v_isleave > 0 Then
        v_retval := 0;
    Else

        v_itime     := getshiftintime(p_empno, p_date, p_shiftcode);
        v_otime     := getshiftouttime(p_empno, p_date, p_shiftcode);
        If p_date >= To_Date('1-Mar-2022', 'dd-Mon-yyyy') Then
            v_wrkhrs := n_workedhrs_include_2nd_shift(lpad(trim(p_empno), 5, '0'), p_date, p_shiftcode);
        Else
            v_wrkhrs := n_workedhrs(lpad(trim(p_empno), 5, '0'), p_date, p_shiftcode);
        End If;
        vfirstpunch := get_punch_num(lpad(p_empno, 5, '0'), p_date, 'OK', 'DHRS');
        vlastpunch  := get_punch_num(lpad(p_empno, 5, '0'), p_date, 'KO', 'DHRS');

        Select
            Count(*)
        Into
            v_count
        From
            ss_integratedpunch
        Where
            empno         = Trim(p_empno)
            And pdate     = p_date
            And falseflag = 1;
        If v_count > 0 Then
            v_esthrs := shift_work_hrs(p_empno, p_date, p_shiftcode);
        Else
            v_esthrs := 0;
        End If;
        If v_itime < vfirstpunch Then
            vlcomeegohrs := vfirstpunch - v_itime;
        End If;
        If v_otime > vlastpunch Then
            vlcomeegohrs := nvl(vlcomeegohrs, 0) + (v_otime - vlastpunch);
        End If;

        If p_penalty_hrs > 0 Then
            If (p_penalty_hrs * 60) < vlcomeegohrs Then
                vlcomeegohrs := p_penalty_hrs * 60;
            End If;
        Else
            vlcomeegohrs := 0;
        End If;
        v_retval    := vlcomeegohrs + v_wrkhrs - v_esthrs;

    End If;
    Select
        Count(*)
    Into
        vpunchcount
    From
        ss_integratedpunch
    Where
        empno         = Trim(p_empno)
        And pdate     = p_date
        And falseflag = 1;
    If Mod(vpunchcount, 2) <> 0 And v_retval > 0 And p_date >= '31-OCT-11' Then
        v_retval := 0;
    End If;
    Return nvl(v_retval, 0);

End;
/