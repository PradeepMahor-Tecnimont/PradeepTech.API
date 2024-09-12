--------------------------------------------------------
--  File created - Thursday-May-26-2022   
--------------------------------------------------------
---------------------------
--Changed PROCEDURE
--SEND_MAIL_FROM_API
---------------------------
CREATE OR REPLACE PROCEDURE "SELFSERVICE"."SEND_MAIL_FROM_API" (
    p_mail_to      Varchar2,
    p_mail_cc      Varchar2,
    p_mail_bcc     Varchar2,
    p_mail_subject Varchar2,
    p_mail_body    Varchar2,
    p_mail_profile Varchar2,
    p_mail_format  Varchar2 Default Null,
    p_success Out  Varchar2,
    p_message Out  Varchar2
) As
    v_mail_profile Varchar2(20);
    v_mail_format  Varchar2(20);
Begin
    return;
    If Trim(p_mail_profile) Is Null Then
        v_mail_profile := 'SELFSERVICE';
    Else
        v_mail_profile := p_mail_profile;
    End If;

    If Trim(p_mail_format) Is Null Then
        v_mail_format := 'Text';
    Else
        v_mail_format := p_mail_format;
    End If;

    tcmpl_app_config.pkg_app_mail_queue.sp_add_to_queue(
        p_person_id    => Null,
        p_meta_id      => Null,
        p_mail_to      => p_mail_to,
        p_mail_cc      => p_mail_cc,
        p_mail_bcc     => p_mail_bcc,
        p_mail_subject => p_mail_subject,
        p_mail_body1   => p_mail_body,
        p_mail_body2   => Null,
        p_mail_type    => v_mail_format,
        p_mail_from    => 'OFF-Boarding',
        p_message_type => p_success,
        p_message_text => p_message
    );

    Return;

    commonmasters.pkg_mail.send_api_mail(
        p_mail_to      => p_mail_to,
        p_mail_cc      => p_mail_cc,
        p_mail_bcc     => p_mail_bcc,
        p_mail_subject => p_mail_subject,
        p_mail_body    => p_mail_body,
        p_mail_profile => v_mail_profile,
        p_mail_format  => v_mail_format,
        p_success      => p_success,
        p_message      => p_message
    );
    /*
    Example

    send_mail_from_api (
        p_mail_to        => 'abc.yahoo.com, def.yahoo.com, ghy123.hotmail.com',
        p_mail_cc        => 'abc.yahoo.com, def.yahoo.com, ghy123.hotmail.com',
        p_mail_bcc       => p_mail_bcc,
        p_mail_subject   => 'This is a Subject of Sample mail',
        p_mail_body      => 'This is Body of Sample mail',
        p_mail_profile   => 'TIMESHEET',   (example --> SQSI, OSD, ALHR, etc...)
        p_success        => p_success,
        p_message        => p_message
    );

    */

End send_mail_from_api;
/
---------------------------
--Changed PACKAGE
--IOT_SWP_PRIMARY_WORKSPACE_QRY
---------------------------
CREATE OR REPLACE PACKAGE "SELFSERVICE"."IOT_SWP_PRIMARY_WORKSPACE_QRY" As

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
    ) Return Sys_Refcursor;

    --**--
    /*
    Function fn_emp_primary_ws_list(
        p_person_id   Varchar2,
        p_meta_id     Varchar2,

        p_assign_code Varchar2 Default Null,
        p_start_date  Date     Default Null,

        p_empno       Varchar2 Default Null,

        p_row_number  Number,
        p_page_length Number
    ) Return Sys_Refcursor;
    */

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
    ) Return Sys_Refcursor;

    Function fn_emp_pws_excel(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_assign_codes_csv Varchar2 Default Null,
        p_start_date       Date Default Null
    ) Return Sys_Refcursor;

    Function fn_emp_pws_plan_excel(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_assign_codes_csv Varchar2 Default Null
    ) Return Sys_Refcursor;

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
    ) Return Sys_Refcursor;

function fn_emp_primary_ws_admin_list(
      p_person_id      varchar2,
      p_meta_id        varchar2,

      p_Empno        varchar2,
      p_generic_search varchar2 default null,
      p_start_date     date     default null,

      p_row_number     number,
      p_page_length    number
   ) return sys_refcursor;

    query_pws Varchar2(4500) := '
With
    params As
    (
        Select
            :p_friday_date     As p_friday_date,
            :p_row_number      As p_row_number,
            :p_page_length     As p_page_length,
            :p_empno           As p_empno,
            :p_assign_code     As p_assign_code,
            :p_pws_csv         As p_pws_csv,
            :p_grades_csv      As p_grades_csv,
            :p_emptype_csv     As p_emptype_csv,
            :p_swp_eligibility As p_swp_eligibility,
            :p_laptop_user     As p_laptop_user,
            :p_generic_search  As p_generic_search
        From
            dual
    ),
    primary_work_space As(
        Select
            a.empno, a.primary_workspace, a.start_date
        From
            swp_primary_workspace a, params
        Where
            trunc(a.start_date) = (
                Select
                    Max(trunc(start_date))
                From
                    swp_primary_workspace b
                Where
                    b.empno = a.empno
                    And b.start_date <= params.p_friday_date
            )
    )
Select
   data.*
From
    (
        Select
            a.empno                                               As empno,
            a.name                                                As employee_name,
            a.assign,
            a.parent,
            iot_swp_common.fn_get_dept_group(a.assign)             As assign_dept_group,
            a.office,
            a.emptype,
            a.email                                               As email,

            iot_swp_common.get_desk_from_dms(a.empno)             As deskid,
            iot_swp_common.get_emp_work_area(Null, Null, a.empno) As work_area,
            iot_swp_common.is_emp_dualmonitor_user(a.empno)       As is_dual_monitor_user,
            iot_swp_common.is_emp_laptop_user(a.empno)            As is_laptop_user,
            Case iot_swp_common.is_emp_laptop_user(a.empno)
                When 1 Then
                    ''Yes''
                Else
                    ''No''
            End                                                   As is_laptop_user_text,
            a.grade                                               As emp_grade,
            nvl(b.primary_workspace, 0)                           As primary_workspace,
            iot_swp_common.fn_get_pws_text(b.primary_workspace) as primary_workspace_text,
            iot_swp_common.is_emp_eligible_for_swp(a.empno)       As is_swp_eligible,
            Case iot_swp_common.is_emp_eligible_for_swp(a.empno)
                When ''OK'' Then
                    ''Yes''
                Else
                    ''No''
            End                                                   As is_swp_eligible_desc,
            Row_Number() Over(Order By a.name)                    As row_number,
            Count(*) Over()                                       As total_row
        From
            ss_emplmast        a,
            primary_work_space b,
            swp_include_emptype c,
            params
        Where
            a.empno      = b.empno(+)
            !ASSIGN_WHERE_CLAUSE!
            And a.status = 1
            And a.empno  = nvl(params.p_empno, a.empno)
            And a.emptype = c.emptype

            And a.assign Not In (
                Select
                    assign
                From
                    swp_exclude_assign
            )
            !GENERIC_SEARCH!            
            And a.emptype In (
            !EMPTYPE_SUBQUERY!
            )
            !LAPTOP_USER_WHERE_CLAUSE!
            !SWP_ELIGIBLE_WHERE_CLAUSE!
            !GRADES_SUBQUERY!
            !PWS_TYPE_SUBQUERY!
        Order By a.assign, a.name
    ) data, params
