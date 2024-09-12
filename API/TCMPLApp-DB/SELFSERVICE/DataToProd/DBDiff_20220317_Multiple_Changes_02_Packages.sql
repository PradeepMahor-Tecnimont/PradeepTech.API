--------------------------------------------------------
--  File created - Thursday-March-17-2022   
--------------------------------------------------------
---------------------------
--New PACKAGE
--IOT_SWP_SMART_WORKSPACE
---------------------------
CREATE OR REPLACE PACKAGE "SELFSERVICE"."IOT_SWP_SMART_WORKSPACE" As
     Type typ_tab_string Is Table Of Varchar(4000) Index By Binary_Integer;
    c_office_workspace constant number := 1;
    c_smart_workspace constant number := 2;
    c_not_in_mum_office constant number := 3;

    Procedure sp_add_weekly_atnd(
        p_person_id         Varchar2,
        p_meta_id           Varchar2,

        p_weekly_attendance typ_tab_string,
        p_empno             Varchar2,
        p_message_type Out  Varchar2,
        p_message_text Out  Varchar2
    );

    Procedure sp_smart_ws_weekly_summary(
        p_person_id                     Varchar2,
        p_meta_id                       Varchar2,

        p_assign_code                   Varchar2,
        p_date                          Date,

        p_emp_count_smart_workspace Out Number,
        p_emp_count_mon             Out Number,
        p_emp_count_tue             Out Number,
        p_emp_count_wed             Out Number,
        p_emp_count_thu             Out Number,
        p_emp_count_fri             Out Number,
        p_costcode_desc             Out Varchar2,
        p_message_type              Out Varchar2,
        p_message_text              Out Varchar2
    );


End IOT_SWP_SMART_WORKSPACE;
/
---------------------------
--Changed PACKAGE
--IOT_HOLIDAY
---------------------------
CREATE OR REPLACE PACKAGE "SELFSERVICE"."IOT_HOLIDAY" As
   Type typ_tab_string Is Table Of Varchar(4000) Index By Binary_Integer;

   Procedure sp_add_holiday(
      p_person_id        Varchar2,
      p_meta_id          Varchar2,

      p_office           Varchar2,
      p_date             Date,
      p_project          Varchar2,
      p_approver         Varchar2,
      p_hh1              Varchar2,
      p_mi1              Varchar2,
      p_hh2              Varchar2,
      p_mi2              Varchar2,
      p_reason           Varchar2,

      p_message_type Out Varchar2,
      p_message_text Out Varchar2
   );

   Procedure sp_delete_holiday(
      p_person_id        Varchar2,
      p_meta_id          Varchar2,

      p_application_id   Varchar2,

      p_message_type Out Varchar2,
      p_message_text Out Varchar2
   );

   Procedure sp_holiday_approval(
      p_person_id         Varchar2,
      p_meta_id           Varchar2,

      p_holiday_approvals typ_tab_string,
      p_approver_profile  Number,
      p_message_type Out  Varchar2,
      p_message_text Out  Varchar2
   );

   Procedure sp_holiday_approval_lead(
      p_person_id        Varchar2,
      p_meta_id          Varchar2,

      p_holiday_approvals  typ_tab_string,

      p_message_type Out Varchar2,
      p_message_text Out Varchar2
   );

   Procedure sp_holiday_approval_hod(
      p_person_id         Varchar2,
      p_meta_id           Varchar2,

      p_holiday_approvals typ_tab_string,

      p_message_type Out  Varchar2,
      p_message_text Out  Varchar2
   );

   Procedure sp_holiday_approval_hr(
      p_person_id         Varchar2,
      p_meta_id           Varchar2,

      p_holiday_approvals typ_tab_string,

      p_message_type Out  Varchar2,
      p_message_text Out  Varchar2
   );

End iot_holiday;
/
---------------------------
--Changed PACKAGE
--IOT_SWP_SELECT_LIST_QRY
---------------------------
CREATE OR REPLACE PACKAGE "SELFSERVICE"."IOT_SWP_SELECT_LIST_QRY" As

    Function fn_desk_list_for_smart(
        p_person_id Varchar2,
        p_meta_id   Varchar2,
        p_date      Date,
        p_empno     Varchar2
    ) Return Sys_Refcursor;

    Function fn_desk_list_for_office(
        p_person_id Varchar2,
        p_meta_id   Varchar2,
        p_date      Date Default Null,
        p_empno     Varchar2
    ) Return Sys_Refcursor;

    Function fn_employee_list_4_hod_sec(
        p_person_id Varchar2,
        p_meta_id   Varchar2
    ) Return Sys_Refcursor;


    Function fn_emp_list4plan_4_hod_sec(
        p_person_id Varchar2,
        p_meta_id   Varchar2
    ) Return Sys_Refcursor;

    Function fn_costcode_list_4_hod_sec(
        p_person_id Varchar2,
        p_meta_id   Varchar2
    ) Return Sys_Refcursor;

    Function fn_dept_list4plan_4_hod_sec(
        p_person_id Varchar2,
        p_meta_id   Varchar2
    ) Return Sys_Refcursor;

    Function fn_employee_type_list(
        p_person_id Varchar2,
        p_meta_id   Varchar2
    ) Return Sys_Refcursor;

    Function fn_grade_list(
        p_person_id Varchar2,
        p_meta_id   Varchar2
    ) Return Sys_Refcursor;

    Function fn_project_list(
        p_person_id Varchar2,
        p_meta_id   Varchar2
    ) Return Sys_Refcursor;

    Function fn_costcode_list_4_admin(
        p_person_id Varchar2,
        p_meta_id   Varchar2
    ) Return Sys_Refcursor ;


End iot_swp_select_list_qry;
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

    Procedure sp_assign_work_space(
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



End iot_swp_primary_workspace;
/
---------------------------
--Changed PACKAGE
--IOT_SWP_CONFIG_WEEK
---------------------------
CREATE OR REPLACE PACKAGE "SELFSERVICE"."IOT_SWP_CONFIG_WEEK" As

    Type typ_tab_string Is Table Of Varchar(4000) Index By Binary_Integer;

    Procedure sp_cofiguration;

    Procedure sp_update_primary_workspace;

End iot_swp_config_week;
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

    query_pws Varchar2(4000) := '
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
            a.office,
            a.emptype,
            iot_swp_common.get_emp_work_area(Null, Null, a.empno) As work_area,
            iot_swp_common.is_emp_laptop_user(a.empno)            As is_laptop_user,
            Case iot_swp_common.is_emp_laptop_user(a.empno)
                When 1 Then
                    ''Yes''
                Else
                    ''No''
            End                                                   As is_laptop_user_text,
            a.grade                                               As emp_grade,
            nvl(b.primary_workspace, 0)                           As primary_workspace,
            Row_Number() Over(Order By a.name)                    As row_number,
            Case iot_swp_common.is_emp_eligible_for_swp(a.empno)
                When ''OK'' Then
                    ''Yes''
                Else
                    ''No''
            End                                                   As is_eligible_desc,
            iot_swp_common.is_emp_eligible_for_swp(a.empno)       As is_eligible,
            Count(*) Over()                                       As total_row
        From
            ss_emplmast        a,
            primary_work_space b,
            swp_include_emptype c,
            params
        Where
            a.empno      = b.empno(+)
            And a.assign = nvl(params.p_assign_code, a.assign)
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
        Order By a.name
    ) data, params
Where
    row_number Between (nvl(params.p_row_number, 0) + 1) And (nvl(params.p_row_number, 0) + params.p_page_length)
';

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
    sub_qry_pws_csv Varchar2(200) := ' 
and
nvl(b.primary_workspace,0) in ( params.p_pws_csv )
';

    where_clause_laptop_user Varchar2(200) := ' and iot_swp_common.is_emp_laptop_user(a.empno) = params.p_laptop_user ';

    where_clause_swp_eligible Varchar2(200) := ' and iot_swp_common.is_emp_eligible_for_swp(a.empno) = params.p_swp_eligibility ';

    where_clause_generic_search Varchar2(200) := ' and (a.name like params.p_generic_search or a.empno like params.p_generic_search ) ';

End iot_swp_primary_workspace_qry;
/
---------------------------
--Changed PACKAGE
--IOT_HOLIDAY_QRY
---------------------------
CREATE OR REPLACE PACKAGE "SELFSERVICE"."IOT_HOLIDAY_QRY" As

   Function fn_holiday_attendance(
      p_person_id   Varchar2,
      p_meta_id     Varchar2,
      p_start_date  Date Default Null,
      p_end_date    Date Default Null,
      p_row_number  Number,
      p_page_length Number
   ) Return Sys_Refcursor;

   Function fn_pending_lead_approval(
      p_person_id   Varchar2,
      p_meta_id     Varchar2,
      p_row_number  Number,
      p_page_length Number
   ) Return Sys_Refcursor;

   Function fn_pending_hod_approval(
      p_person_id   Varchar2,
      p_meta_id     Varchar2,
      p_row_number  Number,
      p_page_length Number
   ) Return Sys_Refcursor;

   Function fn_pending_onbehalf_approval(
      p_person_id   Varchar2,
      p_meta_id     Varchar2,
      p_row_number  Number,
      p_page_length Number
   ) Return Sys_Refcursor;

   Function fn_pending_hr_approval(
      p_person_id   Varchar2,
      p_meta_id     Varchar2,
      p_row_number  Number,
      p_page_length Number
   ) Return Sys_Refcursor;

Procedure sp_holiday_details(
          p_person_id            Varchar2,
          p_meta_id              Varchar2,

          p_Application_Id       Varchar2,

          P_Employee            Out Varchar2,
          P_PROJNO           Out Varchar2,
          P_Lead_Name        Out Varchar2,
          P_Attendance_Date  Out Varchar2,
          P_Punch_In_Time    Out Varchar2,
          P_Punch_Out_Time   Out Varchar2,
          P_REMARKS          Out Varchar2,
          P_Office           Out Varchar2,
          P_LEAD_APPRL       Out Varchar2,
          P_LEAD_APPRL_DATE  Out Varchar2,
          P_LEAD_APPRL_EMPNO Out Varchar2,
          P_HOD_APPRL        Out Varchar2,
          P_HOD_APPRL_DATE   Out Varchar2,
          P_HR_APPRL         Out Varchar2,
          P_HR_APPRL_DATE    Out Varchar2,
          P_DESCRIPTION      Out Varchar2,
          P_Application_Date Out Varchar2,
          P_HOD_Remarks      Out Varchar2,
          P_Hr_Remarks       Out Varchar2,
          P_Lead_Remarks     Out Varchar2,

          p_message_type     Out Varchar2,
          p_message_text     Out Varchar2
   );
End iot_holiday_qry;
/
---------------------------
--Changed PACKAGE
--IOT_SWP_DMS
---------------------------
CREATE OR REPLACE PACKAGE "SELFSERVICE"."IOT_SWP_DMS" As

    Procedure sp_add_desk_user(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_empno            Varchar2,
        p_deskid           Varchar2,
        p_parent           Varchar2,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    );

    Procedure sp_remove_desk_user(
        p_person_id Varchar2,
        p_meta_id   Varchar2,

        p_empno     Varchar2,
        p_deskid    Varchar2
    );

    Procedure sp_lock_desk(
        p_person_id Varchar2,
        p_meta_id   Varchar2,

        p_deskid    Varchar2
    );

    Procedure sp_unlock_desk(
        p_person_id   Varchar2,
        p_meta_id     Varchar2,

        p_deskid      Varchar2,
        p_week_key_id Varchar2

    );

    Procedure sp_clear_desk(
        p_person_id Varchar2,
        p_meta_id   Varchar2,

        p_deskid    Varchar2
    );

