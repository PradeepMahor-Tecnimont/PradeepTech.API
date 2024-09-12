--------------------------------------------------------
--  File created - Thursday-June-09-2022   
--------------------------------------------------------
---------------------------
--Changed PACKAGE
--IOT_SWP_ATTENDANCE_QRY
---------------------------
CREATE OR REPLACE PACKAGE "SELFSERVICE"."IOT_SWP_ATTENDANCE_QRY" As

    Function fn_attendance_for_period(
        p_person_id               Varchar2,
        p_meta_id                 Varchar2,

        p_start_date              Date,
        p_end_date                Date,

        p_is_exclude_x1_employees Number

    ) Return Sys_Refcursor;

    Function fn_attendance_for_day(
        p_person_id               Varchar2,
        p_meta_id                 Varchar2,

        p_start_date              Date,

        p_is_exclude_x1_employees Number

    ) Return Sys_Refcursor;

    Function fn_attendance_for_prev_day(
        p_person_id Varchar2,
        p_meta_id   Varchar2

    ) Return Sys_Refcursor;

    Function fn_date_list(
        p_person_id  Varchar2,
        p_meta_id    Varchar2,

        p_start_date Date,
        p_end_date   Date

    ) Return Sys_Refcursor;
End iot_swp_attendance_qry;
/
---------------------------
--Changed PACKAGE BODY
--IOT_SWP_PRIMARY_WORKSPACE_QRY
---------------------------
CREATE OR REPLACE PACKAGE BODY "SELFSERVICE"."IOT_SWP_PRIMARY_WORKSPACE_QRY" As

    Function fn_emp_primary_ws_list(
        p_person_id             Varchar2,
        p_meta_id               Varchar2,

        p_assign_code           Varchar2 Default Null,
        p_start_date            Date     Default Null,

        p_empno                 Varchar2 Default Null,

        p_emptype_csv           Varchar2 Default Null,
        p_grade_csv             Varchar2 Default Null,
        p_primary_workspace_csv Varchar2 Default Null,
        p_laptop_user           Varchar2 Default Null,
        p_eligible_for_swp      Varchar2 Default Null,
        p_generic_search        Varchar2 Default Null,

        p_is_admin_call         Boolean  Default false,

        p_row_number            Number,
        p_page_length           Number
    ) Return Sys_Refcursor As
        c                     Sys_Refcursor;

        v_hod_sec_empno       Varchar2(5);
        e_employee_not_found  Exception;
        Pragma exception_init(e_employee_not_found, -20001);
        v_friday_date         Date;
        v_hod_sec_assign_code Varchar2(4);
        v_query               Varchar2(6500);
    Begin
        v_friday_date   := iot_swp_common.get_friday_date(nvl(p_start_date, sysdate));

        v_hod_sec_empno := get_empno_from_meta_id(p_meta_id);

        If v_hod_sec_empno = 'ERRRR' And p_is_admin_call = false Then
            Raise e_employee_not_found;
            Return Null;
        End If;

        --If EMPNO is not null then set assign code filter as null else validate assign code
        If p_is_admin_call Then
            v_hod_sec_assign_code := p_assign_code;
        Else
            If p_empno Is Null Or p_assign_code Is Not Null Then
                v_hod_sec_assign_code := iot_swp_common.get_default_costcode_hod_sec(
                                             p_hod_sec_empno => v_hod_sec_empno,
                                             p_assign_code   => p_assign_code
                                         );
                If v_hod_sec_assign_code Is Null Then
                    Return Null;
                End If;
            End If;
        End If;

        v_query         := query_pws;

        If v_hod_sec_assign_code Is Not Null Then
            v_query := replace(v_query, '!ASSIGN_WHERE_CLAUSE!', sub_qry_assign_where_clause);
        Else
            v_query := replace(v_query, '!ASSIGN_WHERE_CLAUSE!', '');
        End If;

        If p_grade_csv Is Not Null Then
            v_query := replace(v_query, '!GRADES_SUBQUERY!', sub_qry_grades_csv);
        Else
            v_query := replace(v_query, '!GRADES_SUBQUERY!', '');
        End If;

        If p_primary_workspace_csv Is Not Null Then
            v_query := replace(v_query, '!PWS_TYPE_SUBQUERY!', sub_qry_pws_csv);
        Else
            v_query := replace(v_query, '!PWS_TYPE_SUBQUERY!', '');
        End If;

        If p_emptype_csv Is Not Null Then
            v_query := replace(v_query, '!EMPTYPE_SUBQUERY!', sub_qry_emptype_csv);
        Else
            v_query := replace(v_query, '!EMPTYPE_SUBQUERY!', sub_qry_emptype_default);
        End If;

        If p_laptop_user Is Not Null Then
            v_query := replace(v_query, '!LAPTOP_USER_WHERE_CLAUSE!', where_clause_laptop_user);
        Else
            v_query := replace(v_query, '!LAPTOP_USER_WHERE_CLAUSE!', '');
        End If;

        If p_eligible_for_swp Is Not Null Then
            v_query := replace(v_query, '!SWP_ELIGIBLE_WHERE_CLAUSE!', where_clause_swp_eligible);
        Else
            v_query := replace(v_query, '!SWP_ELIGIBLE_WHERE_CLAUSE!', '');
        End If;

        If Trim(p_generic_search) Is Not Null Then
            v_query := replace(v_query, '!GENERIC_SEARCH!', where_clause_generic_search);
        Else
            v_query := replace(v_query, '!GENERIC_SEARCH!', '');
        End If;

        /*
            :p_friday_date     As p_friday_date,
            :p_row_number      As p_row_number,
            :p_page_length     As p_page_length,
            :p_for_empno       As p_for_empno,
            :p_hod_assign_code As p_hod_assign_code,
            :p_pws_csv         As p_pws_csv,
            :p_grades_csv      As p_grades_csv,
            :p_emptype_csv     As p_emptype_csv,
            :p_swp_eligibility As p_swp_eligibility,
            :p_laptop_user     As p_laptop_user
        */
        Open c For v_query Using
            v_friday_date,
            p_row_number,
            p_page_length,
            p_empno,
            v_hod_sec_assign_code,
            p_primary_workspace_csv,
            p_grade_csv,
            p_emptype_csv,
            p_eligible_for_swp,
            p_laptop_user,
            '%' || upper(trim(p_generic_search)) || '%';

        Return c;

    End;

    Function fn_emp_primary_ws_plan_list(
        p_person_id             Varchar2,
        p_meta_id               Varchar2,

        p_assign_code           Varchar2 Default Null,

        p_empno                 Varchar2 Default Null,

        p_emptype_csv           Varchar2 Default Null,
        p_grade_csv             Varchar2 Default Null,
        p_primary_workspace_csv Varchar2 Default Null,
        p_laptop_user           Varchar2 Default Null,
        p_eligible_for_swp      Varchar2 Default Null,
        p_generic_search        Varchar2 Default Null,

        p_row_number            Number,
        p_page_length           Number
    ) Return Sys_Refcursor As
        v_plan_friday_date Date;
        rec_config_week    swp_config_weeks%rowtype;
    Begin
        Select
            *
        Into
            rec_config_week
        From
            swp_config_weeks
        Where
            planning_flag = 2;
        v_plan_friday_date := rec_config_week.end_date;
        Return fn_emp_primary_ws_list(
            p_person_id             => p_person_id,
            p_meta_id               => p_meta_id,

            p_assign_code           => p_assign_code,
            p_start_date            => v_plan_friday_date,

            p_empno                 => p_empno,

            p_emptype_csv           => p_emptype_csv,
            p_grade_csv             => p_grade_csv,
            p_primary_workspace_csv => p_primary_workspace_csv,
            p_laptop_user           => p_laptop_user,
            p_eligible_for_swp      => p_eligible_for_swp,
            p_generic_search        => p_generic_search,

            p_is_admin_call         => false,

            p_row_number            => p_row_number,
            p_page_length           => p_page_length
        );

    End fn_emp_primary_ws_plan_list;

    Function fn_emp_pws_excel(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_assign_codes_csv Varchar2 Default Null,
        p_start_date       Date Default Null
    ) Return Sys_Refcursor As
        c                          Sys_Refcursor;
        v_hod_sec_empno            Varchar2(5);
        e_employee_not_found       Exception;
        Pragma exception_init(e_employee_not_found, -20001);
        v_friday_date              Date;
        v_hod_sec_assign_codes_csv Varchar2(4000);
    Begin
        v_friday_date              := iot_swp_common.get_friday_date(nvl(p_start_date, sysdate));

        v_hod_sec_empno            := get_empno_from_meta_id(p_meta_id);

        If v_hod_sec_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;

        v_hod_sec_assign_codes_csv := iot_swp_common.get_hod_sec_costcodes_csv(
                                          p_hod_sec_empno    => v_hod_sec_empno,
                                          p_assign_codes_csv => p_assign_codes_csv
                                      );

        Open c For
            With
                assign_codes As (
                    Select
                        regexp_substr(v_hod_sec_assign_codes_csv, '[^,]+', 1, level) assign
                    From
                        dual
                    Connect By
                        level <=
                        length(v_hod_sec_assign_codes_csv) - length(replace(v_hod_sec_assign_codes_csv, ',')) + 1
                ),
                primary_work_space As(
                    Select
                        a.empno, a.primary_workspace, a.start_date, c.type_desc primary_workspace_desc
                    From
                        swp_primary_workspace       a,
                        swp_primary_workspace_types c
                    Where
                        a.primary_workspace     = c.type_code
                        And trunc(a.start_date) = (
                            Select
                                Max(trunc(start_date))
                            From
                                swp_primary_workspace b
                            Where
                                b.empno = a.empno
                                And b.start_date <= v_friday_date
                        )
                )
            Select
                *
            From
                (
                    Select
                        a.empno                                                           As empno,
                        a.name                                                            As employee_name,
                        a.assign,
                        a.parent,
                        (
                            Select
                            Distinct d.projno
                            From
                                swp_emp_proj_mapping d
                            Where
                                d.empno = a.empno
                        )                                                                 As projno,
                        iot_swp_common.fn_get_dept_group(a.assign)                        As assign_dept_group,
                        a.office,
                        a.emptype,
                        iot_swp_common.get_emp_work_area(p_person_id, p_meta_id, a.empno) work_area,
                        --iot_swp_common.is_emp_laptop_user(a.empno)                        As is_laptop_user,
                        Case iot_swp_common.is_emp_laptop_user(a.empno)
                            When 1 Then
                                'Yes'
                            Else
                                'No'
                        End                                                               As is_laptop_user_text,
                        Case iot_swp_common.is_emp_dualmonitor_user(a.empno)
                            When 1 Then
                                'Yes'
                            Else
                                'No'
                        End                                                               As is_dual_monitor_user_text,

                        a.grade                                                           As emp_grade,
                        nvl(b.primary_workspace_desc, '')                                 As primary_workspace,
                        Case iot_swp_common.is_emp_eligible_for_swp(a.empno)
                            When 'OK' Then
                                'Yes'
                            Else
                                'No'
                        End                                                               As is_swp_eligible_desc

                    --iot_swp_common.is_emp_eligible_for_swp(a.empno)                   As is_eligible
                    From
                        ss_emplmast        a,
                        primary_work_space b,
                        assign_codes       c
                    Where
                        a.empno      = b.empno(+)
                        And a.assign = c.assign
                        And a.status = 1
                        And a.assign Not In (
                            Select
                                assign
                            From
                                swp_exclude_assign
                        )
                        And a.emptype In (
                            Select
                                emptype
                            From
                                swp_include_emptype
                        )

                );

        Return c;

    End fn_emp_pws_excel;

    Function fn_emp_pws_plan_excel(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_assign_codes_csv Varchar2 Default Null

    ) Return Sys_Refcursor As
        v_plan_friday_date Date;
        rec_config_week    swp_config_weeks%rowtype;
    Begin
        Select
            *
        Into
            rec_config_week
        From
            swp_config_weeks
        Where
            planning_flag = 2;
        v_plan_friday_date := rec_config_week.end_date;

        Return fn_emp_pws_excel(
            p_person_id        => p_person_id,
            p_meta_id          => p_meta_id,

            p_assign_codes_csv => p_assign_codes_csv,
            p_start_date       => v_plan_friday_date
        );

    End fn_emp_pws_plan_excel;

    Function fn_emp_pws_admin_list(
        p_person_id             Varchar2,
        p_meta_id               Varchar2,

        p_assign_code           Varchar2 Default Null,
        p_start_date            Date     Default Null,

        p_empno                 Varchar2 Default Null,

        p_emptype_csv           Varchar2 Default Null,
        p_grade_csv             Varchar2 Default Null,
        p_primary_workspace_csv Varchar2 Default Null,
        p_laptop_user           Varchar2 Default Null,
        p_eligible_for_swp      Varchar2 Default Null,
        p_generic_search        Varchar2 Default Null,

        p_row_number            Number,
        p_page_length           Number
    ) Return Sys_Refcursor As
        rec_config_week swp_config_weeks%rowtype;
        v_friday_date   Date;
        v_count         Number;
    Begin
        If p_start_date Is Not Null Then
            v_friday_date := iot_swp_common.get_friday_date(nvl(p_start_date, sysdate));
        Else

            Select
                Count(*)
            Into
                v_count
            From
                swp_config_weeks
            Where
                planning_flag = 2;
            If v_count > 0 Then
                Select
                    *
                Into
                    rec_config_week
                From
                    swp_config_weeks
                Where
                    planning_flag = 2;
                v_friday_date := rec_config_week.end_date;
            Else
                v_friday_date := iot_swp_common.get_friday_date(sysdate);

            End If;
        End If;
        Return fn_emp_primary_ws_list(
            p_person_id             => p_person_id,
            p_meta_id               => p_meta_id,

            p_assign_code           => p_assign_code,
            p_start_date            => v_friday_date,

            p_empno                 => p_empno,

            p_emptype_csv           => p_emptype_csv,
            p_grade_csv             => p_grade_csv,
            p_primary_workspace_csv => p_primary_workspace_csv,
            p_laptop_user           => p_laptop_user,
            p_eligible_for_swp      => p_eligible_for_swp,
            p_generic_search        => p_generic_search,

            p_is_admin_call         => true,

            p_row_number            => p_row_number,
            p_page_length           => p_page_length
        );

    End;

    --By Pradeep only for information

    Function fn_emp_primary_ws_admin_list(
        p_person_id      Varchar2,
        p_meta_id        Varchar2,

        p_empno          Varchar2,
        p_generic_search Varchar2 Default Null,
        p_start_date     Date     Default Null,

        p_row_number     Number,
        p_page_length    Number
    ) Return Sys_Refcursor As
        p_plan_start_date    Date;
        p_plan_end_date      Date;
        p_curr_start_date    Date;
        p_curr_end_date      Date;
        p_planning_exists    Varchar2(200);
        p_pws_open           Varchar2(200);
        p_sws_open           Varchar2(200);
        p_ows_open           Varchar2(200);
        p_message_type       Varchar2(200);
        p_message_text       Varchar2(200);
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
        iot_swp_common.get_planning_week_details(
            p_person_id       => p_person_id,
            p_meta_id         => p_meta_id,
            p_plan_start_date => p_plan_start_date,
            p_plan_end_date   => p_plan_end_date,
            p_curr_start_date => p_curr_start_date,
            p_curr_end_date   => p_curr_end_date,
            p_planning_exists => p_planning_exists,
            p_pws_open        => p_pws_open,
            p_sws_open        => p_sws_open,
            p_ows_open        => p_ows_open,
            p_message_type    => p_message_type,
            p_message_text    => p_message_text
        );
        If (p_message_type = 'KO') Then
            Return Null;
        End If;
        Open c For
            Select
                *
            From
                (
                    Select
                        a.key_id                                As key_id,
                        a.empno                                 As empno,
                        get_emp_name(a.empno)                   As employee_name,
                        to_char(a.start_date, 'dd-Mon-yyyy')    As start_date,
                        a.start_date                            As date_forsort,
                        a.primary_workspace                     As primary_workspace,
                        b.type_desc                             As primary_workspace_text,
                        Case
                            When a.modified_by = 'Sys' Then
                                'System'
                            Else
                                a.modified_by || ' - ' || get_emp_name(a.modified_by)
                        End                                     As modified_by,
                        to_char(a.modified_on, 'dd-Mon-yyyy')   As modified_on_date,
                        Row_Number() Over (Order By empno Desc) As row_number,
                        Count(*) Over ()                        As total_row
                    From
                        swp_primary_workspace                                a, swp_primary_workspace_types b
                    Where
                        b.type_code = a.primary_workspace
                        And a.start_date <= p_curr_start_date
                        And a.empno = p_empno
                    Order By a.start_date Desc
                )
            Where
                row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length)
            Order By
                date_forsort Desc;

        Return c;
    End;

    --End
