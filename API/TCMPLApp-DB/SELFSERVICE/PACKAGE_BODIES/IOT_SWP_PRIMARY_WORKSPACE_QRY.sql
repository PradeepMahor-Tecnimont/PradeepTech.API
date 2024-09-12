Create Or Replace Package Body selfservice.iot_swp_primary_workspace_qry As

    Function fn_emp_pws_list(
        p_person_id             Varchar2,
        p_meta_id               Varchar2,

        p_assign_code           Varchar2 Default Null,
        p_assign_csv            Varchar2 Default Null,
        p_start_date            Date     Default Null,

        p_empno                 Varchar2 Default Null,

        p_emptype_csv           Varchar2 Default Null,
        p_grade_csv             Varchar2 Default Null,
        p_primary_workspace_csv Varchar2 Default Null,
        p_laptop_user           Varchar2 Default Null,
        p_eligible_for_swp      Varchar2 Default Null,
        p_generic_search        Varchar2 Default Null,

        p_is_admin_call         Boolean  Default false,

        p_is_excel_request      Boolean  Default false,

        p_row_number            Number,
        p_page_length           Number
    ) Return Sys_Refcursor As
        c                          Sys_Refcursor;

        v_hod_sec_empno            Varchar2(5);
        e_employee_not_found       Exception;
        Pragma exception_init(e_employee_not_found, -20001);
        v_friday_date              Date;
        v_hod_sec_assign_code      Varchar2(4);
        v_query                    Varchar2(8000);
        v_hod_sec_assign_codes_csv Varchar2(1000);
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

            If nvl(p_is_excel_request, false) = false And (p_empno Is Null Or p_assign_code Is Not Null) Then
                v_hod_sec_assign_code := iot_swp_common.get_default_costcode_hod_sec(
                                             p_hod_sec_empno => v_hod_sec_empno,
                                             p_assign_code   => p_assign_code
                                         );
                If v_hod_sec_assign_code Is Null Then
                    Return Null;
                End If;
            End If;
        End If;

        v_query         := regexp_replace(query_pws, '[[:space:]]+', chr(32));

        If v_hod_sec_assign_code Is Not Null Then
            v_query := replace(v_query, '!ASSIGN_WHERE_CLAUSE!', sub_qry_assign_where_clause);
        Else
            v_hod_sec_assign_codes_csv := iot_swp_common.get_hod_sec_costcodes_csv(
                                              p_hod_sec_empno    => v_hod_sec_empno,
                                              p_assign_codes_csv => p_assign_csv
                                          );
            v_query                    := replace(v_query, '!ASSIGN_WHERE_CLAUSE!', '');
        End If;

        If nvl(p_is_excel_request, false) Then
            v_query := replace(v_query, '!ASSIGN_SUB_QUERY!', sub_qry_assign_csv);
        Else
            v_query := replace(v_query, '!ASSIGN_SUB_QUERY!', '');
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
            :p_empno           As p_empno,
            :p_assign_code     As p_assign_code,
            :p_assign_csv      As p_assign_csv,
            :p_pws_csv         As p_pws_csv,
            :p_grades_csv      As p_grades_csv,
            :p_emptype_csv     As p_emptype_csv,
            :p_swp_eligibility As p_swp_eligibility,
            :p_laptop_user     As p_laptop_user,
            :p_generic_search  As p_generic_search
        */
        Open c For v_query Using
            v_friday_date,
            p_row_number,
            p_page_length,
            p_empno,
            v_hod_sec_assign_code,
            v_hod_sec_assign_codes_csv,
            p_primary_workspace_csv,
            p_grade_csv,
            p_emptype_csv,
            p_eligible_for_swp,
            p_laptop_user,
            '%' || upper(trim(p_generic_search)) || '%';

        Return c;

    End;

    Function fn_emp_pws_plan_list(
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
        Return fn_emp_pws_list(
                p_person_id             => p_person_id,
                p_meta_id               => p_meta_id,

                p_assign_code           => p_assign_code,

                p_assign_csv            => Null,

                p_start_date            => v_plan_friday_date,

                p_empno                 => p_empno,

                p_emptype_csv           => p_emptype_csv,
                p_grade_csv             => p_grade_csv,
                p_primary_workspace_csv => p_primary_workspace_csv,
                p_laptop_user           => p_laptop_user,
                p_eligible_for_swp      => p_eligible_for_swp,
                p_generic_search        => p_generic_search,

                p_is_admin_call         => false,

                p_is_excel_request      => false,

                p_row_number            => p_row_number,
                p_page_length           => p_page_length
            );

    End fn_emp_pws_plan_list;

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

        Return fn_emp_pws_list(
                p_person_id             => p_person_id,
                p_meta_id               => p_meta_id,

                p_assign_code           => Null,

                p_assign_csv            => v_hod_sec_assign_codes_csv,

                p_start_date            => v_friday_date,

                p_empno                 => Null,

                p_emptype_csv           => Null,
                p_grade_csv             => Null,
                p_primary_workspace_csv => Null,
                p_laptop_user           => Null,
                p_eligible_for_swp      => Null,
                p_generic_search        => Null,

                p_is_admin_call         => false,
                p_is_excel_request      => true,

                p_row_number            => 0,
                p_page_length           => 10000
            );

        Return c;

    End fn_emp_pws_excel;

    Function fn_emp_pws_plan_excel(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_assign_codes_csv Varchar2 Default Null

    ) Return Sys_Refcursor As
        v_plan_friday_date         Date;
        rec_config_week            swp_config_weeks%rowtype;
        c                          Sys_Refcursor;
        v_hod_sec_empno            Varchar2(5);
        e_employee_not_found       Exception;
        Pragma exception_init(e_employee_not_found, -20001);
        v_hod_sec_assign_codes_csv Varchar2(4000);
    Begin

        v_hod_sec_empno            := get_empno_from_meta_id(p_meta_id);

        If v_hod_sec_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;

        Select
            *
        Into
            rec_config_week
        From
            swp_config_weeks
        Where
            planning_flag = 2;
        v_plan_friday_date         := rec_config_week.end_date;

        v_hod_sec_assign_codes_csv := iot_swp_common.get_hod_sec_costcodes_csv(
                                          p_hod_sec_empno    => v_hod_sec_empno,
                                          p_assign_codes_csv => p_assign_codes_csv
                                      );

        Return fn_emp_pws_list(
                p_person_id             => p_person_id,
                p_meta_id               => p_meta_id,

                p_assign_code           => Null,

                p_assign_csv            => v_hod_sec_assign_codes_csv,

                p_start_date            => v_plan_friday_date,

                p_empno                 => Null,

                p_emptype_csv           => Null,
                p_grade_csv             => Null,
                p_primary_workspace_csv => Null,
                p_laptop_user           => Null,
                p_eligible_for_swp      => Null,
                p_generic_search        => Null,

                p_is_admin_call         => false,
                p_is_excel_request      => true,

                p_row_number            => 0,
                p_page_length           => 10000
            );

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
        p_assign_csv            Varchar2 Default Null,
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
        Return fn_emp_pws_list(
                p_person_id             => p_person_id,
                p_meta_id               => p_meta_id,

                p_assign_code           => p_assign_code,
                p_assign_csv            => p_assign_csv,

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

    Function fn_emp_pws_hist_admin_list(
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
                        --And a.start_date <= p_curr_start_date
                        And a.start_date <= sysdate
                        And a.empno = p_empno
                    Order By a.start_date Desc
                )
            Where
                row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length)
            Order By
                date_forsort Desc;

        Return c;
    End;

    Function fn_emp_pws_hist_list(
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
                        swp_primary_workspace       a,
                        swp_primary_workspace_types b
                    Where
                        b.type_code = a.primary_workspace
                        And a.start_date <= nvl(p_plan_end_date, sysdate)
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