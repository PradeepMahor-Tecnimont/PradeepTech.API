Create Or Replace Package Body "SELFSERVICE"."IOT_SS_XL_REPORTS_QRY" As

    Function fn_leaves_availed(
        p_person_id Varchar2,
        p_meta_id   Varchar2,
        p_yyyy      Varchar2
    ) Return Sys_Refcursor As
        c                    Sys_Refcursor;
        v_start_date         Date;
        v_by_empno           Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
    Begin
        v_by_empno := get_empno_from_meta_id(p_meta_id);
        If v_by_empno = 'ERRRR' Then
            raise_application_error(-20001, 'Incorrect metaid');
            Return Null;
        End If;

        Begin
            v_start_date := trunc(To_Date(p_yyyy, 'yyyy'), 'YEAR');
        Exception
            When Others Then
                raise_application_error(-20001, 'Incorrect year(yyyy)');
                Return Null;
        End;
        Open c For
            With
                emp_list As (
                    Select
                        empno,
                        e.name,
                        parent,
                        c.abbr As parent_desc,
                        grade,
                        emptype,
                        d.desg designation,
                        e.doj
                    From
                        ss_emplmast e,
                        ss_desgmast d,
                        ss_costmast c
                    Where
                        status         = 1
                        And e.desgcode = d.desgcode (+)
                        And e.parent   = c.costcode
                        And e.emptype In ('R', 'F')
                ), params As (
                    Select
                        trunc(To_Date(p_yyyy, 'yyyy'), 'YEAR')                     start_date,
                        add_months(trunc(To_Date(p_yyyy, 'yyyy'), 'YEAR'), 12) - 1 end_date
                    From
                        dual
                )
            Select
                emp_list.empno,
                emp_list.name                                                                     As employee_name,
                emp_list.parent,
                emp_list.parent_desc,
                emp_list.grade,
                emp_list.emptype,
                emp_list.designation,
                emp_list.doj,
                nvl(pv_data.cl, 0)                                                                cl,
                nvl(pv_data.sl, 0)                                                                sl,
                nvl(pv_data.pl, 0)                                                                pl,
                nvl(pv_data.co, 0)                                                                co,
                nvl(pv_data.cl, 0) + nvl(pv_data.sl, 0) + nvl(pv_data.pl, 0) + nvl(pv_data.co, 0) total
            From
                (
                    Select
                        *
                    From
                        (
                            Select
                                empno,
                                leavetype,
                                actual_leaveperiod
                            From
                                (
                                    Select
                                        l.empno,
                                        leavetype,
                                        leaveperiod,
                                        db_cr,
                                        bdate,
                                        edate,
                                        Case leavetype
                                            When 'SL' Then
                                                leave_bal.get_leave_without_overlap(bdate,
                                                    nvl(edate, bdate),
                                                    p.start_date,
                                                    p.end_date,
                                                    (leaveperiod * -1) / 8,
                                                    'KO')
                                            Else
                                                leave_bal.get_leave_without_overlap(bdate,
                                                    nvl(edate, bdate),
                                                    p.start_date,
                                                    p.end_date,
                                                    (leaveperiod * -1) / 8,
                                                    'OK')
                                        End actual_leaveperiod
                                    From
                                        ss_leaveledg l,
                                        emp_list     e,
                                        params       p
                                    Where
                                        (bdate Between p.start_date And p.end_date
                                            Or edate Between p.start_date And p.end_date)
                                        And db_cr   = 'D'
                                        And leavetype In ('CL', 'SL', 'PL', 'CO')
                                        And adj_type Not In ('DA', 'LE', 'MA', 'OH', 'YA')
                                        And l.empno = e.empno
                                )
                        ) Pivot (
                        Sum(actual_leaveperiod)
                        For leavetype
                        In ('CL' As cl, 'SL' As sl, 'PL' As pl, 'CO' As co)
                        )
                    Order By empno
                ) pv_data,
                emp_list
            Where
                emp_list.empno = pv_data.empno (+);
        Return c;
    End;

    Function fn_subcont_attend_for_10days(
        p_person_id Varchar2,
        p_meta_id   Varchar2
    ) Return Sys_Refcursor As
        c                    Sys_Refcursor;
        v_start_date         Date;
        v_by_empno           Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
    Begin
        v_by_empno   := get_empno_from_meta_id(p_meta_id);
        If v_by_empno = 'ERRRR' Then
            raise_application_error(-20001, 'Incorrect metaid');
            Return Null;
        End If;

        v_start_date := trunc(sysdate - 1);
        Open c For
            With
                user_desk_list As(
                    Select
                        empno,
                            Max(deskid) Keep (Dense_Rank Last Order By
                            deskid) emp_deskid
                    From
                        dms.dm_usermaster
                    Where
                        deskid Not Like 'H%'
                    Group By
                        empno
                ),
                d_days As (
                    Select
                        d_date
                    From
                        (
                            Select
                                d_date
                            From
                                ss_days_details
                            Where
                                d_date Between v_start_date - 20 And v_start_date
                                And d_date Not In (
                                    Select
                                        holiday
                                    From
                                        ss_holidays
                                    Where
                                        holiday Between v_start_date - 20 And v_start_date
                                )
                            Order By d_date Desc
                        )
                    Where
                        Rownum <= 10
                ), emp_list As (
                    Select
                        e.empno,
                        e.name,
                        e.parent,
                        e.assign,
                        e.grade,
                        e.emptype,
                        d_date,
                        emp_deskid,
                        tcmpl_hr.pkg_common.fn_get_office_location_desc(tcmpl_hr.pkg_common.fn_get_emp_office_location(e.
                        empno)) location_desc,
                        iot_swp_common.fn_get_pws_text(iot_swp_common.fn_get_emp_pws(e.empno, d_date))                           pws
                    From
                        ss_emplmast    e,
                        d_days,
                        user_desk_list dl
                    Where
                        e.status    = 1
                        And e.empno = dl.empno(+)
                        And e.emptype In ('C', 'S')

                ), punch_list As (
                    Select
                        empno,
                        pdate,
                            Max(punch_type) Keep(Dense_Rank First Order By
                            hhsort, mmsort) punch_type
                    From
                        (
                            Select
                                a.empno,
                                'PP' punch_type,
                                hhsort,
                                mmsort,
                                pdate
                            From
                                emp_list           a,
                                ss_vu_manual_punch b
                            Where
                                a.empno      = b.empno
                                And a.d_date = b.pdate
                            Union
                            Select
                                a.empno,
                                type,
                                hh,
                                mm,
                                pdate
                            From
                                emp_list     a,
                                ss_ondutyapp b
                            Where
                                type In ('MP', 'IO')
                                And hrd_apprl Not In (ss.approved, ss.rejected)
                                And hod_apprl <> ss.rejected
                                And lead_apprl <> ss.rejected
                                And a.d_date = b.pdate
                                And a.empno  = b.empno
                        )
                    Group By
                        empno,
                        pdate
                    Order By
                        empno,
                        pdate
                )
            Select
                a.empno,
                name employee_name,
                parent,
                assign,
                grade,
                emptype,
                d_date,
                b.punch_type,
                location_desc,
                emp_deskid,
                Case
                    When b.empno Is Null Then
                        0
                    Else
                        1
                End  punch_exists
            From
                emp_list   a,
                punch_list b
            Where
                a.empno      = b.empno (+)
                And a.d_date = b.pdate (+);
        Return c;
    End;

End iot_ss_xl_reports_qry;