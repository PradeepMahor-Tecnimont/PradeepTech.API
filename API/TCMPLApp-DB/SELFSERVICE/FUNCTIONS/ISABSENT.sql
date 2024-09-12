--------------------------------------------------------
--  DDL for Function ISABSENT
--------------------------------------------------------

Create Or Replace Function selfservice.isabsent(
    p_empno    Varchar2,
    p_pdate    Date,
    p_checkdol Number := 0
) Return Number Is
    v_retval            Number;
    v_count             Number;
    v_doj               Date;
    v_dol               Date;
    v_shift             Varchar2(2);
    c_is_absent         Constant Number := 1;
    c_not_absent        Constant Number := 0;
    c_ows               Constant Number := 1;
    c_sws               Constant Number := 2;
    c_dws               Constant Number := 3;
    v_pws               Number;
    v_attendance_status Varchar2(100);
    v_swp_start_date    Date;
Begin

    --SWP Implementaion Date
    v_swp_start_date := To_Date('18-Apr-2022', 'dd-Mon-yyyy');

    --Initial Return vlaue
    v_retval         := c_not_absent;

    --Get employee details
    Select
        doj, dol, getshift1(p_empno, p_pdate)
    Into
        v_doj, v_dol, v_shift
    From
        ss_emplmast
    Where
        empno = ltrim(rtrim(p_empno));

    v_count          := pkg_region_holiday_calc.fn_is_holiday(p_empno, p_pdate);

    --PDATE is greater than date of leaving
    --OR
    --PDATe is before Joining date
    If (p_checkdol <> 0 And p_pdate > v_dol) Or p_pdate < v_doj Then
        Return c_not_absent;
    End If;

    --If PDate is holiday
    If v_shift In ('HH', 'OO') Or v_count > 0 Then
        Return c_not_absent;
    End If;

    If v_doj <= p_pdate And v_count = 0 Then
        v_retval := c_not_absent;
        Select
            Count(*)
        Into
            v_count
        From
            ss_integratedpunch
        Where
            empno     = ltrim(rtrim(p_empno))
            And pdate = p_pdate;

        If v_count > 0 Then
            v_retval := c_not_absent;
        Else
            Select
                isleavedeputour(p_pdate, p_empno)
            Into
                v_count
            From
                dual;

            If v_count > 0 Then
                v_retval := c_not_absent;
            Else
                v_retval := 1;
            End If;

        End If;

    End If;

    --If PDate is after SWP implementation date
    If p_pdate >= v_swp_start_date Then
        v_pws               := iot_swp_common.fn_get_emp_pws(
                                   p_empno => p_empno,
                                   p_date  => p_pdate
                               );

        v_attendance_status := iot_swp_common.fn_get_attendance_status(
                                   p_empno => p_empno,
                                   p_date  => p_pdate,
                                   p_pws   => v_pws
                               );
        If v_attendance_status Like 'LWP%' Then
            Return c_is_absent;
        Elsif v_attendance_status = 'Absent' Then
            If v_pws = c_dws Then
                Return c_not_absent;
            End If;
            Return c_is_absent;
        Else
            Return c_not_absent;
        End If;
    End If;

    Return v_retval;
Exception
    When Others Then
        Return 10;
End;
/