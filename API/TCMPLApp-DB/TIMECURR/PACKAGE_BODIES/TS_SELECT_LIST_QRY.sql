--------------------------------------------------------
--  DDL for Package Body TS_SELECT_LIST_QRY
--------------------------------------------------------

Create Or Replace Package Body "TIMECURR"."TS_SELECT_LIST_QRY" As

    Function fn_year_list(
        p_person_id Varchar2,
        p_meta_id   Varchar2
    ) Return Sys_Refcursor As
        c Sys_Refcursor;
    Begin
        Open c For
            Select
                ts_yyyy data_value_field,
                ts_yyyy data_text_field
            From
                timecurr.ngts_year_mast
            Where
                ts_isactive = 1
            Order By
                ts_yyyy Desc;

        Return c;
    End;

    Function fn_yearmonth_list(
        p_person_id Varchar2,
        p_meta_id   Varchar2,
        p_yyyy      Varchar2,
        p_yearmode  Varchar2
    ) Return Sys_Refcursor As
        c Sys_Refcursor;
    Begin
        Open c For
            Select
                value data_value_field,
                text  data_text_field
            From
                (
                    Select
                        to_char(add_months(To_Date('01-'
                                    ||
                                    Case p_yearmode
                                        When 'A' Then
                                            'Apr-'
                                        Else
                                            'Jan-'
                                    End
                                    || substr(p_yyyy, 1, 4)), 0), 'yyyymm')   value,
                        to_char(add_months(To_Date('01-'
                                    ||
                                    Case p_yearmode
                                        When 'A' Then
                                            'Apr-'
                                        Else
                                            'Jan-'
                                    End
                                    || substr(p_yyyy, 1, 4)), 0), 'Mon Yyyy') text
                    From
                        dual
                    Union All
                    Select
                        to_char(add_months(To_Date('01-'
                                    ||
                                    Case p_yearmode
                                        When 'A' Then
                                            'Apr-'
                                        Else
                                            'Jan-'
                                    End
                                    || substr(p_yyyy, 1, 4)), 1), 'yyyymm')   value,
                        to_char(add_months(To_Date('01-'
                                    ||
                                    Case p_yearmode
                                        When 'A' Then
                                            'Apr-'
                                        Else
                                            'Jan-'
                                    End
                                    || substr(p_yyyy, 1, 4)), 1), 'Mon Yyyy') text
                    From
                        dual
                    Union All
                    Select
                        to_char(add_months(To_Date('01-'
                                    ||
                                    Case p_yearmode
                                        When 'A' Then
                                            'Apr-'
                                        Else
                                            'Jan-'
                                    End
                                    || substr(p_yyyy, 1, 4)), 2), 'yyyymm')   value,
                        to_char(add_months(To_Date('01-'
                                    ||
                                    Case p_yearmode
                                        When 'A' Then
                                            'Apr-'
                                        Else
                                            'Jan-'
                                    End
                                    || substr(p_yyyy, 1, 4)), 2), 'Mon Yyyy') text
                    From
                        dual
                    Union All
                    Select
                        to_char(add_months(To_Date('01-'
                                    ||
                                    Case p_yearmode
                                        When 'A' Then
                                            'Apr-'
                                        Else
                                            'Jan-'
                                    End
                                    || substr(p_yyyy, 1, 4)), 3), 'yyyymm')   value,
                        to_char(add_months(To_Date('01-'
                                    ||
                                    Case p_yearmode
                                        When 'A' Then
                                            'Apr-'
                                        Else
                                            'Jan-'
                                    End
                                    || substr(p_yyyy, 1, 4)), 3), 'Mon Yyyy') text
                    From
                        dual
                    Union All
                    Select
                        to_char(add_months(To_Date('01-'
                                    ||
                                    Case p_yearmode
                                        When 'A' Then
                                            'Apr-'
                                        Else
                                            'Jan-'
                                    End
                                    || substr(p_yyyy, 1, 4)), 4), 'yyyymm')   value,
                        to_char(add_months(To_Date('01-'
                                    ||
                                    Case p_yearmode
                                        When 'A' Then
                                            'Apr-'
                                        Else
                                            'Jan-'
                                    End
                                    || substr(p_yyyy, 1, 4)), 4), 'Mon Yyyy') text
                    From
                        dual
                    Union All
                    Select
                        to_char(add_months(To_Date('01-'
                                    ||
                                    Case p_yearmode
                                        When 'A' Then
                                            'Apr-'
                                        Else
                                            'Jan-'
                                    End
                                    || substr(p_yyyy, 1, 4)), 5), 'yyyymm')   value,
                        to_char(add_months(To_Date('01-'
                                    ||
                                    Case p_yearmode
                                        When 'A' Then
                                            'Apr-'
                                        Else
                                            'Jan-'
                                    End
                                    || substr(p_yyyy, 1, 4)), 5), 'Mon Yyyy') text
                    From
                        dual
                    Union All
                    Select
                        to_char(add_months(To_Date('01-'
                                    ||
                                    Case p_yearmode
                                        When 'A' Then
                                            'Apr-'
                                        Else
                                            'Jan-'
                                    End
                                    || substr(p_yyyy, 1, 4)), 6), 'yyyymm')   value,
                        to_char(add_months(To_Date('01-'
                                    ||
                                    Case p_yearmode
                                        When 'A' Then
                                            'Apr-'
                                        Else
                                            'Jan-'
                                    End
                                    || substr(p_yyyy, 1, 4)), 6), 'Mon Yyyy') text
                    From
                        dual
                    Union All
                    Select
                        to_char(add_months(To_Date('01-'
                                    ||
                                    Case p_yearmode
                                        When 'A' Then
                                            'Apr-'
                                        Else
                                            'Jan-'
                                    End
                                    || substr(p_yyyy, 1, 4)), 7), 'yyyymm')   value,
                        to_char(add_months(To_Date('01-'
                                    ||
                                    Case p_yearmode
                                        When 'A' Then
                                            'Apr-'
                                        Else
                                            'Jan-'
                                    End
                                    || substr(p_yyyy, 1, 4)), 7), 'Mon Yyyy') text
                    From
                        dual
                    Union All
                    Select
                        to_char(add_months(To_Date('01-'
                                    ||
                                    Case p_yearmode
                                        When 'A' Then
                                            'Apr-'
                                        Else
                                            'Jan-'
                                    End
                                    || substr(p_yyyy, 1, 4)), 8), 'yyyymm')   value,
                        to_char(add_months(To_Date('01-'
                                    ||
                                    Case p_yearmode
                                        When 'A' Then
                                            'Apr-'
                                        Else
                                            'Jan-'
                                    End
                                    || substr(p_yyyy, 1, 4)), 8), 'Mon Yyyy') text
                    From
                        dual
                    Union All
                    Select
                        to_char(add_months(To_Date('01-'
                                    ||
                                    Case p_yearmode
                                        When 'A' Then
                                            'Apr-'
                                        Else
                                            'Jan-'
                                    End
                                    || substr(p_yyyy, 1, 4)), 9), 'yyyymm')   value,
                        to_char(add_months(To_Date('01-'
                                    ||
                                    Case p_yearmode
                                        When 'A' Then
                                            'Apr-'
                                        Else
                                            'Jan-'
                                    End
                                    || substr(p_yyyy, 1, 4)), 9), 'Mon Yyyy') text
                    From
                        dual
                    Union All
                    Select
                        to_char(add_months(To_Date('01-'
                                    ||
                                    Case p_yearmode
                                        When 'A' Then
                                            'Apr-'
                                        Else
                                            'Jan-'
                                    End
                                    || substr(p_yyyy, 1, 4)), 10), 'yyyymm')   value,
                        to_char(add_months(To_Date('01-'
                                    ||
                                    Case p_yearmode
                                        When 'A' Then
                                            'Apr-'
                                        Else
                                            'Jan-'
                                    End
                                    || substr(p_yyyy, 1, 4)), 10), 'Mon Yyyy') text
                    From
                        dual
                    Union All
                    Select
                        to_char(add_months(To_Date('01-'
                                    ||
                                    Case p_yearmode
                                        When 'A' Then
                                            'Apr-'
                                        Else
                                            'Jan-'
                                    End
                                    || substr(p_yyyy, 1, 4)), 11), 'yyyymm')   value,
                        to_char(add_months(To_Date('01-'
                                    ||
                                    Case p_yearmode
                                        When 'A' Then
                                            'Apr-'
                                        Else
                                            'Jan-'
                                    End
                                    || substr(p_yyyy, 1, 4)), 11), 'Mon Yyyy') text
                    From
                        dual
                )
            Where
                To_Number(value) <= (
                    Select
                        To_Number(pros_month)
                    From
                        tsconfig
                )
            Order By
                value Desc;

        Return c;
    End;

    Function fn_dept_empno_list(
        p_person_id Varchar2,
        p_meta_id   Varchar2,

        p_yyyymm    Varchar2
    ) Return Sys_Refcursor As
        c       Sys_Refcursor;
        v_empno Varchar2(5);
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);

        Open c For
            Select
                e.empno                     data_value_field,
                e.empno || ' - ' || e.name  data_text_field,
                e.assign || ' - ' || c.name data_group_field
            From
                emplmast             e, costmast c
            Where
                e.assign                             = c.costcode
               /* And e.emptype In (
                    Select
                        emptype
                    From
                        emptypemast
                    Where
                        tm = 1
                )*/
                And (e.status                        = 1
                    Or
                    (e.status                        = 0
                        And e.empno In (
                            Select
                                empno
                            From
                                time_mast
                            Where
                                yymm = p_yyyymm
                        )
                    )
                    Or
                    (e.status                        = 0
                        And to_char(e.dol, 'YYYYMM') = (
                            Select
                                pros_month
                            From
                                tsconfig
                        )))
                And e.assign In (
                    Select
                        costcode
                    From
                        deptphase
                    Where
                        isprimary = 1
                )
                And (e.assign In
                    (
                        Select
                            costcode
                        From
                            costmast
                        Where
                            hod          = v_empno
                            Or secretary = v_empno
                        Union All
                        Select
                            costcode
                        From
                            time_secretary
                        Where
                            empno = v_empno
                    )
                    Or (e.empno                      = v_empno
                        Or e.do                      = v_empno))

            Order By
                3,
                1;

        Return c;
    End;

    Function fn_all_empno_list(
        p_person_id Varchar2,
        p_meta_id   Varchar2,

        p_yyyymm    Varchar2
    ) Return Sys_Refcursor As
        c Sys_Refcursor;
    Begin
        Open c For
            Select
                e.empno                     data_value_field,
                e.empno || ' - ' || e.name  data_text_field,
                e.assign || ' - ' || c.name data_group_field
            From
                emplmast             e, costmast c
            Where
                e.assign                             = c.costcode
               /* And e.emptype In (
                    Select
                        emptype
                    From
                        emptypemast
                    Where
                        tm = 1
                )*/
                And (e.status                        = 1
                    Or
                    (e.status                        = 0
                        And e.empno In (
                            Select
                                empno
                            From
                                time_mast
                            Where
                                yymm = p_yyyymm
                        )
                    )
                    Or
                    (e.status                        = 0
                        And to_char(e.dol, 'YYYYMM') = (
                            Select
                                pros_month
                            From
                                tsconfig
                        )))
                And e.assign In (
                    Select
                        costcode
                    From
                        deptphase
                    Where
                        isprimary = 1
                )
            Order By
                3,
                1;

        Return c;
    End;

    Function fn_osc_costcode_list(
        p_person_id Varchar2,
        p_meta_id   Varchar2
    ) Return Sys_Refcursor As
        c       Sys_Refcursor;
        v_empno Varchar2(5);
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);

        Open c For
            Select
            Distinct c.costcode               data_value_field,
                c.costcode || ' - ' || c.name data_text_field
            From
                costmast  c,
                deptphase dp
            Where
                c.active         = 1
                And c.costcode   = dp.costcode
                And dp.isprimary = 1
                And c.costcode In
                (
                    Select
                        costcode
                    From
                        costmast
                    Where
                        hod          = Trim(v_empno)
                        Or secretary = Trim(v_empno)
                    Union All
                    Select
                        costcode
                    From
                        time_secretary
                    Where
                        empno = Trim(v_empno)
                )
            Order By
                1;

        Return c;
    End;

    Function fn_osc_costcode_empno_list(
        p_person_id Varchar2,
        p_meta_id   Varchar2,

        p_costcode  Varchar2
    ) Return Sys_Refcursor As
        c       Sys_Refcursor;
        v_empno Varchar2(5);
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);

        Open c For
            Select
                e.empno                    data_value_field,
                e.empno || ' - ' || e.name data_text_field
            From
                emplmast    e,
                costmast    c,
                emptypemast etm,
                deptphase   dp
            Where
                e.assign         = c.costcode
                And e.status     = 1
                And c.active     = 1
                And e.emptype    = etm.emptype
                And e.emptype    = 'O'
                --And etm.tm       = 1
                And e.assign     = dp.costcode
                And dp.isprimary = 1
                And (e.empno, p_costcode) Not In (
                    Select
                        tomm.empno, tomm.assign
                    From
                        ts_osc_mhrs_master tomm,
                        tsconfig           t
                    Where
                        tomm.is_lock  = 'OK'
                        And tomm.yymm = t.pros_month
                )
            Order By
                1;

        Return c;
    End;

    Function fn_projno_list(
        p_person_id Varchar2,
        p_meta_id   Varchar2,

        p_costcode  Varchar2
    ) Return Sys_Refcursor As
        c                    Sys_Refcursor;
        v_empno              Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;

        Open c For
            Select
                p.projno                    data_value_field,
                p.projno || ' - ' || p.name data_text_field
            From
                projmast             p, tsconfig t
            Where
                p.active            = 1
                And p.block_booking = 0
                And To_Number(to_char(p.revcdate, 'YYYYMM')) >= To_Number(t.pros_month)
                And substr(p.projno, 6, 2) In (
                    Select
                        phase
                    From
                        deptphase
                    Where
                        costcode = Trim(p_costcode)
                )
                And
                p.projno Not In (
                    Select
                        projno
                    From
                        job_lock
                )
                And
                substr(p.projno, 1, 5) Not In (
                    Select
                        projno
                    From
                        tm_leave
                )
                And
                substr(p.projno, 1, 5) In (
                    Select
                        projno
                    From
                        jobmaster
                    Where actual_closing_date Is Null
                )
            Order By
                projno;

        Return c;
    End;

    Function fn_wpcode_list(
        p_person_id Varchar2,
        p_meta_id   Varchar2
    ) Return Sys_Refcursor As
        c                    Sys_Refcursor;
        v_empno              Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;

        Open c For
            Select
                wpcode                    data_value_field,
                wpcode || ' - ' || wpdesc data_text_field
            From
                time_wpcode
            Order By
                wpcode;

        Return c;
    End;

    Function fn_activity_list(
        p_person_id Varchar2,
        p_meta_id   Varchar2,

        p_costcode  Varchar2
    ) Return Sys_Refcursor As
        c                    Sys_Refcursor;
        v_empno              Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;
        Open c For
            Select
                activity                  data_value_field,
                activity || ' - ' || name data_text_field
            From
                act_mast
            Where
                costcode   = Trim(p_costcode)
                And active = 1
            Order By
                activity;
        Return c;
    End fn_activity_list;

End ts_select_list_qry;