End iot_swp_primary_workspace_qry;
/
---------------------------
--Changed PACKAGE BODY
--IOT_SWP_ATTENDANCE_QRY
---------------------------
CREATE OR REPLACE PACKAGE BODY "SELFSERVICE"."IOT_SWP_ATTENDANCE_QRY" As

    Function fn_attendance_for_period(
        p_person_id               Varchar2,
        p_meta_id                 Varchar2,

        p_start_date              Date,
        p_end_date                Date,
        p_is_exclude_x1_employees Number

    ) Return Sys_Refcursor As
        v_empno              Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
        c                    Sys_Refcursor;
        v_exclude_grade      Varchar2(2);
    Begin

        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;

        If p_is_exclude_x1_employees = 1 Then
            v_exclude_grade := 'X1';
        Else
            v_exclude_grade := '!!';
        End If;

        Open c For
            Select
                data.*,
                iot_swp_common.fn_get_pws_text(data.n_pws)                                    c_pws,
                iot_swp_common.fn_get_attendance_status(data.empno, data.d_date, data.n_pws)  attend_status,
                iot_swp_common.fn_is_attendance_required(data.empno, data.d_date, data.n_pws) attend_required
            From
                (
                    Select
                        *
                    From
                        (
                            With
                                work_days As (
                                    Select
                                        *
                                    From
                                        ss_days_details d
                                    Where
                                        d.d_date Between p_start_date And nvl(p_end_date, sysdate)
                                        And d.d_date Not In (
                                            Select
                                                holiday
                                            From
                                                ss_holidays
                                            Where
                                                holiday Between p_start_date And nvl(p_end_date, sysdate)
                                        )
                                )
                            Select
                                e.empno                                                    As empno,
                                e.name                                                     As employee_name,
                                e.email                                                    As email,
                                e.parent                                                   As parent,
                                e.assign                                                   As assign,
                                e.emptype                                                  As emp_type,
                                e.grade                                                    As grade,
                                e.doj                                                      As doj,
                                p_end_date                                                 As dol,
                                wd.d_date                                                  As d_date,
                                to_char(e.status)                                          As status,
                                to_char(iot_swp_common.fn_get_emp_pws(e.empno, wd.d_date)) n_pws
                            From
                                ss_emplmast e,
                                work_days   wd
                            Where
                                (
                                e.status = 1

                                )
                                And e.emptype In (
                                    Select
                                        emptype
                                    From
                                        swp_include_emptype
                                )
                                And e.assign Not In (
                                    Select
                                        assign
                                    From
                                        swp_exclude_assign
                                )
                                And e.grade <> v_exclude_grade
                        )
                    Where
                        d_date >= doj

                ) data;

        Return c;

    End;

    Function fn_attendance_for_day(
        p_person_id               Varchar2,
        p_meta_id                 Varchar2,

        p_start_date              Date,

        p_is_exclude_x1_employees Number

    ) Return Sys_Refcursor As
        v_empno              Varchar2(5);
        e_employee_not_found Exception;
        e_date_is_holiday    Exception;
        Pragma exception_init(e_employee_not_found, -20001);
        Pragma exception_init(e_date_is_holiday, -20002);
        c                    Sys_Refcursor;
        v_exclude_grade      Varchar2(2);
        v_count              Number;
    Begin

        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;

        If p_is_exclude_x1_employees = 1 Then
            v_exclude_grade := 'X1';
        Else
            v_exclude_grade := '!!';
        End If;

        If p_start_date Is Null Then
            raise_application_error(-20003, 'Invalid date provided.');

            Return Null;
        End If;

        Select
            Count(holiday)
        Into
            v_count
        From
            ss_holidays
        Where
            holiday = p_start_date;
        If v_count > 0 Then
            raise_application_error(-20002, 'Date provided is a holiday');
            Return Null;
        End If;
        Open c For
            Select
                data.*,
                iot_swp_common.fn_get_pws_text(data.n_pws)                                    c_pws,
                iot_swp_common.fn_get_attendance_status(data.empno, data.d_date, data.n_pws)  attend_status,
                iot_swp_common.fn_is_attendance_required(data.empno, data.d_date, data.n_pws) attend_required

            From
                (
                    Select
                        *
                    From
                        (
                            Select
                                e.empno                                                       As empno,
                                e.name                                                        As employee_name,
                                e.email                                                       As email,
                                e.parent                                                      As parent,
                                e.assign                                                      As assign,
                                e.emptype                                                     As emp_type,
                                e.grade                                                       As grade,
                                e.doj                                                         As doj,
                                trunc(p_start_date)                                           As d_date,
                                to_char(e.status)                                             As status,
                                to_char(iot_swp_common.fn_get_emp_pws(e.empno, p_start_date)) n_pws,
                                Case iot_swp_common.fn_can_work_smartly(empno)
                                    When 1 Then
                                        'Yes'
                                    Else
                                        'No'
                                End                                                           As can_work_smartly
                            From
                                ss_emplmast e
                            Where
                                status = 1
                                And emptype In (
                                    Select
                                        emptype
                                    From
                                        swp_include_emptype
                                )
                                And assign Not In(
                                    Select
                                        assign
                                    From
                                        swp_exclude_assign
                                )
                                And grade <> v_exclude_grade
                                And doj <= p_start_date
                        )
                ) data;

        Return c;

    End;

    Function fn_attendance_for_prev_day(
        p_person_id               Varchar2,
        p_meta_id                 Varchar2

    ) Return Sys_Refcursor As
        v_prev_date Date;
    Begin
        v_prev_date := iot_swp_common.fn_get_prev_work_date(trunc(sysdate) - 1);

        Return fn_attendance_for_day(
            p_person_id               => p_person_id,
            p_meta_id                 => p_meta_id,

            p_start_date              => v_prev_date,

            p_is_exclude_x1_employees => 0

        );
    End;

    Function fn_date_list(
        p_person_id  Varchar2,
        p_meta_id    Varchar2,

        p_start_date Date,
        p_end_date   Date

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

        Open c For
            Select
                *
            From
                (
                    Select
                        dd.d_day As d_days, dd.d_date d_date_list
                    From
                        ss_days_details dd
                    Where
                        d_date Between p_start_date And p_end_date
                        And dd.d_date Not In (
                            Select
                                holiday
                            From
                                ss_holidays
                            Where
                                ss_holidays.holiday Between p_start_date And p_end_date
                        )
                )
            Order By
                d_date_list;
        Return c;

    End;

    Function fn_swp_day_attendance_list(
        p_person_id               Varchar2,
        p_meta_id                 Varchar2,

        p_start_date              Date,
        p_end_date                Date,
        p_is_exclude_x1_employees Number

    ) Return Sys_Refcursor As
        v_empno              Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
        c                    Sys_Refcursor;
        v_exclude_grade      Varchar2(2);
    Begin

        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;

        If p_is_exclude_x1_employees = 1 Then
            v_exclude_grade := 'X1';
        Else
            v_exclude_grade := '!!';
        End If;

        Open c For
            Select
                data.*,
                iot_swp_common.fn_get_pws_text(data.n_pws)                                    c_pws,
                iot_swp_common.fn_get_attendance_status(data.empno, data.d_date, data.n_pws)  attend_status,
                iot_swp_common.fn_is_attendance_required(data.empno, data.d_date, data.n_pws) attend_required
            From
                (
                    Select
                        *
                    From
                        (
                            With
                                work_days As (
                                    Select
                                        *
                                    From
                                        ss_days_details d
                                    Where
                                        d.d_date Between p_start_date And nvl(p_end_date, sysdate)
                                        And d.d_date Not In (
                                            Select
                                                holiday
                                            From
                                                ss_holidays
                                            Where
                                                holiday Between p_start_date And nvl(p_end_date, sysdate)
                                        )
                                )
                            Select
                                e.empno                                                    As empno,
                                e.name                                                     As employee_name,
                                e.email                                                    As email,
                                e.parent                                                   As parent,
                                e.assign                                                   As assign,
                                e.emptype                                                  As emp_type,
                                e.grade                                                    As grade,
                                e.doj                                                      As doj,
                                p_end_date                                                 As dol,
                                wd.d_date                                                  As d_date,
                                to_char(e.status)                                          As status,
                                to_char(iot_swp_common.fn_get_emp_pws(e.empno, wd.d_date)) n_pws
                            From
                                ss_emplmast e,
                                work_days   wd
                            Where
                                (
                                e.status = 1

                                )
                                And e.emptype In (
                                    Select
                                        emptype
                                    From
                                        swp_include_emptype
                                )
                                And e.assign Not In (
                                    Select
                                        assign
                                    From
                                        swp_exclude_assign
                                )
                                And e.grade <> v_exclude_grade
                        )
                    Where
                        d_date >= doj

                ) data;

        Return c;

    End;

End iot_swp_attendance_qry;
/
---------------------------
--Changed FUNCTION
--WORKEDHRS3
---------------------------
CREATE OR REPLACE FUNCTION "SELFSERVICE"."WORKEDHRS3" (V_Code IN Varchar2, V_PDate IN Date, V_ShiftCode IN Varchar2) Return Number IS
		Cursor C1 is select * from SS_IntegratedPunch 
			where EmpNo = ltrim(rtrim(V_Code))
			and PDate = V_PDate Order By PDate,hhsort,mmsort,hh,mm;
		Type TabHrs  is table of Number index by Binary_Integer;
		V_TabHrs TabHrs;
		Cntr Number;
		THrs Varchar2(10);
		TotalHrs Number;
		v_I_HH Number;
		v_I_MM Number;
		v_O_HH Number;
		v_O_MM Number;
		V_InTime Number;
		V_OutTime Number;
		v_Count Number;
		V_AvailedLunchTime Number := 0;
BEGIN
		If V_ShiftCode = 'OO' Or V_ShiftCode = 'HH' Then
				Return 0;
		End If;

--	New


			Select TimeIn_HH,TimeIn_Mn,TimeOut_HH,TimeOut_Mn InTo v_I_HH, v_I_MM ,v_O_HH, v_O_MM From SS_ShiftMast 
				Where ShiftCode = Ltrim(Rtrim(v_ShiftCode));
				v_InTime := (v_I_HH*60) + v_I_MM;
				v_OutTime := (v_O_HH*60) + v_O_MM;

  	Select Count(*) InTo v_Count From SS_BusLate_LayOff_Detail 
  			Where EmpNo=Ltrim(Rtrim(v_Code)) And PDate = v_PDate;
  	If v_Count = 1 Then
  			Select TimeIn_HH,TimeIn_MM,TimeOut_HH,TimeOut_MM InTo v_I_HH, v_I_MM ,v_O_HH, v_O_MM 
					From SS_BusLate_LayOff_Mast
					Where PDate=v_PDate 
					And Code = (Select Code From SS_BusLate_LayOff_Detail Where EmpNo=Ltrim(Rtrim(v_Code)) And PDate = v_PDate);
				v_InTime := (v_I_HH*60) + v_I_MM;
				v_OutTime := (v_O_HH*60) + v_O_MM;
  	End If;

-- End Of New

/*		Select 
					GetShiftInTime(v_Code,v_PDate,v_ShiftCode ),
					GetShiftOutTime(v_Code,v_PDate,v_ShiftCode )
				InTo 
					V_InTime, 
					V_OutTime
		From SS_ShiftMast Where ShiftCode = LTrim(Rtrim(V_ShiftCode));
*/			
		TotalHrs := 0;
		Cntr := 1;
		For C2 in C1 Loop
				If ((C2.HH * 60) + C2.MM) > V_OutTime + 60 Then
						V_TabHrs(Cntr) := V_OutTime  + 60;
						Cntr := Cntr + 1;
						Exit;
				Else
						If ((C2.HH * 60) + C2.MM)  < (V_InTime - 15) And Cntr = 1 Then
								V_TabHrs(Cntr) := (V_InTime -15);
								Cntr := Cntr + 1;
						ElsIf ((C2.HH * 60) + C2.MM)  >= (V_InTime - 15) Then
								If Cntr > 1 Then
										If v_TabHrs(Cntr-1) >= ((C2.HH * 60) + C2.MM) Then
												V_TabHrs(Cntr) := V_TabHrs(Cntr-1);
										ElsIf (((C2.HH * 60) + C2.MM) - v_TabHrs(Cntr-1)) <= 60 And Mod(CNtr,2)=1 Then
												V_TabHrs(Cntr) := v_TabHrs(Cntr-1);
										Else 
												V_TabHrs(Cntr) := (C2.HH * 60) + C2.MM;
										End If;
								Else
										V_TabHrs(Cntr) := (C2.HH * 60) + C2.MM;
								End If;
								Cntr := Cntr + 1;
						End If;
				End If;
		End Loop;
		Cntr := Cntr - 1;
	  If Cntr > 1 Then
		  	For i in 1..Cntr Loop
			  		If Mod(i,2) <>0 then
				  			If i = Cntr Then
						  			TotalHrs := TotalHrs - (V_TabHrs(i-1) - V_TabHrs(i-2));
						  			TotalHrs := TotalHrs + (V_TabHrs(i) - V_TabHrs(i-2));
				  			ElsIf i < Cntr Then
						  			TotalHrs := TotalHrs + (V_TabHrs(i+1) - V_TabHrs(i));
				  			End If;
			  		End If;
		  	End Loop;
		  	V_AvailedLunchTime := AvailedLunchTime1(V_Code, V_PDate ,V_ShiftCode );
		  	TotalHrs := TotalHrs - V_AvailedLunchTime;
	  End If;
	  Return TotalHrs ;
Exception
  	when others then return 0;
END
;
/
---------------------------
--Changed FUNCTION
--WORKEDHRS2
---------------------------
CREATE OR REPLACE FUNCTION "SELFSERVICE"."WORKEDHRS2" (V_Code IN Varchar2, V_PDate IN Date, V_ShiftCode IN Varchar2) Return Number IS
	Cursor C1 is select * from SS_IntegratedPunch 
		where EmpNo = ltrim(rtrim(V_Code))
		and PDate = V_PDate Order By PDate,hhsort,mmsort,hh,mm;
	Type TabHrsRec is record (TabHrs number, TabMns number);
	Type TabHrs  is table of TabHrsRec index by Binary_Integer;
	V_TabHrs TabHrs;
	Cntr Number;
	THrs Varchar2(10);
	TotalHrs Number;
	V_InTimeHH Number;
	V_InTimeMN Number;
	V_OutTimeHH Number;
	V_OutTimeMN Number;
	V_AvailedLunchTime Number := 0;
BEGIN
	Select TimeIn_HH, TimeIn_Mn, TimeOut_HH, TimeOut_Mn InTo V_InTimeHH, V_InTimeMN, V_OutTimeHH, V_OutTimeMN From SS_ShiftMast Where ShiftCode = Trim(V_ShiftCode);
	TotalHrs := 0;
	Cntr := 1;
	For C2 in C1 Loop
		If ((C2.HH * 60) + C2.MM) > (((V_OutTimeHH * 60) + V_OutTimeMN) + 60) Then
				V_TabHrs(Cntr).TabHrs := FLoor(((V_OutTimeHH * 60) + V_OutTimeMN + 60)/60);
				V_TabHrs(Cntr).TabMns := Mod(((V_OutTimeHH * 60) + V_OutTimeMN + 60),60);
				Cntr := Cntr + 1;
				Exit;
		Else
			If ((C2.HH * 60) + C2.MM  < (V_InTimeHH * 60) + V_InTimeMN - 15) And Cntr = 1 Then
				V_TabHrs(Cntr).TabHrs := FLoor(((V_InTimeHH * 60) + V_InTimeMN - 15)/60);
				V_TabHrs(Cntr).TabMns := Mod(((V_InTimeHH * 60) + V_InTimeMN - 15),60);
				Cntr := Cntr + 1;
			ElsIf ((C2.HH * 60) + C2.MM  >= (V_InTimeHH * 60) + V_InTimeMN - 15) Then
				V_TabHrs(Cntr).TabHrs := C2.HH;
				V_TabHrs(Cntr).TabMns := C2.MM;
				Cntr := Cntr + 1;
			End If;
		End If;
	End Loop;
	Cntr := Cntr - 1;
  If Cntr > 1 Then
  	For i in 1..Cntr Loop
  		If Mod(i,2) <>0 then
  			If i = Cntr Then
	  			TotalHrs := TotalHrs - (((V_TabHrs(i-1).TabHrs * 60) + V_TabHrs(i-1).TabMns) - ((V_TabHrs(i-2).TabHrs * 60) + V_TabHrs(i-2).TabMns));
	  			TotalHrs := TotalHrs + (((V_TabHrs(i).TabHrs * 60) + V_TabHrs(i).TabMns) - ((V_TabHrs(i-2).TabHrs * 60) + V_TabHrs(i-2).TabMns));
  			ElsIf i < Cntr Then
	  			TotalHrs := TotalHrs + (((V_TabHrs(i+1).TabHrs * 60) + V_TabHrs(i+1).TabMns) - ((V_TabHrs(i).TabHrs * 60) + V_TabHrs(i).TabMns));
  			End If;
  		End If;
  	End Loop;
  	V_AvailedLunchTime := AvailedLunchTime(V_Code, V_PDate ,V_ShiftCode );
  	TotalHrs := TotalHrs - V_AvailedLunchTime;
  End If;
  Return TotalHrs ;
Exception
  	when others then return 0;
END
;
/
---------------------------
--Changed FUNCTION
--WORKEDHRS11
---------------------------
CREATE OR REPLACE FUNCTION "SELFSERVICE"."WORKEDHRS11" (V_Code IN Varchar2, V_PDate IN Date, V_ShiftCode IN Varchar2) Return Number IS
	Cursor C1 is select * from SS_IntegratedPunch 
		where EmpNo = ltrim(rtrim(V_Code))
		and PDate = V_PDate Order By PDate,hhsort,mmsort,hh,mm;
	Type TabHrsRec is record (TabHrs number, TabMns number);
	Type TabHrs  is table of TabHrsRec index by Binary_Integer;
	V_TabHrs TabHrs;
	Cntr Number;
	THrs Varchar2(10);
	TotalHrs Number;
	V_InTimeHH Number;
	V_InTimeMN Number;
	V_OutTimeHH Number;
	V_OutTimeMN Number;
	v_AvailedLunchTime Number := 0;
BEGIN
	Select TimeIn_HH, TimeIn_Mn, TimeOut_HH, TimeOut_Mn InTo V_InTimeHH, V_InTimeMN, V_OutTimeHH, V_OutTimeMN From SS_ShiftMast Where ShiftCode = Trim(V_ShiftCode);
	TotalHrs := 0;
	Cntr := 1;
	For C2 in C1 Loop
		If ((C2.HH * 60) + C2.MM) > (((V_OutTimeHH * 60) + V_OutTimeMN) + 60) Then
				V_TabHrs(Cntr).TabHrs := FLoor(((V_OutTimeHH * 60) + V_OutTimeMN + 60)/60);
				V_TabHrs(Cntr).TabMns := Mod(((V_OutTimeHH * 60) + V_OutTimeMN + 60),60);
				Cntr := Cntr + 1;
				Exit;
		Else
			If ((C2.HH * 60) + C2.MM  < (V_InTimeHH * 60) + V_InTimeMN - 15) And Cntr = 1 Then
				V_TabHrs(Cntr).TabHrs := FLoor(((V_InTimeHH * 60) + V_InTimeMN - 15)/60);
				V_TabHrs(Cntr).TabMns := Mod(((V_InTimeHH * 60) + V_InTimeMN - 15),60);
				Cntr := Cntr + 1;
			ElsIf ((C2.HH * 60) + C2.MM  >= (V_InTimeHH * 60) + V_InTimeMN - 15) Then
				V_TabHrs(Cntr).TabHrs := C2.HH;
				V_TabHrs(Cntr).TabMns := C2.MM;
				Cntr := Cntr + 1;
			End If;
		End If;
	End Loop;
	Cntr := Cntr - 1;
  If Cntr > 1 Then
  	For i in 1..Cntr Loop
  		If Mod(i,2) <>0 then
  			If i = Cntr Then
	  			TotalHrs := TotalHrs - (((V_TabHrs(i-1).TabHrs * 60) + V_TabHrs(i-1).TabMns) - ((V_TabHrs(i-2).TabHrs * 60) + V_TabHrs(i-2).TabMns));
	  			TotalHrs := TotalHrs + (((V_TabHrs(i).TabHrs * 60) + V_TabHrs(i).TabMns) - ((V_TabHrs(i-2).TabHrs * 60) + V_TabHrs(i-2).TabMns));
  			ElsIf i < Cntr Then
	  			TotalHrs := TotalHrs + (((V_TabHrs(i+1).TabHrs * 60) + V_TabHrs(i+1).TabMns) - ((V_TabHrs(i).TabHrs * 60) + V_TabHrs(i).TabMns));
  			End If;
  		End If;
  	End Loop;
  	v_AvailedLunchTime := AvailedLunchTime(V_Code, V_PDate, V_ShiftCode);
  	TotalHrs := TotalHrs - v_AvailedLunchTime;
  End If;
  Return TotalHrs;
Exception
  	when others then return 0;
END
;
/
---------------------------
--Changed FUNCTION
--SS_MONTH_WRK_HRS
---------------------------
CREATE OR REPLACE FUNCTION "SELFSERVICE"."SS_MONTH_WRK_HRS" 
  ( pEmpNo IN VARCHAR2,
    pMM IN VARCHAR2,
    pYYYY IN VARCHAR2)
  RETURN  Number IS
--
-- To modify this template, edit file FUNC.TXT in TEMPLATE 
-- directory of SQL Navigator
--
-- Purpose: Briefly explain the functionality of the function
--
-- MODIFICATION HISTORY
-- Person      Date    Comments
-- ---------   ------  -------------------------------------------       
   vWrkTime                 Number;
--   vWrkHrs                  Number;
--   vWrkMin                  Number;
   -- Declare program variables as shown above
BEGIN
    select  sum(N_WorkedHrs(pEmpNo,D_Date, GetShift1(pEmpNo,D_Date)) ) InTo vWrkTime from ss_days_details
        where d_yyyy = pYYYY and d_mm = pMM ;
    RETURN nvl(vWrkTime,0)/60 ;
/*EXCEPTION
   WHEN others THEN
       Return 0;*/
END;
/
---------------------------
--Changed FUNCTION
--N_IS_EMP_ABSENT
---------------------------
CREATE OR REPLACE FUNCTION "SELFSERVICE"."N_IS_EMP_ABSENT" (
    param_empno        in varchar2,
    param_date         in varchar2,
    param_shift_code   in varchar2,
    param_doj          in varchar2
) return varchar2 as

    v_holiday           number;
    v_count             number;
    c_is_absent         constant number := 1;
    c_not_absent        constant number := 0;
    c_leave_depu_tour   constant number := 2;
    v_on_ldt            number;
    v_ldt_appl          number;
begin
    v_holiday    := get_holiday(param_date);
    if v_holiday > 0 or nvl(param_shift_code,'ABCD') in (
        'HH',
        'OO'
    ) then
        --return -1;
        return c_not_absent;
    end if;

    --Check DOJ & DOL

    if param_date < nvl(param_doj,param_date) then
        --return -5;
        return c_not_absent;
    end if;
    v_on_ldt     := isleavedeputour(param_date,param_empno);
    if v_on_ldt = 1 then
        --return -2;
        --return c_leave_depu_tour;
        return c_not_absent;
    end if;
    select
        count(empno)
    into v_count
    from
        ss_integratedpunch
    where
        empno = trim(param_empno)
        and pdate = param_date;

    if v_count > 0 then
        --return -3;
        return c_not_absent;
    end if;
    v_ldt_appl   := isldt_appl(param_empno,param_date);
    if v_ldt_appl > 0 then
        --return -6;
        return c_not_absent;
    end if;
    --return -4;
    return c_is_absent;
end n_is_emp_absent;
/
---------------------------
--Changed FUNCTION
--N_CFWDDELTAHRS
---------------------------
CREATE OR REPLACE FUNCTION "SELFSERVICE"."N_CFWDDELTAHRS" (p_EmpNo IN Varchar2, p_PDate IN Date, p_SaveTot In Number) RETURN Number IS

-- p_SaveTot - if '1' Then totals of Last Complete Week of the month are stored in the database.
-- p_SaveTot - if '0' Then totals of Last Complete Week of the month are retrived from the database.
		
		Cursor C1 (c_EmpNo IN Varchar2, c_Date IN Date) Is
				Select c_EmpNo As EmpNo, To_Number(D_DD) As Days, 
						LateCome1(c_EmpNo,D_Date) AS LCome,
						D_Date AS PDate, 
						GetShift1(c_EmpNo, D_Date) AS SCode,
						Get_Holiday(D_Date) As isSunday,
						EarlyGo1(c_EmpNo,D_Date) AS EGo,
						isLComeEGoApp(c_EmpNo,D_Date) AS LC_App,
						isSLeaveApp(c_EmpNo,D_Date) AS SL_App,
						isLastWorkDay1(c_EmpNo, D_Date) AS isLWD,
						Wk_Of_Year
				From SS_Days_Details
				Where D_Date >= c_Date And D_Date <= Last_Day(c_Date)
				Order by D_Date;

		LC_AppCntr Number := 0;
		SL_AppCntr Number := 0;
		v_OpenLC_Cntr Number := 0;
		v_OpenMM Number :=0;
		v_SDate Date;
		v_Count Number :=0;
		v_DHrs Number :=0;
		v_SumDHrs Number :=0;
		v_CFwdHrs Number :=0;
		v_RetVal Number := 0;
		v_CFwdHrsOfLastWeek Number :=0;
		--v_CFwdSLAppCntr Number :=0;

BEGIN
		If To_Number(To_Char(p_PDate,'dd')) = 1 Then
				Select Count(*) InTo v_Count From SS_DeltaHrsBal Where PDate < p_PDate And EmpNo = Trim(p_EmpNo);
				If v_Count = 0 Then
						v_SDate := To_Date('30-nov-2001');
				Else
						Select PDate, MM, LC_AppCntr InTo v_SDate, v_OpenMM, v_OpenLC_Cntr From SS_DeltaHrsBal 
							Where PDate < p_PDate 
							And EmpNo = Trim(p_EmpNo)
							And PDate = (Select Max(PDate) From SS_DeltaHrsBal Where PDate < p_PDate And EmpNo = Trim(p_EmpNo) Group By EmpNo);
				End If;
				v_SDate := v_SDate + 1;
				If v_SDate <> p_PDate Then
						For C2 IN C1(p_EmpNo,v_SDate) Loop
								LC_AppCntr := LC_AppCntr + C2.LC_App;
								SL_AppCntr := SL_AppCntr + C2.SL_App;

								/*If To_Char(Last_Day(v_SDate),'Dy') <> 'Sun' Then
										If To_Number(To_Char(Last_Day(v_SDate),'IW')) <> To_Number(C2.Wk_Of_Year) Then
											v_CFwdSLAppCntr := 	v_CFwdSLAppCntr + C2.SL_App;
										End If;
								End If;*/

								Select N_DeltaHrs(C2.EmpNo,C2.PDate,C2.SCode,PenaltyLeave1(C2.LCome,C2.EGo,C2.isLWD,LC_AppCntr,SL_AppCntr,C2.LC_App,C2.SL_App)) InTo v_DHrs From Dual;
								v_SumDHrs := v_SumDHrs + v_DHrs;
								If C2.isLWD = 1 And C2.PDate <> Last_Day(v_SDate) Then
										Select CFwd_DHRs_Week(LastDay_CFwd_DHrs1(v_DHrs, C2.EGo, C2.SL_App, SL_AppCntr, C2.isLWD), C2.isLWD, v_SumDHRs) InTo v_CFwdHrs From Dual;
										Select Least(Greatest(v_SumDHrs,v_CFwdHrs),0) InTo v_SumDHrs From Dual;
								End If;
								/*If C2.isLDM = 1 And C2.isLWD = 0 Then
										Null;
								End If;*/
								If C2.isSunday = 2 Then
										v_CFwdHrsOfLastWeek := v_SumDHrs;
										LC_AppCntr := 0;
								End If;
						End Loop;
						If p_SaveTot = 1 Then
								Delete From SS_DeltaHrsBal_OT where EmpNo = p_EmpNo And Mon = To_Char(v_SDate,'MM') And YYYY = To_Char(v_SDate, 'yyyy');
								Insert InTo SS_DeltaHrsBal_OT (EmpNo,Mon,YYYY,DeltaHrs) Values (p_EmpNo,LPad(To_Char(v_SDate,'MM'),2,'0'),LPad(To_Char(v_SDate,'YYYY'),4,'0'),v_CFwdHrsOfLastWeek);
								Commit;
						End If;
						v_RetVal := v_SumDHrs;
						LC_AppCntr := 0;
				Else
						v_RetVal := v_OpenMM;
				End If;
				Return v_RetVal;
		End If;
END
;
/
---------------------------
--Changed FUNCTION
--LATECOME
---------------------------
CREATE OR REPLACE FUNCTION "SELFSERVICE"."LATECOME" (EmpNum IN Varchar2, V_PDate IN Date) RETURN Number IS
	getDate		  Varchar2(2);
	ITime  			Number;
	LCome 			Number;
	SCode 			Varchar2(2);
	IsHoliday 	Number;	
	VCount 			Number;
	ITimeHH 		Number;
	ITimeMn 		Number;
	OTimeHH 		Number;
	OTimeMn 		Number;	
	PunchNos 		Number;
	FirstPunch 	Number;
	V_AvailedLunchTime  Number;
	V_EstimatedLunchTime Number;
BEGIN		
		ITime := 0;
		LCome := 0;
		IsHoliday := CheckHoliday(V_PDate);
		If IsHoliday = 3 then
			SCode := 'HH';
		ElsIf IsHoliday = 0 then
			getDate := To_Char(V_Pdate, 'dd');						

			Select Substr(s_mrk, ((To_number(getDate) * 2) - 1), 2) Into SCode From ss_muster
				Where empno = lpad(trim(EmpNum),5,'0') And mnth = Trim(To_Char(V_Pdate, 'yyyymm'));

			select TimeIn_HH,TimeIn_Mn,TimeOut_HH,TimeOut_Mn into ITimeHH, ITimeMn, OTimeHH, OTimeMn
				from SS_ShiftMast where ShiftCode = Trim(SCode); 
			ITime := ITimeHH * 60 + ITimeMn;
		End If;
		select count(*) into PunchNos from SS_IntegratedPunch where empno = lpad(trim(EmpNum),5,'0') and PDate = V_PDate Order By PDate, HHSort, MMSort;
		If PunchNos > 1 then
				FirstPunch := FirstLastPunch1(lpad(trim(EmpNum),5,'0'),V_PDate,0);
				If IsHoliday = 0 then
					V_AvailedLunchTime := AvailedLunchTime(EmpNum, V_PDate ,SCode);
					V_EstimatedLunchTime := EstimatedLunchTime(EmpNum, V_PDate ,SCode);
					LCome := FirstPunch - ITime - (V_EstimatedLunchTime - V_AvailedLunchTime);
					If LCome < 1 then
						LCome := 0;
					End If;
				End If;
		End if;
		Return LCome;
Exception 
	When Others Then
		Return -1;		
END;
/
---------------------------
--Changed FUNCTION
--LASTDAY_CFWD_DHRS
---------------------------
CREATE OR REPLACE FUNCTION "SELFSERVICE"."LASTDAY_CFWD_DHRS" (p_EmpNo IN Varchar2, p_PDate IN Date) RETURN Number IS
		v_RetVal Number := 0;
		v_EGo Number;
		isLastWrkDy Number;
		v_SLAppCntr Number;
		v_SLApp Number;
		v_ShiftCode Varchar2(10);
		v_DeltaHrs Number;
BEGIN
		Select GetShift1(p_EmpNo,p_PDate) InTo v_ShiftCode From Dual;
		Select 	EarlyGo(p_EmpNo, p_PDate),
						GetSLeaveAppCntr(p_EmpNo,p_PDate),
						IsSLeaveApp(p_EmpNo,p_PDate),
						DeltaHrs(p_EmpNo,p_PDate,v_ShiftCode)
				InTo v_EGo,v_SLAppCntr,v_SLApp,v_DeltaHrs
				From Dual;

		If v_EGo > 0 And v_DeltaHrs < 0 Then
			If (v_EGo <= 60) Then
					Select Greatest(v_EGo,v_DeltaHrs) InTo v_RetVal From Dual;
	  			v_RetVal := v_EGo;
			ElsIf (v_SLApp = 1 And v_SLAppCntr <= 2) And (v_EGo > 60 And v_EGo <= 240) Then
					Select Greatest(v_EGo,v_DeltaHrs) InTo v_RetVal From Dual;
	  			v_RetVal := v_EGo;
			End If;
		End If;
  	Return v_RetVal * -1;
END
;
/
---------------------------
--Changed FUNCTION
--ISLEAVEDEPUTOUR
---------------------------
CREATE OR REPLACE FUNCTION "SELFSERVICE"."ISLEAVEDEPUTOUR" (
    v_date  In Date,
    v_empno In Varchar2
) Return Number Is
    v_cntr   Number;
    v_retval Number := 0;
Begin
    --Check Leave
    Select
        Count(*)
    Into
        v_cntr
    From
        ss_leaveledg
    Where
        empno = Trim(v_empno)
        And bdate <= v_date
        And nvl(edate, bdate) >= v_date
        And adj_type In ('LA', 'LC', 'SW');

    If v_cntr > 0 Then
        --v_retval := 1;
        Return 1;
    End If;

    --Check On Tour / On Deputation 
    Select
        Count(*)
    Into
        v_cntr
    From
        ss_depu
    Where
        empno             = Trim(v_empno)
        And bdate <= v_date
        And nvl(edate, bdate) >= v_date
        And (hod_apprl    = 1
            And hrd_apprl = 1)
        And type <> 'RW';

    If v_cntr > 0 Then
        --v_retval := v_retval + 2;
        Return 2;
    End If;

    --Remote Work (Work From Home)
    Select
        Count(*)
    Into
        v_cntr
    From
        ss_depu
    Where
        empno             = Trim(v_empno)
        And bdate <= v_date
        And nvl(edate, bdate) >= v_date
        And (hod_apprl    = 1
            And hrd_apprl = 1)
        And type          = 'RW';

    If v_cntr > 0 Then
        Return 3;
    End If;

    --Leave adjustment SW
    Select
        Count(*)
    Into
        v_cntr
    From
        ss_leave_adj
    Where
        empno = v_empno
        And v_date Between bdate And nvl(edate, bdate);
    If v_cntr > 0 Then
        Return 4;
    End If;

    Return 0;
Exception
    When Others Then
        Return v_retval;
End;
/
---------------------------
--Changed FUNCTION
--ISEXTRAHOURS
---------------------------
CREATE OR REPLACE FUNCTION "SELFSERVICE"."ISEXTRAHOURS" (p_EmpNo Varchar2, p_Month Varchar2, p_Year Varchar2) RETURN Number IS
		v_Cntr Number;
BEGIN
  	Select Count(*) InTo v_Cntr From (Select N_WorkedHrs(p_EmpNo, D_Date,GetShift1(p_EmpNo,D_Date)) - EstimatedWrkHrs(p_EmpNo, D_Date) 
  		 As ExtraHrs From SS_Days_Details
  		Where D_Date >= N_GetStartDate(p_Month, p_Year) And D_Date <= N_GetEndDate(p_Month, p_Year)) Where ExtraHrs >= 30 ;
  	IF v_Cntr > 0 Then
  		 Return 1;
  	Else
  		Return 0;
  	End If;
Exception
		When Others Then
			Return 0;  			
END;
/
---------------------------
--Changed FUNCTION
--GET_MUSTER_STATUS
---------------------------
CREATE OR REPLACE FUNCTION "SELFSERVICE"."GET_MUSTER_STATUS" 
  ( parEmpNo IN Varchar2,
    parDate IN Date )
  RETURN  CHAR IS
--
--  THIS FUNCTION RETURN THE EMPLOYEE MUSTER STATUS FOR THE DAY
--  This functin returns the employee muster status for the day eg. leave, deputation, on duty, in office, etc.
--  Return values of this function
--------
--  PP  --  Employee is Present
--  IO  --  Forgetting Punch Card - But present in office
--  OD  --  On Duty for the whole day
--  LE  --  Employee is on leave
--  DP  --  Employee is on Deputaion
--  TR  --  Employee is on Tour
--  HT  --  Employee is at Home Town
--  AB  --  Employee is Absent
--  VS  --  Employee is on duty for  VISA PROBLEM
--  NA  --  Not Applicable (eg. parDate is < DOJ of Employee)
--------
    vRetVal     CHAR(2);
    vCount      Number;
BEGIN 
    vRetVal := 'NA';

    -- Check if employee has punched his Punch Card ( P R E S E N T )
    Select Count(*) InTo vCount From SS_Punch
        Where EmpNo = Trim(parEmpNo) And PDate = parDate;
    If vCount > 0 Then            Return 'PP';        End If;

    -- Check If Employee is on   L E A V E
    Select Count(*) InTo vCount From SS_LeaveLedg Where EmpNo = Trim(parEmpNo)
        And Bdate <= parDate And Nvl(EDate,BDate) >= parDate
        And DB_CR = 'D' And Adj_Type In ( 'LC', 'DR', 'LA');
    If vCount > 0 Then            Return 'LE';        End If;

    -- Check If Employee is on   O N   D U T Y
    Select Count(*) InTo vCount From SS_OnDuty Where EmpNo = Trim(parEmpNo)
        And PDate = parDate And Type = 'OD';
    If vCount > 0 Then            Return  'OD';        End If;

    -- Check If Employee has applied for  F O R G E T T I N G   P U N C H   C A R D
    Select Count(*) InTo vCount From SS_OnDuty Where EmpNo = Trim(parEmpNo)
        And PDate = parDate And Type = 'IO';
    If vCount > 0 Then            Return  'IO';        End If;


    -- Check If Employee is  H O M E   T O W N
    Select Count(*) InTo vCount From SS_Depu Where EmpNo = Trim(parEmpNo)
        And BDate <= parDate And EDate >= parDate And Type = 'HT';
    If vCount > 0 Then            Return  'HT';        End If;

    -- Check If Employee is on  D E P U T A T I O N
    Select Count(*) InTo vCount From SS_Depu Where EmpNo = Trim(parEmpNo)
        And BDate <= parDate And EDate >= parDate And Type = 'DP';
    If vCount > 0 Then            Return  'DP';        End If;

    -- Check If Employee is on   T O U R
    Select Count(*) InTo vCount From SS_Depu Where EmpNo = Trim(parEmpNo)
        And BDate <= parDate And EDate >= parDate And Type = 'TR';
    If vCount > 0 Then            Return  'TR';        End If;

    -- Check If Employee is on duty for  V I S A   P R O B L E M
    Select Count(*) InTo vCount From SS_Depu Where EmpNo = Trim(parEmpNo)
        And BDate <= parDate And EDate >= parDate And Type = 'VS';
    If vCount > 0 Then            Return  'VS';        End If;

    -- Check If Employee is  A B S E N T
    If IsAbsent(parEmpNo,pardate) = 1 Then   Return 'AB';   End If;


    RETURN vRetVal;
EXCEPTION
   WHEN Others THEN
       Return vRetVal;
END;
/
---------------------------
--Changed FUNCTION
--GETABSENTDATE_SHIFT
---------------------------
CREATE OR REPLACE FUNCTION "SELFSERVICE"."GETABSENTDATE_SHIFT" (
    empnum        in varchar2,
    thedate       in date,
    param_shift   varchar2
) return number is
    v_holiday    number;
    v_count      number;
    isabsent     number;
    v_onleave    number;
    dateofjoin   date;
begin
    isabsent    := 0;
    v_holiday   := get_holiday(thedate);
    if nvl(param_shift,'ABCD') not in (
        'HH',
        'OO'
    ) and v_holiday = 0 then
        --If v_holiday = 0 Then
        select
            count(empno)
        into v_count
        from
            ss_integratedpunch
        where
            empno = trim(empnum)
            and pdate = thedate;

        if v_count = 0 then
            v_onleave   := isleavedeputour(thedate,empnum);
            if v_onleave = 0 then
                select
                    nvl(doj,thedate)
                into dateofjoin
                from
                    ss_emplmast
                where
                    empno = trim(empnum);

                if thedate < dateofjoin then
                    isabsent   := 0;
                else
                    isabsent   := 1;
                end if;

            elsif v_onleave = 1 then
                isabsent   := 2;
            else
                isabsent   := 3;
            end if;

        end if;

        --End If;

    end if;

    return isabsent;
end;
/
---------------------------
--Changed FUNCTION
--GETABSENTDATE
---------------------------
CREATE OR REPLACE FUNCTION "SELFSERVICE"."GETABSENTDATE" (EmpNum In Varchar2, TheDate In Date) RETURN Number IS
	v_holiday Number;
	v_count Number;
	IsAbsent Number;
	v_onleave Number;
	dateofjoin Date;
BEGIN		
  IsAbsent := 0;
  v_holiday := Get_Holiday(TheDate);

  If v_holiday = 0 Then
  	 Select Count(empno) Into v_count From ss_integratedpunch
  	 	  Where empno = Trim(EmpNum) And pdate = TheDate;
	  	 	  If v_count = 0 Then
				 	  	v_onleave := IsLeaveDepuTour(TheDate, EmpNum);
				 	  	If v_onleave = 0 Then
								Select Nvl(doj, TheDate) Into dateofjoin From ss_emplmast
									Where empno = Trim(EmpNum);			 	  		
									If TheDate < dateofjoin Then
										IsAbsent := 0;										 	  			
									Else	
					 	  			IsAbsent := 1;	
					 	  		End If;	  		
				 	  	ElsIf v_onleave = 1 Then
				 	  		IsAbsent := 2;	
				 	  	Else
				 	  		IsAbsent := 3;	
				 	  	End If;				 	  		
	  	 	  End If; 	
  End If;	 	  
  Return IsAbsent;
END


;
/
---------------------------
--Changed FUNCTION
--ESTIMATEDWRKHRS
---------------------------
CREATE OR REPLACE FUNCTION "SELFSERVICE"."ESTIMATEDWRKHRS" (p_EmpNo Varchar2, p_DAte Date) RETURN Number IS
		v_Cntr Number;
		v_InTime Number;
		v_OutTime Number;
		v_LunchTime Number;
		v_ShiftCode Varchar2(2);
		v_RetVal Number := 0;
BEGIN

		v_ShiftCode := GetShift1(p_EmpNo, p_Date);
		v_InTime := GetShiftInTime(p_EmpNo, p_Date, v_ShiftCode);
		v_OutTime := GetShiftOutTime(p_EmpNo, p_Date, v_ShiftCode);
		v_LunchTime := AvailedLunchTime1(p_EmpNo, p_Date, v_ShiftCode);
		v_RetVal := v_OutTime - v_InTime - v_LunchTime;
		Return v_RetVal;

Exception
		When Others Then
			Return 0;  			
END;
/
---------------------------
--Changed FUNCTION
--EARLYGO
---------------------------
CREATE OR REPLACE FUNCTION "SELFSERVICE"."EARLYGO" (EmpNum IN Varchar2, V_PDate IN Date) Return Number IS
	getDate Varchar2(2);
	VCount number;
	ITimeHH number;
	ITimeMn number;
	OTimeHH number;
	OTimeMn number;	
	PunchNos number;
	LastPunch number;
	EGo Number;
	IsHoliday Varchar2(2);
	SCode Varchar2(10);
	OTime Number;
	V_AvailedLunchTime Number;
	V_EstimatedLunchTime Number;
BEGIN			
		EGo := 0;
		IsHoliday := CheckHoliday(V_PDate);
		If IsHoliday = 3 then
			SCode := 'HH';
		ElsIf IsHoliday = 0 then
			getDate := To_Char(V_Pdate, 'dd');			

			Select Substr(s_mrk, ((To_number(getDate) * 2) - 1), 2) Into SCode From ss_muster
				Where empno = Trim(lpad(EmpNum,5,'0')) And mnth = Trim(To_Char(V_Pdate, 'yyyymm'));

			select TimeIn_HH,TimeIn_Mn,TimeOut_HH,TimeOut_Mn into ITimeHH, ITimeMn, OTimeHH, OTimeMn
				from SS_ShiftMast where ShiftCode = Trim(SCode); 
			OTime := ((OTimeHH*60) + OTimeMn);
		End If;
		select count(*) into PunchNos from SS_IntegratedPunch where empno = ltrim(rtrim(lpad(EmpNum,5,'0'))) and PDate = V_PDate Order By PDate, HHSort, MMSort;
		If PunchNos > 1 then
				LastPunch := FirstLastPunch1(lpad(EmpNum,5,'0'),V_PDate,1);
				If IsHoliday = 0 then
					V_AvailedLunchTime := AvailedLunchTime(lpad(EmpNum,5,'0'), V_PDate ,SCode);
					V_EstimatedLunchTime := EstimatedLunchTime(lpad(EmpNum,5,'0'), V_PDate ,SCode);
					EGo := OTime - LastPunch - (V_EstimatedLunchTime - V_AvailedLunchTime);
					If EGo < 1 then
						EGo := 0;
					End If;
				End If; 
		End if;
		Return EGo;
END;
/
---------------------------
--Changed FUNCTION
--DELTAHRS1
---------------------------
CREATE OR REPLACE FUNCTION "SELFSERVICE"."DELTAHRS1" (p_EmpNo IN Varchar2, 
									 p_PDate IN Date, p_ShiftCode In Varchar2,
									 v_PLevHrs IN Number ) RETURN Number IS
									 
		v_Count Number := 0;
		v_RetVal Number := 0;
		v_WrkHrs Number :=0;
		--v_PLevHrs Number :=0;
		v_EstHrs Number :=0;
		--v_ShiftCode Varchar2(3000):='';
		v_OTime Number := 0;
		v_ITime Number := 0;
		x number;
		v_isLeave Number;
BEGIN
		If Ltrim(rtrim(p_ShiftCode)) = 'OO' Or Ltrim(Rtrim(p_ShiftCode)) = 'HH' Then
				Return v_RetVal;
		End If;


		Select count(*) InTo v_Count from ss_depu where bdate <= p_PDate
			and edate >= p_PDate and EmpNo = p_EmpNo And HOD_Apprl = 1 And HRD_Apprl=1;

		Select Count(*) InTo v_isLeave From SS_LeaveLedg Where EmpNo= Ltrim(Rtrim(p_EmpNo))
			and BDate <= p_PDate and Nvl(EDate,BDate) >= p_PDate And HD_Date is Null 
			and (Adj_Type = 'LA' Or Adj_Type='LC');

		If v_Count > 0 Or v_isLeave > 0 Then
				v_RetVal := 0;
		Else
				Select 
						GetShiftInTime(p_EmpNo,p_PDate,p_ShiftCode),
						GetShiftOutTime(p_EmpNo,p_PDate,p_ShiftCode)
					InTo 
						v_ITime, 
						v_OTime
					From SS_ShiftMast 
					Where ShiftCode = Trim(p_ShiftCode); 

				Select 	EstimatedLunchTime1(p_EmpNo,p_PDate,p_ShiftCode),
								WorkedHrs3(lpad(trim(p_EmpNo),5,'0'), p_PDate,p_ShiftCode) 
					InTo v_EstHrs,v_WrkHrs From Dual;
				Select Count(*) InTo v_Count From SS_IntegratedPunch 
						Where EmpNo = Trim(p_EmpNo) 
						And PDate = p_PDate;
				If v_Count > 0 Then
						v_EstHrs := v_OTime - v_ITime - v_EstHrs;
				Else
						v_EstHrs := 0;
				End If;
				v_RetVal := v_WrkHrs + (v_PLevHrs * 60) - v_EstHrs;
				--dbms_output.put_line('WrkHrs :- ' || v_WrkHrs);
				--dbms_output.put_line('PLevhr :- ' || v_PLevHrs);
				--dbms_output.put_line('EstHrs :- ' || v_EstHrs);
		End If;
		Return v_RetVal;
END;
/
---------------------------
--Changed FUNCTION
--DELTAHRS
---------------------------
CREATE OR REPLACE FUNCTION "SELFSERVICE"."DELTAHRS" (p_EmpNo IN Varchar2, p_PDate IN Date, p_ShiftCode In Varchar2) RETURN Number IS
		v_Count Number := 0;
		v_RetVal Number := 0;
		v_WrkHrs Number :=0;
		v_PLevHrs Number :=0;
		v_EstHrs Number :=0;
		--v_ShiftCode Varchar2(3000):='';
		v_ITimeHH Number := 0; 
		v_ITimeMn Number := 0;
		v_OTimeHH Number := 0;
		v_OTimeMn Number := 0;
		v_ITime Number := 0;
		x number;
BEGIN
		If Get_Holiday(p_PDate) = 0 Then
				v_ITime:=0;
				Select TimeIn_HH,TimeIn_Mn,TimeOut_HH,TimeOut_Mn InTo v_ITimeHH, v_ITimeMn, v_OTimeHH, v_OTimeMn
						From SS_ShiftMast Where ShiftCode = Trim(p_ShiftCode); 

				v_ITime := v_ITimeHH * 60 + v_ITimeMn ;
				Select 	EstimatedLunchTime(p_EmpNo,p_PDate,p_ShiftCode),
								WorkedHrs2(lpad(trim(p_EmpNo),5,'0'), p_PDate,p_ShiftCode),
								PenaltyLeave(p_EmpNo, p_PDate)
					InTo v_EstHrs,v_WrkHrs,v_PLevHrs From Dual;
				Select Count(*) InTo v_Count From SS_IntegratedPunch 
						Where EmpNo = Trim(p_EmpNo) 
						And PDate = p_PDate;
				If v_Count > 0 Then
						v_EstHrs := ((v_OTimeHH*60) + v_OTimeMn) - ((v_ITimeHH * 60) + v_ITimeMn) - v_EstHrs;
				Else
						v_EstHrs := 0;
				End If;
				v_RetVal := v_WrkHrs + (v_PLevHrs * 60) - v_EstHrs;
		End If;
		--dbms_output.put_line('WrkHrs :- ' || v_WrkHrs);
		--dbms_output.put_line('PLevhr :- ' || v_PLevHrs);
		--dbms_output.put_line('EstHrs :- ' || v_EstHrs); 
		Return v_RetVal;
END;
/
---------------------------
--Changed FUNCTION
--CFWDOTDELTAHRS
---------------------------
CREATE OR REPLACE FUNCTION "SELFSERVICE"."CFWDOTDELTAHRS" (p_EmpNo IN Varchar2, p_PDate IN Date) RETURN Number IS

		Cursor C1 (c_EmpNo IN Varchar2, c_Date IN Date) Is
				Select c_EmpNo As EmpNo, Days, LateCome(c_EmpNo,To_Date(Days ||'-'||To_Char(c_Date,'mon-yyyy'))) AS LCome,
						To_Date(Days ||'-'||To_Char(c_Date,'mon-yyyy')) AS PDate, 
						GetShift1(c_EmpNo, To_Date(Days ||'-'||To_Char(c_Date,'mon-yyyy'))) AS SCode,
						Get_Holiday(To_Date(Days ||'-'||To_Char(c_Date,'mon-yyyy'))) As isSunday,
						EarlyGo1(c_EmpNo,To_Date(Days ||'-'||To_Char(c_Date,'mon-yyyy'))) AS EGo,
						isLComeEGoApp(c_EmpNo,To_Date(Days ||'-'||To_Char(c_Date,'mon-yyyy'))) AS LC_App,
						isSLeaveApp(c_EmpNo,To_Date(Days ||'-'||To_Char(c_Date,'mon-yyyy'))) AS SL_App,
						--isLastDayOfMonth(To_Date(Days ||'-'||To_Char(c_Date,'mon-yyyy'))) AS isLDM,
						isLastWorkDay1(c_EmpNo, To_Date(Days ||'-'||To_Char(c_Date,'mon-yyyy'))) AS isLWD
				From SS_Days, SS_Muster 
				Where EmpNo = c_EmpNo 
				And MnTh = To_Char(c_Date,'yyyymm')
				And Days <= To_Number(To_Char(Last_Day(c_Date),'dd'))
				And To_Number(MnTh) >= 200201
				Order by Days;

		LC_AppCntr Number := 0;
		SL_AppCntr Number := 0;
		v_OpenLC_Cntr Number := 0;
		v_OpenMM Number :=0;
		v_SDate Date;
		v_Count Number :=0;
		v_DHrs Number :=0;
		v_SumDHrs Number :=0;
		v_SumOTDHrs Number :=0;
		v_CFwdHrs Number :=0;
		v_RetVal Number := 0;

BEGIN
		If To_Number(To_Char(p_PDate,'dd')) = 1 And p_PDate > To_Date('1-jan-2002') Then
				Select Count(*) InTo v_Count From SS_DeltaHrsBal Where PDate < p_PDate And EmpNo = Trim(p_EmpNo) ;
				If v_Count = 0 Then
						v_SDate := To_Date('30-nov-2001');
				Else
						Select PDate, MM, LC_AppCntr, OT_MM InTo v_SDate, v_OpenMM, v_OpenLC_Cntr, v_SumOTDHrs From SS_DeltaHrsBal 
							Where PDate < p_PDate 
							And EmpNo = Trim(p_EmpNo)
							And PDate = (Select Max(PDate) From SS_DeltaHrsBal Where PDate < p_PDate And EmpNo = Trim(p_EmpNo) Group By EmpNo);
				End If;
				v_SDate := v_SDate + 1;
				If v_SDate <> p_PDate Then
						For C2 IN C1(p_EmpNo,v_SDate) Loop
								LC_AppCntr := LC_AppCntr + C2.LC_App;
								SL_AppCntr := SL_AppCntr + C2.SL_App;
								Select DeltaHrs1(C2.EmpNo,C2.PDate,C2.SCode,PenaltyLeave1(C2.LCome,C2.EGo,C2.isLWD,LC_AppCntr,SL_AppCntr,C2.LC_App,C2.SL_App)) InTo v_DHrs From Dual;
								If v_DHrs >= 30 Then
										v_SumOTDHrs := v_SumOTDHrs + v_DHrs;
								End If;
								If C2.isSunday = 2 Then
										v_SumOTDHrs := 0;
										LC_AppCntr := 0;
								End If;
						End Loop;
						v_RetVal := v_SumOTDHrs;
						LC_AppCntr := 0;
				Else
						v_RetVal := v_OpenMM;
				End If;
		End If;
		Return nvl(v_RetVal,0);
END
;
/
---------------------------
--Changed FUNCTION
--CFWDDELTAHRSTEST1
---------------------------
CREATE OR REPLACE FUNCTION "SELFSERVICE"."CFWDDELTAHRSTEST1" (p_EmpNo IN Varchar2, p_PDate IN Date) RETURN Number IS
  
		Cursor C1 (c_EmpNo IN Varchar2, c_Date IN Date) Is
				Select c_EmpNo As EmpNo, Days, LateCome1(c_EmpNo,To_Date(Days ||'-'||To_Char(c_Date,'mon-yyyy'))) AS LCome,
						To_Date(Days ||'-'||To_Char(c_Date,'mon-yyyy')) AS PDate, 
						GetShift1(c_EmpNo, To_Date(Days ||'-'||To_Char(c_Date,'mon-yyyy'))) AS SCode,
						Get_Holiday(To_Date(Days ||'-'||To_Char(c_Date,'mon-yyyy'))) As isSunday,
						EarlyGo1(c_EmpNo,To_Date(Days ||'-'||To_Char(c_Date,'mon-yyyy'))) AS EGo,
						isLComeEGoApp(c_EmpNo,To_Date(Days ||'-'||To_Char(c_Date,'mon-yyyy'))) AS LC_App,
						isSLeaveApp(c_EmpNo,To_Date(Days ||'-'||To_Char(c_Date,'mon-yyyy'))) AS SL_App,
						--isLastDayOfMonth(To_Date(Days ||'-'||To_Char(c_Date,'mon-yyyy'))) AS isLDM,
						isLastWorkDay1(c_EmpNo, To_Date(Days ||'-'||To_Char(c_Date,'mon-yyyy'))) AS isLWD
				From SS_Days, SS_Muster 
				Where EmpNo = c_EmpNo 
				And MnTh = To_Char(c_Date,'yyyymm')
				And Days <= To_Number(To_Char(Last_Day(c_Date),'dd'))
				Order by Days;

		LC_AppCntr Number := 0;
		SL_AppCntr Number := 0;
		v_OpenLC_Cntr Number := 0;
		v_OpenMM Number :=0;
		v_SDate Date;
		v_Count Number :=0;
		v_DHrs Number :=0;
		v_SumDHrs Number :=0;
		v_CFwdHrs Number :=0;
		v_RetVal Number := 0;

BEGIN
		If To_Number(To_Char(p_PDate,'dd')) = 1 Then
				Select Count(*) InTo v_Count From SS_DeltaHrsBal Where PDate < p_PDate And EmpNo = Trim(p_EmpNo);
				If v_Count = 0 Then
						v_SDate := To_Date('30-nov-2001');
				Else
						Select PDate, MM, LC_AppCntr InTo v_SDate, v_OpenMM, v_OpenLC_Cntr From SS_DeltaHrsBal 
							Where PDate < p_PDate 
							And EmpNo = Trim(p_EmpNo)
							And PDate = (Select Max(PDate) From SS_DeltaHrsBal Where PDate < p_PDate And EmpNo = Trim(p_EmpNo) Group By EmpNo);
				End If;
				v_SDate := v_SDate + 1;
				If v_SDate <> p_PDate Then
						For C2 IN C1(p_EmpNo,v_SDate) Loop
								LC_AppCntr := LC_AppCntr + C2.LC_App;
								SL_AppCntr := SL_AppCntr + C2.SL_App;
								Select DeltaHrs1(C2.EmpNo,C2.PDate,C2.SCode,PenaltyLeave1(C2.LCome,C2.EGo,C2.isLWD,LC_AppCntr,SL_AppCntr,C2.LC_App,C2.SL_App)) InTo v_DHrs From Dual;
								v_SumDHrs := v_SumDHrs + v_DHrs;
								If C2.isLWD = 1 And C2.PDate <> Last_Day(v_SDate) Then
										Select CFwd_DHRs_Week(LastDay_CFwd_DHrs1(v_DHrs, C2.EGo, C2.SL_App, SL_AppCntr, C2.isLWD), C2.isLWD, v_SumDHRs) InTo v_CFwdHrs From Dual;
										Select Least(Greatest(v_SumDHrs,v_CFwdHrs),0) InTo v_SumDHrs From Dual;
								End If;
								/*If C2.isLDM = 1 And C2.isLWD = 0 Then
										Null;
								End If;*/
								If C2.isSunday = 2 Then
										LC_AppCntr := 0;
								End If;
						End Loop;
						v_RetVal := v_SumDHrs;
						LC_AppCntr := 0;
				Else
						v_RetVal := v_OpenMM;
				End If;
				Return v_RetVal;
		End If;
END
;
/
---------------------------
--Changed FUNCTION
--CFWDDELTAHRSTEST
---------------------------
CREATE OR REPLACE FUNCTION "SELFSERVICE"."CFWDDELTAHRSTEST" (p_EmpNo IN Varchar2, p_PDate IN Date) RETURN Number IS
 
		Cursor C1 (c_EmpNo IN Varchar2, c_Date IN Date) Is
				Select c_EmpNo As EmpNo, Days, LateCome(c_EmpNo,To_Date(Days ||'-'||To_Char(c_Date,'mon-yyyy'))) AS LCome,
						To_Date(Days ||'-'||To_Char(c_Date,'mon-yyyy')) AS PDate, 
						SubStr(s_mrk,((days-1) * 2)+1,2) AS SCode,
						Get_Holiday(To_Date(Days ||'-'||To_Char(c_Date,'mon-yyyy'))) As isSunday,
						EarlyGo(c_EmpNo,To_Date(Days ||'-'||To_Char(c_Date,'mon-yyyy'))) AS EGo,
						isLComeEGoApp(c_EmpNo,To_Date(Days ||'-'||To_Char(c_Date,'mon-yyyy'))) AS LC_App,
						isSLeaveApp(c_EmpNo,To_Date(Days ||'-'||To_Char(c_Date,'mon-yyyy'))) AS SL_App,
						--isLastDayOfMonth(To_Date(Days ||'-'||To_Char(c_Date,'mon-yyyy'))) AS isLDM,
						isLastWorkDay(To_Date(Days ||'-'||To_Char(c_Date,'mon-yyyy'))) AS isLWD
				From SS_Days, SS_Muster 
				Where EmpNo = c_EmpNo 
				And MnTh = To_Char(c_Date,'yyyymm')
				And Days <= To_Number(To_Char(Last_Day(c_Date),'dd'))
				Order by Days;

		LC_AppCntr Number := 0;
		SL_AppCntr Number := 0;
		v_OpenLC_Cntr Number := 0;
		v_OpenMM Number :=0;
		v_SDate Date;
		v_Count Number :=0;
		v_DHrs Number :=0;
		v_SumDHrs Number :=0;
		v_CFwdHrs Number :=0;
		v_RetVal Number := 0;
BEGIN
		If To_Number(To_Char(p_PDate,'dd')) = 1 Then
				Select Count(*) InTo v_Count From SS_DeltaHrsBal Where PDate < p_PDate And EmpNo = Trim(p_EmpNo);
				If v_Count = 0 Then
						v_SDate := To_Date('01-dec-2001');
				Else
						Select PDate, MM, LC_AppCntr InTo v_SDate, v_OpenMM, v_OpenLC_Cntr From SS_DeltaHrsBal 
							Where PDate < p_PDate 
							And EmpNo = Trim(p_EmpNo)
							And PDate = (Select Max(PDate) From SS_DeltaHrsBal Where PDate < p_PDate And EmpNo = Trim(p_EmpNo) Group By EmpNo);
				End If;
				v_SDate := v_SDate + 1;
				If v_SDate <> p_PDate Then
						For C2 IN C1(p_EmpNo,v_SDate) Loop
								LC_AppCntr := LC_AppCntr + C2.LC_App;
								SL_AppCntr := SL_AppCntr + C2.SL_App;
								Select DeltaHrs1(C2.EmpNo,C2.PDate,C2.SCode,PenaltyLeave1(C2.LCome,C2.EGo,C2.isLWD,LC_AppCntr,SL_AppCntr,C2.LC_App,C2.SL_App)) InTo v_DHrs From Dual;
								v_SumDHrs := v_SumDHrs + v_DHrs;
								If C2.isLWD = 1 Then
										Select LastDay_CFwd_DHrs1(v_DHrs, C2.EGo, C2.SL_App, SL_AppCntr, C2.isLWD) InTo v_CFwdHrs From Dual;
										Select Least(Greatest(v_SumDHrs,v_CFwdHrs),0) InTo v_SumDHrs From Dual;
								End If;
								/*If C2.isLDM = 1 And C2.isLWD = 0 Then
										Null;
								End If;*/
								If C2.isSunday = 2 Then
										LC_AppCntr := 0;
								End If;
						End Loop;
						v_RetVal := v_SumDHrs;
						LC_AppCntr := 0;
				End If;
				Return v_RetVal;
		End If;
END
;
/
---------------------------
--Changed FUNCTION
--AVAILEDLUNCHTIME1_COPY
---------------------------
CREATE OR REPLACE FUNCTION "SELFSERVICE"."AVAILEDLUNCHTIME1_COPY" (
    p_empno   In        Varchar2,
    p_date    In        Date,
    p_scode   In        Varchar2
) Return Number Is

    Cursor c1 Is
    Select
        *
    From
        ss_integratedpunch
    Where
        empno = Ltrim(Rtrim(p_empno))
        And pdate      = p_date
        And falseflag  = 1
    Order By
        pdate,
        hhsort,
        mmsort,
        hh,
        mm;

    Type tab_hrs_rec Is Record (
        punch_hrs           Number
    );
    Type tab_hrs Is
        Table Of tab_hrs_rec Index By Binary_Integer;
    v_tab_hrs           tab_hrs;
    v_cntr              Number;
    v_parent            Char(4);
    v_lunch_start_hrs   Number;
    v_lunch_end_hrs     Number;
    v_first_punch       Number;
    v_last_punch        Number;
    v_lunch_dura        Number;
    v_next_punch        Number;
    v_act_lunch_hrs     Number;
Begin
    Select
        Count(*)
    Into v_cntr
    From
        ss_integratedpunch
    Where
        empno = p_empno
        And pdate = p_date;

    If isleavedeputour(
        p_date,
        p_empno
    ) > 0 Or v_cntr < 2 Then
        Return 0;
    End If;

    v_cntr   := 1;
    For c2 In c1 Loop
        v_tab_hrs(v_cntr).punch_hrs   := ( c2.hh * 60 ) + c2.mm;
    --V_tab_hrs(Cntr).TabMns := C2.MM;

        v_cntr                        := v_cntr + 1;
    End Loop;

    Select
        parent
    Into v_parent
    From
        ss_emplmast
    Where
        empno = Trim(p_empno);
  --if p_scode in ('XX', 'MM') Then

    If Trim(p_scode) In (
        'OO',
        'HH'
    ) Then
        v_lunch_start_hrs   := 720;
        v_lunch_end_hrs     := 840;
        v_lunch_dura        := 30;
    Else
        Select
            ( starthh * 60 ) + startmn,
            ( endhh * 60 ) + endmn
        Into
            v_lunch_start_hrs,
            v_lunch_end_hrs
        From
            ss_lunchmast
        Where
            shiftcode = Ltrim(Rtrim(p_scode))
            And parent = Ltrim(Rtrim(v_parent));

        Select
            Nvl(lunch_mn, 0)
        Into v_lunch_dura
        From
            ss_shiftmast
        Where
            shiftcode = p_scode;

    End If;

    v_cntr   := v_cntr - 1;
    If v_lunch_start_hrs >= v_tab_hrs(v_cntr).punch_hrs Or v_lunch_start_hrs <= v_tab_hrs(1).punch_hrs Then
        Return 0;
    End If;

    If v_cntr = 2 Then
        If v_tab_hrs(1).punch_hrs <= v_lunch_start_hrs And v_tab_hrs(2).punch_hrs >= ( v_lunch_start_hrs + v_lunch_dura ) Then
            Return v_lunch_dura;
      --elsif v_tab_hrs(1).Punch_hrs <= v_lunch_start_hrs AND v_tab_hrs(2).Punch_hrs <= (v_lunch_start_hrs + v_lunch_dura) THEN
      --return (v_lunch_start_hrs + v_lunch_dura) - v_tab_hrs(2).Punch_hrs;
        Elsif v_tab_hrs(1).punch_hrs <= v_lunch_start_hrs And v_tab_hrs(2).punch_hrs >= ( v_lunch_start_hrs ) Then
            If v_tab_hrs(2).punch_hrs - ( v_lunch_start_hrs ) < v_lunch_dura Then
                v_lunch_dura := v_tab_hrs(2).punch_hrs - ( v_lunch_start_hrs );
            End If;
        End If;
    End If;

    If v_tab_hrs(1).punch_hrs >= v_lunch_start_hrs And v_tab_hrs(1).punch_hrs <= v_lunch_end_hrs Then
        If v_tab_hrs(1).punch_hrs - v_lunch_start_hrs < v_lunch_dura Then
            Return v_tab_hrs(1).punch_hrs - v_lunch_start_hrs;
        End If;
    End If;

    --When last punch is between Lunch Start Time and Lunch Duration

    If v_tab_hrs(v_cntr).punch_hrs >= v_lunch_start_hrs And v_tab_hrs(v_cntr).punch_hrs <= v_lunch_end_hrs Then
        For i In 1..v_cntr Loop 
        --
            If i Mod 2 = 0 Then
                Continue;
            End If;
            If v_tab_hrs(i).punch_hrs > v_lunch_end_hrs Then
                Exit;
            End If;
            If v_tab_hrs(i).punch_hrs >= v_lunch_start_hrs Then
                v_act_lunch_hrs := Nvl(v_act_lunch_hrs, 0) + v_tab_hrs(i + 1).punch_hrs - v_tab_hrs(i).punch_hrs;
            Else
                If v_tab_hrs(i + 1).punch_hrs >= v_lunch_start_hrs Then
                    v_act_lunch_hrs := v_tab_hrs(i + 1).punch_hrs - v_lunch_start_hrs;
                End If;
            End If;

        End Loop;

        Return Least(v_act_lunch_hrs, v_lunch_dura);
        /*
        If v_tab_hrs(v_cntr).punch_hrs - v_lunch_start_hrs < v_lunch_dura Then
            Return v_tab_hrs(v_cntr).punch_hrs - v_lunch_start_hrs;
        End If;
        */
    End If;

    For i In 1..v_cntr Loop 
    --

     If i Mod 2 = 0 Then
        If i < v_cntr Then
            If v_tab_hrs(i).punch_hrs >= v_lunch_start_hrs And v_tab_hrs(i).punch_hrs <= v_lunch_end_hrs Then
                v_next_punch := Least(v_tab_hrs(i + 1).punch_hrs, v_lunch_end_hrs);
                If ( v_next_punch - v_tab_hrs(i).punch_hrs ) >= v_lunch_dura Then
                    Return 0;
                    Exit;
                Elsif ( v_next_punch - v_tab_hrs(i).punch_hrs ) > 0 And ( v_next_punch - v_tab_hrs(i).punch_hrs ) < v_lunch_dura Then
                    Return v_lunch_dura - ( v_next_punch - v_tab_hrs(i).punch_hrs );
                    Exit;
                End If;

            End If;

        End If;

    End If;
    End Loop;

    Return v_lunch_dura;
  --END ;
  -- v_RetVal   Number := 0;
  -- v_parent    Varchar2(4);
  -- vStartHH    Number := 0;
  -- vStartMN    Number := 0;
  -- vEndHH     Number := 0;
  -- vEndMN     Number := 0;
  -- v_first_punch  Number := 0;
  -- v_last_punch   Number := 0;
  --BEGIN
  --
  -- v_first_punch := FirstLastPunch1(I_EmpNo,I_PDate,0);
  -- v_last_punch := FirstLastPunch1(I_EmpNo,I_PDate,1);
  --
  /*Select FirstLastPunch1(I_EmpNo,I_PDate,0), FirstLastPunch1(I_EmpNo,I_PDate,1)
  InTo v_first_punch, v_last_punch
  From Dual;*/
  /*If I_PDate <= To_Date('27-Jul-2003') Then*/
  --   If Ltrim(Rtrim(I_SCode)) = 'OO' Or Ltrim(Rtrim(I_SCode)) = 'HH' Then
  --     If v_first_punch < 720 And v_last_punch > 820 Then
  --       v_RetVal := 30;
  --     End If;
  --     Return v_RetVal;
  --   End If;
  --   Select Assign InTo v_parent From SS_EmplMast Where EmpNo = Ltrim(RTrim(I_EmpNo));
  --   Select StartHH, StartMN, EndHH, EndMN
  --    InTo vStartHH, vStartMN, vEndHH, vEndMN
  --    From SS_LunchMast Where ShiftCode = Ltrim(RTrim(I_SCode)) And Parent = Ltrim(RTrim(v_parent));
  --   If v_first_punch >= (vEndHH * 60) + vEndMN Then
  --     Return 0;
  --   ElsIf v_last_punch <= (vStartHH * 60) + vStartMN Then
  --     Return 0;
  --   ElsIf v_first_punch <= (vStartHH * 60) + vStartMN And v_last_punch >= ((vEndHH * 60) + vEndMN) Then
  --     Return ((vEndHH * 60) + vEndMN) - ((vStartHH * 60) + vStartMN);
  --   ElsIf (v_first_punch > (vStartHH * 60) + vStartMN) And (v_first_punch < (vEndHH * 60) + vEndMN) And v_last_punch >= (vEndHH * 60) + vEndMN Then
  --     Return ((vEndHH * 60) + vEndMN) - v_first_punch;
  --   ElsIf (v_first_punch < (vStartHH * 60) + vStartMN) And (v_last_punch < (vEndHH * 60) + vEndMN) And v_last_punch >= (vStartHH * 60) + vStartMN Then
  --     Return v_last_punch - ((vStartHH * 60) + vStartMN);
  --   ElsIf (v_first_punch > (vStartHH * 60) + vStartMN) And (v_last_punch < (vEndHH * 60) + vEndMN) Then
  --     Return v_last_punch - v_first_punch;
  --   ElsIf NVL(LTrim(rTrim(v_first_punch)),0) = 0 Then
  --     Return 0;
  --   ElsIf IsLeaveDepuTour(I_PDate, I_EmpNo) > 0 Then
  --     Return 0;
  --   Else
  --     Return 30;
  --   End If;
  /*Else
  If I_SCode = 'OO' Or I_SCode = 'HH' Then
  vStartHH := 12;
  vStartMN := 0;
  vEndHH   := 13;
  vEndMN   := 40;
  Else
  Select Assign InTo v_parent From SS_EmplMast Where EmpNo = Ltrim(RTrim(I_EmpNo));
  Select StartHH, StartMN, EndHH, EndMN
  InTo vStartHH, vStartMN, vEndHH, vEndMN
  From SS_LunchMast Where ShiftCode = Ltrim(RTrim(I_SCode)) And Parent = Ltrim(RTrim(v_parent));
  End If;
  If v_first_punch >= (vEndHH * 60) + vEndMN Then
  Return 0;
  ElsIf v_last_punch <= (vStartHH * 60) + vStartMN Then
  Return 0;
  ElsIf v_first_punch <= (vStartHH * 60) + vStartMN And v_last_punch >= ((vEndHH * 60) + vEndMN) Then
  If I_SCode = 'OO' Or I_SCode = 'HH' Then
  v_RetVal := ((vEndHH * 60) + vEndMN) - ((vStartHH * 60) + vStartMN);
  Select Least(v_RetVal,30) InTo v_RetVal From Dual;
  Return v_RetVal;
  Else
  Return ((vEndHH * 60) + vEndMN) - ((vStartHH * 60) + vStartMN);
  End If;
  ElsIf (v_first_punch > (vStartHH * 60) + vStartMN) And (v_first_punch < (vEndHH * 60) + vEndMN) And v_last_punch >= (vEndHH * 60) + vEndMN Then
  If I_SCode = 'OO' Or I_SCode = 'HH' Then
  v_RetVal := ((vEndHH * 60) + vEndMN) - v_first_punch;
  Select Least(v_RetVal,30) InTo v_RetVal From Dual;
  Return v_RetVal;
  Else
  Return ((vEndHH * 60) + vEndMN) - v_first_punch;
  End If;
  ElsIf (v_first_punch < (vStartHH * 60) + vStartMN) And (v_last_punch < (vEndHH * 60) + vEndMN) And v_last_punch >= (vStartHH * 60) + vStartMN Then
  If I_SCode = 'OO' Or I_SCode = 'HH' Then
  v_RetVal := v_last_punch - ((vStartHH * 60) + vStartMN);
  Select Least(v_RetVal,30) InTo v_RetVal From Dual;
  Return v_RetVal;
  Else
  Return v_last_punch - ((vStartHH * 60) + vStartMN);
  End If;
  ElsIf (v_first_punch > (vStartHH * 60) + vStartMN) And (v_last_punch < (vEndHH * 60) + vEndMN) Then
  If I_SCode = 'OO' Or I_SCode = 'HH' Then
  v_RetVal := v_last_punch - v_first_punch;
  Select Least(v_RetVal,30) InTo v_RetVal From Dual;
  Return v_RetVal;
  Else
  Return v_last_punch - v_first_punch;
  End If;
  ElsIf NVL(LTrim(rTrim(v_first_punch)),0) = 0 Then
  Return 0;
  ElsIf IsLeaveDepuTour(I_PDate, I_EmpNo) > 0 Then
  Return 0;
  Else
  Return 30;
  End If;
  End If;  */
Exception
    When Others Then
        Return 30;
End;
/
---------------------------
--Changed FUNCTION
--AVAILEDLUNCHTIME
---------------------------
CREATE OR REPLACE FUNCTION "SELFSERVICE"."AVAILEDLUNCHTIME" (I_EmpNo IN Varchar2, I_PDate IN Date, I_SCode IN Varchar2) Return Number IS 
	v_RetVal			Number := 0;
	vParent 			Varchar2(4);
	vStartHH 			Number := 0;
	vStartMN 			Number := 0;
	vEndHH 				Number := 0;
	vEndMN 				Number := 0;
	vFirstPunch 	Number := 0;
	vLastPunch 		Number := 0;
	vIsHoliday		Number := 0;
BEGIN
  v_RetVal := AVAILEDLUNCHTIME1(i_empno,i_pdate,i_scode);
  return v_retval;
/*
	If I_SCode = 'OO' Or I_SCode = 'HH' Then
			Return 0;
	End If;
	Select Assign InTo vParent From SS_EmplMast Where EmpNo = Trim(I_EmpNo);

	Select Get_HOliday(I_PDate), FirstLastPunch1(I_EmpNo,I_PDate,0), FirstLastPunch1(I_EmpNo,I_PDate,1), StartHH, StartMN, EndHH, EndMN 
		InTo vIsHoliday, vFirstPunch, vLastPunch, vStartHH, vStartMN, vEndHH, vEndMN 
		From SS_LunchMast Where ShiftCode = Trim(I_SCode) And Parent = Trim(vParent);

	If vFirstPunch >= (vEndHH * 60) + vEndMN And vIsHoliday = 0 Then
			Return 0;
	ElsIf vLastPunch <= (vStartHH * 60) + vStartMN And vIsHoliday = 0 Then
			Return 0;
	ElsIf vFirstPunch <= (vStartHH * 60) + vStartMN And vIsHoliday = 0 And vLastPunch >= ((vEndHH * 60) + vEndMN) Then
			Return ((vEndHH * 60) + vEndMN) - ((vStartHH * 60) + vStartMN);
	ElsIf (vFirstPunch > (vStartHH * 60) + vStartMN) And (vFirstPunch < (vEndHH * 60) + vEndMN) And vIsHoliday = 0 Then
			Return ((vEndHH * 60) + vEndMN) - vFirstPunch;
	ElsIf NVL(Trim(vFirstPunch),0) = 0 And vIsHoliday = 0 Then
			Return 0;
	ElsIf vIsHoliday > 0 Or IsLeaveDepuTour(I_PDate, I_EmpNo) > 0 Then
			Return 0;
	Else
			Return 30;
	End If;

Exception
	When Others Then
		Return 30;
    */
END;
/
