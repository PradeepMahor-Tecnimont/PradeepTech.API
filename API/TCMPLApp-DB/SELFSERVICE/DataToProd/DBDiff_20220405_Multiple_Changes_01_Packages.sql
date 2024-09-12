--------------------------------------------------------
--  File created - Tuesday-April-05-2022   
--------------------------------------------------------
---------------------------
--Changed PACKAGE
--IOT_SWP_DMS_REP_QRY
---------------------------
CREATE OR REPLACE PACKAGE "SELFSERVICE"."IOT_SWP_DMS_REP_QRY" As

    Function fn_non_sws_emp_athome_4hodsec(
        p_person_id   Varchar2,
        p_meta_id     Varchar2,
        p_row_number  Number,
        p_page_length Number
    ) Return Sys_Refcursor;

    Function fn_non_sws_emp_athome_4admin(
        p_person_id   Varchar2,
        p_meta_id     Varchar2,
        p_row_number  Number,
        p_page_length Number
    ) Return Sys_Refcursor;

    c_query_non_sws_emp_home Varchar2(6000) := '
With
    params As
    (
        Select
            :p_hod_sec_empno     As p_hod_sec_empno,
            :p_row_number as p_row_number, 
            :p_page_length as p_page_length
        From
            dual
    )
Select
    *
From
    (
        Select
            a.empno                                   As empno,
            a.name                                    As employee_name,
            a.parent                                  As parent,
            a.emptype                                 As emptype,
            a.grade                                   As emp_grade,
            a.is_swp_eligible                         As is_swp_eligible,
            a.is_laptop_user                          As is_laptop_user,
            a.email                                   As emp_email,
            iot_swp_common.get_desk_from_dms(a.empno) As deskid,
            a.present_count                           As present_count,
            Row_Number() Over (Order By parent)       As row_number,
            Count(*) Over ()                          As total_row
        From
            (
                Select
                    *
                From
                    (
                        Select
                            empno,
                            name,
                            parent,
                            grade,
                            emptype,
                            is_swp_eligible,
                            is_laptop_user,
                            email,
                            Sum(is_present) present_count
                        From
                            (
                                With
                                    dates As (
                                        Select
                                            d_date
                                        From
                                            (
                                                Select
                                                    dd.*
                                                From
                                                    ss_days_details dd
                                                Where
                                                    dd.d_date Between sysdate - 14 And sysdate
                                                    And dd.d_date Not In (
                                                        Select
                                                            holiday
                                                        From
                                                            ss_holidays
                                                        Where
                                                            holiday Between sysdate - 14 And sysdate
                                                    )
                                                Order By d_date Desc
                                            )
                                        Where
                                            Rownum < 7
                                    )
                                Select
                                    a.*, iot_swp_common.fn_is_present_4_swp(empno, dates.d_date) is_present
                                From
                                    (
                                        Select
                                            *
                                        From
                                            (
                                                Select
                                                    e.empno,
                                                    e.name,
                                                    e.parent,
                                                    e.grade,
                                                    e.emptype,
                                                    iot_swp_common.is_emp_eligible_for_swp(e.empno) is_swp_eligible,
                                                    iot_swp_common.is_emp_laptop_user(e.empno)      is_laptop_user,
                                                    e.email
                                                From
                                                    ss_emplmast e
                                                Where
                                                    e.status = 1
                                                    !ASSIGN_SUB_QUERY!
                                                    and e.assign not in (Select assign from swp_exclude_assign)
                                            )
                                        Where
                                            (
                                                is_swp_eligible != ''OK''
                                                Or is_laptop_user = 0
                                                Or emptype In (''S'')
                                            )
                                            And emptype Not In (''O'')
                                    ) a, dates
                            )
                        Group By empno, name, parent, grade, emptype, is_swp_eligible, is_laptop_user, email
                        Order By parent
                    )
                Where
                    present_count < 3
            ) a
    ), params
Where
    row_number Between (nvl(params.p_row_number, 0) + 1) And (nvl(params.p_row_number, 0) + params.p_page_length)';

    c_assign_sub_query Varchar2(500) := '