Where
    row_number Between (nvl(params.p_row_number, 0) + 1) And (nvl(params.p_row_number, 0) + params.p_page_length)
 ';

    sub_qry_assign_where_clause Varchar2(70) := ' And a.assign = params.p_assign_code ';

    sub_qry_grades_csv Varchar2(400) := ' and a.grade in (
Select
    regexp_substr(params.p_grades_csv, ''[^,]+'', 1, level) grade
From
    dual
Connect By
    level <=
    length(params.p_grades_csv) - length(replace(params.p_grades_csv, '','')) + 1 )
';

    sub_qry_emptype_default Varchar2(200) := ' 
Select
    emptype
From
    swp_include_emptype
';

    sub_qry_emptype_csv Varchar2(400) := ' 
Select
    regexp_substr(params.p_emptype_csv, ''[^,]+'', 1, level) emptype
From
    dual
Connect By
    level <=
    length(params.p_emptype_csv) - length(replace(params.p_emptype_csv, '','')) + 1
';
    sub_qry_pws_csv Varchar2(500) := ' 
and
nvl(b.primary_workspace,0) in ( Select
    regexp_substr(params.p_pws_csv, ''[^,]+'', 1, level) emptype
From
    dual, params
Connect By
    level <=
    length(params.p_pws_csv) - length(replace(params.p_pws_csv, '','')) + 1)';

    where_clause_laptop_user Varchar2(200) := ' and iot_swp_common.is_emp_laptop_user(a.empno) = params.p_laptop_user ';

    where_clause_swp_eligible Varchar2(200) := ' and iot_swp_common.is_emp_eligible_for_swp(a.empno) = params.p_swp_eligibility ';

    where_clause_generic_search Varchar2(200) := ' and (a.name like params.p_generic_search or a.empno like params.p_generic_search ) ';

End iot_swp_primary_workspace_qry;
/
---------------------------
--Changed PACKAGE
--IOT_SWP_EMP_TO_OFFICE_QRY
---------------------------
CREATE OR REPLACE PACKAGE "SELFSERVICE"."IOT_SWP_EMP_TO_OFFICE_QRY" as

   function fn_Emp_Coming_To_Office_list(
      p_person_id      varchar2,
      p_meta_id        varchar2,

      p_generic_search varchar2 default null,
      p_start_date     date     default null,
      P_Activefuture   number   default null,
      
      p_row_number     number,
      p_page_length    number
   ) return sys_refcursor;

end IOT_SWP_EMP_TO_OFFICE_QRY;
/
---------------------------
--Changed PACKAGE
--IOT_SWP_PRIMARY_WORKSPACE
---------------------------
CREATE OR REPLACE PACKAGE "SELFSERVICE"."IOT_SWP_PRIMARY_WORKSPACE" As

    Type typ_tab_string Is Table Of Varchar(4000) Index By Binary_Integer;
    c_office_workspace constant number := 1;
    c_smart_workspace constant number := 2;
    c_not_in_mum_office constant number := 3;


    Procedure sp_add_office_ws_desk(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_deskid           Varchar2,
        p_empno            Varchar2,
        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    );

    Procedure sp_hod_assign_work_space(
        p_person_id           Varchar2,
        p_meta_id             Varchar2,

        p_emp_workspace_array typ_tab_string,
        p_message_type Out    Varchar2,
        p_message_text Out    Varchar2
    );

    Procedure sp_hr_assign_work_space(
        p_person_id           Varchar2,
        p_meta_id             Varchar2,

        p_emp_workspace_array typ_tab_string,
        p_message_type Out    Varchar2,
        p_message_text Out    Varchar2
    );

    Procedure sp_workspace_summary(
        p_person_id                      Varchar2,
        p_meta_id                        Varchar2,

        p_assign_code                    Varchar2 Default Null,
        p_start_date                     Date     Default Null,

        p_total_emp_count            Out Number,
        p_emp_count_office_workspace Out Number,
        p_emp_count_smart_workspace  Out Number,
        p_emp_count_not_in_ho        Out Number,

        p_emp_perc_office_workspace        Out Number,
        p_emp_perc_smart_workspace        Out Number,

        p_message_type               Out Varchar2,
        p_message_text               Out Varchar2
    );

    Procedure sp_workspace_plan_summary(
        p_person_id                      Varchar2,
        p_meta_id                        Varchar2,

        p_assign_code                    Varchar2 default null,

        p_total_emp_count            Out Number,
        p_emp_count_office_workspace Out Number,
        p_emp_count_smart_workspace  Out Number,
        p_emp_count_not_in_ho        Out Number,

        p_emp_perc_office_workspace       Out Number,
        p_emp_perc_smart_workspace        Out Number,

        p_message_type               Out Varchar2,
        p_message_text               Out Varchar2
    );


   procedure sp_admin_assign_work_space(
      p_person_id           varchar2,
      p_meta_id             varchar2,

      p_is_admin_call       number default 0,
      p_emp_workspace_array typ_tab_string,
      p_message_type out    varchar2,
      p_message_text out    varchar2
   );

   procedure sp_admin_delete_work_space(
      p_person_id        varchar2,
      p_meta_id          varchar2,

      p_application_id   varchar2,
      p_start_date       date,

      p_message_type out varchar2,
      p_message_text out varchar2
   );

