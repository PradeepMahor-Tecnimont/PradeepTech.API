--------------------------------------------------------
--  DDL for Package Body IOT_EXTRAHOURS_QRY
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE BODY "SELFSERVICE"."IOT_EXTRAHOURS_QRY" As

    Function fn_extra_hrs_claims(
        p_empno        Varchar2,
        p_req_for_self Varchar2,
        p_start_date   Date Default Null,
        p_row_number   Number,
        p_page_length  Number
    ) Return Sys_Refcursor As
        v_request_for_self Varchar2(20);
        c                  Sys_Refcursor;
    Begin
        Open c For

            Select
                claims.*
            From
                (

                    Select
                        a.app_date                                 As claim_date,
                        a.app_no                                   As claim_no,
                        month || '-' || yyyy                       As claim_period,
                        get_emp_name(nvl(a.lead_apprl_empno, ''))  lead_name,
                        ot                                         As claimed_ot,
                        hhot                                       As claimed_hhot,
                        co                                         As claimed_co,
                        ss.approval_text(nvl(a.lead_apprl, 0))     lead_approval_desc,
                        ss.approval_text(nvl(a.hod_apprl, 0))      hod_approval_desc,
                        ss.approval_text(nvl(a.hrd_apprl, 0))      hrd_approval_desc,
                        a.lead_remarks,
                        a.hod_remarks,
                        a.hrd_remarks,
                        nvl(a.lead_apprd_ot, 0)                    As lead_approved_ot,
                        nvl(a.lead_apprd_hhot, 0)                  As lead_approved_hhot,
                        nvl(a.lead_apprd_co, 0)                    As lead_approved_co,
                        nvl(a.hod_apprd_ot, 0)                     As hod_approved_ot,
                        nvl(a.hod_apprd_hhot, 0)                   As hod_approved_hhot,
                        nvl(a.hod_apprd_co, 0)                     As hod_approved_co,
                        Case
                            When nvl(a.hrd_apprd_ot, 0) = 0 Then
                                Null
                            Else
                                a.hrd_apprd_ot
                        End                                        As hrd_approved_ot,
                        Case
                            When nvl(a.hrd_apprd_hhot, 0) = 0 Then
                                Null
                            Else
                                a.hrd_apprd_hhot
                        End                                        As hrd_approved_hhot,
                        Case
                            When nvl(a.hrd_apprd_co, 0) = 0 Then
                                Null
                            Else
                                a.hrd_apprd_co
                        End                                        As hrd_approved_co,
                        Case
                            When p_req_for_self                  = 'OK'
                                And nvl(a.lead_apprl, ss.pending) In (ss.pending, ss.apprl_none)
                                And nvl(a.hod_apprl, ss.pending) = ss.pending
                            Then
                                1
                            Else
                                0
                        End                                        can_delete_claim,
                        Row_Number() Over (Order By app_date Desc) row_number,
                        Count(*) Over ()                           total_row

                    From
                        ss_otmaster a
                    Where
                        a.empno             = p_empno
                        And to_number(a.yyyy || a.mon) >= to_number(to_char(add_months(sysdate, - 24), 'YYYYMM'))
                        And a.yyyy || a.mon = Case
                            When p_start_date Is Null Then
                                a.yyyy || a.mon
                            Else
                                to_char(p_start_date, 'yyyymm')
                        End
                    Order By a.app_date Desc
                ) claims
            Where
                row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length);
        Return c;
    End fn_extra_hrs_claims;

    Function fn_extra_hrs_claims_4_self(
        p_person_id   Varchar2,
        p_meta_id     Varchar2,
        p_start_date  Date Default Null,
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
        c       := fn_extra_hrs_claims(
                       p_empno        => v_empno,
                       p_req_for_self => 'OK',
                       p_start_date   => p_start_date,
                       p_row_number   => p_row_number,
                       p_page_length  => p_page_length
                   );
        Return c;
    End fn_extra_hrs_claims_4_self;

    Function fn_extra_hrs_claims_4_other(
        p_person_id   Varchar2,
        p_meta_id     Varchar2,
        p_empno       Varchar2,
        p_start_date  Date Default Null,
        p_row_number  Number,
        p_page_length Number
    ) Return Sys_Refcursor As
        v_count              Number;
        c                    Sys_Refcursor;
        v_empno              Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
    Begin
        Select
            Count(*)
        Into
            v_count
        From
            ss_emplmast
        Where
            empno = p_empno;
        If v_count = 0 Then
            Raise e_employee_not_found;
            Return Null;
        End If;
        c := fn_extra_hrs_claims(
                 p_empno        => p_empno,
                 p_req_for_self => 'KO',
                 p_start_date   => p_start_date,
                 p_row_number   => p_row_number,
                 p_page_length  => p_page_length
             );
        Return c;
    End fn_extra_hrs_claims_4_other;

    Function fn_extra_hrs_claim_detail(
        p_person_id Varchar2,
        p_meta_id   Varchar2,
        p_claim_no  Varchar2
    ) Return Sys_Refcursor As
        c Sys_Refcursor;
    Begin
        Open c For

            Select
                ot_detail.*,
                to_hrs(nvl(get_time_sheet_work_hrs(empno, pdate), 0) * 60)  As ts_work_hrs,
                to_hrs(nvl(get_time_sheet_extra_hrs(empno, pdate), 0) * 60) As ts_extra_hrs
            From
                (
                    Select
                        empno,
                        yyyy || '-' || mon                                             As claim_period,
                        app_no                                                         As claim_no,
                        d_details                                                      As day_detail,
                        w_details                                                      As week_detail,
                        w_ot_max                                                       As week_extrahours_applicable,
                        w_ot_claim                                                     As week_extrahours_claim,
                        w_co                                                           As week_claimed_co,
                        w_hhot_claim                                                   As week_holiday_ot_claim,
                        w_hhot_max                                                     As week_holiday_ot_applicable,
                        to_date(day_yyyy || '-' || of_mon || '-' || day, 'yyyy-mm-dd') As pdate
                    From
                        ss_otdetail
                    Where
                        app_no = p_claim_no
                ) ot_detail
            Order By
                pdate;
        Return c;
    End fn_extra_hrs_claim_detail;

    Function fn_pending_lead_approval(
        p_person_id      Varchar2,
        p_meta_id        Varchar2,
        p_application_id Varchar2 Default Null,
        p_row_number     Number,
        p_page_length    Number
    ) Return Sys_Refcursor As
        c                    Sys_Refcursor;
        e_employee_not_found Exception;
        v_empno              Varchar2(5);
        Pragma exception_init(e_employee_not_found, -20001);
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;
        Open c For
            Select
                *
            From
                (

                    Select
                        e.empno || ' - ' || e.name                                               As employee,
                        a.app_date                                                               As claim_date,
                        a.app_no                                                                 As claim_no,
                        month || '-' || yyyy                                                     As claim_period,
                        a.lead_apprl_empno || ' - ' || get_emp_name(nvl(a.lead_apprl_empno, '')) lead_name,
                        ot                                                                       As claimed_ot,
                        hhot                                                                     As claimed_hhot,
                        co                                                                       As claimed_co,
                        ss.approval_text(nvl(a.lead_apprl, 0))                                   lead_approval_desc,
                        ss.approval_text(nvl(a.hod_apprl, 0))                                    hod_approval_desc,
                        ss.approval_text(nvl(a.hrd_apprl, 0))                                    hrd_approval_desc,
                        a.lead_remarks,
                        a.hod_remarks,
                        a.hrd_remarks,
                        nvl(a.lead_apprd_ot, 0)                                                  As lead_approved_ot,
                        nvl(a.lead_apprd_hhot, 0)                                                As lead_approved_hhot,
                        nvl(a.lead_apprd_co, 0)                                                  As lead_approved_co,
                        nvl(a.hod_apprd_ot, 0)                                                   As hod_approved_ot,
                        nvl(a.hod_apprd_hhot, 0)                                                 As hod_approved_hhot,
                        nvl(a.hod_apprd_co, 0)                                                   As hod_approved_co,
                        Case
                            When nvl(a.hrd_apprd_ot, 0) = 0 Then
                                Null
                            Else
                                a.hrd_apprd_ot
                        End                                                                      As hrd_approved_ot,
                        Case
                            When nvl(a.hrd_apprd_hhot, 0) = 0 Then
                                Null
                            Else
                                a.hrd_apprd_hhot
                        End                                                                      As hrd_approved_hhot,
                        Case
                            When nvl(a.hrd_apprd_co, 0) = 0 Then
                                Null
                            Else
                                a.hrd_apprd_co
                        End                                                                      As hrd_approved_co,
                        Case
                            When nvl(a.lead_apprl, ss.pending) In (ss.pending, ss.apprl_none)
                                And nvl(a.hod_apprl, ss.pending) = ss.pending
                            Then
                                1
                            Else
                                0
                        End                                                                      can_delete_claim,
                        Row_Number() Over (Order By app_date Desc)                               row_number,
                        Count(*) Over ()                                                         total_row

                    From
                        ss_otmaster a,
                        ss_emplmast e
                    Where
                        (nvl(lead_apprl, 0)    = 0)
                        And e.empno            = a.empno
                        And a.lead_apprl_empno = v_empno
                        And a.app_no           = nvl(p_application_id, a.app_no)
                        And to_number(a.yyyy || a.mon) >= to_number(to_char(add_months(sysdate, - 24), 'YYYYMM'))
                    Order By a.app_date Desc
                )
            Where
                row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length);

        Return c;
    End fn_pending_lead_approval;

    Function fn_pending_hod_approval(
        p_person_id      Varchar2,
        p_meta_id        Varchar2,
        p_application_id Varchar2 Default Null,
        p_row_number     Number,
        p_page_length    Number
    ) Return Sys_Refcursor As
        c                    Sys_Refcursor;
        e_employee_not_found Exception;
        v_empno              Varchar2(5);
        Pragma exception_init(e_employee_not_found, -20001);
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;
        Open c For
            Select
                *
            From
                (

                    Select
                        e.empno || ' - ' || e.name                 As employee,
                        a.app_date                                 As claim_date,
                        a.app_no                                   As claim_no,
                        month || '-' || yyyy                       As claim_period,
                        get_emp_name(nvl(a.lead_apprl_empno, ''))  lead_name,
                        ot                                         As claimed_ot,
                        hhot                                       As claimed_hhot,
                        co                                         As claimed_co,
                        ss.approval_text(nvl(a.lead_apprl, 0))     lead_approval_desc,
                        ss.approval_text(nvl(a.hod_apprl, 0))      hod_approval_desc,
                        ss.approval_text(nvl(a.hrd_apprl, 0))      hrd_approval_desc,
                        a.lead_remarks,
                        a.hod_remarks,
                        a.hrd_remarks,
                        nvl(a.lead_apprd_ot, 0)                    As lead_approved_ot,
                        nvl(a.lead_apprd_hhot, 0)                  As lead_approved_hhot,
                        nvl(a.lead_apprd_co, 0)                    As lead_approved_co,
                        nvl(a.hod_apprd_ot, 0)                     As hod_approved_ot,
                        nvl(a.hod_apprd_hhot, 0)                   As hod_approved_hhot,
                        nvl(a.hod_apprd_co, 0)                     As hod_approved_co,
                        Case
                            When nvl(a.hrd_apprd_ot, 0) = 0 Then
                                Null
                            Else
                                a.hrd_apprd_ot
                        End                                        As hrd_approved_ot,
                        Case
                            When nvl(a.hrd_apprd_hhot, 0) = 0 Then
                                Null
                            Else
                                a.hrd_apprd_hhot
                        End                                        As hrd_approved_hhot,
                        Case
                            When nvl(a.hrd_apprd_co, 0) = 0 Then
                                Null
                            Else
                                a.hrd_apprd_co
                        End                                        As hrd_approved_co,
                        Case
                            When nvl(a.lead_apprl, ss.pending) In (ss.pending, ss.apprl_none)
                                And nvl(a.hod_apprl, ss.pending) = ss.pending
                            Then
                                1
                            Else
                                0
                        End                                        can_delete_claim,
                        Row_Number() Over (Order By app_date Desc) row_number,
                        Count(*) Over ()                           total_row

                    From
                        ss_otmaster a,
                        ss_emplmast e
                    Where
                        (nvl(lead_apprl, 0) In (1, 4))
                        And (nvl(hod_apprl, 0) = 0)
                        And a.empno            = e.empno
                        And a.app_no           = nvl(p_application_id, a.app_no)
                        And e.mngr             = Trim(v_empno)
                        And to_number(a.yyyy || a.mon) >= to_number(to_char(add_months(sysdate, - 24), 'YYYYMM'))
                    Order By a.app_date Desc
                )
            Where
                row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length);
        Return c;

    End fn_pending_hod_approval;

    Function fn_pending_onbehalf_approval(
        p_person_id      Varchar2,
        p_meta_id        Varchar2,
        p_application_id Varchar2 Default Null,
        p_row_number     Number,
        p_page_length    Number
    ) Return Sys_Refcursor As
        c                    Sys_Refcursor;
        e_employee_not_found Exception;
        v_empno              Varchar2(5);
        Pragma exception_init(e_employee_not_found, -20001);
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;
        Open c For
            Select
                *
            From
                (

                    Select
                        e.empno || ' - ' || e.name                 As employee,
                        a.app_date                                 As claim_date,
                        a.app_no                                   As claim_no,
                        month || '-' || yyyy                       As claim_period,
                        get_emp_name(nvl(a.lead_apprl_empno, ''))  lead_name,
                        ot                                         As claimed_ot,
                        hhot                                       As claimed_hhot,
                        co                                         As claimed_co,
                        ss.approval_text(nvl(a.lead_apprl, 0))     lead_approval_desc,
                        ss.approval_text(nvl(a.hod_apprl, 0))      hod_approval_desc,
                        ss.approval_text(nvl(a.hrd_apprl, 0))      hrd_approval_desc,
                        a.lead_remarks,
                        a.hod_remarks,
                        a.hrd_remarks,
                        nvl(a.lead_apprd_ot, 0)                    As lead_approved_ot,
                        nvl(a.lead_apprd_hhot, 0)                  As lead_approved_hhot,
                        nvl(a.lead_apprd_co, 0)                    As lead_approved_co,
                        nvl(a.hod_apprd_ot, 0)                     As hod_approved_ot,
                        nvl(a.hod_apprd_hhot, 0)                   As hod_approved_hhot,
                        nvl(a.hod_apprd_co, 0)                     As hod_approved_co,
                        Case
                            When nvl(a.hrd_apprd_ot, 0) = 0 Then
                                Null
                            Else
                                a.hrd_apprd_ot
                        End                                        As hrd_approved_ot,
                        Case
                            When nvl(a.hrd_apprd_hhot, 0) = 0 Then
                                Null
                            Else
                                a.hrd_apprd_hhot
                        End                                        As hrd_approved_hhot,
                        Case
                            When nvl(a.hrd_apprd_co, 0) = 0 Then
                                Null
                            Else
                                a.hrd_apprd_co
                        End                                        As hrd_approved_co,
                        Case
                            When nvl(a.lead_apprl, ss.pending) In (ss.pending, ss.apprl_none)
                                And nvl(a.hod_apprl, ss.pending) = ss.pending
                            Then
                                1
                            Else
                                0
                        End                                        can_delete_claim,
                        Row_Number() Over (Order By app_date Desc) row_number,
                        Count(*) Over ()                           total_row

                    From
                        ss_otmaster a,
                        ss_emplmast e
                    Where
                        (nvl(lead_apprl, 0) In (1, 4))
                        And (nvl(hod_apprl, 0) = 0)
                        And a.empno            = e.empno
                        And a.app_no           = nvl(p_application_id, a.app_no)
                        And to_number(a.yyyy || a.mon) >= to_number(to_char(add_months(sysdate, - 24), 'YYYYMM'))
                        And e.mngr In (
                            Select
                                mngr
                            From
                                ss_delegate
                            Where
                                empno = v_empno
                        )
                    Order By a.app_date Desc
                )
            Where
                row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length);
        Return c;

        Return c;
    End fn_pending_onbehalf_approval;

    Function fn_pending_hr_approval(
        p_person_id      Varchar2,
        p_meta_id        Varchar2,
        p_application_id Varchar2 Default Null,
        p_row_number     Number,
        p_page_length    Number
    ) Return Sys_Refcursor As
        c                    Sys_Refcursor;
        e_employee_not_found Exception;
        v_empno              Varchar2(5);
        Pragma exception_init(e_employee_not_found, -20001);
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;

        Open c For
            Select
                *
            From
                (
                    Select
                        e.empno || ' - ' || e.name                        As employee,
                        a.app_date                                        As claim_date,
                        a.app_no                                          As claim_no,
                        month || '-' || yyyy                              As claim_period,
                        get_emp_name(nvl(a.lead_apprl_empno, ''))         As lead_name,
                        ot                                                As claimed_ot,
                        hhot                                              As claimed_hhot,
                        co                                                As claimed_co,
                        ss.approval_text(nvl(a.lead_apprl, 0))            As lead_approval_desc,
                        ss.approval_text(nvl(a.hod_apprl, 0))             As hod_approval_desc,
                        ss.approval_text(nvl(a.hrd_apprl, 0))             As hrd_approval_desc,
                        a.lead_remarks,
                        a.hod_remarks,
                        a.hrd_remarks,
                        nvl(a.lead_apprd_ot, 0)                           As lead_approved_ot,
                        nvl(a.lead_apprd_hhot, 0)                         As lead_approved_hhot,
                        nvl(a.lead_apprd_co, 0)                           As lead_approved_co,
                        nvl(a.hod_apprd_ot, 0)                            As hod_approved_ot,
                        nvl(a.hod_apprd_hhot, 0)                          As hod_approved_hhot,
                        nvl(a.hod_apprd_co, 0)                            As hod_approved_co,
                        Case
                            When nvl(a.hrd_apprd_ot, 0) = 0 Then
                                Null
                            Else
                                a.hrd_apprd_ot
                        End                                               As hrd_approved_ot,
                        Case
                            When nvl(a.hrd_apprd_hhot, 0) = 0 Then
                                Null
                            Else
                                a.hrd_apprd_hhot
                        End                                               As hrd_approved_hhot,
                        Case
                            When nvl(a.hrd_apprd_co, 0) = 0 Then
                                Null
                            Else
                                a.hrd_apprd_co
                        End                                               As hrd_approved_co,
                        Case
                            When nvl(a.lead_apprl, ss.pending) In (ss.pending, ss.apprl_none)
                                And nvl(a.hod_apprl, ss.pending) = ss.pending
                            Then
                                1
                            Else
                                0
                        End                                               As can_delete_claim,
                        e.parent                                          As parent,
                        get_emp_pen_lve_4_month(a.empno, a.yyyy || a.mon) As penalty_hrs,
                        Row_Number() Over (Order By e.parent, e.empno)    As row_number,
                        Count(*) Over ()                                  As total_row
                    From
                        ss_otmaster a,
                        ss_emplmast e
                    Where
                        (nvl(hod_apprl, 0)     = 1)
                        And (nvl(hrd_apprl, 0) = 0)
                        And e.empno            = a.empno
                        And a.app_no           = nvl(p_application_id, a.app_no)
                        And to_number(a.yyyy || a.mon) >= to_number(to_char(add_months(sysdate, - 24), 'YYYYMM'))
                    Order By e.parent, a.empno
                )
            Where
                row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length);

        Return c;
    End fn_pending_hr_approval;

End iot_extrahours_qry;

/

  GRANT EXECUTE ON "SELFSERVICE"."IOT_EXTRAHOURS_QRY" TO "TCMPL_APP_CONFIG";