And e.assign In (
    Select
        parent
    From
        ss_user_dept_rights, params
    Where
        empno = params.p_hod_sec_empno
    Union
    Select
        costcode
    From
        ss_costmast, params
    Where
        hod = params.p_hod_sec_empno
)
';
End iot_swp_dms_rep_qry;
/
---------------------------
--Changed PACKAGE BODY
--IOT_ONDUTY_QRY
---------------------------
CREATE OR REPLACE PACKAGE BODY "SELFSERVICE"."IOT_ONDUTY_QRY" As

    Function fn_get_onduty_applications(
        p_empno        Varchar2,
        p_req_for_self Varchar2,
        p_onduty_type  Varchar2 Default Null,
        p_start_date   Date     Default Null,
        p_end_date     Date     Default Null,
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
                        a.empno,
                        app_date,
                        to_char(a.app_date, 'dd-Mon-yyyy')      As application_date,
                        a.app_no                                As application_id,
                        a.pdate                                 As application_for_date,
                        a.start_date                            As start_date,
                        description,
                        a.type                                  As onduty_type,
                        get_emp_name(a.lead_apprl_empno)        As lead_name,
                        a.lead_apprldesc                        As lead_approval,
                        hod_apprldesc                           As hod_approval,
                        hrd_apprldesc                           As hr_approval,
                        Case
                            When p_req_for_self = 'OK' Then
                                a.can_delete_app
                            Else
                                0
                        End                                     As can_delete_app,
                        Row_Number() Over (Order By a.start_date desc) As row_number,
                        Count(*) Over ()                        As total_row
                    From
                        ss_vu_od_depu a
                    Where
                        a.empno    = p_empno
                        And a.pdate >= add_months(sysdate, - 24)
                        And a.type = nvl(p_onduty_type, a.type)
                        And a.pdate Between trunc(nvl(p_start_date, a.pdate)) And trunc(nvl(p_end_date, a.pdate))
                    Order By start_date Desc
                )
            Where
                row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length)
            Order By
                start_date Desc;
        Return c;

    End;

    Function fn_onduty_applications_4_other(
        p_person_id   Varchar2,
        p_meta_id     Varchar2,
        p_empno       Varchar2,
        p_onduty_type Varchar2 Default Null,
        p_start_date  Date     Default Null,
        p_end_date    Date     Default Null,
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
            empno      = p_empno;
            --And status = 1;
        If v_self_empno = v_for_empno Then
            v_req_for_self := 'OK';
        Else
            v_req_for_self := 'KO';
        End If;

        c            := fn_get_onduty_applications(v_for_empno, v_req_for_self, p_onduty_type, p_start_date, p_end_date, p_row_number,
                                                   p_page_length);
        Return c;
    End fn_onduty_applications_4_other;

    Function fn_onduty_applications_4_self(
        p_person_id   Varchar2,
        p_meta_id     Varchar2,
        p_onduty_type Varchar2 Default Null,
        p_start_date  Date     Default Null,
        p_end_date    Date     Default Null,
        p_row_number  Number,
        p_page_length Number
    ) Return Sys_Refcursor As
        v_empno              Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
        c                    Sys_Refcursor;
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;
        c       := fn_get_onduty_applications(v_empno, 'OK', p_onduty_type, p_start_date, p_end_date, p_row_number, p_page_length);
        Return c;

    End fn_onduty_applications_4_self;

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
                        to_char(a.app_date, 'dd-Mon-yyyy')      As application_date,
                        a.app_no                                As application_id,
                        to_char(bdate, 'dd-Mon-yyyy')           As start_date,
                        to_char(edate, 'dd-Mon-yyyy')           As end_date,
                        type                                    As onduty_type,
                        dm_get_emp_office(a.empno)              As office,
                        a.empno || ' - ' || name                As emp_name,
                        a.empno                                 As emp_no,
                        parent                                  As parent,
                        getempname(lead_apprl_empno)            As lead_name,
                        lead_reason                             As lead_remarks,
                        Row_Number() Over (Order By a.app_date) As row_number,
                        Count(*) Over ()                        As total_row
                    From
                        ss_odapprl  a,
                        ss_emplmast e
                    Where
                        (nvl(lead_apprl, 0)    = 0)
                        And a.empno            = e.empno
                        And e.status           = 1
                        And a.lead_apprl_empno = Trim(v_lead_empno)
                    Order By parent, a.empno
                )
            Where
                row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length);
        Return c;
    End fn_pending_lead_approval;

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
                        to_char(a.app_date, 'dd-Mon-yyyy')      As application_date,
                        a.app_no                                As application_id,
                        to_char(bdate, 'dd-Mon-yyyy')           As start_date,
                        to_char(edate, 'dd-Mon-yyyy')           As end_date,
                        type                                    As onduty_type,
                        dm_get_emp_office(a.empno)              As office,
                        a.empno || ' - ' || name                As emp_name,
                        a.empno                                 As emp_no,
                        parent                                  As parent,
                        getempname(lead_apprl_empno)            As lead_name,
                        hodreason                               As hod_remarks,
                        Row_Number() Over (Order By a.app_date) As row_number,
                        Count(*) Over ()                        As total_row
                    From
                        ss_odapprl  a,
                        ss_emplmast e
                    Where
                        (nvl(lead_apprl, 0) In (1, 4))
                        And (nvl(hod_apprl, 0) = 0)
                        And a.empno            = e.empno
                        And e.status           = 1
                        And e.mngr             = Trim(v_hod_empno)

                    Order By parent, a.empno
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
                        to_char(a.app_date, 'dd-Mon-yyyy')      As application_date,
                        a.app_no                                As application_id,
                        to_char(bdate, 'dd-Mon-yyyy')           As start_date,
                        to_char(edate, 'dd-Mon-yyyy')           As end_date,
                        type                                    As onduty_type,
                        dm_get_emp_office(a.empno)              As office,
                        a.empno || ' - ' || name                As emp_name,
                        a.empno                                 As emp_no,
                        parent                                  As parent,
                        getempname(lead_apprl_empno)            As lead_name,
                        hodreason                               As hod_remarks,
                        Row_Number() Over (Order By a.app_date) As row_number,
                        Count(*) Over ()                        As total_row
                    From
                        ss_odapprl  a,
                        ss_emplmast e
                    Where
                        (nvl(lead_apprl, 0) In (1, 4))
                        And (nvl(hod_apprl, 0) = 0)
                        And a.empno            = e.empno
                        And e.status           = 1
                        And e.mngr In (
                            Select
                                mngr
                            From
                                ss_delegate
                            Where
                                empno = Trim(v_hod_empno)
                        )
                    Order By parent, a.empno
                )
            Where
                row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length);
        Return c;
    End fn_pending_onbehalf_approval;

    Function fn_pending_hr_approval(
        p_person_id   Varchar2,
        p_meta_id     Varchar2,
        p_row_number  Number,
        p_page_length Number
    ) Return Sys_Refcursor As
        c       Sys_Refcursor;
        v_empno Varchar2(5);
    Begin

        Open c For
            Select
                *
            From
                (
                    Select
                        to_char(a.app_date, 'dd-Mon-yyyy')             As application_date,
                        a.app_no                                       As application_id,
                        to_char(bdate, 'dd-Mon-yyyy')                  As start_date,
                        to_char(edate, 'dd-Mon-yyyy')                  As end_date,
                        type                                           As onduty_type,
                        dm_get_emp_office(a.empno)                     As office,
                        a.empno || ' - ' || name                       As emp_name,
                        a.empno                                        As emp_no,
                        parent                                         As parent,
                        getempname(lead_apprl_empno)                   As lead_name,
                        hrdreason                                      As hr_remarks,
                        Row_Number() Over (Order By e.parent, e.empno) As row_number,
                        Count(*) Over ()                               As total_row
                    From
                        ss_odapprl  a,
                        ss_emplmast e
                    Where
                        (nvl(hod_apprl, 0)     = 1)
                        And a.empno            = e.empno
                        And e.status           = 1
                        And (nvl(hrd_apprl, 0) = 0)
                    Order By e.parent, e.empno Asc
                )
            Where
                row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length);
        Return c;
    End fn_pending_hr_approval;