End iot_swp_primary_workspace;
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
                       (select distinct d.PROJNO 
                           from swp_emp_proj_mapping d where d.empno = a.empno) as projno,
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


   function fn_emp_primary_ws_admin_list(
      p_person_id      varchar2,
      p_meta_id        varchar2,

	   p_Empno        varchar2,
      p_generic_search varchar2 default null,
      p_start_date     date     default null,

      p_row_number     number,
      p_page_length    number
   ) return sys_refcursor as
      P_PLAN_START_DATE    date;
      P_PLAN_END_DATE      date;
      P_CURR_START_DATE    date;
      P_CURR_END_DATE      date;
      P_PLANNING_EXISTS    varchar2(200);
      P_PWS_OPEN           varchar2(200);
      P_SWS_OPEN           varchar2(200);
      P_OWS_OPEN           varchar2(200);
      P_MESSAGE_TYPE       varchar2(200);
      P_MESSAGE_TEXT       varchar2(200);
      v_empno              varchar2(5);
      e_employee_not_found exception;
      pragma exception_init(e_employee_not_found, -20001);
      c                    sys_refcursor;
   begin
      v_empno := get_empno_from_meta_id(p_meta_id);
      if v_empno = 'ERRRR' then
         raise e_employee_not_found;
         return null;
      end if;
      IOT_SWP_COMMON.GET_PLANNING_WEEK_DETAILS(
         P_PERSON_ID       => P_PERSON_ID,
         P_META_ID         => P_META_ID,
         P_PLAN_START_DATE => P_PLAN_START_DATE,
         P_PLAN_END_DATE   => P_PLAN_END_DATE,
         P_CURR_START_DATE => P_CURR_START_DATE,
         P_CURR_END_DATE   => P_CURR_END_DATE,
         P_PLANNING_EXISTS => P_PLANNING_EXISTS,
         P_PWS_OPEN        => P_PWS_OPEN,
         P_SWS_OPEN        => P_SWS_OPEN,
         P_OWS_OPEN        => P_OWS_OPEN,
         P_MESSAGE_TYPE    => P_MESSAGE_TYPE,
         P_MESSAGE_TEXT    => P_MESSAGE_TEXT
      );
      if (P_MESSAGE_TYPE = 'KO') then
         return null;
      end if;
      open c for
           select * from (
		   select A.Key_Id as Key_id,
                          A.Empno as Empno,
                          get_emp_name(A.Empno) as Employee_Name,                         
                          to_char(A.Start_Date, 'dd-Mon-yyyy') as Start_Date,
                           A.Start_Date as date_ForSort,
                          A.PRIMARY_WORKSPACE as Primary_Workspace,
                          b.TYPE_DESC As Primary_Workspace_Text,
                           case
                             when A.MODIFIED_BY = 'Sys' then
                                'System'
                             else
                                A.MODIFIED_BY
                                || ' - '
                                || get_emp_name(A.MODIFIED_BY)
                          end as Modified_by,
                          to_char(A.MODIFIED_ON, 'dd-Mon-yyyy') as Modified_on_date ,
						  row_number() over (order by Empno desc) As row_number,
						  count(*) over () As total_row 
                     from Swp_Primary_Workspace A  ,SWP_PRIMARY_WORKSPACE_TYPES b 
                    where b.TYPE_CODE = a.PRIMARY_WORKSPACE
                      and A.Start_Date <=  P_CURR_START_DATE
                      and A.EMPNO = p_Empno
                    order by A.START_DATE                
                )         
          where row_number between (nvl(p_row_number, 0) + 1) and (nvl(p_row_number, 0) + p_page_length)
           order by date_ForSort ;

      return c;
   end;


   --End