End iot_swp_dms;
/
---------------------------
--Changed PACKAGE BODY
--IOT_HOLIDAY
---------------------------
CREATE OR REPLACE PACKAGE BODY "SELFSERVICE"."IOT_HOLIDAY" As

   Procedure sp_add_holiday(
      p_person_id        Varchar2,
      p_meta_id          Varchar2,

      p_office           Varchar2,
      p_date             Date,
      p_project          Varchar2,
      p_approver         Varchar2,
      p_hh1              Varchar2,
      p_mi1              Varchar2,
      p_hh2              Varchar2,
      p_mi2              Varchar2,
      p_reason           Varchar2,

      p_message_type Out Varchar2,
      p_message_text Out Varchar2
   ) As
      v_empno        Varchar2(5);
      v_user_tcp_ip  Varchar2(5) := 'NA';
      v_message_type Number      := 0;
   Begin
      v_empno := get_empno_from_meta_id(p_meta_id);

      If v_empno = 'ERRRR' Then
         p_message_type := 'KO';
         p_message_text := 'Invalid employee number';
         Return;
      End If;

      holiday_attendance.sp_add_holiday(
         p_person_id     => p_person_id,
         p_meta_id       => p_meta_id,
         p_from_date     => p_date,
         p_projno        => p_project,
         p_last_hh       => to_number(Trim(p_hh1)),
         p_last_mn       => to_number(Trim(p_mi1)),
         p_last_hh1      => to_number(Trim(p_hh2)),
         p_last_mn1      => to_number(Trim(p_mi2)),
         p_lead_approver => p_approver,
         p_remarks       => p_reason,
         p_location      => Trim(P_office),
         p_user_tcp_ip   => Trim(v_user_tcp_ip),
         p_message_type  => p_message_type,
         p_message_text  => p_message_text
      );

      If v_message_type = ss.failure Then
         p_message_type := 'KO';
      Else
         p_message_type := 'OK';
      End If;

   Exception
      When Others Then
         p_message_type := 'KO';
         p_message_text := 'Err - '
                           || sqlcode
                           || ' - '
                           || sqlerrm;

   End sp_add_holiday;

   Procedure sp_delete_holiday(
      p_person_id        Varchar2,
      p_meta_id          Varchar2,

      p_application_id   Varchar2,

      p_message_type Out Varchar2,
      p_message_text Out Varchar2
   ) As
      v_empno        Varchar2(5);
      v_user_tcp_ip  Varchar2(5) := 'NA';
      v_message_type Number      := 0;
   Begin
      v_empno := get_empno_from_meta_id(p_meta_id);

      If v_empno = 'ERRRR' Then
         p_message_type := 'KO';
         p_message_text := 'Invalid employee number';
         Return;
      End If;

      holiday_attendance.sp_delete_holiday(
         p_person_id      => p_person_id,
         p_meta_id        => p_meta_id,
         p_application_id => p_application_id,
         p_message_type   => p_message_type,
         p_message_text   => p_message_text
      );

      If v_message_type = ss.failure Then
         p_message_type := 'KO';
      Else
         p_message_type := 'OK';
      End If;

   Exception
      When Others Then
         p_message_type := 'KO';
         p_message_text := 'Err - '
                           || sqlcode
                           || ' - '
                           || sqlerrm;

   End sp_delete_holiday;

   Procedure sp_holiday_approval(
      p_person_id         Varchar2,
      p_meta_id           Varchar2,

      p_holiday_approvals typ_tab_string,
      p_approver_profile  Number,
      p_message_type Out  Varchar2,
      p_message_text Out  Varchar2
   ) As
      v_app_no            Varchar2(70);
      v_approval          Number;
      v_remarks           Varchar2(70);
      v_count             Number;
      strsql              Varchar2(600);
      v_odappstat_rec     ss_odappstat%rowtype;
      v_approver_empno    Varchar2(5);
      v_user_tcp_ip       Varchar2(30);
      v_msg_type          Varchar2(20);
      v_msg_text          Varchar2(1000);
      v_medical_cert_file Varchar2(200);
   Begin

      v_approver_empno := get_empno_from_meta_id(p_meta_id);
      If v_approver_empno = 'ERRRR' Then
         p_message_type := 'KO';
         p_message_text := 'Invalid employee number';
         Return;
      End If;

      Null;

      Commit;
      p_message_type   := 'OK';
      p_message_text   := 'Procedure executed successfully.';
   Exception
      When Others Then
         p_message_type := 'KO';
         p_message_text := 'ERR :- '
                           || sqlcode
                           || ' - '
                           || sqlerrm;
   End;

   Procedure sp_holiday_approval_lead(
      p_person_id         Varchar2,
      p_meta_id           Varchar2,

      p_holiday_approvals typ_tab_string,

      p_message_type Out  Varchar2,
      p_message_text Out  Varchar2
   )
   As
   Begin
      sp_holiday_approval(
         p_person_id         => p_person_id,
         p_meta_id           => p_meta_id,

         p_holiday_approvals => p_holiday_approvals,
         p_approver_profile  => user_profile.type_lead,
         p_message_type      => p_message_type,
         p_message_text      => p_message_text
      );
   End;

   Procedure sp_holiday_approval_hod(
      p_person_id         Varchar2,
      p_meta_id           Varchar2,

      p_holiday_approvals typ_tab_string,

      p_message_type Out  Varchar2,
      p_message_text Out  Varchar2
   )
   As
   Begin
      sp_holiday_approval(
         p_person_id         => p_person_id,
         p_meta_id           => p_meta_id,

         p_holiday_approvals => p_holiday_approvals,
         p_approver_profile  => user_profile.type_hod,
         p_message_type      => p_message_type,
         p_message_text      => p_message_text
      );
   End sp_holiday_approval_hod;

   Procedure sp_holiday_approval_hr(
      p_person_id         Varchar2,
      p_meta_id           Varchar2,

      p_holiday_approvals typ_tab_string,

      p_message_type Out  Varchar2,
      p_message_text Out  Varchar2
   )
   As
   Begin
      sp_holiday_approval(
         p_person_id         => p_person_id,
         p_meta_id           => p_meta_id,

         p_holiday_approvals => p_holiday_approvals,
         p_approver_profile  => user_profile.type_hrd,
         p_message_type      => p_message_type,
         p_message_text      => p_message_text
      );
   End sp_holiday_approval_hr;

End IOT_HOLIDAY;
/
---------------------------
--Changed PACKAGE BODY
--IOT_SWP_DESK_AREA_MAP_QRY
---------------------------
CREATE OR REPLACE PACKAGE BODY "SELFSERVICE"."IOT_SWP_DESK_AREA_MAP_QRY" As
 
Function fn_desk_area_map_list(
     p_person_id   Varchar2,
      p_meta_id     Varchar2,
      P_area        Varchar2 Default Null,
      p_row_number  Number,
      p_page_length Number
   ) Return Sys_Refcursor
   Is
   c                    Sys_Refcursor;
   v_count              Number;
   v_empno              Varchar2(5);
   v_hod_sec_assign_code              Varchar2(4);
   e_employee_not_found Exception;
   Pragma exception_init(e_employee_not_found, -20001);

Begin

   v_empno := get_empno_from_meta_id(p_meta_id);
   If v_empno = 'ERRRR' Then
      Raise e_employee_not_found;
      Return Null;
   End If;

   /*
   Select a.KYE_ID, a.DESKID, a.AREA_KEY_ID ,
      b.AREA_KEY_ID, b.AREA_DESC, b.AREA_CATG_CODE, b.AREA_INFO
   From SWP_DESK_AREA_MAPPING a , DMS.DM_DESK_AREAS b
   where a.AREA_KEY_ID = b.AREA_KEY_ID(+);
   */
 /*
   If v_empno Is Null Or p_assign_code Is Not Null Then
            v_hod_sec_assign_code := iot_swp_common.get_default_costcode_hod_sec(
                                         p_hod_sec_empno => v_empno,
                                         p_assign_code   => p_assign_code
                                     );
     end if;       

   Open c For
      Select *
        From (
                Select empprojmap.KYE_ID As keyid,
                       empprojmap.EMPNO As Empno,
                        a.name As Empname,
                       empprojmap.PROJNO As Projno,
                       b.name As Projname,
                       Row_Number() Over (Order By empprojmap.KYE_ID Desc) row_number,
                       Count(*) Over () total_row
                  From SWP_EMP_PROJ_MAPPING empprojmap , 
                        ss_emplmast a , ss_projmast b
                 Where a.empno = empprojmap.empno 
                     and b.projno = empprojmap.PROJNO
                     and  empprojmap.EMPNO In (
                          Select Distinct empno
                            From ss_emplmast
                           Where status = 1
                            And a.assign = nvl(v_hod_sec_assign_code, a.assign)
                       )

             )
       Where row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length)
       Order By Empno,PROJNO;
   Return c;
	*/
 RETURN NULL;

End fn_desk_area_map_list;