End iot_onduty_qry;
/
---------------------------
--Changed PACKAGE BODY
--IOT_SWP_DMS_REP_QRY
---------------------------
CREATE OR REPLACE PACKAGE BODY "SELFSERVICE"."IOT_SWP_DMS_REP_QRY" As
    e_employee_not_found Exception;
    Pragma exception_init(e_employee_not_found, -20001);

    Function fn_non_sws_emp_athome(
        p_hod_sec_empno Varchar2,
        p_is_admin      Boolean,
        p_row_number    Number,
        p_page_length   Number
    ) Return Sys_Refcursor As
        v_query Varchar2(6500);
        c       Sys_Refcursor;
    Begin
        v_query := c_query_non_sws_emp_home;
        If p_is_admin Then
            v_query := replace(v_query, '!ASSIGN_SUB_QUERY!', '');
        Else
            v_query := replace(v_query, '!ASSIGN_SUB_QUERY!', c_assign_sub_query);
        End If;
        Open c For v_query Using p_hod_sec_empno, p_row_number, p_page_length;
        Return c;
    End;

    Function fn_non_sws_emp_athome_4hodsec(
        p_person_id   Varchar2,
        p_meta_id     Varchar2,
        p_row_number  Number,
        p_page_length Number
    ) Return Sys_Refcursor As
        c               Sys_Refcursor;
        v_hod_sec_empno Varchar2(5);
    Begin

        v_hod_sec_empno := get_empno_from_meta_id(p_meta_id);
        If v_hod_sec_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;

        c               := fn_non_sws_emp_athome(
                               p_hod_sec_empno => v_hod_sec_empno,
                               p_is_admin      => false,
                               p_row_number    => p_row_number,
                               p_page_length   => p_page_length
                           );
        /*
                Open c For
                    Select
                        *
                    From
                        (
                            Select
                                a.empno                                   As empno,
                                a.name                                    As employee_name,
                                a.parent                                  As parent,
                                a.emptype                                 As emptype,
                                a.grade                                   As emp_grade,
                                a.is_swp_eligible                         As is_swp_eligible,
                                a.is_laptop_user                          As is_laptop_user,
                                a.email                                   As emp_email,
                                iot_swp_common.get_desk_from_dms(a.empno) As deskid,
                                a.present_count                           As present_count,
                                Row_Number() Over (Order By parent)       As row_number,
                                Count(*) Over ()                          As total_row
                            From
                                (

                                    Select
                                        *
                                    From
                                        (
                                            Select
                                                empno,
                                                name,
                                                parent,
                                                grade,
                                                emptype,
                                                is_swp_eligible,
                                                is_laptop_user,
                                                email,
                                                Sum(is_present) present_count
                                            From
                                                (
                                                    With
                                                        dates As (
                                                            Select
                                                                d_date
                                                            From
                                                                (
                                                                    Select
                                                                        dd.*
                                                                    From
                                                                        ss_days_details dd
                                                                    Where
                                                                        dd.d_date Between sysdate - 14 And sysdate
                                                                        And dd.d_date Not In (
                                                                            Select
                                                                                holiday
                                                                            From
                                                                                ss_holidays
                                                                            Where
                                                                                holiday Between sysdate - 14 And sysdate
                                                                        )
                                                                    Order By d_date Desc
                                                                )
                                                            Where
                                                                Rownum < 7

                                                        )
                                                    Select
                                                        a.*, iot_swp_common.fn_is_present_4_swp(empno, dates.d_date) is_present
                                                    From
                                                        (
                                                            Select
                                                                *
                                                            From
                                                                (

                                                                    Select
                                                                        e.empno,
                                                                        e.name,
                                                                        e.parent,
                                                                        e.grade,
                                                                        e.emptype,
                                                                        iot_swp_common.is_emp_eligible_for_swp(e.empno) is_swp_eligible,
                                                                        iot_swp_common.is_emp_laptop_user(e.empno)      is_laptop_user,
                                                                        e.email
                                                                    From
                                                                        ss_emplmast e
                                                                    Where
                                                                        e.status = 1
                                                                        And e.assign In (
                                                                            Select
                                                                                parent
                                                                            From
                                                                                ss_user_dept_rights
                                                                            Where
                                                                                empno = v_hod_sec_empno
                                                                            Union

                                                                            Select
                                                                                costcode
                                                                            From
                                                                                ss_costmast
                                                                            Where
                                                                                hod = v_hod_sec_empno
                                                                        )

                                                                )
                                                            Where
                                                                (
                                                                    is_swp_eligible != 'OK'
                                                                    Or is_laptop_user = 0
                                                                    Or emptype In ('S')
                                                                )
                                                                And emptype Not In ('O')
                                                        ) a, dates
                                                )
                                            Group By empno, name, parent, grade, emptype, is_swp_eligible, is_laptop_user, email
                                            Order By parent
                                        )
                                    Where
                                        present_count < 3

                                ) a
                        )
                    Where
                        row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length);
                        */
        Return c;
    End;

    Function fn_non_sws_emp_athome_4admin(
        p_person_id   Varchar2,
        p_meta_id     Varchar2,
        p_row_number  Number,
        p_page_length Number
    ) Return Sys_Refcursor As
        c             Sys_Refcursor;
        v_admin_empno Varchar2(5);
    Begin

        v_admin_empno := get_empno_from_meta_id(p_meta_id);
        If v_admin_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;

        c             := fn_non_sws_emp_athome(
                             p_hod_sec_empno => Null,
                             p_is_admin      => true,
                             p_row_number    => p_row_number,
                             p_page_length   => p_page_length
                         );

        Return c;
    End;

End iot_swp_dms_rep_qry;
/