End iot_swp_primary_workspace_qry;
/
---------------------------
--Changed PACKAGE BODY
--IOT_SWP_PRIMARY_WORKSPACE
---------------------------
CREATE OR REPLACE PACKAGE BODY "SELFSERVICE"."IOT_SWP_PRIMARY_WORKSPACE" As

    Procedure del_emp_future_planning(
        p_empno               Varchar2,
        p_planning_start_date Date
    ) As
        v_ows_desk_id Varchar2(10);
    Begin

        Delete
            From swp_smart_attendance_plan
        Where
            empno = Trim(p_empno)
            And attendance_date >= p_planning_start_date;

        Delete
            From swp_primary_workspace
        Where
            empno = Trim(p_empno)
            And start_date >= p_planning_start_date;

    End;

    Procedure sp_assign_work_space(
        p_person_id           Varchar2,
        p_meta_id             Varchar2,

        p_is_admin_call       Number Default 0,
        p_emp_workspace_array typ_tab_string,
        p_message_type Out    Varchar2,
        p_message_text Out    Varchar2
    ) As
        v_workspace_code      Number;
        v_mod_by_empno        Varchar2(5);
        v_count               Number;
        v_key                 Varchar2(10);
        v_empno               Varchar2(5);
        rec_config_week       swp_config_weeks%rowtype;
        c_planning_future     Constant Number(1) := 2;
        c_planning_current    Constant Number(1) := 1;
        c_planning_is_open    Constant Number(1) := 1;
        Type typ_tab_primary_workspace Is Table Of swp_primary_workspace%rowtype Index By Binary_Integer;
        tab_primary_workspace typ_tab_primary_workspace;
        v_ows_desk_id         Varchar2(10);
    Begin
        v_mod_by_empno := get_empno_from_meta_id(p_meta_id);
        If v_mod_by_empno = 'ERRRR' Then
            p_message_type := 'KO';
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        If nvl(p_is_admin_call, 0) != 1 Then
            Begin

                Select
                    *
                Into
                    rec_config_week
                From
                    swp_config_weeks
                Where
                    planning_flag = c_planning_future
                    And pws_open  = c_planning_is_open;
            Exception
                When Others Then
                    p_message_type := 'KO';
                    p_message_text := 'Err - SWP Planning is not open. Cannot proceed.';
                    Return;
            End;
        Elsif nvl(p_is_admin_call, 0) = 1 Then

            Begin

                Select
                    *
                Into
                    rec_config_week
                From
                    swp_config_weeks
                Where
                    planning_flag = c_planning_future;
            Exception
                When Others Then
                    p_message_type := 'KO';
                    p_message_text := 'Err - SWP Planning is not open. Cannot proceed.';
                    Return;
            End;

        End If;

        For i In 1..p_emp_workspace_array.count
        Loop

            With
                csv As (
                    Select
                        p_emp_workspace_array(i) str
                    From
                        dual
                )
            Select
                Trim(regexp_substr(str, '[^~!~]+', 1, 1)) empno,
                Trim(regexp_substr(str, '[^~!~]+', 1, 2)) workspace_code
            Into
                v_empno, v_workspace_code
            From
                csv;

            Select
                * Bulk Collect
            Into
                tab_primary_workspace
            From
                (
                    Select
                        *
                    From
                        swp_primary_workspace
                    Where
                        empno = Trim(v_empno)
                    Order By start_date Desc
                )
            Where
                Rownum <= 2;

            If tab_primary_workspace.count > 0 Then
                --If same FUTURE record exists in database then continue
                --If no change then continue
                If tab_primary_workspace(1).primary_workspace = v_workspace_code Then
                    Continue;
                End If;

                --Delete existing SWP DESK ASSIGNMENT planning
                del_emp_future_planning(
                    p_empno               => v_empno,
                    p_planning_start_date => trunc(rec_config_week.start_date)
                );
                --
                v_ows_desk_id := iot_swp_common.get_swp_planned_desk(v_empno);
                --Remove user desk association in DMS
                If Trim(v_ows_desk_id) Is Not Null Then
                    iot_swp_dms.sp_remove_desk_user(
                        p_person_id => p_person_id,
                        p_meta_id   => p_meta_id,

                        p_empno     => v_empno,
                        p_deskid    => v_ows_desk_id
                    );
                End If;

                --If furture planning is reverted to old planning then continue
                If tab_primary_workspace(1).active_code = c_planning_future Then
                    If tab_primary_workspace.Exists(2) Then
                        If tab_primary_workspace(2).primary_workspace = v_workspace_code Then
                            Continue;
                        End If;
                    End If;
                End If;
            End If;
            v_key := dbms_random.string('X', 10);
            Insert Into swp_primary_workspace (
                key_id,
                empno,
                primary_workspace,
                start_date,
                modified_on,
                modified_by,
                active_code
            )
            Values (
                v_key,
                v_empno,
                v_workspace_code,
                rec_config_week.start_date,
                sysdate,
                v_mod_by_empno,
                c_planning_future
            );
            Commit;
        End Loop;

        p_message_type := 'OK';
        p_message_text := 'Procedure executed successfully.';
    Exception
        When Others Then
            Rollback;
            p_message_type := 'KO';
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
    End;

    /*
        Procedure sp_assign_work_space(
            p_person_id           Varchar2,
            p_meta_id             Varchar2,

            p_emp_workspace_array typ_tab_string,
            p_message_type Out    Varchar2,
            p_message_text Out    Varchar2
        ) As
            v_workspace_code      Number;
            v_mod_by_empno        Varchar2(5);
            v_count               Number;
            v_key                 Varchar2(10);
            v_empno               Varchar2(5);
            rec_config_week       swp_config_weeks%rowtype;
            c_planning_future     Constant Number(1) := 2;
            c_planning_current    Constant Number(1) := 1;
            c_planning_is_open    Constant Number(1) := 1;
            Type typ_tab_primary_workspace Is Table Of swp_primary_workspace%rowtype Index By Binary_Integer;
            tab_primary_workspace typ_tab_primary_workspace;
            v_ows_desk_id         Varchar2(10);
        Begin
            v_mod_by_empno := get_empno_from_meta_id(p_meta_id);
            If v_mod_by_empno = 'ERRRR' Then
                p_message_type := 'KO';
                p_message_text := 'Invalid employee number';
                Return;
            End If;
            Begin

                Select
                    *
                Into
                    rec_config_week
                From
                    swp_config_weeks
                Where
                    planning_flag = c_planning_future
                    And pws_open  = c_planning_is_open;
            Exception
                When Others Then
                    p_message_type := 'KO';
                    p_message_text := 'Err - SWP Planning is not open. Cannot proceed.';
                    Return;
            End;

            For i In 1..p_emp_workspace_array.count
            Loop

                With
                    csv As (
                        Select
                            p_emp_workspace_array(i) str
                        From
                            dual
                    )
                Select
                    Trim(regexp_substr(str, '[^~!~]+', 1, 1)) empno,
                    Trim(regexp_substr(str, '[^~!~]+', 1, 2)) workspace_code
                Into
                    v_empno, v_workspace_code
                From
                    csv;

                Select
                    * Bulk Collect
                Into
                    tab_primary_workspace
                From
                    (
                        Select
                            *
                        From
                            swp_primary_workspace
                        Where
                            empno = Trim(v_empno)
                        Order By start_date Desc
                    )
                Where
                    Rownum <= 2;

                If tab_primary_workspace.count > 0 Then
                    --If same FUTURE record exists in database then continue
                    --If no change then continue
                    If tab_primary_workspace(1).primary_workspace = v_workspace_code Then
                        Continue;
                    End If;

                    --Delete existing SWP DESK ASSIGNMENT planning
                    del_emp_future_planning(
                        p_empno               => v_empno,
                        p_planning_start_date => trunc(rec_config_week.start_date)
                    );
                    --
                    v_ows_desk_id := iot_swp_common.get_swp_planned_desk(v_empno);
                    --Remove user desk association in DMS
                    If Trim(v_ows_desk_id) Is Not Null Then
                        iot_swp_dms.sp_remove_desk_user(
                            p_person_id => p_person_id,
                            p_meta_id   => p_meta_id,

                            p_empno     => v_empno,
                            p_deskid    => v_ows_desk_id
                        );
                    End If;

                    --If furture planning is reverted to old planning then continue
                    If tab_primary_workspace(1).active_code = c_planning_future Then
                        If tab_primary_workspace.Exists(2) Then
                            If tab_primary_workspace(2).primary_workspace = v_workspace_code Then
                                Continue;
                            End If;
                        End If;
                    End If;
                End If;
                v_key := dbms_random.string('X', 10);
                Insert Into swp_primary_workspace (
                    key_id,
                    empno,
                    primary_workspace,
                    start_date,
                    modified_on,
                    modified_by,
                    active_code
                )
                Values (
                    v_key,
                    v_empno,
                    v_workspace_code,
                    rec_config_week.start_date,
                    sysdate,
                    v_mod_by_empno,
                    c_planning_future
                );
                Commit;
            End Loop;

            p_message_type := 'OK';
            p_message_text := 'Procedure executed successfully.';
        Exception
            When Others Then
                Rollback;
                p_message_type := 'KO';
                p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
        End;
    */
    Procedure sp_add_office_ws_desk(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_deskid           Varchar2,
        p_empno            Varchar2,
        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        strsql            Varchar2(600);
        v_count           Number;
        v_status          Varchar2(5);
        v_mod_by_empno    Varchar2(5);
        v_pk              Varchar2(10);
        v_fk              Varchar2(10);
        v_empno           Varchar2(5);
        v_attendance_date Date;
        v_desk            Varchar2(20);
    Begin

        v_mod_by_empno := get_empno_from_meta_id(p_meta_id);

        If v_mod_by_empno = 'ERRRR' Then
            p_message_type := 'KO';
            p_message_text := 'Invalid employee number';
            Return;
        End If;
        If Not iot_swp_common.fn_can_do_desk_plan_4_emp(p_empno) Then
            p_message_type := 'KO';
            p_message_text := 'Planning not allowed for employee assign code.';
            Return;
        End If;

        Select
            Count(*)
        Into
            v_count
        From
            swp_primary_workspace
        Where
            Trim(empno)                 = Trim(p_empno)
            And Trim(primary_workspace) = '1';

        If v_count = 0 Then
            p_message_type := 'KO';
            p_message_text := 'Invalid employee number ' || p_empno;
            Return;
        End If;

        Insert Into dm_vu_emp_desk_map (
            empno,
            deskid
        --,modified_on,
        --modified_by
        )
        Values (
            p_empno,
            p_deskid
        --,sysdate,
        --v_mod_by_empno
        );
        Commit;

        p_message_type := 'OK';
        p_message_text := 'Procedure executed successfully.';
    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;

    End sp_add_office_ws_desk;

    Procedure sp_workspace_summary(
        p_person_id                      Varchar2,
        p_meta_id                        Varchar2,

        p_assign_code                    Varchar2 Default Null,
        p_start_date                     Date     Default Null,

        p_total_emp_count            Out Number,
        p_emp_count_office_workspace Out Number,
        p_emp_count_smart_workspace  Out Number,
        p_emp_count_not_in_ho        Out Number,

        p_emp_perc_office_workspace  Out Number,
        p_emp_perc_smart_workspace   Out Number,

        p_message_type               Out Varchar2,
        p_message_text               Out Varchar2
    ) As
        v_empno              Varchar2(5);
        v_total              Number;
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
        v_friday_date        Date;
        Cursor cur_sum Is

            With
                assign_codes As (
                    Select
                        assign
                    From
                        (
                            Select
                                assign
                            From
                                (
                                    Select
                                        costcode As assign
                                    From
                                        ss_costmast
                                    Where
                                        hod = v_empno
                                    Union
                                    Select
                                        parent As assign
                                    From
                                        ss_user_dept_rights
                                    Where
                                        empno = v_empno
                                )
                            Where
                                assign = nvl(p_assign_code, assign)
                            Order By assign
                        )
                    Where
                        Rownum = 1
                ),
                primary_work_space As(
                    Select
                        a.empno, a.primary_workspace, a.start_date
                    From
                        swp_primary_workspace a
                    Where
                        trunc(a.start_date) = (
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
                workspace, Count(empno) emp_count
            From
                (
                    Select
                        empno, nvl(primary_workspace, 3) workspace
                    From
                        (
                            Select
                                e.empno, emptype, status, aw.primary_workspace
                            From
                                ss_emplmast        e,
                                primary_work_space aw,
                                assign_codes       ac
                            Where
                                e.assign    = ac.assign
                                And e.empno = aw.empno(+)
                                And status  = 1
                                And emptype In (
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

                        )
                )
            Group By
                workspace;
    Begin
        v_friday_date               := iot_swp_common.get_friday_date(nvl(p_start_date, sysdate));
        v_empno                     := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return;
        End If;
        For c1 In cur_sum
        Loop
            If c1.workspace = 1 Then
                p_emp_count_office_workspace := c1.emp_count;
            Elsif c1.workspace = 2 Then
                p_emp_count_smart_workspace := c1.emp_count;
            Elsif c1.workspace = 3 Then
                p_emp_count_not_in_ho := c1.emp_count;
            End If;

        End Loop;
        p_total_emp_count           := nvl(p_emp_count_office_workspace, 0) + nvl(p_emp_count_smart_workspace, 0) + nvl(p_emp_count_not_in_ho, 0);
        v_total                     := (nvl(p_total_emp_count, 0) - nvl(p_emp_count_not_in_ho, 0));
        p_emp_perc_office_workspace := round(((nvl(p_emp_count_office_workspace, 0) / v_total) * 100), 1);
        p_emp_perc_smart_workspace  := round(((nvl(p_emp_count_smart_workspace, 0) / v_total) * 100), 1);

        p_message_type              := 'OK';
        p_message_text              := 'Procedure executed successfully.';
    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;

    End;

    Procedure sp_workspace_plan_summary(
        p_person_id                      Varchar2,
        p_meta_id                        Varchar2,

        p_assign_code                    Varchar2 Default Null,

        p_total_emp_count            Out Number,
        p_emp_count_office_workspace Out Number,
        p_emp_count_smart_workspace  Out Number,
        p_emp_count_not_in_ho        Out Number,

        p_emp_perc_office_workspace  Out Number,
        p_emp_perc_smart_workspace   Out Number,

        p_message_type               Out Varchar2,
        p_message_text               Out Varchar2
    ) As
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
        sp_workspace_summary(
            p_person_id                  => p_person_id,
            p_meta_id                    => p_meta_id,

            p_assign_code                => p_assign_code,
            p_start_date                 => v_plan_friday_date,

            p_total_emp_count            => p_total_emp_count,
            p_emp_count_office_workspace => p_emp_count_office_workspace,
            p_emp_count_smart_workspace  => p_emp_count_smart_workspace,
            p_emp_count_not_in_ho        => p_emp_count_not_in_ho,

            p_emp_perc_office_workspace  => p_emp_perc_office_workspace,
            p_emp_perc_smart_workspace   => p_emp_perc_smart_workspace,

            p_message_type               => p_message_type,
            p_message_text               => p_message_text
        );
    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;

    End;

    Procedure sp_hod_assign_work_space(
        p_person_id           Varchar2,
        p_meta_id             Varchar2,

        p_emp_workspace_array typ_tab_string,
        p_message_type Out    Varchar2,
        p_message_text Out    Varchar2
    ) As
        v_workspace_code      Number;
        v_mod_by_empno        Varchar2(5);
        v_count               Number;
        v_key                 Varchar2(10);
        v_empno               Varchar2(5);
        rec_config_week       swp_config_weeks%rowtype;
        c_planning_future     Constant Number(1) := 2;
        c_planning_current    Constant Number(1) := 1;
        c_planning_is_open    Constant Number(1) := 1;
        Type typ_tab_primary_workspace Is Table Of swp_primary_workspace%rowtype Index By Binary_Integer;
        tab_primary_workspace typ_tab_primary_workspace;
        v_ows_desk_id         Varchar2(10);
    Begin

        sp_assign_work_space(
            p_person_id           => p_person_id,
            p_meta_id             => p_meta_id,

            p_emp_workspace_array => p_emp_workspace_array,
            p_message_type        => p_message_type,
            p_message_text        => p_message_text
        );
    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;

    End;

    Procedure sp_hr_assign_work_space(
        p_person_id           Varchar2,
        p_meta_id             Varchar2,

        p_emp_workspace_array typ_tab_string,
        p_message_type Out    Varchar2,
        p_message_text Out    Varchar2
    ) As
        v_workspace_code      Number;
        v_mod_by_empno        Varchar2(5);
        v_count               Number;
        v_key                 Varchar2(10);
        v_empno               Varchar2(5);
        rec_config_week       swp_config_weeks%rowtype;
        c_planning_future     Constant Number(1) := 2;
        c_planning_current    Constant Number(1) := 1;
        c_planning_is_open    Constant Number(1) := 1;
        Type typ_tab_primary_workspace Is Table Of swp_primary_workspace%rowtype Index By Binary_Integer;
        tab_primary_workspace typ_tab_primary_workspace;
        v_ows_desk_id         Varchar2(10);
    Begin

        sp_assign_work_space(
            p_person_id           => p_person_id,
            p_meta_id             => p_meta_id,
            p_is_admin_call       => 1,
            p_emp_workspace_array => p_emp_workspace_array,
            p_message_type        => p_message_type,
            p_message_text        => p_message_text
        );
    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;

    End;

-- By Pradeep only for information

    Procedure sp_admin_assign_work_space(
        p_person_id           Varchar2,
        p_meta_id             Varchar2,

        p_is_admin_call       Number Default 0,
        p_emp_workspace_array typ_tab_string,
        p_message_type Out    Varchar2,
        p_message_text Out    Varchar2
    ) As
        v_workspace_code      Number;
        v_mod_by_empno        Varchar2(5);
        v_count               Number;
        v_key                 Varchar2(10);
        v_empno               Varchar2(5);
        v_start_date          date;
        rec_config_week       swp_config_weeks%rowtype;
        c_planning_future     Constant Number(1) := 2;
        c_planning_current    Constant Number(1) := 1;
        c_planning_is_open    Constant Number(1) := 1;
        Type typ_tab_primary_workspace Is Table Of swp_primary_workspace%rowtype Index By Binary_Integer;
        tab_primary_workspace typ_tab_primary_workspace;
        v_ows_desk_id         Varchar2(10);
    Begin
        v_mod_by_empno := get_empno_from_meta_id(p_meta_id);
        If v_mod_by_empno = 'ERRRR' Then
            p_message_type := 'KO';
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        If nvl(p_is_admin_call, 0) != 1 Then
            Begin

                Select
                    *
                Into
                    rec_config_week
                From
                    swp_config_weeks
                Where
                    planning_flag = c_planning_future
                    And pws_open  = c_planning_is_open;
            Exception
                When Others Then
                    p_message_type := 'KO';
                    p_message_text := 'Err - SWP Planning is not open. Cannot proceed.';
                    Return;
            End;
        Elsif nvl(p_is_admin_call, 0) = 1 Then

            Begin

                Select
                    *
                Into
                    rec_config_week
                From
                    swp_config_weeks
                Where
                    planning_flag = c_planning_future;
            Exception
                When Others Then
                    p_message_type := 'KO';
                    p_message_text := 'Err - SWP Planning is not open. Cannot proceed.';
                    Return;
            End;

        End If;

        For i In 1..p_emp_workspace_array.count
        Loop

            With
                csv As (
                    Select
                        p_emp_workspace_array(i) str
                    From
                        dual
                )
            Select
                Trim(regexp_substr(str, '[^~!~]+', 1, 1)) empno,
                Trim(regexp_substr(str, '[^~!~]+', 1, 2)) workspace_code,
                Trim(regexp_substr(str, '[^~!~]+', 1, 3)) start_date

            Into
                v_empno, v_workspace_code, v_start_date
            From
                csv;

            Select
                * Bulk Collect
            Into
                tab_primary_workspace
            From
                (
                    Select
                        *
                    From
                        swp_primary_workspace
                    Where
                        empno = Trim(v_empno)
                    Order By start_date Desc
                )
            Where
                Rownum <= 2;

            If tab_primary_workspace.count > 0 Then
                --If same FUTURE record exists in database then continue
                --If no change then continue
                If tab_primary_workspace(1).primary_workspace = v_workspace_code Then
                    Continue;
                End If;

                --Delete existing SWP DESK ASSIGNMENT planning
                --By Pradeep Mahor
                /*
                IOT_SWP_PRIMARY_WORKSPACE.del_emp_future_planning(
                    p_empno               => v_empno,
                    p_planning_start_date => trunc(rec_config_week.start_date)
                );
                */
                --
                v_ows_desk_id := iot_swp_common.get_swp_planned_desk(v_empno);
                --Remove user desk association in DMS
                If Trim(v_ows_desk_id) Is Not Null Then
                    iot_swp_dms.sp_remove_desk_user(
                        p_person_id => p_person_id,
                        p_meta_id   => p_meta_id,

                        p_empno     => v_empno,
                        p_deskid    => v_ows_desk_id
                    );
                End If;

                --If furture planning is reverted to old planning then continue
                If tab_primary_workspace(1).active_code = c_planning_future Then
                    If tab_primary_workspace.Exists(2) Then
                        If tab_primary_workspace(2).primary_workspace = v_workspace_code Then
                            Continue;
                        End If;
                    End If;
                End If;
            End If;
            v_key := dbms_random.string('X', 10);
            Insert Into swp_primary_workspace (
                key_id,
                empno,
                primary_workspace,
                start_date,
                modified_on,
                modified_by,
                active_code
            )
            Values (
                v_key,
                v_empno,
                v_workspace_code,
                To_Date(v_start_date,'dd-MON-yyyy'),
                sysdate,
                v_mod_by_empno,
                c_planning_future
            );
            Commit;
        End Loop;

        p_message_type := 'OK';
        p_message_text := 'Procedure executed successfully.';
    Exception
        When Others Then
            Rollback;
            p_message_type := 'KO';
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm ||' - '|| v_start_date;
    End;


   procedure sp_admin_delete_work_space(
      p_person_id        varchar2,
      p_meta_id          varchar2,

      p_application_id   varchar2,
      p_start_date       date,

      p_message_type out varchar2,
      p_message_text out varchar2
   ) as
      v_count    number;
      v_empno    varchar2(5);
      v_tab_from varchar2(2);
   begin
      v_count        := 0;
      v_empno        := get_empno_from_meta_id(p_meta_id);

      if v_empno = 'ERRRR' then
         p_message_type := 'KO';
         p_message_text := 'Invalid employee number';
         return;
      end if;

      delete from Swp_Primary_Workspace
       where KEY_ID = p_application_id
         and START_DATE >= p_start_date;

      commit;

      p_message_type := 'OK';
      p_message_text := 'Procedure executed successfully.';

   exception
      when others then
         p_message_type := 'KO';
         p_message_text := 'Err - '
                           || sqlcode
                           || ' - '
                           || sqlerrm;

   end sp_admin_delete_work_space;

-- End


End iot_swp_primary_workspace;
/
---------------------------
--Changed PACKAGE BODY
--IOT_SWP_EMP_TO_OFFICE_QRY
---------------------------
CREATE OR REPLACE PACKAGE BODY "SELFSERVICE"."IOT_SWP_EMP_TO_OFFICE_QRY" as

   function fn_Emp_Coming_To_Office_list(
      p_person_id      varchar2,
      p_meta_id        varchar2,

      p_generic_search varchar2 default null,
      p_start_date     date     default null,
      P_Activefuture   number  default null,
      
      p_row_number     number,
      p_page_length    number
   ) return sys_refcursor as
      P_PLAN_START_DATE    date;
      P_PLAN_END_DATE      date;
      P_CURR_START_DATE    date;
      P_CURR_END_DATE      date;
      P_PLANNING_EXISTS    varchar2(200);
      P_PWS_OPEN           varchar2(200);
      P_SWS_OPEN           varchar2(200);
      P_OWS_OPEN           varchar2(200);
      P_MESSAGE_TYPE       varchar2(200);
      P_MESSAGE_TEXT       varchar2(200);
      v_empno              varchar2(5);
      e_employee_not_found exception;
      pragma exception_init(e_employee_not_found, -20001);
      c                    sys_refcursor;
   begin

      v_empno := get_empno_from_meta_id(p_meta_id);
      if v_empno = 'ERRRR' then
         raise e_employee_not_found;
         return null;
      end if;

      IOT_SWP_COMMON.GET_PLANNING_WEEK_DETAILS(
         P_PERSON_ID       => P_PERSON_ID,
         P_META_ID         => P_META_ID,
         P_PLAN_START_DATE => P_PLAN_START_DATE,
         P_PLAN_END_DATE   => P_PLAN_END_DATE,
         P_CURR_START_DATE => P_CURR_START_DATE,
         P_CURR_END_DATE   => P_CURR_END_DATE,
         P_PLANNING_EXISTS => P_PLANNING_EXISTS,
         P_PWS_OPEN        => P_PWS_OPEN,
         P_SWS_OPEN        => P_SWS_OPEN,
         P_OWS_OPEN        => P_OWS_OPEN,
         P_MESSAGE_TYPE    => P_MESSAGE_TYPE,
         P_MESSAGE_TEXT    => P_MESSAGE_TEXT
      );

      if (P_MESSAGE_TYPE = 'KO') then
         return null;
      end if;

      open c for
           select * from (
           select Key_id , Empno , Employee_Name ,to_char(P_CURR_START_DATE, 'dd-Mon-yyyy') as Curr_Pws_Date,curr_pws ,Curr_desk ,
                  future_pws , to_char(START_DATE, 'dd-Mon-yyyy') As Future_Pws_Date ,
                  Start_Date For_Order,  Desk_Id , Modified_by , Modified_on_date ,
                  row_number() over (order by Empno desc) As row_number,
                  count(*) over () As total_row 
           from (
                    select A.Key_Id as Key_id,
                          A.Empno as Empno,
                          get_emp_name(A.Empno) as Employee_Name, 
                          iot_swp_common.fn_get_pws_text(iot_swp_common.fn_get_emp_pws(A.Empno,P_CURR_END_DATE)) As curr_pws,
                          iot_swp_common.fn_get_pws_text(iot_swp_common.fn_get_emp_pws(A.Empno,A.Start_Date)) As future_pws,
                          iot_swp_common.get_desk_from_dms(A.Empno) As Curr_desk,                          
                          A.Start_Date  as Start_Date,
                          '' as Desk_Id,
                          case
                             when A.MODIFIED_BY = 'Sys' then
                                'System'
                             else
                                A.MODIFIED_BY
                                || ' - '
                                || get_emp_name(A.MODIFIED_BY)
                          end as Modified_by,
                          to_char(A.MODIFIED_ON, 'dd-Mon-yyyy') as Modified_on_date 
                     from Swp_Primary_Workspace A
                    where  A.PRIMARY_WORKSPACE = nvl(P_Activefuture,A.PRIMARY_WORKSPACE)
                        and  A.Start_Date >= P_PLAN_START_DATE

                  union    
                      select '' as Key_id,
                          A.Empno as Empno,
                          get_emp_name(A.Empno) as Employee_Name, 
                          iot_swp_common.fn_get_pws_text(iot_swp_common.fn_get_emp_pws(A.Empno,P_CURR_END_DATE)) As curr_pws,
                          iot_swp_common.fn_get_pws_text(iot_swp_common.fn_get_emp_pws(A.Empno,A.Start_Date)) As future_pws,
                          iot_swp_common.get_desk_from_dms(A.Empno) As Curr_desk,           
                          A.Start_Date  as Start_Date, 
                          a.DESKID as Desk_Id,
                          '' as Modified_by,
                          '' as Modified_on_date 
                     from SWP_TEMP_DESK_ALLOCATION A
                    where  A.Start_Date >= P_PLAN_START_DATE                    
                )
         )
          where row_number between (nvl(p_row_number, 0) + 1) and (nvl(p_row_number, 0) + p_page_length)
           order by future_pws ;

      return c;

   end;

end IOT_SWP_EMP_TO_OFFICE_QRY;
/
---------------------------
--Changed FUNCTION
--N_OTPERIOD_INLCUDE_2ND_SHIFT
---------------------------
CREATE OR REPLACE FUNCTION "SELFSERVICE"."N_OTPERIOD_INLCUDE_2ND_SHIFT" (
    p_empno       In Varchar2,
    p_date        In Date,
    p_shift_code  In Varchar2,
    p_delta_hrs   In Number,
    p_compoff_hrs In Number Default 0
) Return Number Is

    v_ret_ot_hrs          Number;

    Type typ_tab_hrs Is
        Table Of Number Index By Binary_Integer;
    v_tab_hrs             typ_tab_hrs;
    cntr                  Number;
    thrs                  Varchar2(10);
    v_shift_out_time      Number;
    v_shift_in_time       Number;
    v_is_ot_applicable    Number;
    v_punchnos            Number;
    vtrno                 Char(5);
    v4ot                  Boolean := true;
    v_is_train_ot         Number;

    v_ot_start_time       Number;
    v_ot_end_time         Number;

    v_from_hrs            Number;
    v_to_hrs              Number;
    row_shift_mast        ss_shiftmast%rowtype;
    v_atual_shift_in_time Number;
Begin
    If p_shift_code = 'TN' Or p_shift_code = 'PA' Or p_shift_code = 'GE' Or p_shift_code = 'GV' Then
        Return 0;
    End If;
    If Trim(p_shift_code) In ('HH', 'OO') Then
        row_shift_mast.timein_hh := 0;
        row_shift_mast.timein_mn := 0;
    Else
        Select
            *
        Into
            row_shift_mast
        From
            ss_shiftmast
        Where
            shiftcode = Trim(p_shift_code);
    End If;
    --And nvl(ot_applicable, 0) = 1;

    If trunc(p_date) In (
            trunc(To_Date('21-FEB-2017', 'dd-MON-yyyy')),
            trunc(To_Date('28-SEP-2017', 'dd-MON-yyyy'))
        )
    Then
        Return 0;
    End If;

    If nvl(row_shift_mast.ot_applicable, 0) = 0 And trim(p_shift_code) <> 'HH' And trim(p_shift_code) <> 'OO' Then
        Return 0;
    End If;

    --Training

    v_is_train_ot         := n_ot_4_training(p_empno, p_date);
    If v_is_train_ot = ss.ss_false Then
        Return 0;
    End If;
    --Training

    If p_date < To_Date('1-Mar-2022', 'dd-Mon-yyyy') Then
        Return n_otperiod(
            p_empno,
            p_date,
            p_shift_code,
            p_delta_hrs,
            p_compoff_hrs
        );
    End If;

    v_atual_shift_in_time := (row_shift_mast.timein_hh * 60) + row_shift_mast.timein_mn;

    v_ret_ot_hrs          := 0;

    Select
        ((hh * 60) + mm) mins Bulk Collect
    Into
        v_tab_hrs
    From
        ss_integratedpunch
    Where
        empno         = ltrim(rtrim(p_empno))
        And pdate     = p_date
        And falseflag = 1
        And Trim(mach) <> 'WFH0'
    Order By
        pdate,
        hhsort,
        mmsort,
        hh,
        mm;
    If (v_tab_hrs.count Mod 2) <> 0 Then
        Return 0;
    End If;

    v_shift_out_time      := getshiftouttime(p_empno, p_date, p_shift_code, v4ot);

    v_shift_in_time       := getshiftintime(p_empno, p_date, p_shift_code);
    If p_shift_code In ('OO', 'HH') Then

        v_ot_start_time := 0;
        v_ot_end_time   := 1439;
    Elsif v_atual_shift_in_time > (12 * 60) Then
        v_ot_start_time := 0;
        v_ot_end_time   := v_shift_in_time;
    Else
        v_ot_start_time := v_shift_out_time;
        v_ot_end_time   := 1439;
    End If;

    v_ret_ot_hrs          := 0;
    For i In 1..v_tab_hrs.count
    Loop
        If Mod(i, 2) = 0 Then
            If v_tab_hrs(i) < v_ot_start_time Then
                Continue;
            End If;
            If v_tab_hrs(i - 1) > v_ot_end_time Then
                Exit;
            End If;

            v_from_hrs   := greatest(v_ot_start_time, v_tab_hrs(i - 1));

            v_to_hrs     := least(v_ot_end_time, v_tab_hrs(i));

            v_ret_ot_hrs := v_ret_ot_hrs + v_to_hrs - v_from_hrs;

        End If;
    End Loop;

    If p_shift_code <> 'OO' And p_shift_code <> 'HH' Then

        v_ret_ot_hrs := least(p_delta_hrs, v_ret_ot_hrs);

    Elsif p_shift_code = 'OO' Or p_shift_code = 'HH' Then

        v_ret_ot_hrs := v_ret_ot_hrs - availedlunchtime1(p_empno, p_date, p_shift_code);

    End If;

    If p_compoff_hrs = 1 Then
        If v_ret_ot_hrs >= 120 Then
            v_ret_ot_hrs := (floor(v_ret_ot_hrs / 60) * 60);
        Else
            v_ret_ot_hrs := 0;
        End If;
    Else
        If p_shift_code = 'OO' Or p_shift_code = 'HH' Then
            If v_ret_ot_hrs >= 240 Then
                v_ret_ot_hrs := (floor(v_ret_ot_hrs / 60) * 60);
            Else
                v_ret_ot_hrs := 0;
            End If;

        Else
            If v_ret_ot_hrs >= 120 Then
                v_ret_ot_hrs := 120;
            Else
                v_ret_ot_hrs := 0;
            End If;
        End If;
    End If;

    Return v_ret_ot_hrs;
End;
/