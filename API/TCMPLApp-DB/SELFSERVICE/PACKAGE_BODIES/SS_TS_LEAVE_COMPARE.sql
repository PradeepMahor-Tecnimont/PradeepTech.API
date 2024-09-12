--------------------------------------------------------
--  DDL for Package Body SS_TS_LEAVE_COMPARE
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE BODY "SELFSERVICE"."SS_TS_LEAVE_COMPARE" As

    Function get_emp_ss_leave_4_month (
        p_empno Varchar2,
        p_yyyymm Varchar2
    ) Return Number Is
        v_retval Number;
    Begin
        Select
            Sum(aa.nu_leaveperiod)
        Into v_retval
        From
            (
                Select
                    empno,
                    leavetype,
                    app_no,
                    nu_bdate,
                    nu_edate,
                    leave_4_mm - holiday_count As nu_leaveperiod,
                    bdate,
                    edate,
                    leave_period
                From
                    (
                        Select
                            empno,
                            leavetype,
                            app_no,
                            1 + nu_edate - nu_bdate leave_4_mm,
                            nu_bdate,
                            nu_edate,
                            leave_period,
                            bdate,
                            edate,
                            (
                                Select
                                    Count(*)
                                From
                                    ss_holidays
                                Where
                                    holiday Between a.nu_bdate And a.nu_edate
                            ) As holiday_count
                        From
                            (
                                Select
                                    empno,
                                    leavetype,
                                    app_no,
                                    Case
                                        When To_Char(bdate, 'yyyymm') <> p_yyyymm Then
                                            To_Date(p_yyyymm, 'yyyymm')
                                        Else
                                            bdate
                                    End nu_bdate,
                                    Case
                                        When To_Char(edate, 'yyyymm') <> p_yyyymm Then
                                            Last_Day(To_Date(p_yyyymm, 'yyyymm'))
                                        Else
                                            edate
                                    End nu_edate,
                                    edate,
                                    bdate,
                                    leaveperiod / 8 * - 1 As leave_period
                                From
                                    ss_leaveledg
                                Where
                                    ( ( To_Char(bdate, 'yyyymm') = p_yyyymm
                                        Or To_Char(Nvl(edate, bdate), 'yyyymm') = p_yyyymm )
                                      Or ( To_Date(p_yyyymm, 'yyyymm') Between bdate And edate
                                           And Last_Day(To_Date(p_yyyymm, 'yyyymm')) Between bdate And edate ) )
                                    And edate Is Not Null
                                    And bdate <> edate
                                    And To_Char(bdate, 'yyyymm') <> To_Char(edate, 'yyyymm')
                                    And adj_type In (
                                        'LA',
                                        'LC'
                                    )
                                    And db_cr                              = 'D'
                                    And empno                              = p_empno
                            ) a
                    )
                Union
                Select
                    empno,
                    leavetype,
                    app_no,
                    bdate,
                    edate,
                    leaveperiod / 8 * - 1 leave_period,
                    bdate,
                    edate,
                    leaveperiod / 8 * - 1 leave_period
                From
                    ss_leaveledg
                Where
                    bdate Between To_Date(p_yyyymm, 'yyyymm') And Last_Day(To_Date(p_yyyymm, 'yyyymm'))
                    And Nvl(edate, bdate) Between To_Date(p_yyyymm, 'yyyymm') And Last_Day(To_Date(p_yyyymm, 'yyyymm'))
                    And adj_type In (
                        'LA',
                        'LC'
                    )
                    And db_cr  = 'D'
                    And empno  = p_empno
            ) aa,
            ss_emplmast         bb,
            ss_engg_costcodes   cc
        Where
            aa.empno = bb.empno
            And ( bb.parent = cc.costcode )
            And aa.empno = p_empno;

        Return nvl(v_retval,0);
    Exception
        When Others Then
            Return 0;
    End get_emp_ss_leave_4_month;

    Function get_emp_ts_leave_4_month (
        p_empno Varchar2,
        p_yyyymm Varchar2
    ) Return Number As
        v_adj_hrs      Number;
        v_normal_hrs   Number;
    Begin
        Begin
            Select
                Sum(total)
            Into v_normal_hrs
            From
                ss_time_daily a
            Where
                Substr(projno, 1, 5) In (
                    '11114',
                    '22224',
                    '33334',
                    '22225'
                )
                And wpcode  = '1'
                And yymm    = p_yyyymm
                And empno   = p_empno;

        Exception
            When others Then
                v_normal_hrs := 0;
        End;

        Begin
            Select
                Sum(total)
            Into v_adj_hrs
            From
                ss_time_daily a
            Where
                Substr(projno, 1, 5) In (
                    '11114',
                    '22224',
                    '33334',
                    '22225'
                )
                And wpcode  = '4'
                And yymm    = To_Char(Add_Months(To_Date(p_yyyymm, 'yyyymm'), 1), 'yyyymm')
                And empno   = p_empno;

        Exception
            When others Then
                v_adj_hrs := 0;
        End;

        Return (nvl(v_normal_hrs,0) + nvl(v_adj_hrs,0))/8;
    Exception
        When Others Then
            Return 0;
    End get_emp_ts_leave_4_month;

End ss_ts_leave_compare;


/