End IOT_SWP_DESK_AREA_MAP_QRY;
/
---------------------------
--New PACKAGE BODY
--IOT_SWP_SMART_WORKSPACE
---------------------------
CREATE OR REPLACE PACKAGE BODY "SELFSERVICE"."IOT_SWP_SMART_WORKSPACE" As
    Procedure del_emp_sws_atend_plan(
        p_empno Varchar2,
        p_date  Date
    )
    As
        rec_smart_attendance_plan swp_smart_attendance_plan%rowtype;
        v_plan_start_date         Date;
        v_plan_end_date           Date;
        v_planning_exists         Varchar2(2);
        v_planning_open           Varchar2(2);
        v_message_type            Varchar2(10);
        v_message_text            Varchar2(1000);

        v_general_area            Varchar2(4) := 'A002';
        v_count                   Number;
        rec_config_week           swp_config_weeks%rowtype;
    Begin
        If Not iot_swp_common.fn_can_do_desk_plan_4_emp(p_empno) Then
            Return;
        End If;
        Begin
            Select
                *
            Into
                rec_smart_attendance_plan
            From
                swp_smart_attendance_plan
            Where
                empno               = p_empno
                And attendance_date = p_date;
        Exception
            When no_data_found Then
                Return;
        End;
        --Delete from Planning table

        Delete
            From swp_smart_attendance_plan
        Where
            key_id = rec_smart_attendance_plan.key_id;

        --Check if the desk is General desk.

        If Not iot_swp_common.is_desk_in_general_area(rec_smart_attendance_plan.deskid) Then
            Return;
        End If;
        --

        Select
            *
        Into
            rec_config_week
        From
            swp_config_weeks
        Where
            planning_open = 1;

        iot_swp_dms.sp_unlock_desk(
            p_person_id   => Null,
            p_meta_id     => Null,

            p_deskid      => rec_smart_attendance_plan.deskid,
            p_week_key_id => rec_config_week.key_id
        );

    End;

    Procedure sp_add_weekly_atnd(
        p_person_id         Varchar2,
        p_meta_id           Varchar2,

        p_weekly_attendance typ_tab_string,
        p_empno             Varchar2,
        p_message_type Out  Varchar2,
        p_message_text Out  Varchar2
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
        rec_config_week   swp_config_weeks%rowtype;
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
            *
        Into
            rec_config_week
        From
            swp_config_weeks
        Where
            planning_open = 1;
        Select
            Count(*)
        Into
            v_count
        From
            swp_primary_workspace
        Where
            Trim(empno)                 = Trim(p_empno)
            And Trim(primary_workspace) = 2;

        If v_count = 0 Then
            p_message_type := 'KO';
            p_message_text := 'Invalid employee number ' || p_empno;
            Return;
        End If;

        For i In 1..p_weekly_attendance.count
        Loop

            With
                csv As (
                    Select
                        p_weekly_attendance(i) str
                    From
                        dual
                )
            Select
                Trim(regexp_substr(str, '[^~!~]+', 1, 1))          empno,
                to_date(Trim(regexp_substr(str, '[^~!~]+', 1, 2))) attendance_date,
                Trim(regexp_substr(str, '[^~!~]+', 1, 3))          desk,
                Trim(regexp_substr(str, '[^~!~]+', 1, 4))          status
            Into
                v_empno, v_attendance_date, v_desk, v_status
            From
                csv;

            If v_status = 0 Then
                del_emp_sws_atend_plan(
                    p_empno => v_empno,
                    p_date  => trunc(v_attendance_date)
                );
            End If;

            Delete
                From swp_smart_attendance_plan
            Where
                empno               = v_empno
                And attendance_date = v_attendance_date;

            If v_status = '1' Then

                v_pk := dbms_random.string('X', 10);

                Select
                    key_id
                Into
                    v_fk
                From
                    swp_primary_workspace
                Where
                    Trim(empno)                 = Trim(p_empno)
                    And Trim(primary_workspace) = '2';

                Insert Into swp_smart_attendance_plan
                (
                    key_id,
                    ws_key_id,
                    empno,
                    attendance_date,
                    deskid,
                    modified_on,
                    modified_by,
                    week_key_id
                )
                Values
                (
                    v_pk,
                    v_fk,
                    v_empno,
                    v_attendance_date,
                    v_desk,
                    sysdate,
                    v_mod_by_empno,
                    rec_config_week.key_id
                );
                If iot_swp_common.is_desk_in_general_area(v_desk) Then

                    iot_swp_dms.sp_clear_desk(
                        p_person_id => Null,
                        p_meta_id   => p_meta_id,

                        p_deskid    => v_desk

                    );

                    iot_swp_dms.sp_lock_desk(
                        p_person_id => Null,
                        p_meta_id   => Null,

                        p_deskid    => v_desk
                    );
                End If;
            End If;

        End Loop;
        Commit;

        p_message_type := 'OK';
        p_message_text := 'Procedure executed successfully.';
    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;

    End sp_add_weekly_atnd;

    Procedure sp_smart_ws_weekly_summary(
        p_person_id                     Varchar2,
        p_meta_id                       Varchar2,

        p_assign_code                   Varchar2,
        p_date                          Date,

        p_emp_count_smart_workspace Out Number,
        p_emp_count_mon             Out Number,
        p_emp_count_tue             Out Number,
        p_emp_count_wed             Out Number,
        p_emp_count_thu             Out Number,
        p_emp_count_fri             Out Number,
        p_costcode_desc             Out Varchar2,
        p_message_type              Out Varchar2,
        p_message_text              Out Varchar2
    ) As
        v_start_date Date;
        v_end_date   Date;
        Cursor cur_summary(cp_start_date Date,
                           cp_end_date   Date) Is
            Select
                attendance_day, Count(empno) emp_count
            From
                (
                    Select
                        e.empno, to_char(attendance_date, 'DY') attendance_day
                    From
                        ss_emplmast               e,
                        swp_smart_attendance_plan wa
                    Where
                        e.assign    = p_assign_code
                        And attendance_date Between cp_start_date And cp_end_date
                        And e.empno = wa.empno(+)
                        And status  = 1
                        And emptype In (
                            Select
                                emptype
                            From
                                swp_include_emptype
                        )
                )
            Group By
                attendance_day;

    Begin
        v_start_date   := iot_swp_common.get_monday_date(p_date);
        v_end_date     := iot_swp_common.get_friday_date(p_date);
        Select
            costcode || ' - ' || name
        Into
            p_costcode_desc
        From
            ss_costmast
        Where
            costcode = p_assign_code;

        For c1 In cur_summary(v_start_date, v_end_date)
        Loop
            If c1.attendance_day = 'MON' Then
                p_emp_count_mon := c1.emp_count;
            Elsif c1.attendance_day = 'TUE' Then
                p_emp_count_tue := c1.emp_count;
            Elsif c1.attendance_day = 'WED' Then
                p_emp_count_wed := c1.emp_count;
            Elsif c1.attendance_day = 'THU' Then
                p_emp_count_thu := c1.emp_count;
            Elsif c1.attendance_day = 'FRI' Then
                p_emp_count_fri := c1.emp_count;
            End If;
        End Loop;

        --Total Count
        Select
            --e.empno, emptype, status, aw.primary_workspace
            Count(*)
        Into
            p_emp_count_smart_workspace
        From
            ss_emplmast           e,
            swp_primary_workspace aw

        Where
            e.assign                 = p_assign_code
            And e.empno              = aw.empno
            And status               = 1
            And emptype In (
                Select
                    emptype
                From
                    swp_include_emptype
            )
            And aw.primary_workspace = 2
            And
            trunc(aw.start_date)     = (
                    Select
                        Max(trunc(start_date))
                    From
                        swp_primary_workspace b
                    Where
                        b.empno = aw.empno
                        And b.start_date <= v_end_date
                );

        /*

                Select
                    Count(*)
                Into
                    p_emp_count_smart_workspace
                From
                    swp_primary_workspace
                Where
                    primary_workspace = 2
                    And empno In (
                        Select
                            empno
                        From
                            ss_emplmast
                        Where
                            status     = 1
                            And assign = p_assign_code
                    );
        */
        p_message_type := 'OK';
        p_message_text := 'Procedure executed successfully.';
    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
    End;

End iot_swp_smart_workspace;
/
---------------------------
--Changed PACKAGE BODY
--IOT_SWP_DMS_REP_QRY
---------------------------
CREATE OR REPLACE PACKAGE BODY "SELFSERVICE"."IOT_SWP_DMS_REP_QRY" As
    e_employee_not_found Exception;
    Pragma exception_init(e_employee_not_found, -20001);

    Function fn_emp_with_home_pc_4hodsec(
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

        Open c For
        select * from (
            Select
                a.empno as empno,
                a.name as employee_name,
                a.parent as parent,
                a.emptype as emptype,
                a.grade as emp_grade,
                a.is_swp_eligible as is_swp_eligible,
                a.is_laptop_user as is_laptop_user,
                a.present_count as present_count,
                Row_Number() Over (Order By parent)   As row_number,
                Count(*) Over () As total_row
            From
                (

                    Select
                        *
                    From
                        (
                            Select
                                empno, name, parent, grade, emptype, is_swp_eligible, is_laptop_user, Sum(is_present) present_count
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
                                                        iot_swp_common.is_emp_laptop_user(e.empno)      is_laptop_user
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
                            Group By empno, name, parent, grade, emptype, is_swp_eligible, is_laptop_user
                            order by parent
                        )
                    Where
                        present_count < 3

                ) a) where row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length);
        Return c;
    End;

    Function fn_emp_with_home_pc_4admin(
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
        Open c For

            Select
                um.empno, e.name, e.parent, e.grade, e.emptype, da.assetid, da.deskid
            From
                dms.dm_deskallocation da,
                dms.dm_usermaster     um,
                ss_emplmast           e
            Where
                da.deskid Like 'H%'
                And da.deskid = um.deskid
                And um.empno  = e.empno;
        Return c;
    End;

End iot_swp_dms_rep_qry;
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
                planning_flag     = c_planning_future
                And planning_open = c_planning_is_open;
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
                v_ows_desk_id := iot_swp_common.get_desk_from_dms(v_empno);
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


End iot_swp_primary_workspace;
/
---------------------------
--Changed PACKAGE BODY
--IOT_SWP_SELECT_LIST_QRY
---------------------------
CREATE OR REPLACE PACKAGE BODY "SELFSERVICE"."IOT_SWP_SELECT_LIST_QRY" As

    Function fn_desk_list_for_smart(
        p_person_id Varchar2,
        p_meta_id   Varchar2,
        p_date      Date,
        p_empno     Varchar2
    ) Return Sys_Refcursor As
        c                 Sys_Refcursor;
        v_empno           Varchar2(5);
        timesheet_allowed Number;
        c_permanent_desk  Constant Number := 1;
    Begin
        --v_empno := get_empno_from_meta_id(p_meta_id);
        Open c For
            Select
                deskid                             data_value_field,
                rpad(deskid, 7, ' ') || ' | ' ||
                rpad(office, 5, ' ') || ' | ' ||
                rpad(nvl(floor, ' '), 6, ' ') || ' | ' ||
                rpad(nvl(wing, ' '), 5, ' ') || ' | ' ||
                rpad(nvl(bay, ' '), 9, ' ') || ' | ' ||
                rpad(nvl(work_area, ' '), 15, ' ') As data_text_field
            From
                dm_vu_desk_list
            Where
                office Not Like 'Home%'
                And office Like 'MOC1%'
                And nvl(cabin, 'X') <> 'C'
                --and nvl(desk_share_type,-10) = c_permanent_desk --Permanent
                And Trim(deskid) Not In (
                    Select
                        deskid
                    From
                        swp_smart_attendance_plan
                    Where
                        trunc(attendance_date) = trunc(p_date)
                        And empno != Trim(p_empno)
                    Union
                    Select
                        deskid
                    From
                        dm_vu_emp_desk_map_swp_plan
                )
            Order By
                office;

        Return c;
    End fn_desk_list_for_smart;

    Function fn_desk_list_for_office(
        p_person_id Varchar2,
        p_meta_id   Varchar2,
        p_date      Date Default Null,
        p_empno     Varchar2
    ) Return Sys_Refcursor As
        c                 Sys_Refcursor;
        v_empno           Varchar2(5);
        c_permanent_desk  Constant Number := 1;
        timesheet_allowed Number;
    Begin
        Open c For

            Select
                deskid                             data_value_field,
                rpad(deskid, 7, ' ') || ' | ' ||
                rpad(office, 5, ' ') || ' | ' ||
                rpad(nvl(floor, ' '), 6, ' ') || ' | ' ||
                rpad(nvl(wing, ' '), 5, ' ') || ' | ' ||
                rpad(nvl(bay, ' '), 9, ' ') || ' | ' ||
                rpad(nvl(work_area, ' '), 15, ' ') As data_text_field
            From
                dms.dm_deskmaster dms
            Where
                office Not Like 'Home%'
                And nvl(cabin, 'X') <> 'C'
                --and nvl(desk_share_type,-10) = c_permanent_desk --Permanent
                And dms.deskid Not In
                (
                    Select
                    Distinct dmst.deskid
                    From
                        dm_vu_emp_desk_map_swp_plan dmst
                )
                And dms.deskid Not In
                (
                    Select
                    Distinct swp_wfm.deskid
                    From
                        swp_smart_attendance_plan swp_wfm
                    Where
                        trunc(swp_wfm.attendance_date) >= trunc(sysdate)
                )
            Order By
                office,
                deskid;

        Return c;
    End fn_desk_list_for_office;

    Function fn_employee_list_4_hod_sec(
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
                empno                  data_value_field,
                empno || ' - ' || name data_text_field
            From
                ss_emplmast
            Where
                status = 1
                And assign In (
                    Select
                        parent
                    From
                        ss_user_dept_rights
                    Where
                        empno = v_empno
                    Union
                    Select
                        costcode
                    From
                        ss_costmast
                    Where
                        hod = v_empno
                )
                And assign Not In (
                    Select
                        assign
                    From
                        swp_exclude_assign
                )
            Order By
                empno;

        Return c;
    End;

    Function fn_emp_list4plan_4_hod_sec(
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
                empno                  data_value_field,
                empno || ' - ' || name data_text_field
            From
                ss_emplmast
            Where
                status = 1
                And assign In (
                    Select
                        parent
                    From
                        ss_user_dept_rights                                   a, swp_include_assign_4_seat_plan b
                    Where
                        empno        = v_empno
                        And a.parent = b.assign
                    Union
                    Select
                        costcode
                    From
                        ss_costmast                                   a, swp_include_assign_4_seat_plan b
                    Where
                        hod            = v_empno
                        And a.costcode = b.assign
                )
                And assign Not In (
                    Select
                        assign
                    From
                        swp_exclude_assign
                )
            Order By
                empno;

        Return c;
    End;

    Function fn_costcode_list_4_hod_sec(
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
                costcode                  data_value_field,
                costcode || ' - ' || name data_text_field
            From
                ss_costmast
            Where
                costcode In (
                    Select
                        parent
                    From
                        ss_user_dept_rights a
                    Where
                        empno = v_empno
                    Union
                    Select
                        costcode
                    From
                        ss_costmast a
                    Where
                        hod = v_empno
                )
                And costcode Not In (
                    Select
                        assign
                    From
                        swp_exclude_assign
                )
                And noofemps > 0
            Order By
                costcode;

        Return c;
    End;

    Function fn_dept_list4plan_4_hod_sec(
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
                costcode                  data_value_field,
                costcode || ' - ' || name data_text_field
            From
                ss_costmast
            Where
                costcode In (
                    Select
                        parent
                    From
                        ss_user_dept_rights                                   a, swp_include_assign_4_seat_plan b
                    Where
                        empno        = v_empno
                        And a.parent = b.assign
                    Union
                    Select
                        costcode
                    From
                        ss_costmast                                   a, swp_include_assign_4_seat_plan b
                    Where
                        hod            = v_empno
                        And a.costcode = b.assign
                )
                And costcode Not In (
                    Select
                        assign
                    From
                        swp_exclude_assign
                )
                And noofemps > 0
            Order By
                costcode;

        Return c;
    End;

    Function fn_employee_type_list(
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
                a.emptype                     data_value_field,
                a.emptype || ' - ' || empdesc data_text_field
            From
                ss_vu_emptypes      a,
                swp_include_emptype b
            Where
                a.emptype = b.emptype
            Order By
                empdesc;
        Return c;
    End;

    Function fn_grade_list(
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
                grade_id   data_value_field,
                grade_desc data_text_field
            From
                ss_vu_grades
            Where
                grade_id <> '-'
            Order By
                grade_desc;
        -- select grade_id data_value_field, grade_desc data_text_field 
        -- from timecurr.hr_grade_master order by grade_desc;
        Return c;
    End;

    Function fn_project_list(
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
                projno                  data_value_field,
                projno || ' - ' || name data_text_field
            From
                ss_projmast
            Where
                active = 1
            Order By
                projno,
                name;

        Return c;
    End;

    Function fn_costcode_list_4_admin(
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
                costcode                  data_value_field,
                costcode || ' - ' || name data_text_field
            From
                ss_costmast
            Where
                costcode Not In (
                    Select
                        assign
                    From
                        swp_exclude_assign
                )
                And noofemps > 0
            Order By
                costcode;
        Return c;
    End;

End iot_swp_select_list_qry;
/
---------------------------
--Changed PACKAGE BODY
--IOT_SWP_OFFICE_WORKSPACE_QRY
---------------------------
CREATE OR REPLACE PACKAGE BODY "SELFSERVICE"."IOT_SWP_OFFICE_WORKSPACE_QRY" As

    Function fn_office_planning(
        p_person_id              Varchar2,
        p_meta_id                Varchar2,
        p_date                   Date,
        p_assign_code            Varchar2 Default Null,

        p_emptype_csv            Varchar2 Default Null,
        p_grade_csv              Varchar2 Default Null,
        p_generic_search         Varchar2 Default Null,
        p_desk_assignment_status Varchar2 Default Null,

        p_row_number             Number,
        p_page_length            Number

    ) Return Sys_Refcursor As
        c                     Sys_Refcursor;
        v_hod_sec_empno       Varchar2(5);
        e_employee_not_found  Exception;
        Pragma exception_init(e_employee_not_found, -20001);
        v_query               Varchar2(6000);
        v_hod_sec_assign_code Varchar2(4);
    Begin

        v_query               := c_qry_office_planning;

        v_hod_sec_empno       := get_empno_from_meta_id(p_meta_id);
        If v_hod_sec_empno = 'ERRRR' Then
            Raise e_employee_not_found;
        End If;

        v_hod_sec_assign_code := iot_swp_common.get_default_dept4plan_hod_sec(
                                     p_hod_sec_empno => v_hod_sec_empno,
                                     p_assign_code   => p_assign_code
                                 );

        If p_grade_csv Is Not Null Then
            v_query := replace(v_query, '!GRADES_SUBQUERY!', sub_qry_grades_csv);
        Else
            v_query := replace(v_query, '!GRADES_SUBQUERY!', '');
        End If;

        If p_emptype_csv Is Not Null Then
            v_query := replace(v_query, '!EMPTYPE_SUBQUERY!', sub_qry_emptype_csv);
        Else
            v_query := replace(v_query, '!EMPTYPE_SUBQUERY!', sub_qry_emptype_default);
        End If;

        If Trim(p_generic_search) Is Not Null Then
            v_query := replace(v_query, '!GENERIC_SEARCH!', where_clause_generic_search);
        Else
            v_query := replace(v_query, '!GENERIC_SEARCH!', '');
        End If;

        If p_desk_assignment_status = 'Pending' Then
            v_query := replace(v_query, '!DESK_ASSIGNMENT_STATUS!', ' where deskid is null ');
        Elsif p_desk_assignment_status = 'Assigned' Then
            v_query := replace(v_query, '!DESK_ASSIGNMENT_STATUS!', ' where deskid is not null ');
        Else
            v_query := replace(v_query, '!DESK_ASSIGNMENT_STATUS!', '');
        End If;

        /*
                Insert Into swp_mail_log (subject, mail_sent_to_cc_bcc, modified_on)
                Values (v_empno || '-' || p_row_number || '-' || p_page_length || '-' || to_char(v_start_date, 'yyyymmdd') || '-' ||
                    to_char(v_end_date, 'yyyymmdd'),
                    v_query, sysdate);
                Commit;
          */
        Open c For v_query Using
            p_person_id,
            p_meta_id,
            p_row_number,
            p_page_length,

            v_hod_sec_assign_code,
            p_emptype_csv,
            p_grade_csv,
            '%' || upper(trim(p_generic_search)) || '%',
            p_desk_assignment_status;
        Return c;

    End;

    Function fn_general_area_list(
        p_person_id   Varchar2,
        p_meta_id     Varchar2,
        p_empno       Varchar2 Default Null,
        p_date        Date     Default Null,

        p_row_number  Number,
        p_page_length Number
    ) Return Sys_Refcursor As
        c                      Sys_Refcursor;
        v_count                Number;
        v_empno                Varchar2(5);
        e_employee_not_found   Exception;
        Pragma exception_init(e_employee_not_found, -20001);
        c_restricted_area_catg Constant Varchar2(4) := 'A003';
        v_emp_area_code        Varchar2(3);
    Begin
        v_emp_area_code := iot_swp_common.get_emp_work_area_code(p_empno);
        Open c For
            With
                desk_list As (
                    Select
                        *
                    From
                        dm_vu_desk_list  dl,
                        dm_vu_desk_areas da
                    Where
                        da.area_key_id        = dl.work_area
                        And (da.area_catg_code != c_restricted_area_catg
                            Or da.area_key_id = v_emp_area_code
                        )
                        And deskid Not In(
                            Select
                                deskid
                            From
                                dm_vu_desk_lock_swp_plan
                        )
                )
            Select
                *
            From
                (
                    Select
                        a.*,
                        a.total_count - a.occupied_count                            As available_count,
                        Row_Number() Over (Order By area_desc, office, wing, floor) As row_number,
                        Count(*) Over ()                                            As total_row
                    From
                        (
                            Select
                                d.work_area,
                                d.area_catg_code,
                                d.area_desc,
                                d.office,
                                d.floor,
                                d.wing,
                                Count(d.deskid) total_count,
                                Count(ed.empno) occupied_count
                            From
                                desk_list          d,
                                DM_VU_EMP_DESK_MAP_SWP_PLAN ed
                            Where
                                d.deskid = ed.deskid(+)
                            Group By office, wing, floor, work_area, area_desc, area_catg_code
                            Order By area_desc, office, wing, floor
                        ) a
                )
            Where
                row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length);
        Return c;
    End fn_general_area_list;

    Function fn_work_area_desk(
        p_person_id   Varchar2,
        p_meta_id     Varchar2,

        p_date        Date,
        p_work_area   Varchar2,
        p_office      Varchar2 Default Null,
        p_floor       Varchar2 Default Null,
        p_wing        Varchar2 Default Null,

        p_row_number  Number,
        p_page_length Number
    ) Return Sys_Refcursor As
        c                    Sys_Refcursor;
        v_empno              Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
        v_office             dm_vu_desk_list.office%Type;
        v_floor              dm_vu_desk_list.floor%Type;
        v_wing               dm_vu_desk_list.wing%Type;
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;

        If p_office Is Null Then
            v_office := '%';
        Else
            v_office := p_office;
        End If;

        If p_floor Is Null Then
            v_floor := '%';
        Else
            v_floor := p_floor;
        End If;

        If p_wing Is Null Then
            v_wing := '%';
        Else
            v_wing := p_wing;
        End If;

        Open c For
            Select
                *
            From
                (
                    Select
                        mast.deskid                              As deskid,
                        mast.office                              As office,
                        mast.floor                               As floor,
                        mast.seatno                              As seat_no,
                        mast.wing                                As wing,
                        mast.assetcode                           As asset_code,
                        mast.bay                                 As bay,
                        Row_Number() Over (Order By deskid Desc) row_number,
                        Count(*) Over ()                         total_row
                    From
                        dms.dm_deskmaster mast
                    Where
                        mast.work_area = Trim(p_work_area)
                        And mast.office Like v_office
                        And mast.floor Like v_floor
                        And nvl(mast.wing, '-') Like v_wing

                        And mast.deskid
                        Not In(
                            Select
                                swptbl.deskid
                            From
                                swp_smart_attendance_plan swptbl
                            --where (trunc(ATTENDANCE_DATE) = TRUNC(p_date) or p_date is null)
                            Union
                            Select
                                c.deskid
                            From
                                DM_VU_EMP_DESK_MAP_SWP_PLAN c
                            Union
                            Select
                                deskid
                            From
                                dm_vu_desk_lock_swp_plan
                        )
                )
            Where
                row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length)
            Order By
                deskid,
                seat_no;
        Return c;
    End fn_work_area_desk;

End iot_swp_office_workspace_qry;
/
---------------------------
--Changed PACKAGE BODY
--IOT_SWP_DMS
---------------------------
CREATE OR REPLACE PACKAGE BODY "SELFSERVICE"."IOT_SWP_DMS" As

    /*  p_unqid := 'SWPF'  -- fixed desk
        p_unqid := 'SWPV'  -- variable desk     */

    c_empno_swpv       Constant Varchar2(4)  := 'SWPV';
    c_blockdesk_4_swpv Constant Number(1)    := 7;
    c_unqid_swpv       Constant Varchar2(20) := 'Desk block SWPV';


    Procedure sp_add_desk_user(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_empno            Varchar2,
        p_deskid           Varchar2,
        p_parent           Varchar2,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_exists Number;
    Begin
        If Not iot_swp_common.fn_can_do_desk_plan_4_emp(p_empno) Then
            p_message_type := 'KO';
            p_message_text := 'Planning not allowed for employee assign code.';
            Return;
        End If;
        Select
            Count(du.empno)
        Into
            v_exists
        From
            dms.dm_usermaster_swp_plan du
        Where
            du.empno        = p_empno
            And du.deskid   = p_deskid
            And du.costcode = p_parent;

        If v_exists = 0 Then
            Insert Into dms.dm_usermaster_swp_plan(empno, deskid, costcode, dep_flag)
            Values
                (p_empno, p_deskid, p_parent, 0);
        Else
            p_message_type := 'KO';
            p_message_text := 'Err : User already assigned desk in DMS';
            Return;
        End If;
        p_message_type := 'OK';
        p_message_text := 'Procedure executed successfully.';
    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'Err - ' || sqlcode || ' - ' || sqlerrm;

    End sp_add_desk_user;

    Procedure sp_remove_desk_user(
        p_person_id Varchar2,
        p_meta_id   Varchar2,

        p_empno     Varchar2,
        p_deskid    Varchar2
    ) As
        v_pk              Varchar2(20);
        v_create_by_empno Varchar2(5);
    Begin

        If Not iot_swp_common.fn_can_do_desk_plan_4_emp(p_empno) Then
            Return;
        End If;

        v_create_by_empno := get_empno_from_meta_id(p_meta_id);

        Delete
            From dms.dm_usermaster_swp_plan du
        Where
            du.empno      = p_empno
            And du.deskid = p_deskid;
        /*
        If p_unqid = 'SWPV' Then
            --send assets to orphan table

            v_pk := dbms_random.string('X', 20);

            Insert Into dms.dm_orphan_asset(unqid, empno, deskid, assetid, createdon, createdby, confirmed)
            Select
                v_pk,
                p_empno,
                deskid,
                assetid,
                sysdate,
                v_create_by_empno,
                0
            From
                dms.dm_deskallocation
            Where
                deskid = p_deskid;

            -- release assets of desk from dm_deskallocation table 

            Delete
                From dms.dm_deskallocation
            Where
                deskid = p_deskid;
        End If;
        */
    End sp_remove_desk_user;

    Procedure sp_lock_desk(
        p_person_id Varchar2,
        p_meta_id   Varchar2,

        p_deskid    Varchar2
    ) As
        v_exists Number;
    Begin
        return;
        Select
            Count(dl.empno)
        Into
            v_exists
        From
            dms.dm_desklock_swp_plan dl
        Where
            dl.empno      = c_empno_swpv
            And dl.deskid = p_deskid;

        If v_exists = 0 Then
            Insert Into dms.dm_desklock_swp_plan(unqid, empno, deskid, targetdesk, blockflag, blockreason)
            Values
                (c_unqid_swpv, c_empno_swpv, p_deskid, 0, 1, c_blockdesk_4_swpv);
        Else
            Update
                dms.dm_desklock_swp_plan
            Set
                unqid = c_unqid_swpv,
                targetdesk = 0,
                blockflag = 1,
                blockreason = c_blockdesk_4_swpv
            Where
                empno      = c_empno_swpv
                And deskid = p_deskid;
        End If;
    End sp_lock_desk;

    Procedure sp_unlock_desk(
        p_person_id   Varchar2,
        p_meta_id     Varchar2,

        p_deskid      Varchar2,
        p_week_key_id Varchar2
    ) As
        v_count Number;
    Begin

        return;
        Select
            Count(*)
        Into
            v_count
        From
            swp_smart_attendance_plan
        Where
            Trim(deskid)    = Trim(p_deskid)
            And week_key_id = p_week_key_id;

        --
        If v_count > 0 Then
            Return;
        End If;
        Delete
            From dms.dm_desklock_swp_plan dl
        Where
            Trim(dl.empno)      = Trim(c_empno_swpv)
            And Trim(dl.deskid) = Trim(p_deskid)
            And Trim(dl.unqid)  = Trim(c_unqid_swpv);
    End sp_unlock_desk;

    Procedure sp_clear_desk(
        p_person_id Varchar2,
        p_meta_id   Varchar2,

        p_deskid    Varchar2
    ) As
        v_pk              Varchar2(20);
        v_create_by_empno Varchar2(5);
    Begin
        return;
        v_create_by_empno := get_empno_from_meta_id(p_meta_id);

        /* send assets to orphan table */

        v_pk              := dbms_random.string('X', 20);

        Insert Into dms.dm_orphan_asset(unqid, empno, deskid, assetid, createdon, createdby, confirmed)
        Select
            v_pk,
            '',
            deskid,
            assetid,
            sysdate,
            v_create_by_empno,
            0
        From
            dms.dm_deskallocation_swp_plan
        Where
            deskid = p_deskid;

        /* release assets of desk from dm_deskallocation table */

        Delete
            From dms.dm_deskallocation_swp_plan
        Where
            deskid = p_deskid;

    End sp_clear_desk;

End iot_swp_dms;
/
---------------------------
--Changed PACKAGE BODY
--IOT_HOLIDAY_QRY
---------------------------
CREATE OR REPLACE PACKAGE BODY "SELFSERVICE"."IOT_HOLIDAY_QRY" As

   Function get_holiday_attendance(
      p_empno       Varchar2,
      p_start_date  Date,
      p_end_date    Date,
      p_row_number  Number,
      p_page_length Number
   ) Return Sys_Refcursor As
      c Sys_Refcursor;
   Begin
      Open c For
         Select *
           From (
                   Select to_char(app_date, 'dd-Mon-yyyy') As applied_on,
                          a.app_no As app_no,
                          a.description As description,
                          get_emp_name(lead_apprl_empno) As lead_name,
                          a.lead_apprldesc As lead_approval,
                          a.hod_apprldesc As hod_approval,
                          a.hrd_apprldesc As hr_approval,
                          a.lead_reason As lead_remarks,
                          a.pdate As holiday_attendance_date,
                          Case
                             When (a.pdate < sysdate)
                                Or (a.hod_apprl > 0)
                             Then
                                1
                             Else
                                0
                          End delete_allowed,
                          Row_Number() Over (Order By app_date Desc) row_number,
                          Count(*) Over () total_row
                     From ss_ha_app_stat a
                    Where empno = p_empno
                      And a.app_date >= nvl(p_start_date, add_months(sysdate, - 3))
                      And trunc(a.app_date) <= nvl(p_end_date, trunc(a.app_date))
                    -- empno = p_empno And a.app_date >= add_months(sysdate, - 3)
                    Order By pdate Desc
                )
          Where row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length);

      Return c;

   End;

   Function fn_holiday_attendance(
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
      c       := get_holiday_attendance(v_empno, p_start_date, p_end_date, p_row_number, p_page_length);
      Return c;
   End fn_holiday_attendance;

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
         Select *
           From (
                   Select to_char(app_date, 'dd-Mon-yyyy') As Application_Date,
                          a.app_no As Application_Id,
                          A.empno As Empno,
                          B.Name As Emp_Name,
                          A.PROJNO As Project,
                          GetEmpName(A.Lead_Apprl_EmpNo) As Lead_Name,
                          to_char(A.Pdate, 'dd-Mon-yyyy') ||'  '||A.START_HH
                          || ':'
                          || A.START_MM
                          || ' To '
                          || A.END_HH
                          || ':'
                          || A.END_MM As Attendance_Date,
                          A.location As office,
                          A.LEAD_REASON As Lead_remarks,
                          B.Parent As Parent,
                          Row_Number() Over (Order By a.app_date) As row_number,
                          Count(*) Over () As total_row
                     From SS_Holiday_Attendance A, SS_EmplMast B
                    Where A.EmpNo = B.EmpNo
                      And (nvl(Lead_apprl, 0) = 0)
                      And (nvl(Hrd_apprl, 0) = 0)
                      And (nvl(Hod_apprl, 0) = 0)
                      And Lead_Apprl_EmpNo = Trim(v_lead_empno)
                    Order By Parent, A.empno
                )
          Where row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length);
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
         Select *
           From (
                   Select to_char(app_date, 'dd-Mon-yyyy') As Application_Date,
                          a.app_no As Application_Id,
                          A.empno As Empno,
                          B.Name As Emp_Name,
                          A.PROJNO As Project,
                          GetEmpName(A.Lead_Apprl_EmpNo) As Lead_Name,
                          to_char(A.Pdate, 'dd-Mon-yyyy') ||'  '||A.START_HH
                          || ':'
                          || A.START_MM
                          || ' To '
                          || A.END_HH
                          || ':'
                          || A.END_MM As Attendance_Date,
                          A.location As office,
                          A.HODREASON As hod_remarks,
                          B.Parent As Parent,
                          Row_Number() Over (Order By a.app_date) As row_number,
                          Count(*) Over () As total_row
                     From SS_Holiday_Attendance A, SS_EmplMast B
                    Where (nvl(Lead_apprl, 0) In (1, 4))
                      And (nvl(Hrd_apprl, 0) = 0)
                      And (nvl(Hod_apprl, 0) = 0)
                      And A.EmpNo = B.EmpNo
                      And A.EmpNo In (Select empno From SS_EmplMast Where Mngr = Trim(v_hod_empno))
                    Order By Parent, A.empno
                )
          Where row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length);
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
         Select *
           From (
                   Select to_char(app_date, 'dd-Mon-yyyy') As Application_Date,
                          a.app_no As Application_Id,
                          A.empno As Empno,
                          B.Name As Emp_Name,
                          A.PROJNO As Project,
                          GetEmpName(A.Lead_Apprl_EmpNo) As Lead_Name,
                          to_char(A.Pdate, 'dd-Mon-yyyy') ||'  '||A.START_HH
                          || ':'
                          || A.START_MM
                          || ' To '
                          || A.END_HH
                          || ':'
                          || A.END_MM As Attendance_Date,
                          A.location As office,
                          A.HODREASON As hod_remarks,
                          B.Parent As Parent,
                          Row_Number() Over (Order By a.app_date) As row_number,
                          Count(*) Over () As total_row
                     From SS_Holiday_Attendance A, SS_EmplMast B
                    Where (NVL(Lead_apprl, 0) In (1, 4))
                      And (NVL(Hrd_apprl, 0) = 0)
                      And (NVL(Hod_apprl, 0) = 0)
                      And A.EmpNo = B.EmpNo
                      And A.EmpNo In
                          (
                             Select empno
                               From SS_EmplMast
                              Where Mngr In
                                    (Select Mngr From SS_Delegate Where empno = Trim(v_hod_empno)
                                    )
                          )
                    Order By Parent, A.empno
                )
          Where row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length);
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
         Select *
           From (
                  Select to_char(app_date, 'dd-Mon-yyyy') As Application_Date,
                          a.app_no As Application_Id,
                          A.empno As Empno,
                          B.Name As Emp_Name,
                          A.PROJNO As Project,
                          GetEmpName(A.Lead_Apprl_EmpNo) As Lead_Name,
                          to_char(A.Pdate, 'dd-Mon-yyyy') ||'  '||A.START_HH
                          || ':'
                          || A.START_MM
                          || ' To '
                          || A.END_HH
                          || ':'
                          || A.END_MM As Attendance_Date,
                          A.location As office,
                          A.HRDREASON As Hr_remarks,
                          B.Parent As Parent,
                          Row_Number() Over (Order By a.app_date) As row_number,
                          Count(*) Over () As total_row
                     From SS_Holiday_Attendance A, SS_EmplMast B
                    Where (nvl(Lead_apprl, 0) In (1, 4))
                      And (nvl(Hod_apprl, 0) = 1)
                      And A.EmpNo = B.EmpNo
                      And (nvl(Hrd_apprl, 0) = 0)
                    Order By Parent, A.empno

                )
          Where row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length);
      Return c;
   End fn_pending_hr_approval;

Procedure sp_holiday_details(
          p_person_id            Varchar2,
          p_meta_id              Varchar2,

          p_Application_Id       Varchar2,

          P_Employee            Out Varchar2,
          P_PROJNO           Out Varchar2,
          P_Lead_Name        Out Varchar2,
          P_Attendance_Date  Out Varchar2,
          P_Punch_In_Time    Out Varchar2,
          P_Punch_Out_Time   Out Varchar2,
          P_REMARKS          Out Varchar2,
          P_Office           Out Varchar2,
          P_LEAD_APPRL       Out Varchar2,
          P_LEAD_APPRL_DATE  Out Varchar2,
          P_LEAD_APPRL_EMPNO Out Varchar2,
          P_HOD_APPRL        Out Varchar2,
          P_HOD_APPRL_DATE   Out Varchar2,
          P_HR_APPRL         Out Varchar2,
          P_HR_APPRL_DATE    Out Varchar2,
          P_DESCRIPTION      Out Varchar2,
          P_Application_Date Out Varchar2,
          P_HOD_Remarks      Out Varchar2,
          P_Hr_Remarks       Out Varchar2,
          P_Lead_Remarks     Out Varchar2,

          p_message_type     Out Varchar2,
          p_message_text     Out Varchar2
   ) As
   v_empno        Varchar2(5);
   v_user_tcp_ip  Varchar2(5) := 'NA';
   v_message_type Number      := 0;
Begin
   v_empno        := get_empno_from_meta_id(p_meta_id);

   If v_empno = 'ERRRR' Then
      p_message_type := 'KO';
      p_message_text := 'Invalid employee number';
      Return;
   End If;

   Select A.EMPNO ||' - ' ||GetEmpName(A.EMPNO) As Employee,
          A.PROJNO As PROJNO,
          GetEmpName(A.Lead_Apprl_EmpNo) As Lead_Name,
          to_char(A.PDATE, 'dd-Mon-yyyy') As Attendance_Date,
          to_char(A.START_HH)
          || ':'
          || to_char(A.START_MM) As Punch_In_Time,
          to_char(A.END_HH)
          || ':'
          || to_char(A.END_MM) As Punch_Out_Time,
          A.REMARKS As,
          A.LOCATION As office,
          Case A.LEAD_APPRL 
               when 0 then 'Pending'
               when 1 then 'Approved'
               when 2 then 'Rejected'
               Else '' end  As Lead_Apprl,
          to_char(A.LEAD_APPRL_DATE, 'dd-Mon-yyyy') As LEAD_APPRL_DATE,
          A.LEAD_APPRL_EMPNO As LEAD_APPRL_EMPNO,
          Case A.HOD_APPRL 
               when 0 then 'Pending'
               when 1 then 'Approved'
               when 2 then 'Rejected'
               Else '' end As HOD_APPRL,
          to_char(A.HOD_APPRL_DATE, 'dd-Mon-yyyy') As HOD_APPRL_DATE,
          Case A.HRD_APPRL 
               when 0 then 'Pending'
               when 1 then 'Approved'
               when 2 then 'Rejected'
               Else '' end  As HR_APPRL,
          to_char(A.HRD_APPRL_DATE, 'dd-Mon-yyyy') As HR_APPRL_DATE,
          A.DESCRIPTION As DESCRIPTION,
          to_char(A.app_date, 'dd-Mon-yyyy') As Application_Date,
          A.HODREASON As HOD_Remarks,
          A.HRDREASON As Hr_Remarks,
          A.LEAD_REASON As Lead_Remarks
     Into P_Employee,
          P_PROJNO,
          P_Lead_Name,
          P_Attendance_Date,
          P_Punch_In_Time,
          P_Punch_Out_Time,
          P_REMARKS,
          P_Office,
          P_LEAD_APPRL,
          P_LEAD_APPRL_DATE,
          P_LEAD_APPRL_EMPNO,
          P_HOD_APPRL,
          P_HOD_APPRL_DATE,
          P_HR_APPRL,
          P_HR_APPRL_DATE,
          P_DESCRIPTION,
          P_Application_Date,
          P_HOD_Remarks,
          P_Hr_Remarks,
          P_Lead_Remarks
     From SS_HOLIDAY_ATTENDANCE A
    Where A.APP_NO = P_Application_Id;

   p_message_type := 'OK';
   p_message_text := 'Procedure executed successfully.';

   Exception
   When Others Then
      p_message_type := 'KO';
      p_message_text := 'ERR :- '
                           || sqlcode
                           || ' - '
                           || sqlerrm;

End sp_holiday_details;

   --  GRANT EXECUTE ON "IOT_HOLIDAY_QRY" TO "TCMPL_APP_CONFIG";

End iot_holiday_qry;
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
        v_query               Varchar2(6000);
    Begin
        v_friday_date   := iot_swp_common.get_friday_date(nvl(p_start_date, sysdate));

        v_hod_sec_empno := get_empno_from_meta_id(p_meta_id);

        If v_hod_sec_empno = 'ERRRR' Then
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
            End If;
        End If;

        v_query         := query_pws;

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
                        a.grade                                                           As emp_grade,
                        nvl(b.primary_workspace_desc, '')                                 As primary_workspace,
                        Case iot_swp_common.is_emp_eligible_for_swp(a.empno)
                            When 'OK' Then
                                'Yes'
                            Else
                                'No'
                        End                                                               As is_eligible_desc

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
            v_friday_date := iot_swp_common.get_friday_date(nvl(p_start_date, sysdate));

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

End iot_swp_primary_workspace_qry;
/
---------------------------
--Changed PACKAGE BODY
--IOT_SWP_SMART_WORKSPACE_QRY
---------------------------
CREATE OR REPLACE PACKAGE BODY "SELFSERVICE"."IOT_SWP_SMART_WORKSPACE_QRY" As

    c_reserved_catagory    Varchar2(4)          := 'A001';
    c_restricted_area_catg Constant Varchar2(4) := 'A003';
    c_deskblock_4_swpf     Constant Number(1)   := 6;
    c_deskblock_4_swpv     Constant Number(1)   := 7;
    c_deskblock_not_swpf   Constant Number(1)   := -1;
    Function fn_reserved_area_list(
        p_person_id   Varchar2,
        p_meta_id     Varchar2,
        p_date        Date Default Null,

        p_row_number  Number,
        p_page_length Number
    ) Return Sys_Refcursor As
        c                    Sys_Refcursor;
        v_empno              Varchar2(5);
        v_area_catg_code     Constant Varchar2(4) := 'A001';
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
        v_count              Number;
    Begin

        Open c For
            With
                plan As(
                    Select
                        deskid
                    From
                        swp_smart_attendance_plan ap
                    Where
                        ap.attendance_date = p_date
                    Union
                    Select
                        deskid
                    From
                        DM_VU_EMP_DESK_MAP_SWP_PLAN
                )
            Select
                *
            From
                (
                    Select
                        aa.*,
                        aa.total_count - aa.occupied_count As available_count,
                        Row_Number() Over (Order By area_desc,
                                work_area,
                                office,
                                floor,
                                wing)                      row_number,
                        Count(*) Over ()                   total_row

                    From
                        (
                            Select
                                da.area_catg_code area_category,
                                da.area_desc,
                                dl.work_area,
                                dl.office,
                                dl.floor,
                                dl.wing,
                                Count(dl.deskid)  total_count,
                                Count(ap.deskid)  occupied_count
                            From
                                dm_vu_desk_list  dl,
                                dm_vu_desk_areas da,
                                plan             ap
                            Where
                                da.area_key_id        = dl.work_area
                                And da.area_catg_code = c_reserved_catagory
                                And dl.deskid         = ap.deskid(+)
                            Group By da.area_catg_code,
                                da.area_desc,
                                dl.work_area,
                                dl.office,
                                dl.floor,
                                dl.wing
                        ) aa
                )
            Where
                row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length)
            Order By
                area_desc,
                work_area,
                office,
                floor,
                wing;
        Return c;

    End fn_reserved_area_list;

    Function fn_general_area_list(
        p_person_id   Varchar2,
        p_meta_id     Varchar2,
        p_empno       Varchar2 Default Null,
        p_date        Date     Default Null,

        p_row_number  Number,
        p_page_length Number
    ) Return Sys_Refcursor As
        c                    Sys_Refcursor;
        v_count              Number;
        v_empno              Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
        v_emp_area_code      Varchar2(3);
    Begin
        v_emp_area_code := iot_swp_common.get_emp_work_area_code(p_empno);
        Open c For
            With
                desk_list As (
                    Select
                        *
                    From
                        dm_vu_desk_list  dl,
                        dm_vu_desk_areas da
                    Where
                        da.area_key_id        = dl.work_area
                        And (da.area_catg_code != c_restricted_area_catg
                            Or da.area_key_id = v_emp_area_code
                        )
                        And deskid Not In(
                            Select
                                deskid
                            From
                                dm_vu_desk_lock_swp_plan
                            Where
                                blockreason <> c_deskblock_4_swpv

                        )
                        And deskid Not In(
                            Select
                                deskid
                            From
                                swp_smart_attendance_plan ap
                            Where
                                ap.attendance_date = p_date
                        )
                )
            Select
                *
            From
                (
                    Select
                        a.*,
                        a.total_count - a.occupied_count                            As available_count,
                        Row_Number() Over (Order By area_desc, office, wing, floor) As row_number,
                        Count(*) Over ()                                            As total_row
                    From
                        (
                            Select
                                d.work_area,
                                d.area_catg_code area_category,
                                d.area_desc,
                                d.office,
                                d.floor,
                                d.wing,
                                Count(d.deskid)  total_count,
                                Count(ed.empno)  occupied_count
                            From
                                desk_list          d,
                                DM_VU_EMP_DESK_MAP_SWP_PLAN ed
                            Where
                                d.deskid = ed.deskid(+)
                            Group By office, wing, floor, work_area, area_desc, area_catg_code
                            Order By area_desc, office, wing, floor
                        ) a
                )
            Where
                row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length);
        Return c;
    End fn_general_area_list;

    Function fn_work_area_desk(
        p_person_id     Varchar2,
        p_meta_id       Varchar2,

        p_date          Date,
        p_work_area     Varchar2,
        p_area_category Varchar2 Default Null,
        p_office        Varchar2 Default Null,
        p_floor         Varchar2 Default Null,
        p_wing          Varchar2 Default Null,

        p_row_number    Number,
        p_page_length   Number
    ) Return Sys_Refcursor As
        c                        Sys_Refcursor;
        v_empno                  Varchar2(5);
        e_employee_not_found     Exception;
        Pragma exception_init(e_employee_not_found, -20001);
        v_office                 Varchar2(5);
        v_floor                  dm_vu_desk_list.floor%Type;
        v_wing                   dm_vu_desk_list.wing%Type;
        v_exclude_deskblock_type Number(1);

    Begin
        If p_area_category = c_reserved_catagory Then
            v_exclude_deskblock_type := c_deskblock_4_swpf;
        Else
            v_exclude_deskblock_type := c_deskblock_4_swpv;
        End If;

        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;
        If Trim(p_office) Is Null Then
            v_office := '%';
        Else
            v_office := trim(p_office);
        End If;

        If Trim(p_floor) Is Null Then
            v_floor := '%';
        Else
            v_floor := trim(p_floor);
        End If;

        If Trim(p_wing) Is Null Then
            v_wing := '%';
        Else
            v_wing := trim(p_wing);
        End If;

        Open c For
            Select
                *
            From
                (

                    Select
                        mast.deskid                         As deskid,
                        mast.office                         As office,
                        mast.floor                          As floor,
                        mast.seatno                         As seat_no,
                        mast.wing                           As wing,
                        mast.assetcode                      As asset_code,
                        mast.bay                            As bay,
                        da.area_catg_code                   As area_category,
                        Row_Number() Over (Order By deskid) row_number,
                        Count(*) Over ()                    total_row
                    From
                        dm_vu_desk_list  mast,
                        dm_vu_desk_areas da
                    Where
                        mast.work_area     = da.area_key_id
                        And mast.work_area = Trim(p_work_area)

                        And Trim(mast.office) Like v_office
                        And Trim(mast.floor) Like v_floor
                        And nvl(Trim(mast.wing), '-') Like v_wing

                        And mast.deskid
                        Not In(
                            Select
                                swptbl.deskid
                            From
                                swp_smart_attendance_plan swptbl
                            Where
                                (attendance_date) = (p_date)
                            Union
                            Select
                                c.deskid
                            From
                                DM_VU_EMP_DESK_MAP_SWP_PLAN c
                            Union
                            Select
                                deskid
                            From
                                dms.dm_desklock_swp_plan dl
                            Where
                                dl.blockreason <> v_exclude_deskblock_type
                        )
                )
            Where
                row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length)
            Order By
                deskid,
                seat_no;
        Return c;
    End fn_work_area_desk;

    Function fn_restricted_area_list(
        p_person_id   Varchar2,
        p_meta_id     Varchar2,
        p_date        Date Default Null,

        p_row_number  Number,
        p_page_length Number
    ) Return typ_area_list
        Pipelined
    Is
        tab_area_list_ok     typ_area_list;
        v_count              Number;
        v_empno              Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);

    Begin

        Open cur_restricted_area_list(p_date, Null, Null, Null, p_row_number, p_page_length);
        Loop
            Fetch cur_restricted_area_list Bulk Collect Into tab_area_list_ok Limit 50;
            For i In 1..tab_area_list_ok.count
            Loop
                Pipe Row(tab_area_list_ok(i));
            End Loop;
            Exit When cur_restricted_area_list%notfound;
        End Loop;
        Close cur_restricted_area_list;
        Return;

    End fn_restricted_area_list;

    Function fn_emp_week_attend_planning(
        p_person_id Varchar2,
        p_meta_id   Varchar2,
        p_empno     Varchar2,
        p_date      Date
    ) Return Sys_Refcursor As
        c                    Sys_Refcursor;
        v_empno              Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
        v_query              Varchar2(4000);
        v_start_date         Date := iot_swp_common.get_monday_date(trunc(p_date));
        v_end_date           Date := iot_swp_common.get_friday_date(trunc(p_date));
    Begin

        Open c For
            /*
                     With
                        atnd_days As (
                           Select w.empno,
                                  Trim(w.attendance_date) As attendance_date,
                                  Trim(w.deskid) As deskid,
                                  1 As planned
                             From swp_smart_attendance_plan w
                            Where w.empno = p_empno
                              And attendance_date Between v_start_date And v_end_date
                        )

                     Select e.empno As empno,
                            dd.d_day,
                            dd.d_date,
                            nvl(atnd_days.planned, 0) As planned,
                            atnd_days.deskid As deskid
                       From ss_emplmast e,
                            ss_days_details dd,
                            atnd_days
                      Where e.empno = Trim(p_empno)
                        And dd.d_date = atnd_days.attendance_date(+)
                        And d_date Between v_start_date And v_end_date
                      Order By dd.d_date;
            */

            With
                atnd_days As (
                    Select
                        w.empno,
                        Trim(w.attendance_date) As attendance_date,
                        Trim(w.deskid)          As deskid,
                        1                       As planned
                    From
                        swp_smart_attendance_plan w
                    Where
                        w.empno = p_empno
                        And attendance_date Between v_start_date And v_end_date
                ),
                holiday As (
                    Select
                        holiday, 1 As is_holiday
                    From
                        ss_holidays
                    Where
                        holiday Between v_start_date And v_end_date
                )
            Select
                e.empno                   As empno,
                dd.d_day,
                dd.d_date,
                nvl(atnd_days.planned, 0) As planned,
                atnd_days.deskid          As deskid,
                nvl(hh.is_holiday, 0)     As is_holiday
            From
                ss_emplmast     e,
                ss_days_details dd,
                atnd_days,
                holiday         hh
            Where
                e.empno       = Trim(p_empno)

                And dd.d_date = atnd_days.attendance_date(+)
                And dd.d_date = hh.holiday(+)
                And d_date Between v_start_date And v_end_date
            Order By
                dd.d_date;
        Return c;

    End;
    Function fn_week_attend_planning(
        p_person_id   Varchar2,
        p_meta_id     Varchar2,
        p_date        Date     Default sysdate,

        p_assign_code Varchar2 Default Null,

        p_emptype_csv            Varchar2 Default Null,
        p_grade_csv              Varchar2 Default Null,
        p_generic_search         Varchar2 Default Null,
        p_desk_assignment_status Varchar2 Default Null,

        p_row_number  Number,
        p_page_length Number
    ) Return Sys_Refcursor As
        c                    Sys_Refcursor;
        v_hod_sec_empno       Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
        v_query               Varchar2(7000);
        v_start_date         Date := iot_swp_common.get_monday_date(p_date) - 1;
        v_end_date           Date := iot_swp_common.get_friday_date(p_date);
        v_hod_sec_assign_code Varchar2(4);
        Cursor cur_days Is
            Select
                to_char(d_date, 'yyyymmdd') yymmdd, to_char(d_date, 'DY') dday
            From
                ss_days_details
            Where
                d_date Between v_start_date And v_end_date;
    Begin
        --v_start_date := get_monday_date(p_date);
        --v_end_date   := get_friday_date(p_date);

        v_query := c_qry_attendance_planning;
        For c1 In cur_days
        Loop
            If c1.dday = 'MON' Then
                v_query := replace(v_query, '!MON!', chr(39) || c1.yymmdd || chr(39));
            Elsif c1.dday = 'TUE' Then
                v_query := replace(v_query, '!TUE!', chr(39) || c1.yymmdd || chr(39));
            Elsif c1.dday = 'WED' Then
                v_query := replace(v_query, '!WED!', chr(39) || c1.yymmdd || chr(39));
            Elsif c1.dday = 'THU' Then
                v_query := replace(v_query, '!THU!', chr(39) || c1.yymmdd || chr(39));
            Elsif c1.dday = 'FRI' Then
                v_query := replace(v_query, '!FRI!', chr(39) || c1.yymmdd || chr(39));
            End If;
        End Loop;
        v_hod_sec_empno       := get_empno_from_meta_id(p_meta_id);
        If v_hod_sec_empno = 'ERRRR' Then
            Raise e_employee_not_found;
        End If;

        v_hod_sec_assign_code := iot_swp_common.get_default_dept4plan_hod_sec(
                                     p_hod_sec_empno => v_hod_sec_empno,
                                     p_assign_code   => p_assign_code
                                 );

        If p_grade_csv Is Not Null Then
            v_query := replace(v_query, '!GRADES_SUBQUERY!', sub_qry_grades_csv);
        Else
            v_query := replace(v_query, '!GRADES_SUBQUERY!', '');
        End If;

        If p_emptype_csv Is Not Null Then
            v_query := replace(v_query, '!EMPTYPE_SUBQUERY!', sub_qry_emptype_csv);
        Else
            v_query := replace(v_query, '!EMPTYPE_SUBQUERY!', sub_qry_emptype_default);
        End If;

        If Trim(p_generic_search) Is Not Null Then
            v_query := replace(v_query, '!GENERIC_SEARCH!', where_clause_generic_search);
        Else
            v_query := replace(v_query, '!GENERIC_SEARCH!', '');
        End If;

        If p_desk_assignment_status = 'Pending' Then
            v_query := replace(v_query, '!DESK_ASSIGNMENT_STATUS!', ' and a.empno is null ');
        Elsif p_desk_assignment_status = 'Assigned' Then
            v_query := replace(v_query, '!DESK_ASSIGNMENT_STATUS!', ' and a.empno is not null ');
        Else
            v_query := replace(v_query, '!DESK_ASSIGNMENT_STATUS!', '');
        End If;

        /*
                Insert Into swp_mail_log (subject, mail_sent_to_cc_bcc, modified_on)
                Values (v_empno || '-' || p_row_number || '-' || p_page_length || '-' || to_char(v_start_date, 'yyyymmdd') || '-' ||
                    to_char(v_end_date, 'yyyymmdd'),
                    v_query, sysdate);
                Commit;
                */
        Open c For v_query Using
            p_person_id,
            p_meta_id,
            p_row_number,
            p_page_length,

            v_start_date,
            v_end_date,

            v_hod_sec_assign_code,
            p_emptype_csv,
            p_grade_csv,
            '%' || upper(trim(p_generic_search)) || '%',
            p_desk_assignment_status;

        Return c;

    End;

End iot_swp_smart_workspace_qry;
/
---------------------------
--Changed PACKAGE BODY
--IOT_SWP_COMMON
---------------------------
CREATE OR REPLACE PACKAGE BODY "SELFSERVICE"."IOT_SWP_COMMON" As

    Function get_emp_work_area(
        p_person_id Varchar2,
        p_meta_id   Varchar2,
        p_empno     Varchar2
    ) Return Varchar2 As
        v_count  Number;
        v_projno Varchar2(5);
        v_area   Varchar2(20);
    Begin
        Select
            Count(*)
        Into
            v_count
        From
            ss_vu_jobmaster
        Where
            projno In (
                Select
                    projno
                From
                    swp_map_emp_project
                Where
                    empno = p_empno
            )
            And taskforce Is Not Null
            And Rownum = 1;

        If (v_count > 0) Then

            Select
                taskforce
            Into
                v_area
            From
                ss_vu_jobmaster
            Where
                projno In (
                    Select
                        projno
                    From
                        swp_map_emp_project
                    Where
                        empno = p_empno
                )
                And taskforce Is Not Null
                And Rownum = 1;
        Else
            Begin
                Select
                    da.area_desc
                Into
                    v_area
                From
                    dms.dm_desk_area_dept_map dad,
                    dms.dm_desk_areas         da,
                    ss_emplmast               e
                Where
                    dad.area_code = da.area_key_id
                    And e.assign  = dad.assign
                    And e.empno   = p_empno;

            Exception
                When Others Then
                    v_area := Null;
            End;
        End If;

        Return v_area;
    Exception
        When Others Then
            Return Null;
    End get_emp_work_area;

    Function get_emp_work_area_code(
        p_empno Varchar2
    ) Return Varchar2 As
        v_count     Number;
        v_projno    Varchar2(5);
        v_area_code Varchar2(3);
    Begin
        Select
            da.area_key_id
        Into
            v_area_code
        From
            dms.dm_desk_area_dept_map dad,
            dms.dm_desk_areas         da,
            ss_emplmast               e
        Where
            dad.area_code = da.area_key_id
            And e.assign  = dad.assign
            And e.empno   = p_empno;

        Return v_area_code;
    Exception
        When Others Then
            Return Null;
    End get_emp_work_area_code;

    Function get_desk_from_dms(
        p_empno In Varchar2
    ) Return Varchar2 As
        v_retval Varchar(50) := 'NA';
    Begin

        Select
        Distinct dmst.deskid As desk
        Into
            v_retval
        From
            dm_vu_emp_desk_map dmst
        Where
            dmst.empno = Trim(p_empno);

        Return v_retval;
    Exception
        When Others Then
            Return Null;
    End get_desk_from_dms;

    Procedure get_planning_week_details(
        p_person_id           Varchar2,
        p_meta_id             Varchar2,
        p_plan_start_date Out Date,
        p_plan_end_date   Out Date,
        p_curr_start_date Out Date,
        p_curr_end_date   Out Date,
        p_planning_exists Out Varchar2,
        p_planning_open   Out Varchar2,
        p_message_type    Out Varchar2,
        p_message_text    Out Varchar2

    ) As
        v_count         Number;
        v_rec_plan_week swp_config_weeks%rowtype;
        v_rec_curr_week swp_config_weeks%rowtype;
    Begin
        Select
            Count(*)
        Into
            v_count
        From
            swp_config_weeks
        Where
            planning_flag = 2;
        If v_count = 0 Then
            p_planning_exists := 'KO';
            p_planning_open   := 'KO';
        Else
            Select
                *
            Into
                v_rec_plan_week
            From
                swp_config_weeks
            Where
                planning_flag = 2;

            p_plan_start_date := v_rec_plan_week.start_date;
            p_plan_end_date   := v_rec_plan_week.end_date;
            p_planning_exists := 'OK';
            p_planning_open   := Case
                                     When nvl(v_rec_plan_week.planning_open, 0) = 1 Then
                                         'OK'
                                     Else
                                         'KO'
                                 End;
        End If;
        Select
            *
        Into
            v_rec_curr_week
        From
            (
                Select
                    *
                From
                    swp_config_weeks
                Where
                    planning_flag <> 2
                Order By start_date Desc
            )
        Where
            Rownum = 1;

        p_curr_start_date := v_rec_curr_week.start_date;
        p_curr_end_date   := v_rec_curr_week.end_date;

        p_message_type    := 'OK';
        p_message_text    := 'Procedure executed successfully.';
    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
    End get_planning_week_details;

    Function get_total_desk(
        p_work_area Varchar2,
        p_office    Varchar2,
        p_floor     Varchar2,
        p_wing      Varchar2
    ) Return Number As
        v_count Number := 0;
    Begin
        Select
            Count(*)
        Into
            v_count
        From
            dms.dm_deskmaster                         mast, dms.dm_desk_areas area
        Where
            mast.work_area       = p_work_area
            And area.area_key_id = mast.work_area
            And mast.office      = Trim(p_office)
            And mast.floor       = Trim(p_floor)
            And (mast.wing       = p_wing Or p_wing Is Null);

        Return v_count;
    End;

    Function get_occupied_desk(
        p_work_area Varchar2,
        p_office    Varchar2,
        p_floor     Varchar2,
        p_wing      Varchar2,
        p_date      Date Default Null
    ) Return Number As
        v_count Number := 0;
    Begin

        Select
            Count(*)
        Into
            v_count
        From
            dms.dm_deskmaster                         mast, dms.dm_desk_areas area
        Where
            mast.work_area        = p_work_area
            And area.area_key_id  = mast.work_area
            And Trim(mast.office) = Trim(p_office)
            And Trim(mast.floor)  = Trim(p_floor)
            And (mast.wing        = p_wing Or p_wing Is Null)
            And mast.deskid
            In (
                (
                    Select
                    Distinct swptbl.deskid
                    From
                        swp_smart_attendance_plan swptbl
                    Where
                        (trunc(attendance_date) = trunc(p_date) Or p_date Is Null)
                    Union
                    Select
                    Distinct c.deskid
                    From
                        dm_vu_emp_desk_map_swp_plan c
                )
            );
        Return v_count;
    End;

    Function get_monday_date(p_date Date) Return Date As
        v_day_num Number;
    Begin
        v_day_num := to_number(to_char(p_date, 'd'));
        If v_day_num <= 2 Then
            Return p_date + (2 - v_day_num);
        Else
            Return p_date - v_day_num + 2;
        End If;

    End;

    Function get_friday_date(p_date Date) Return Date As
        v_day_num Number;
    Begin
        v_day_num := to_char(p_date, 'd');

        Return p_date + (6 - v_day_num);

    End;

    Function is_emp_eligible_for_swp(
        p_empno Varchar2
    ) Return Varchar2
    As
        v_count Number;
    Begin
        Select
            Count(*)
        Into
            v_count
        From
            swp_emp_response
        Where
            empno        = p_empno
            And hr_apprl = 'OK';
        If v_count = 1 Then
            Return 'OK';
        Else
            Return 'KO';
        End If;
    End;

    Function get_default_costcode_hod_sec(
        p_hod_sec_empno Varchar2,
        p_assign_code   Varchar2 Default Null
    ) Return Varchar2
    As
        v_assign        Varchar2(4);
        v_hod_sec_empno Varchar2(5);
    Begin
        Select
            p_hod_sec_empno
        Into
            v_hod_sec_empno
        From
            ss_emplmast
        Where
            status    = 1
            And empno = lpad(p_hod_sec_empno, 5, '0');
        Select
            assign
        Into
            v_assign
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
                            hod = v_hod_sec_empno
                        Union
                        Select
                            parent As assign
                        From
                            ss_user_dept_rights
                        Where
                            empno = v_hod_sec_empno
                    )
                Where
                    assign = nvl(p_assign_code, assign)
                Order By assign
            )
        Where
            Rownum = 1;
        Return v_assign;
    Exception
        When Others Then
            Return Null;
    End;

    Function get_default_dept4plan_hod_sec(
        p_hod_sec_empno Varchar2,
        p_assign_code   Varchar2 Default Null
    ) Return Varchar2
    As
        v_assign        Varchar2(4);
        v_hod_sec_empno Varchar2(5);
    Begin
        Select
            p_hod_sec_empno
        Into
            v_hod_sec_empno
        From
            ss_emplmast
        Where
            status    = 1
            And empno = lpad(p_hod_sec_empno, 5, '0');
        Select
            assign
        Into
            v_assign
        From
            (
                Select
                    assign
                From
                    (
                        Select
                            parent As assign
                        From
                            ss_user_dept_rights                                   a, swp_include_assign_4_seat_plan b
                        Where
                            empno        = v_hod_sec_empno
                            And a.parent = b.assign
                        Union
                        Select
                            costcode As assign
                        From
                            ss_costmast                                   a, swp_include_assign_4_seat_plan b
                        Where
                            hod            = v_hod_sec_empno
                            And a.costcode = b.assign
                    )
                Where
                    assign = nvl(p_assign_code, assign)
                Order By assign
            )
        Where
            Rownum = 1;
        Return v_assign;
    Exception
        When Others Then
            Return Null;
    End;

    Function get_hod_sec_costcodes_csv(
        p_hod_sec_empno    Varchar2,
        p_assign_codes_csv Varchar2 Default Null
    ) Return Varchar2
    As
        v_assign        Varchar2(4);
        v_hod_sec_empno Varchar2(5);
        v_ret_val       Varchar2(4000);
    Begin
        Select
            p_hod_sec_empno
        Into
            v_hod_sec_empno
        From
            ss_emplmast
        Where
            status    = 1
            And empno = lpad(p_hod_sec_empno, 5, '0');
        If p_assign_codes_csv Is Null Then
            Select
                Listagg(assign, ',') Within
                    Group (Order By
                        assign)
            Into
                v_ret_val
            From
                (
                    Select
                        costcode As assign
                    From
                        ss_costmast
                    Where
                        hod = v_hod_sec_empno
                    Union
                    Select
                        parent As assign
                    From
                        ss_user_dept_rights
                    Where
                        empno = v_hod_sec_empno
                );
        Else
            Select
                Listagg(assign, ',') Within
                    Group (Order By
                        assign)
            Into
                v_ret_val
            From
                (
                    Select
                        costcode As assign
                    From
                        ss_costmast
                    Where
                        hod = v_hod_sec_empno
                    Union
                    Select
                        parent As assign
                    From
                        ss_user_dept_rights
                    Where
                        empno = v_hod_sec_empno
                )
            Where
                assign In (
                    Select
                        regexp_substr(p_assign_codes_csv, '[^,]+', 1, level) value
                    From
                        dual
                    Connect By
                        level <=
                        length(p_assign_codes_csv) - length(replace(p_assign_codes_csv, ',')) + 1
                );

        End If;
        Return v_ret_val;
    Exception
        When Others Then
            Return Null;
    End;

    Function is_emp_laptop_user(
        p_empno Varchar2
    ) Return Number
    As
        v_laptop_count Number;
    Begin
        v_laptop_count := itinv_stk.dist.is_laptop_user(p_empno);
        If v_laptop_count > 0 Then
            Return 1;
        Else
            Return 0;
        End If;
    End;

    Function csv_to_ary_grades(
        p_grades_csv Varchar2 Default Null
    ) Return Sys_Refcursor As
        c Sys_Refcursor;
    Begin
        If p_grades_csv Is Null Then
            Open c For
                Select
                    grade_id grade
                From
                    ss_vu_grades
                Where
                    grade_id <> '-';
        Else
            Open c For
                Select
                    regexp_substr(p_grades_csv, '[^,]+', 1, level) grade
                From
                    dual
                Connect By
                    level <=
                    length(p_grades_csv) - length(replace(p_grades_csv, ',')) + 1;
        End If;
    End;

    Function is_desk_in_general_area(p_deskid Varchar2) Return Boolean

    As
        v_general_area Varchar2(4) := 'A002';
        v_count        Number;
    Begin
        --Check if the desk is General desk.
        Select
            Count(*)
        Into
            v_count
        From
            dms.dm_deskmaster d,
            dms.dm_desk_areas da
        Where
            deskid                = p_deskid
            And d.work_area       = da.area_key_id
            And da.area_catg_code = v_general_area;
        Return v_count = 1;

    End;

    Procedure sp_primary_workspace(
        p_person_id                   Varchar2,
        p_meta_id                     Varchar2,

        p_current_workspace_text  Out Varchar2,
        p_current_workspace_val   Out Varchar2,

        p_planning_workspace_text Out Varchar2,
        p_planning_workspace_val  Out Varchar2,

        p_message_type            Out Varchar2,
        p_message_text            Out Varchar2

    ) As
        v_count              Number;
        v_empno              Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);

    Begin

        v_empno        := get_empno_from_meta_id(p_meta_id);

        If v_empno = 'ERRRR' Then
            Raise e_employee_not_found;
        End If;

        Select
        Distinct
            a.primary_workspace As p_primary_workspace_val,
            b.type_desc         As p_primary_workspace_text
        Into
            p_current_workspace_val,
            p_current_workspace_text
        From
            swp_primary_workspace                                a, swp_primary_workspace_types b
        Where
            a.primary_workspace = b.type_code
            And a.empno         = v_empno
            And a.active_code   = 1;

        Select
        Distinct
            a.primary_workspace As p_primary_workspace_val,
            b.type_desc         As p_primary_workspace_text
        Into
            p_planning_workspace_val,
            p_planning_workspace_text
        From
            swp_primary_workspace                                a, swp_primary_workspace_types b
        Where
            a.primary_workspace = b.type_code
            And a.empno         = v_empno
            And a.active_code   = 2;

        p_message_type := 'OK';
        p_message_text := 'Procedure executed successfully.';
    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
    End sp_primary_workspace;

    Function fn_employee_workspace(
        p_person_id Varchar2,
        p_meta_id   Varchar2,
        p_empno     Varchar2,
        p_date      Date
    ) Return Sys_Refcursor As
    Begin
        Return Null;
    End;

    Procedure sp_emp_office_workspace(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_empno            Varchar2,

        p_office       Out Varchar2,
        p_floor        Out Varchar2,
        p_wing         Out Varchar2,
        p_desk         Out Varchar2,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2

    ) As
        v_count              Number;
        v_empno              Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);

    Begin

        v_empno        := get_empno_from_meta_id(p_meta_id);

        If v_empno = 'ERRRR' Then
            Raise e_employee_not_found;
        End If;

        Select
        Distinct
            'P_Office' As p_office,
            'P_Floor'  As p_floor,
            'P_Desk'   As p_desk,
            'P_Wing'   As p_wing
        Into
            p_office,
            p_floor,
            p_wing,
            p_desk
        From
            dual;

        p_message_type := 'OK';
        p_message_text := 'Procedure executed successfully.';
    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
    End sp_emp_office_workspace;

    Function fn_can_do_desk_plan_4_emp(p_empno Varchar2) Return Boolean As
        v_count Number;
    Begin
        Select
            Count(*)
        Into
            v_count
        From
            ss_emplmast                    e,
            swp_include_assign_4_seat_plan sp
        Where
            empno        = p_empno
            And e.assign = sp.assign;
        Return v_count > 0;
    End;

    Function fn_is_present_4_swp(
        p_empno Varchar2,
        p_date  Date) Return Number
    As
        v_count Number;
    Begin

        --Punch Count
        Select
            Count(*)
        Into
            v_count
        From
            ss_punch
        Where
            empno     = p_empno
            And pdate = p_date;
        If v_count > 0 Then
            Return 1;
        End If;

        --Approved Leave
        Select
            Count(*)
        Into
            v_count
        From
            ss_leaveledg
        Where
            empno           = p_empno
            And bdate <= p_date
            And nvl(edate, bdate) >= p_date
            And (adj_type   = 'LA'
                Or adj_type = 'LC');
        If v_count > 0 Then
            Return 1;
        End If;

        --Forgot Punch
        Select
            Count(*)
        Into
            v_count
        From
            ss_ondutyapp
        Where
            empno      = p_empno
            And pdate  = p_date
            And odtype = 'IO';
        If v_count > 0 Then
            Return 1;
        End If;

        --OnTour Deputation
        Select
            Count(*)
        Into
            v_count
        From
            ss_depu
        Where
            empno             = Trim(p_empno)
            And bdate <= p_date
            And nvl(edate, bdate) >= p_date
            And (hod_apprl    = 1
                And hrd_apprl = 1)
            And type <> 'RW';
        If v_count > 0 Then
            Return 1;
        End If;
        Return 0;
    End;

End iot_swp_common;
/
