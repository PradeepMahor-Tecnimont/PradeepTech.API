--------------------------------------------------------
--  DDL for Package Body LEAVE_BAL
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE BODY "SELFSERVICE"."LEAVE_BAL" As

    Function get_overlap_leave (
        p_empno        Varchar2,
        p_date         Date,
        p_leave_type   Varchar2
    ) Return Number Is
        v_ret_val Number;
    Begin
        Select
            Sum(overlap_leave_period)
        Into v_ret_val
        From
            (
                Select
                    empno,
                    leavetype,
                    app_no,
                    leave_period,
                    bdate,
                    edate,
                    nu_edate,
                    leave_period - ( edate - nu_edate - holiday_count ) nu_leave_period,
                    ( edate - nu_edate - holiday_count ) overlap_leave_period
                From
                    (
                        Select
                            empno,
                            leavetype,
                            app_no,
                            leave_period,
                            bdate,
                            edate,
                            nu_edate,
                            holidaysbetween(
                                nu_edate,
                                edate
                            ) As holiday_count
                        From
                            (
                                Select
                                    empno,
                                    leavetype,
                                    app_no,
                                    bdate,
                                    Nvl(edate, bdate) edate,
                                    Case
                                        When Nvl(edate, bdate) > p_date Then
                                            p_date
                                        Else
                                            Nvl(edate, bdate)
                                    End nu_edate,
                                    leaveperiod / 8 * - 1 As leave_period
                                From
                                    ss_leaveledg
                                Where
                                    empno = p_empno
                                    And leavetype  = p_leave_type
                                    And bdate <= p_date
                                    And Nvl(edate, bdate) > p_date
                                    And adj_type In (
                                        'LA',
                                        'LC'
                                    )
                                    And db_cr      = 'D'
                            )
                    )
            );

        Return v_ret_val;
    Exception
        When Others Then
            Return 0;
    End;

    Function get_cl_bal (
        p_empno Varchar2,
        p_date Date
    ) Return Number As
        c_closing_bal             Constant Number := 0;
        v_bal_including_overlap   Number;
        v_overlap_leave           Number;
    Begin
        v_bal_including_overlap   := closingclbal(
            v_empno         => p_empno,
            v_opbaldtfrom   => p_date,
            v_openbal       => c_closing_bal
        );

        v_overlap_leave           := get_overlap_leave(
            p_empno,
            p_date,
            'CL'
        );
        Return v_bal_including_overlap + Nvl(v_overlap_leave, 0);
    Exception
        When Others Then
            Return Null;
    End get_cl_bal;

    Function get_sl_bal (
        p_empno Varchar2,
        p_date Date
    ) Return Number As
        c_closing_bal             Constant Number := 0;
        v_bal_including_overlap   Number;
        v_overlap_leave           Number;
    Begin
        v_bal_including_overlap   := closingslbal(
            v_empno         => p_empno,
            v_opbaldtfrom   => p_date,
            v_openbal       => c_closing_bal
        );

        v_overlap_leave           := get_overlap_leave(
            p_empno,
            p_date,
            'SL'
        );
        Return v_bal_including_overlap + Nvl(v_overlap_leave, 0);
    Exception
        When Others Then
            Return Null;
    End get_sl_bal;

    Function get_pl_bal (
        p_empno Varchar2,
        p_date Date
    ) Return Number As
        c_closing_bal             Constant Number := 0;
        v_bal_including_overlap   Number;
        v_overlap_leave           Number;
    Begin
        v_bal_including_overlap   := closingplbal(
            v_empno         => p_empno,
            v_opbaldtfrom   => p_date,
            v_openbal       => c_closing_bal
        );

        v_overlap_leave           := get_overlap_leave(
            p_empno,
            p_date,
            'PL'
        );
        Return v_bal_including_overlap + Nvl(v_overlap_leave, 0);
    Exception
        When Others Then
            Return Null;
    End get_pl_bal;

    Function get_ex_bal (
        p_empno Varchar2,
        p_date Date
    ) Return Number As
        c_closing_bal             Constant Number := 0;
        v_bal_including_overlap   Number;
        v_overlap_leave           Number;
    Begin
        v_bal_including_overlap   := closingexbal(
            v_empno         => p_empno,
            v_opbaldtfrom   => p_date,
            v_openbal       => c_closing_bal
        );

        v_overlap_leave           := get_overlap_leave(
            p_empno,
            p_date,
            'EX'
        );
        Return v_bal_including_overlap + Nvl(v_overlap_leave, 0);
    Exception
        When Others Then
            Return Null;
    End get_ex_bal;

    Function get_co_bal (
        p_empno Varchar2,
        p_date Date
    ) Return Number As
        c_closing_bal             Constant Number := 0;
        v_bal_including_overlap   Number;
        v_overlap_leave           Number;
    Begin
        v_bal_including_overlap   := closingcobal(
            v_empno         => p_empno,
            v_opbaldtfrom   => p_date,
            v_openbal       => c_closing_bal
        );

        v_overlap_leave           := get_overlap_leave(
            p_empno,
            p_date,
            'CO'
        );
        Return v_bal_including_overlap + Nvl(v_overlap_leave, 0);
    Exception
        When Others Then
            Return Null;
    End get_co_bal;

    Function get_oh_bal (
        p_empno Varchar2,
        p_date Date
    ) Return Number As
        c_closing_bal             Constant Number := 0;
        v_bal_including_overlap   Number;
        v_overlap_leave           Number;
    Begin
        v_bal_including_overlap   := closingohbal(
            v_empno         => p_empno,
            v_opbaldtfrom   => p_date,
            v_openbal       => c_closing_bal
        );

        v_overlap_leave           := get_overlap_leave(
            p_empno,
            p_date,
            'OH'
        );
        Return v_bal_including_overlap + Nvl(v_overlap_leave, 0);
    Exception
        When Others Then
            Return Null;
    End get_oh_bal;

    Function get_leave_without_overlap (
        p_app_bdate          Date,
        p_app_edate          Date,
        p_rep_bdate          Date,
        p_rep_edate          Date,
        p_leave_period       Number,
        p_consider_holiday   Varchar2 Default 'OK'
    ) Return Number As
        v_nu_app_bdate    Date;
        v_nu_app_edate    Date;
        v_holiday_count   Number;
    Begin
        If p_app_bdate >= p_rep_bdate And Nvl(p_app_edate, p_app_bdate) <= p_rep_edate Then
            Return p_leave_period;
        End If;

        --1-Jan between 25-Dec & 5-Jan

        If p_rep_bdate Between p_app_bdate And p_app_edate And p_rep_edate Between p_app_bdate And p_app_edate Then
            Return Null;
        Elsif p_rep_bdate Between p_app_bdate And p_app_edate Then
            v_nu_app_bdate := p_rep_bdate;
            If p_consider_holiday = 'OK' Then
                v_holiday_count := holidaysbetween(
                    pstartdate   => p_app_bdate,
                    penddate     => v_nu_app_bdate
                );
                Return p_leave_period - ( ( v_nu_app_bdate - p_app_bdate ) - v_holiday_count ) - 1;
            Else
                Return p_leave_period - ( v_nu_app_bdate - p_app_bdate );
            End If;

        Elsif p_rep_edate Between p_app_bdate And p_app_edate Then
            v_nu_app_edate := p_rep_edate;
            If p_consider_holiday = 'OK' Then
                v_holiday_count := holidaysbetween(
                    pstartdate   => v_nu_app_edate,
                    penddate     => p_app_edate
                );
                Return p_leave_period - ( ( p_app_edate - v_nu_app_edate ) - v_holiday_count );
            Else
                Return p_leave_period  - (  p_app_edate - v_nu_app_edate );
            End If;

        End If;

    End;

End leave_bal;


/
