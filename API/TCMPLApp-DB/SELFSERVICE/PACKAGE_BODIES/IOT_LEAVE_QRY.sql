--------------------------------------------------------
--  DDL for Package Body IOT_LEAVE_QRY
--------------------------------------------------------

Create Or Replace Package Body "SELFSERVICE"."IOT_LEAVE_QRY" As

    Function get_leave_applications(
        p_empno        Varchar2,
        p_req_for_self Varchar2,
        p_start_date   Date     Default Null,
        p_end_date     Date     Default Null,
        p_leave_type   Varchar2 Default Null,
        p_row_number   Number,
        p_page_length  Number
    ) Return Sys_Refcursor As
        c Sys_Refcursor;
    Begin
        Open c For
            Select
                *
            From
                (
                    Select
                        app_date_4_sort,
                        lead,
                        app_no,
                        application_date,
                        start_date,
                        end_date,
                        leave_type,
                        leave_period,
                        lead_approval_desc,
                        hod_approval_desc,
                        hrd_approval_desc,
                        lead_reason,
                        hod_reason,
                        hrd_reason,
                        from_tab,
                        db_cr,
                        is_pl,
                        can_delete_app,
                        Sum(is_pl) Over (Order By start_date Desc, app_no)   As pl_total,
                        Case
                            When Sum(is_pl) Over (Order By start_date Desc, app_no) <= 3
                                And is_pl = 1
                            Then
                                1
                            Else
                                0
                        End                                                  As can_edit_pl_app,
                        Trim(med_cert_file_name)                             As med_cert_file_name,
                        Row_Number() Over (Order By start_date Desc, app_no) As row_number,
                        Count(*) Over ()                                     As total_row

                    From
                        (
                                (

                        Select
                            la.app_date                             As app_date_4_sort,
                            get_emp_name(la.lead_apprl_empno)       As lead,
                            ltrim(rtrim(la.app_no))                 As app_no,
                            to_char(la.app_date, 'dd-Mon-yyyy')     As application_date,
                            la.bdate                                As start_date,
                            la.edate                                As end_date,
                            Case
                                When nvl(is_covid_sick_leave, 0) = 1
                                    And Trim(leavetype)          = 'SL'
                                Then
                                    'SL-COVID'
                                Else
                                    Trim(leavetype)
                            End                                     As leave_type,
                            to_days(la.leaveperiod)                 As leave_period,
                            ss.approval_text(nvl(la.lead_apprl, 0)) As lead_approval_desc,
                            Case nvl(la.lead_apprl, 0)
                                When ss.disapproved Then
                                    '-'
                                Else
                                    ss.approval_text(nvl(la.hod_apprl, 0))
                            End                                     As hod_approval_desc,
                            Case nvl(la.hod_apprl, 0)
                                When ss.disapproved Then
                                    '-'
                                Else
                                    ss.approval_text(nvl(la.hrd_apprl, 0))
                            End                                     As hrd_approval_desc,
                            la.lead_reason,
                            la.hodreason                            As hod_reason,
                            la.hrdreason                            As hrd_reason,
                            '1'                                     As from_tab,
                            'D'                                     As db_cr,
                            Case
                                When is_rejected = 1 Then
                                    0
                                When nvl(la.hrd_apprl, 0) = 1
                                    And la.leavetype      = 'PL'
                                Then
                                    1
                                Else
                                    0
                            End                                     As is_pl,
                            med_cert_file_name                      As med_cert_file_name,
                            Case
                                When p_req_for_self                  = 'OK'
                                    And nvl(la.lead_apprl, c_pending) In (c_pending, c_apprl_none)
                                    And nvl(la.hod_apprl, c_pending) = c_pending
                                Then
                                    1
                                Else
                                    0
                            End                                     can_delete_app
                        From
                            ss_vu_leaveapp la
                        Where
                            la.app_no Not Like 'Prev%'
                            And Trim(la.empno) = p_empno
                            And la.leavetype   = nvl(p_leave_type, la.leavetype)

                        )
                        Union
                        (
                        Select
                            a.app_date                                                       As app_date_4_sort,
                            ''                                                               As lead,
                            Trim(a.app_no)                                                   As app_no,
                            to_char(a.app_date, 'dd-Mon-yyyy')                               As application_date,
                            a.bdate                                                          As start_date,
                            a.edate                                                          As end_date,
                            Case
                                When nvl(is_covid_sick_leave, 0) = 1
                                    And Trim(leavetype)          = 'SL'
                                Then
                                    'SL-COVID'
                                Else
                                    Trim(leavetype)
                            End                                                              As leave_type,
                            to_days(decode(a.db_cr, 'D', a.leaveperiod * -1, a.leaveperiod)) As leave_period,
                            'NONE'                                                           As lead_approval_desc,
                            'Approved'                                                       As hod_approval_desc,
                            'Approved'                                                       As hrd_approval_desc,
                            ''                                                               As lead_reason,
                            ''                                                               As hod_reason,
                            ''                                                               As hrd_reason,
                            '2'                                                              As from_tab,
                            db_cr                                                            As db_cr,
                            0                                                                As is_pl,
                            Null                                                             As med_cert_file_name,
                            0                                                                As can_delete
                        From
                            ss_leaveledg a
                        Where
                            a.empno         = lpad(Trim(p_empno), 5, 0)
                            And a.app_no Not Like 'Prev%'
                            And a.leavetype = nvl(p_leave_type, a.leavetype)
                            And ltrim(rtrim(a.app_no)) Not In
                            (
                                Select
                                    ss_vu_leaveapp.app_no
                                From
                                    ss_vu_leaveapp
                                Where
                                    ss_vu_leaveapp.empno = p_empno
                            )
                        )

                        )
                    Where
                        start_date >= add_months(sysdate, -24)
                        And trunc(start_date) Between nvl(p_start_date, trunc(start_date)) And nvl(p_end_date, trunc(start_date))
                    Order By start_date Desc, app_date_4_sort Desc
                )
            Where
                row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length);

        Return c;

    End;

    Function get_leave_ledger(
        p_empno       Varchar2,
        p_start_date  Date Default Null,
        p_end_date    Date Default Null,
        p_row_number  Number,
        p_page_length Number
    ) Return Sys_Refcursor As
        c            Sys_Refcursor;
        v_start_date Date;
        v_end_date   Date;
    Begin
        If p_start_date Is Null Then
            v_start_date := trunc(nvl(p_start_date, sysdate), 'YEAR');
            v_end_date   := add_months(trunc(nvl(p_end_date, sysdate), 'YEAR'), 12) - 1;
        Else
            v_start_date := trunc(p_start_date);
            v_end_date   := trunc(p_end_date);
        End If;
        Open c For
            Select
                app_no,
                app_date As application_date,
                leave_type,
                description,
                b_date   start_date,
                e_date   end_date,
                no_of_days_db,
                no_of_days_cr,
                row_number,
                total_row
            From
                (
                    Select
                        app_no,
                        app_date,
                        Case
                            When nvl(is_covid_sick_leave, 0) = 1
                                And Trim(leavetype)          = 'SL'
                            Then
                                'SL-COVID'
                            Else
                                Trim(leavetype)
                        End                                    As leave_type,
                        description,
                        dispbdate                              b_date,
                        dispedate                              e_date,
                        to_days(dbday)                         no_of_days_db,
                        to_days(crday)                         no_of_days_cr,
                        Row_Number() Over (Order By dispbdate) row_number,
                        Count(*) Over ()                       total_row
                    From
                        ss_displedg
                    Where
                        empno = p_empno
                        And dispbdate Between v_start_date And v_end_date
                )
            Where
                row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length);

        Return c;

    End get_leave_ledger;

    Function fn_leave_ledger_4_self(
        p_person_id   Varchar2,
        p_meta_id     Varchar2,
        p_start_date  Date Default Null,
        p_end_date    Date Default Null,
        p_row_number  Number,
        p_page_length Number
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
        c       := get_leave_ledger(v_empno, p_start_date, p_end_date, p_row_number, p_page_length);
        Return c;
    End fn_leave_ledger_4_self;

    Function fn_leave_ledger_4_other(
        p_person_id   Varchar2,
        p_meta_id     Varchar2,
        p_empno       Varchar2,
        p_start_date  Date Default Null,
        p_end_date    Date Default Null,
        p_row_number  Number,
        p_page_length Number
    ) Return Sys_Refcursor As
        c       Sys_Refcursor;
        v_empno Varchar2(5);
    Begin
        Select
            empno
        Into
            v_empno
        From
            ss_emplmast
        Where
            empno = p_empno;
        --And status = 1;
        c := get_leave_ledger(v_empno, p_start_date, p_end_date, p_row_number, p_page_length);
        Return c;
    End fn_leave_ledger_4_other;

    Function fn_leave_applications_4_other(
        p_person_id   Varchar2,
        p_meta_id     Varchar2,
        p_empno       Varchar2,
        p_start_date  Date     Default Null,
        p_end_date    Date     Default Null,
        p_leave_type  Varchar2 Default Null,
        p_row_number  Number,
        p_page_length Number
    ) Return Sys_Refcursor As
        c                    Sys_Refcursor;
        v_self_empno         Varchar2(5);
        v_req_for_self       Varchar2(2);
        v_for_empno          Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
    Begin
        v_self_empno := get_empno_from_meta_id(p_meta_id);
        If v_self_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;
        Select
            empno
        Into
            v_for_empno
        From
            ss_emplmast
        Where
            empno = p_empno;
        --And status = 1;
        If v_self_empno = v_for_empno Then
            v_req_for_self := 'OK';
        Else
            v_req_for_self := 'KO';
        End If;
        c            := get_leave_applications(v_for_empno, v_req_for_self, p_start_date, p_end_date, p_leave_type, p_row_number,
                                               p_page_length);
        Return c;
    End fn_leave_applications_4_other;

    Function fn_leave_applications_4_self(
        p_person_id   Varchar2,
        p_meta_id     Varchar2,
        p_start_date  Date     Default Null,
        p_end_date    Date     Default Null,
        p_leave_type  Varchar2 Default Null,
        p_row_number  Number,
        p_page_length Number
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
        c       := get_leave_applications(v_empno, 'OK', p_start_date, p_end_date, p_leave_type, p_row_number, p_page_length);
        Return c;
    End fn_leave_applications_4_self;

    Function fn_pending_hod_approval(

        p_person_id   Varchar2,
        p_meta_id     Varchar2,
        p_row_number  Number,
        p_page_length Number
    ) Return Sys_Refcursor As
        c                    Sys_Refcursor;
        v_hod_empno          Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
    Begin
        v_hod_empno := get_empno_from_meta_id(p_meta_id);
        If v_hod_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;

        Open c For
            Select
                *
            From
                (
                    Select
                        l.empno || ' - ' || e.name                   As employee_name,
                        parent,
                        app_date                                     As application_date,
                        app_no                                       As application_id,
                        bdate                                        As start_date,
                        edate                                        As end_date,
                        to_days(leaveperiod)                         As leave_period,
                        Case
                            When nvl(is_covid_sick_leave, 0) = 1
                                And Trim(leavetype)          = 'SL'
                            Then
                                'SL-COVID'
                            Else
                                Trim(leavetype)
                        End                                          As leave_type,
                        get_emp_name(l.lead_apprl_empno)             As lead_name,
                        Trim(med_cert_file_name)                     As med_cert_file_name,
                        lead_reason                                  As lead_remarks,
                        hodreason                                    As hod_remarks,
                        hrdreason                                    As hr_remarks,
                        Row_Number() Over (Order By parent, l.empno) row_number,
                        Count(*) Over ()                             total_row

                    From
                        ss_leaveapp l,
                        ss_emplmast e
                    Where
                        (nvl(hod_apprl, c_pending) = c_pending)
                        And l.empno                = e.empno
                        And e.status               = 1
                        And nvl(lead_apprl, c_pending) In (c_approved, c_apprl_none)
                        And e.mngr                 = Trim(v_hod_empno)
                        And l.leavetype <> 'SL'
                    Order By parent,
                        l.empno
                )
            Where
                row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length);
        Return c;
    End fn_pending_hod_approval;

    Function fn_pending_onbehalf_approval(

        p_person_id   Varchar2,
        p_meta_id     Varchar2,
        p_row_number  Number,
        p_page_length Number
    ) Return Sys_Refcursor As
        c                    Sys_Refcursor;
        v_hod_empno          Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
    Begin
        v_hod_empno := get_empno_from_meta_id(p_meta_id);
        If v_hod_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;

        Open c For
            Select
                *
            From
                (
                    Select
                        l.empno || ' - ' || e.name                   As employee_name,
                        parent,
                        app_date                                     As application_date,
                        app_no                                       As application_id,
                        bdate                                        As start_date,
                        edate                                        As end_date,
                        to_days(leaveperiod)                         As leave_period,
                        leavetype                                    As leave_type,
                        get_emp_name(l.lead_apprl_empno)             As lead_name,
                        Trim(med_cert_file_name)                     As med_cert_file_name,
                        lead_reason                                  As lead_remarks,
                        hodreason                                    As hod_remarks,
                        hrdreason                                    As hr_remarks,
                        Row_Number() Over (Order By parent, l.empno) row_number,
                        Count(*) Over ()                             total_row

                    From
                        ss_leaveapp l,
                        ss_emplmast e
                    Where
                        (nvl(hod_apprl, c_pending) = c_pending)
                        And l.empno                = e.empno
                        And e.status               = 1
                        And nvl(lead_apprl, c_pending) In (c_approved, c_apprl_none)
                        And e.mngr In (
                            Select
                                mngr
                            From
                                ss_delegate
                            Where
                                empno = Trim(v_hod_empno)
                        )
                        And l.leavetype <> 'SL'
                    Order By parent,
                        l.empno
                )
            Where
                row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length);
        Return c;
    End fn_pending_onbehalf_approval;

    Function fn_pending_hr_approval(

        p_person_id   Varchar2,
        p_meta_id     Varchar2,
        p_parent      Varchar2 Default Null,

        p_row_number  Number,
        p_page_length Number
    ) Return Sys_Refcursor As
        c                    Sys_Refcursor;
        v_hr_empno           Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
    Begin
        /*
            v_hr_empno := get_empno_from_meta_id(p_meta_id);
            If v_hr_empno = 'ERRRR' Then
                Raise e_employee_not_found;
                Return Null;
            End If;
        */
        Open c For
            Select
                *
            From
                (
                    Select
                        l.empno || ' - ' || e.name                   As employee_name,
                        parent,
                        app_date                                     As application_date,
                        app_no                                       As application_id,
                        bdate                                        As start_date,
                        edate                                        As end_date,
                        to_days(leaveperiod)                         As leave_period,
                        Case
                            When nvl(is_covid_sick_leave, 0) = 1
                                And Trim(leavetype)          = 'SL'
                            Then
                                'SL-COVID'
                            Else
                                Trim(leavetype)
                        End                                          As leave_type,
                        Case leavetype
                            When 'CL' Then
                                closingclbal(l.empno, trunc(sysdate), 0)
                            When 'SL' Then
                                closingslbal(l.empno, trunc(sysdate), 0)
                            When 'PL' Then
                                closingplbal(l.empno, trunc(sysdate), 0)
                            When 'CO' Then
                                closingcobal(l.empno, trunc(sysdate), 0)
                            When 'EX' Then
                                closingexbal(l.empno, trunc(sysdate), 0)
                            When 'OH' Then
                                closingohbal(l.empno, trunc(sysdate), 0)
                            Else
                                0
                        End                                          As leave_balance,
                        --Get_Leave_Balance(l.empno,sysdate,ss.closing_bal,leavetype, :param_Leave_Count)                        
                        get_emp_name(l.lead_apprl_empno)             As lead_name,
                        Trim(med_cert_file_name)                     As med_cert_file_name,
                        lead_reason                                  As lead_remarks,
                        hodreason                                    As hod_marks,
                        hrdreason                                    As hr_remarks,
                        Row_Number() Over (Order By parent, l.empno) row_number,
                        Count(*) Over ()                             total_row

                    From
                        ss_leaveapp l,
                        ss_emplmast e
                    Where
                        l.empno                         = e.empno
                        And nvl(l.hod_apprl, c_pending) = c_approved
                        And nvl(l.hrd_apprl, c_pending) = c_pending
                        And e.status                    = 1
                        And e.parent                    = nvl(p_parent, e.parent)
                        And l.leavetype <> 'SL'
                    Order By parent,
                        l.empno
                )
            Where
                row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length);
        Return c;
    End fn_pending_hr_approval;

    Function fn_pending_lead_approval(

        p_person_id   Varchar2,
        p_meta_id     Varchar2,
        p_row_number  Number,
        p_page_length Number
    ) Return Sys_Refcursor As
        c                    Sys_Refcursor;
        v_lead_empno         Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
    Begin
        v_lead_empno := get_empno_from_meta_id(p_meta_id);
        If v_lead_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;

        Open c For
            Select
                *
            From
                (
                    Select
                        l.empno || ' - ' || e.name                   As employee_name,
                        parent,
                        app_date                                     As application_date,
                        app_no                                       As application_id,
                        bdate                                        As start_date,
                        edate                                        As end_date,
                        to_days(leaveperiod)                         As leave_period,
                        Case
                            When nvl(is_covid_sick_leave, 0) = 1
                                And Trim(leavetype)          = 'SL'
                            Then
                                'SL-COVID'
                            Else
                                Trim(leavetype)
                        End                                          As leave_type,
                        get_emp_name(l.lead_apprl_empno)             As lead_name,
                        Trim(med_cert_file_name)                     As med_cert_file_name,
                        lead_reason                                  As lead_remarks,
                        hodreason                                    As hod_marks,
                        hrdreason                                    As hr_remarks,
                        Row_Number() Over (Order By parent, l.empno) row_number,
                        Count(*) Over ()                             total_row
                    From
                        ss_leaveapp l,
                        ss_emplmast e
                    Where
                        (nvl(lead_apprl, 0)    = 0)
                        And l.empno            = e.empno
                        And e.status           = 1
                        And l.lead_apprl_empno = Trim(v_lead_empno)
                        And l.leavetype <> 'SL'

                    Order By parent,
                        l.empno
                )
            Where
                row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length);

        Return c;
    End fn_pending_lead_approval;

    Function fn_sl_pend_hr_approval(

        p_person_id   Varchar2,
        p_meta_id     Varchar2,
        p_parent      Varchar2 Default Null,

        p_row_number  Number,
        p_page_length Number
    ) Return Sys_Refcursor As
        c                    Sys_Refcursor;
        v_hr_empno           Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
    Begin
        /*
            v_hr_empno := get_empno_from_meta_id(p_meta_id);
            If v_hr_empno = 'ERRRR' Then
                Raise e_employee_not_found;
                Return Null;
            End If;
        */
        Open c For
            Select
                *
            From
                (
                    Select
                        l.empno || ' - ' || e.name                   As employee_name,
                        parent,
                        app_date                                     As application_date,
                        app_no                                       As application_id,
                        bdate                                        As start_date,
                        edate                                        As end_date,
                        to_days(leaveperiod)                         As leave_period,
                        Case
                            When nvl(is_covid_sick_leave, 0) = 1
                                And Trim(leavetype)          = 'SL'
                            Then
                                'SL-COVID'
                            Else
                                Trim(leavetype)
                        End                                          As leave_type,

                        iot_leave.fn_sl_in_yyyy(l.empno, bdate)      As leave_availed,

                        get_emp_name(l.lead_apprl_empno)             As lead_name,
                        Trim(med_cert_file_name)                     As med_cert_file_name,
                        lead_reason                                  As lead_remarks,
                        hodreason                                    As hod_marks,
                        hrdreason                                    As hr_remarks,
                        Row_Number() Over (Order By parent, l.empno) As row_number,
                        Count(*) Over ()                             As total_row

                    From
                        ss_leaveapp l,
                        ss_emplmast e
                    Where
                        l.empno                         = e.empno
                        And l.leavetype                 = 'SL'
                        And nvl(l.hod_apprl, c_pending) = c_approved
                        And nvl(l.hrd_apprl, c_pending) = c_pending
                        And e.status                    = 1
                        And e.parent                    = nvl(p_parent, e.parent)

                    Order By parent,
                        l.empno
                )
            Where
                row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length);
        Return c;
    End fn_sl_pend_hr_approval;

    Function fn_sl_pend_hod_approval(

        p_person_id   Varchar2,
        p_meta_id     Varchar2,
        p_row_number  Number,
        p_page_length Number
    ) Return Sys_Refcursor As
        c                    Sys_Refcursor;
        v_hod_empno          Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
    Begin
        v_hod_empno := get_empno_from_meta_id(p_meta_id);
        If v_hod_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;

        Open c For
            Select
                *
            From
                (
                    Select
                        l.empno || ' - ' || e.name                   As employee_name,
                        parent,
                        app_date                                     As application_date,
                        app_no                                       As application_id,
                        bdate                                        As start_date,
                        edate                                        As end_date,
                        to_days(leaveperiod)                         As leave_period,
                        Case
                            When nvl(is_covid_sick_leave, 0) = 1
                                And Trim(leavetype)          = 'SL'
                            Then
                                'SL-COVID'
                            Else
                                Trim(leavetype)
                        End                                          As leave_type,
                        get_emp_name(l.lead_apprl_empno)             As lead_name,
                        Trim(med_cert_file_name)                     As med_cert_file_name,
                        lead_reason                                  As lead_remarks,
                        hodreason                                    As hod_remarks,
                        hrdreason                                    As hr_remarks,
                        Row_Number() Over (Order By parent, l.empno) row_number,
                        Count(*) Over ()                             total_row

                    From
                        ss_leaveapp l,
                        ss_emplmast e
                    Where
                        (nvl(hod_apprl, c_pending) = c_pending)
                        And l.empno                = e.empno
                        And e.status               = 1
                        And nvl(lead_apprl, c_pending) In (c_approved, c_apprl_none)
                        And e.mngr                 = Trim(v_hod_empno)
                        And l.leavetype            = 'SL'
                    Order By parent,
                        l.empno
                )
            Where
                row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length);
        Return c;
    End fn_sl_pend_hod_approval;

    Function fn_sl_pend_onbehalf_approval(

        p_person_id   Varchar2,
        p_meta_id     Varchar2,
        p_row_number  Number,
        p_page_length Number
    ) Return Sys_Refcursor As
        c                    Sys_Refcursor;
        v_hod_empno          Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
    Begin
        v_hod_empno := get_empno_from_meta_id(p_meta_id);
        If v_hod_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;

        Open c For
            Select
                *
            From
                (
                    Select
                        l.empno || ' - ' || e.name                   As employee_name,
                        parent,
                        app_date                                     As application_date,
                        app_no                                       As application_id,
                        bdate                                        As start_date,
                        edate                                        As end_date,
                        to_days(leaveperiod)                         As leave_period,
                        leavetype                                    As leave_type,
                        get_emp_name(l.lead_apprl_empno)             As lead_name,
                        Trim(med_cert_file_name)                     As med_cert_file_name,
                        lead_reason                                  As lead_remarks,
                        hodreason                                    As hod_remarks,
                        hrdreason                                    As hr_remarks,
                        Row_Number() Over (Order By parent, l.empno) row_number,
                        Count(*) Over ()                             total_row

                    From
                        ss_leaveapp l,
                        ss_emplmast e
                    Where
                        (nvl(hod_apprl, c_pending) = c_pending)
                        And l.empno                = e.empno
                        And e.status               = 1
                        And nvl(lead_apprl, c_pending) In (c_approved, c_apprl_none)
                        And e.mngr In (
                            Select
                                mngr
                            From
                                ss_delegate
                            Where
                                empno = Trim(v_hod_empno)
                        )
                        And l.leavetype            = 'SL'
                    Order By parent,
                        l.empno
                )
            Where
                row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length);
        Return c;
    End fn_sl_pend_onbehalf_approval;

    Function fn_sl_pend_lead_approval(

        p_person_id   Varchar2,
        p_meta_id     Varchar2,
        p_row_number  Number,
        p_page_length Number
    ) Return Sys_Refcursor As
        c                    Sys_Refcursor;
        v_lead_empno         Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
    Begin
        v_lead_empno := get_empno_from_meta_id(p_meta_id);
        If v_lead_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;

        Open c For
            Select
                *
            From
                (
                    Select
                        l.empno || ' - ' || e.name                   As employee_name,
                        parent,
                        app_date                                     As application_date,
                        app_no                                       As application_id,
                        bdate                                        As start_date,
                        edate                                        As end_date,
                        to_days(leaveperiod)                         As leave_period,
                        Case
                            When nvl(is_covid_sick_leave, 0) = 1
                                And Trim(leavetype)          = 'SL'
                            Then
                                'SL-COVID'
                            Else
                                Trim(leavetype)
                        End                                          As leave_type,
                        get_emp_name(l.lead_apprl_empno)             As lead_name,
                        Trim(med_cert_file_name)                     As med_cert_file_name,
                        lead_reason                                  As lead_remarks,
                        hodreason                                    As hod_marks,
                        hrdreason                                    As hr_remarks,
                        Row_Number() Over (Order By parent, l.empno) row_number,
                        Count(*) Over ()                             total_row
                    From
                        ss_leaveapp l,
                        ss_emplmast e
                    Where
                        (nvl(lead_apprl, 0)    = 0)
                        And l.empno            = e.empno
                        And e.status           = 1
                        And l.lead_apprl_empno = Trim(v_lead_empno)
                        And l.leavetype        = 'SL'
                    Order By parent,
                        l.empno
                )
            Where
                row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length);

        Return c;
    End fn_sl_pend_lead_approval;

End iot_leave_qry;
/

Grant Execute On "SELFSERVICE"."IOT_LEAVE_QRY" To "TCMPL_APP_CONFIG";
Grant Execute On "SELFSERVICE"."IOT_LEAVE_QRY" To "IOT_TCMPL";