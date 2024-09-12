Create Or Replace Package Body selfservice.pkg_leave_calendar_qry As

    Function fn_leave_hr_list(
        p_person_id   Varchar2,
        p_meta_id     Varchar2,
        p_month       Varchar2 Default Null,
        p_parent      Varchar2 Default Null,
        p_row_number  Number,
        p_page_length Number
    ) Return Sys_Refcursor As
        c            Sys_Refcursor;
        v_start_date Date;
        v_end_date   Date;
    Begin

        If p_month Is Null Then
            Select
                trunc(sysdate, 'mm') first_of_month,
                last_day(sysdate)    last_of_month
            Into
                v_start_date,
                v_end_date
            From
                dual;
        Else
            Select
                trunc(To_Date(p_month), 'mm') first_of_month,
                last_day(To_Date(p_month))    last_of_month
            Into
                v_start_date,
                v_end_date
            From
                dual;
        End If;

        Open c For
            Select
                *
            From
                (
                    Select
                        a.app_no                             As "Id",
                        a.empno,
                        a.empno || ' - ' || a.name           As "Title",
                        to_char(a.app_date, 'YYYY-MM-DD')    app_date,
                        to_char(a.bdate, 'YYYY-MM-DD')       As "Start",
                        to_char((a.edate + 1), 'YYYY-MM-DD') As "End",
                        to_char(a.work_ldate, 'YYYY-MM-DD')  As work_l_date,
                        a.leavetype                          As leave_type,
                        a.reason,
                        to_char(a.apprl_status)              apprl_status

                    From
                        ss_vu_4_leave_calendar a
                    Where
                        (a.bdate >= nvl(v_start_date, a.bdate) And a.edate <= nvl(v_end_date, a.edate))
                        And a.parent = nvl(p_parent, a.parent)
                );

        Return c;
    End fn_leave_hr_list;

    Function fn_leave_hod_list(
        p_person_id   Varchar2,
        p_meta_id     Varchar2,
        p_month       Varchar2 Default Null,
        p_parent      Varchar2 Default Null,
        p_row_number  Number,
        p_page_length Number
    ) Return Sys_Refcursor As
        c                    Sys_Refcursor;
        v_start_date         Date;
        v_end_date           Date;

        v_parent             Varchar2(4);
        v_empno              Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
    Begin
        v_empno := selfservice.get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;

        If p_month Is Null Then
            Select
                trunc(sysdate, 'mm') first_of_month,
                last_day(sysdate)    last_of_month
            Into
                v_start_date,
                v_end_date
            From
                dual;
        Else
            Select
                trunc(To_Date(p_month), 'mm') first_of_month,
                last_day(To_Date(p_month))    last_of_month
            Into
                v_start_date,
                v_end_date
            From
                dual;
        End If;
        Open c For
            Select
                *
            From
                (
                    Select
                        a.app_no                             As "Id",
                        a.empno,
                        a.empno || ' - ' || a.name           As "Title",
                        to_char(a.app_date, 'YYYY-MM-DD')    app_date,
                        to_char(a.bdate, 'YYYY-MM-DD')       As "Start",
                        to_char((a.edate + 1), 'YYYY-MM-DD') As "End",
                        to_char(a.work_ldate, 'YYYY-MM-DD')  As work_l_date,
                        a.leavetype                          As leave_type,
                        a.reason,
                        to_char(a.apprl_status)              apprl_status

                    From
                        ss_vu_4_leave_calendar a
                    Where
                        (a.bdate >= nvl(v_start_date, a.bdate) And a.edate <= nvl(v_end_date, a.edate))
                        And (
                            a.parent In(
                                Select
                                    costcode
                                From
                                    ss_costmast
                                Where
                                    hod = v_empno
                                    And costcode = nvl(p_parent, costcode)
                            ) Or a.empno In (
                                Select
                                    empno
                                From
                                    ss_emplmast
                                Where
                                    mngr = v_empno
                            )
                            And parent = nvl(p_parent, parent)
                        )
                );

        Return c;
    End fn_leave_hod_list;

    Function fn_leave_hod_list_for_excel(
        p_person_id   Varchar2,
        p_meta_id     Varchar2,
        p_month       Varchar2 Default Null,
        p_parent      Varchar2 Default Null,
        p_start_date  Date     Default Null,
        p_end_date    Date     Default Null,
        p_view_type   Varchar2,
        p_row_number  Number,
        p_page_length Number
    ) Return Sys_Refcursor As
        c                    Sys_Refcursor;
        v_start_date         Date;
        v_end_date           Date;

        v_parent             Varchar2(4);
        v_empno              Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
    Begin
        v_empno := selfservice.get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;
        If p_view_type = 'dayGridMonth' Then
            If p_month Is Null Then
                Select
                    trunc(sysdate, 'mm') first_of_month,
                    last_day(sysdate)    last_of_month
                Into
                    v_start_date,
                    v_end_date
                From
                    dual;
            Else
                Select
                    trunc(To_Date(p_month), 'mm') first_of_month,
                    last_day(To_Date(p_month))    last_of_month
                Into
                    v_start_date,
                    v_end_date
                From
                    dual;
            End If;
        Else
            v_start_date := p_start_date;
            v_end_date   := p_end_date;
        End If;
        Open c For
            Select
                *
            From
                (
                    Select
                        a.app_no                             As id,
                        a.empno || ' - ' || a.name           As emp_name,
                        to_char(a.app_date, 'YYYY-MM-DD')    As app_date,
                        to_char(a.bdate, 'YYYY-MM-DD')       As start_date,
                        to_char((a.edate + 1), 'YYYY-MM-DD') As end_date,
                        to_char(a.work_ldate, 'YYYY-MM-DD')  As work_last_date,
                        a.leavetype                          As leave_type,
                        a.reason                             As reason,
                        b.emptype                            As emp_type,
                        b.grade                              As grade,
                        a.parent                             As parent,
                        to_char(a.edate - a.bdate + 1)       As leave_period
                    From
                        ss_vu_4_leave_calendar a
                        Join ss_emplmast       b
                        On a.empno = b.empno
                    Where
                        (a.bdate >= nvl(v_start_date, a.bdate) And a.edate <= nvl(v_end_date, a.edate))
                        And (
                            a.parent In(
                                Select
                                    costcode
                                From
                                    ss_costmast
                                Where
                                    hod = v_empno
                                    And costcode = nvl(p_parent, costcode)
                            ) Or a.empno In (
                                Select
                                    empno
                                From
                                    ss_emplmast
                                Where
                                    mngr = v_empno
                            )
                            And a.parent = nvl(p_parent, a.parent)
                        )
                );

        Return c;
    End fn_leave_hod_list_for_excel;

End pkg_leave_calendar_qry;
/