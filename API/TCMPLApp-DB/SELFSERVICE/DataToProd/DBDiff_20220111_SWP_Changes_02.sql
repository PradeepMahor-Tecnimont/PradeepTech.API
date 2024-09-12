--------------------------------------------------------
--  File created - Tuesday-January-11-2022   
--------------------------------------------------------
---------------------------
--New TABLE
--SWP_EMP_PROJ_MAPPING
---------------------------
  CREATE TABLE "SELFSERVICE"."SWP_EMP_PROJ_MAPPING" 
   (	"KYE_ID" VARCHAR2(20) NOT NULL ENABLE,
	"EMPNO" CHAR(5),
	"PROJNO" VARCHAR2(20),
	"MODIFIED_ON" DATE,
	"MODIFIED_BY" CHAR(5),
	CONSTRAINT "SWP_EMP_PROJ_MAPPING_PK" PRIMARY KEY ("KYE_ID") ENABLE
   );
---------------------------
--New VIEW
--SS_VU_GRADES
---------------------------
CREATE OR REPLACE FORCE VIEW "SELFSERVICE"."SS_VU_GRADES" 
 ( "GRADE_ID", "GRADE_DESC"
  )  AS 
  select "GRADE_ID","GRADE_DESC" from COMMONMASTERS.hr_grade_master;
---------------------------
--Changed VIEW
--DM_VU_EMP_DESK_MAP
---------------------------
CREATE OR REPLACE FORCE VIEW "SELFSERVICE"."DM_VU_EMP_DESK_MAP" 
 ( "EMPNO", "DESKID"
  )  AS 
  SELECT 
    "EMPNO","DESKID"
FROM 
    
dms.dm_vu_emp_desk_map;
---------------------------
--New VIEW
--SS_VU_EMPTYPES
---------------------------
CREATE OR REPLACE FORCE VIEW "SELFSERVICE"."SS_VU_EMPTYPES" 
 ( "EMPTYPE", "EMPDESC", "EMPREMARKS", "TM", "PRINTLOGO", "SORTORDER"
  )  AS 
  select "EMPTYPE","EMPDESC","EMPREMARKS","TM","PRINTLOGO","SORTORDER" from commonmasters.emptypemast;
---------------------------
--New INDEX
--SS_ABSENT_MASTER_PK
---------------------------
  CREATE UNIQUE INDEX "SELFSERVICE"."SS_ABSENT_MASTER_PK" ON "SELFSERVICE"."SS_ABSENT_MASTER" ("ABSENT_YYYYMM","PAYSLIP_YYYYMM");
---------------------------
--New INDEX
--SS_ABSENT_TS_LEAVE_PK1
---------------------------
  CREATE UNIQUE INDEX "SELFSERVICE"."SS_ABSENT_TS_LEAVE_PK1" ON "SELFSERVICE"."SS_ABSENT_TS_LEAVE" ("EMPNO","TDATE","PROJNO","ACTIVITY");
---------------------------
--New INDEX
--SS_HSESUGG_PK
---------------------------
  CREATE UNIQUE INDEX "SELFSERVICE"."SS_HSESUGG_PK" ON "SELFSERVICE"."SS_HSESUGG" ("SUGGNO");
---------------------------
--New INDEX
--SWP_EMP_PROJ_MAPPING_PK
---------------------------
  CREATE UNIQUE INDEX "SELFSERVICE"."SWP_EMP_PROJ_MAPPING_PK" ON "SELFSERVICE"."SWP_EMP_PROJ_MAPPING" ("KYE_ID");
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

    where_clause_swp_eligible Varchar2(200) := ' and iot_swp_common.is_emp_eligible_for_swp(a.empno) params.p_swp_eligibility ';

    where_clause_generic_search Varchar2(200) := ' and (a.name like params.p_generic_search or a.empno like params.p_generic_search ) ';

End iot_swp_primary_workspace_qry;
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

    Function fn_costcode_list_4_hod_sec(
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

End iot_swp_select_list_qry;
/
---------------------------
--Changed PACKAGE
--IOT_ONDUTY
---------------------------
CREATE OR REPLACE PACKAGE "SELFSERVICE"."IOT_ONDUTY" As

    Type typ_tab_string Is Table Of Varchar(4000) Index By Binary_Integer;

    Procedure sp_add_punch_entry(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_empno            Varchar2,
        p_hh1              Varchar2,
        p_mi1              Varchar2,
        p_hh2              Varchar2 Default Null,
        p_mi2              Varchar2 Default Null,
        p_date             Date,
        p_type             Varchar2,
        p_sub_type         Varchar2 Default Null,
        p_lead_approver    Varchar2,
        p_reason           Varchar2,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    );

    Procedure sp_add_depu_tour(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_empno            Varchar2,
        p_start_date       Date,
        p_end_date         Date,
        p_type             Varchar2,
        p_lead_approver    Varchar2,
        p_reason           Varchar2,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    );

    Procedure sp_extend_depu(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_application_id   Varchar2,
        p_end_date         Date,
        p_reason           Varchar2,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    );

    Procedure sp_delete_od_app_4_self(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_application_id   Varchar2,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    );

    Procedure sp_delete_od_app_force(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_application_id   Varchar2,

        p_empno            Varchar2,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    );

    Procedure sp_onduty_application_details(
        p_person_id           Varchar2,
        p_meta_id             Varchar2,

        p_application_id      Varchar2,

        p_emp_name        Out Varchar2,

        p_onduty_type     Out Varchar2,
        p_onduty_sub_type Out Varchar2,
        p_start_date      Out Varchar2,
        p_end_date        Out Varchar2,

        p_hh1             Out Varchar2,
        p_mi1             Out Varchar2,
        p_hh2             Out Varchar2,
        p_mi2             Out Varchar2,

        p_reason          Out Varchar2,

        p_lead_name       Out Varchar2,
        p_lead_approval   Out Varchar2,
        p_hod_approval    Out Varchar2,
        p_hr_approval     Out Varchar2,

        p_message_type    Out Varchar2,
        p_message_text    Out Varchar2
    );

    Procedure sp_onduty_approval_lead(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_onduty_approvals typ_tab_string,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    );

    Procedure sp_onduty_approval_hod(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_onduty_approvals typ_tab_string,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    );

    Procedure sp_onduty_approval_hr(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_onduty_approvals typ_tab_string,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    );

End iot_onduty;
/
---------------------------
--New PACKAGE
--IOT_SWP_EMP_PROJ_MAP_QRY
---------------------------
CREATE OR REPLACE PACKAGE "SELFSERVICE"."IOT_SWP_EMP_PROJ_MAP_QRY" As

Function fn_emp_proj_map_list(
      p_person_id   Varchar2,
      p_meta_id     Varchar2,
      p_date        Date Default Null,

      p_row_number  Number,
      p_page_length Number
   ) Return Sys_Refcursor;

end IOT_SWP_EMP_PROJ_MAP_QRY;
/
---------------------------
--New PACKAGE
--IOT_SWP_DMS
---------------------------
CREATE OR REPLACE PACKAGE "SELFSERVICE"."IOT_SWP_DMS" As

    Procedure sp_add_desk_user(
        p_person_id         Varchar2,
        p_meta_id           Varchar2,
        
        p_empno             Varchar2,
        p_deskid            Varchar2,
        p_parent            Varchar2
    );

    Procedure sp_remove_desk_user(
        p_person_id         Varchar2,
        p_meta_id           Varchar2,

        p_empno             Varchar2,
        p_deskid            Varchar2,
        p_unqid             Varchar2       
    );

    Procedure sp_lock_desk(
        p_person_id         Varchar2,
        p_meta_id           Varchar2,

        p_empno             Varchar2,
        p_deskid            Varchar2,
        p_unqid             Varchar2
    );

    Procedure sp_unlock_desk(
        p_person_id         Varchar2,
        p_meta_id           Varchar2,

        p_empno             Varchar2,
        p_deskid            Varchar2
    );

    Procedure sp_clear_desk(
        p_person_id         Varchar2,
        p_meta_id           Varchar2,        

        p_deskid            Varchar2
    );

End iot_swp_dms;
/
---------------------------
--Changed PACKAGE
--IOT_SWP_COMMON
---------------------------
CREATE OR REPLACE PACKAGE "SELFSERVICE"."IOT_SWP_COMMON" As

    Function get_emp_work_area(
        p_person_id Varchar2,
        p_meta_id   Varchar2,
        p_empno     Varchar2
    ) Return Varchar2;

    Function get_emp_work_area_code(
        p_empno Varchar2
    ) Return Varchar2;

    Function get_desk_from_dms(
        p_empno In Varchar2
    ) Return Varchar2;

    /*
    Function get_emp_dms_type_desc(
        p_empno In Varchar2
    ) Return Varchar2;

    Function get_emp_dms_type_code(
        p_empno In Varchar2
    ) Return Number;
    */
    Procedure get_planning_week_details(
        p_person_id           Varchar2,
        p_meta_id             Varchar2,
        p_start_date      Out Date,
        p_end_date        Out Date,
        p_planning_exists Out Varchar2,
        p_planning_open   Out Varchar2,
        p_message_type    Out Varchar2,
        p_message_text    Out Varchar2

    );
    Function get_total_desk(
        p_work_area Varchar2,
        p_office    Varchar2,
        p_floor     Varchar2,
        p_wing      Varchar2
    ) Return Number;

    Function get_occupied_desk(
        p_work_area Varchar2,
        p_office    Varchar2,
        p_floor     Varchar2,
        p_wing      Varchar2,
        p_date      Date Default Null
    ) Return Number;

    Function get_monday_date(p_date Date) Return Date;

    Function get_friday_date(p_date Date) Return Date;

    --
    Function is_emp_eligible_for_swp(
        p_empno Varchar2
    ) Return Varchar2;

    --
    Function get_default_costcode_hod_sec(
        p_hod_sec_empno Varchar2,
        p_assign_code   Varchar2 Default Null
    ) Return Varchar2;

    Function get_hod_sec_costcodes_csv(
        p_hod_sec_empno    Varchar2,
        p_assign_codes_csv Varchar2 Default Null
    ) Return Varchar2;

    Function is_emp_laptop_user(
        p_empno Varchar2
    ) Return Number;
    --
    Function csv_to_ary_grades(
        p_grades_csv Varchar2 Default Null
    ) Return Sys_Refcursor;
End iot_swp_common;
/
---------------------------
--Changed PACKAGE BODY
--IOT_SWP_OFFICE_WORKSPACE
---------------------------
CREATE OR REPLACE PACKAGE BODY "SELFSERVICE"."IOT_SWP_OFFICE_WORKSPACE" As

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
      v_ststue          Varchar2(5);
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

      Select Count(*)
        Into v_count
        From swp_primary_workspace
       Where Trim(empno) = Trim(p_empno)
         And Trim(primary_workspace) = '1';

      If v_count = 0 Then
         p_message_type := 'KO';
         p_message_text := 'Invalid employee number ' || p_empno;
         Return;
      End If;

      Insert Into dm_vu_emp_desk_map (
         empno,
         deskid--,
         --modified_on,
         --modified_by
      )
      Values (
         p_empno,
         p_deskid--,
         --sysdate,
         --v_mod_by_empno
      );
      Commit;

      p_message_type := 'OK';
      p_message_text := 'Procedure executed successfully.';
   Exception
      When Others Then
         p_message_type := 'KO';
         p_message_text := 'ERR :- '
                           || sqlcode
                           || ' - '
                           || sqlerrm;

   End sp_add_office_ws_desk;

End IOT_SWP_OFFICE_WORKSPACE;
/
---------------------------
--New PACKAGE BODY
--IOT_SWP_EMP_PROJ_MAP_QRY
---------------------------
CREATE OR REPLACE PACKAGE BODY "SELFSERVICE"."IOT_SWP_EMP_PROJ_MAP_QRY" As
 
Function fn_emp_proj_map_list(
      p_person_id   Varchar2,
      p_meta_id     Varchar2,
      p_date        Date Default Null,

      p_row_number  Number,
      p_page_length Number
   ) Return Sys_Refcursor
   Is
   c                    Sys_Refcursor;
   v_count              Number;
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
      Select *
        From (
                Select empprojmap.KYE_ID As keyid,
                       empprojmap.EMPNO As Empno,
                       empprojmap.PROJNO As Projno,
                       Row_Number() Over (Order By empprojmap.KYE_ID Desc) row_number,
                       Count(*) Over () total_row
                  From SWP_EMP_PROJ_MAPPING empprojmap
                 Where empprojmap.EMPNO In (
                          Select Distinct empno
                            From ss_emplmast
                           Where status = 1
                             And assign In (
                                    Select parent
                                      From ss_user_dept_rights
                                     Where empno = v_empno
                                    Union
                                    Select costcode
                                      From ss_costmast
                                     Where hod = v_empno
                                 )
                       )

             )
       Where row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length)
       Order By Empno,PROJNO;
   Return c;

End fn_emp_proj_map_list;

    --  GRANT EXECUTE ON "IOT_SWP_EMP_PROJ_MAP_QRY" TO "TCMPL_APP_CONFIG";

End IOT_SWP_EMP_PROJ_MAP_QRY;
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
                        dm_vu_emp_desk_map
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
                        dm_vu_emp_desk_map dmst
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

End iot_swp_select_list_qry;
/
---------------------------
--Changed PACKAGE BODY
--IOT_ONDUTY
---------------------------
CREATE OR REPLACE PACKAGE BODY "SELFSERVICE"."IOT_ONDUTY" As

    Procedure sp_onduty_details(
        p_application_id      Varchar2,

        p_emp_name        Out Varchar2,

        p_onduty_type     Out Varchar2,
        p_onduty_sub_type Out Varchar2,
        p_start_date      Out Varchar2,
        p_end_date        Out Varchar2,

        p_hh1             Out Varchar2,
        p_mi1             Out Varchar2,
        p_hh2             Out Varchar2,
        p_mi2             Out Varchar2,

        p_reason          Out Varchar2,
        p_lead_name       Out Varchar2,
        p_lead_approval   Out Varchar2,
        p_hod_approval    Out Varchar2,
        p_hr_approval     Out Varchar2,

        p_message_type    Out Varchar2,
        p_message_text    Out Varchar2
    ) As

        v_onduty_app ss_ondutyapp%rowtype;
        v_depu       ss_depu%rowtype;
        v_empno      Varchar2(5);
        v_count      Number;

    Begin
        Select
            Count(*)
        Into
            v_count
        From
            ss_ondutyapp
        Where
            Trim(app_no) = Trim(p_application_id);
        If v_count = 1 Then
            Select
                *
            Into
                v_onduty_app
            From
                ss_ondutyapp
            Where
                Trim(app_no) = Trim(p_application_id);
        Else
            Select
                Count(*)
            Into
                v_count
            From
                ss_depu
            Where
                Trim(app_no) = Trim(p_application_id);

            If v_count = 1 Then
                Select
                    *
                Into
                    v_depu
                From
                    ss_depu
                Where
                    Trim(app_no) = Trim(p_application_id);
            End If;
        End If;
        If v_count = 0 Then
            p_message_type := 'KO';
            p_message_text := 'Err - Invalid application id';
            Return;
        End If;
        If v_onduty_app.empno Is Not Null Then
            Select
                description
            Into
                p_onduty_type
            From
                ss_ondutymast
            Where
                type = v_onduty_app.type;
            p_onduty_type   := v_onduty_app.type || ' - ' || p_onduty_type;
            If nvl(v_onduty_app.odtype, 0) <> 0 Then
                Select
                    description
                Into
                    p_onduty_sub_type
                From
                    ss_onduty_sub_type
                Where
                    od_sub_type = v_onduty_app.odtype;
                p_onduty_sub_type := v_onduty_app.odtype || ' - ' || p_onduty_sub_type;
            End If;

            p_emp_name      := get_emp_name(v_onduty_app.empno);
            p_start_date    := to_char(v_onduty_app.pdate, 'dd-Mon-yyyy');
            p_hh1           := lpad(v_onduty_app.hh, 2, '0');
            p_mi1           := lpad(v_onduty_app.mm, 2, '0');
            p_hh2           := lpad(v_onduty_app.hh1, 2, '0');
            p_mi2           := lpad(v_onduty_app.mm1, 2, '0');
            p_reason        := v_onduty_app.reason;

            p_lead_name     := get_emp_name(v_onduty_app.lead_apprl_empno);
            p_lead_approval := ss.approval_text(v_onduty_app.lead_apprl);
            p_hod_approval  := ss.approval_text(v_onduty_app.hod_apprl);
            p_hr_approval   := ss.approval_text(v_onduty_app.hrd_apprl);

        Elsif v_depu.empno Is Not Null Then

            p_start_date    := to_char(v_depu.bdate, 'dd-Mon-yyyy');
            p_end_date      := to_char(v_depu.edate, 'dd-Mon-yyyy');
            p_reason        := v_depu.reason;

            Select
                description
            Into
                p_onduty_type
            From
                ss_ondutymast
            Where
                type = v_onduty_app.type;
            p_onduty_type   := v_onduty_app.type || ' - ' || p_onduty_type;

            p_emp_name      := get_emp_name(v_depu.empno);
            p_lead_name     := get_emp_name(v_depu.lead_apprl_empno);

            p_lead_approval := ss.approval_text(v_depu.lead_apprl);
            p_hod_approval  := ss.approval_text(v_depu.hod_apprl);
            p_hr_approval   := ss.approval_text(v_depu.hrd_apprl);

        End If;

        p_message_type := 'OK';

    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'Err - ' || sqlcode || ' - ' || sqlerrm;
    End;

    Procedure sp_add_punch_entry(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_empno            Varchar2,
        p_hh1              Varchar2,
        p_mi1              Varchar2,
        p_hh2              Varchar2 Default Null,
        p_mi2              Varchar2 Default Null,
        p_date             Date,
        p_type             Varchar2,
        p_sub_type         Varchar2 Default Null,
        p_lead_approver    Varchar2,
        p_reason           Varchar2,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_entry_by_empno Varchar2(5);
        v_count          Number;
        v_lead_approval  Number := 0;
        v_hod_approval   Number := 0;
        v_desc           Varchar2(60);
    Begin
        v_entry_by_empno := get_empno_from_meta_id(p_meta_id);
        If v_entry_by_empno = 'ERRRR' Then
            p_message_type := 'KO';
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        od.add_onduty_type_1(
            p_empno         => p_empno,
            p_od_type       => p_type,
            p_od_sub_type   => nvl(Trim(p_sub_type), 0),
            p_pdate         => to_char(p_date, 'yyyymmdd'),
            p_hh            => to_number(Trim(p_hh1)),
            p_mi            => to_number(Trim(p_mi1)),
            p_hh1           => to_number(Trim(p_hh2)),
            p_mi1           => to_number(Trim(p_mi2)),
            p_lead_approver => p_lead_approver,
            p_reason        => p_reason,
            p_entry_by      => v_entry_by_empno,
            p_user_ip       => Null,
            p_success       => p_message_type,
            p_message       => p_message_text
        );

    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'Err - ' || sqlcode || ' - ' || sqlerrm;
    End sp_add_punch_entry;

    Procedure sp_add_depu_tour(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_empno            Varchar2,
        p_start_date       Date,
        p_end_date         Date,
        p_type             Varchar2,
        p_lead_approver    Varchar2,
        p_reason           Varchar2,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_entry_by_empno Varchar2(5);
        v_count          Number;

    Begin
        v_entry_by_empno := get_empno_from_meta_id(p_meta_id);
        If v_entry_by_empno = 'ERRRR' Then
            p_message_type := 'KO';
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        od.add_onduty_type_2(
            p_empno         => p_empno,
            p_od_type       => p_type,
            p_b_yyyymmdd    => to_char(p_start_date, 'yyyymmdd'),
            p_e_yyyymmdd    => to_char(p_end_date, 'yyyymmdd'),
            p_entry_by      => v_entry_by_empno,
            p_lead_approver => p_lead_approver,
            p_user_ip       => Null,
            p_reason        => p_reason,
            p_success       => p_message_type,
            p_message       => p_message_text
        );
    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'Err - ' || sqlcode || ' - ' || sqlerrm;

    End sp_add_depu_tour;

    Procedure sp_extend_depu(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_application_id   Varchar2,
        p_end_date         Date,
        p_reason           Varchar2,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_entry_by_empno Varchar2(5);
        v_count          Number;
        rec_depu         ss_depu%rowtype;
    Begin
        Select
            *
        Into
            rec_depu
        From
            ss_depu
        Where
            trim(app_no) = trim(p_application_id);
        If rec_depu.edate > p_end_date Then
            p_message_type := 'KO';
            p_message_text := 'Extension end date should be greater than existing end date.';
            Return;
        End If;
        sp_add_depu_tour(
            p_person_id     => p_person_id,
            p_meta_id       => p_meta_id,

            p_empno         => rec_depu.empno,
            p_start_date    => rec_depu.edate + 1,
            p_end_date      => p_end_date,
            p_type          => rec_depu.type,
            p_lead_approver => 'None',
            p_reason        => p_reason,

            p_message_type  => p_message_type,
            p_message_text  => p_message_text
        );
    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'Err - ' || sqlcode || ' - ' || sqlerrm;

    End;

    --
    Procedure sp_delete_od_app_4_self(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_application_id   Varchar2,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_count    Number;
        v_empno    Varchar2(5);
        v_tab_from Varchar2(2);
    Begin
        v_count        := 0;
        v_empno        := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            p_message_type := 'KO';
            p_message_text := 'Invalid employee number';
            Return;
        End If;
        Select
            Count(*)
        Into
            v_count
        From
            ss_ondutyapp
        Where
            Trim(app_no) = Trim(p_application_id)
            And empno    = v_empno;
        If v_count = 1 Then
            v_tab_from := 'OD';
        Else
            Select
                Count(*)
            Into
                v_count
            From
                ss_depu
            Where
                Trim(app_no) = Trim(p_application_id)
                And empno    = v_empno;
            If v_count = 1 Then
                v_tab_from := 'DP';
            End If;
        End If;
        If v_count = 0 Then
            p_message_type := 'KO';
            p_message_text := 'Err - Invalid application id';
            Return;
        End If;
        del_od_app(p_app_no   => p_application_id,
                   p_tab_from => v_tab_from);
        p_message_type := 'OK';
        p_message_text := 'Procedure executed successfully.';

    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'Err - ' || sqlcode || ' - ' || sqlerrm;

    End sp_delete_od_app_4_self;

    Procedure sp_delete_od_app_force(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_application_id   Varchar2,
        p_empno            Varchar2,
        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_count      Number;
        v_self_empno Varchar2(5);

        v_tab_from   Varchar2(2);
    Begin
        v_count        := 0;
        v_self_empno   := get_empno_from_meta_id(p_meta_id);
        If v_self_empno = 'ERRRR' Then
            p_message_type := 'KO';
            p_message_text := 'Invalid employee number';
            Return;
        End If;
        Select
            Count(*)
        Into
            v_count
        From
            ss_ondutyapp
        Where
            Trim(app_no) = Trim(p_application_id)
            And empno    = p_empno;
        If v_count = 1 Then
            v_tab_from := 'OD';
        Else
            Select
                Count(*)
            Into
                v_count
            From
                ss_depu
            Where
                Trim(app_no) = Trim(p_application_id)
                And empno    = p_empno;
            If v_count = 1 Then
                v_tab_from := 'DP';
            End If;
        End If;
        If v_count = 0 Then
            p_message_type := 'KO';
            p_message_text := 'Err - Invalid application id';
            Return;
        End If;
        del_od_app(p_app_no   => p_application_id,
                   p_tab_from => v_tab_from);
        p_message_type := 'OK';
        p_message_text := 'Procedure executed successfully.';

    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'Err - ' || sqlcode || ' - ' || sqlerrm;

    End sp_delete_od_app_force;

    Procedure sp_onduty_application_details(
        p_person_id           Varchar2,
        p_meta_id             Varchar2,

        p_application_id      Varchar2,

        p_emp_name        Out Varchar2,

        p_onduty_type     Out Varchar2,
        p_onduty_sub_type Out Varchar2,
        p_start_date      Out Varchar2,
        p_end_date        Out Varchar2,

        p_hh1             Out Varchar2,
        p_mi1             Out Varchar2,
        p_hh2             Out Varchar2,
        p_mi2             Out Varchar2,

        p_reason          Out Varchar2,

        p_lead_name       Out Varchar2,
        p_lead_approval   Out Varchar2,
        p_hod_approval    Out Varchar2,
        p_hr_approval     Out Varchar2,

        p_message_type    Out Varchar2,
        p_message_text    Out Varchar2
    ) As
        v_count    Number;
        v_empno    Varchar2(5);
        v_tab_from Varchar2(2);
    Begin
        v_count := 0;
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            p_message_type := 'KO';
            p_message_text := 'Invalid employee number';
            Return;
        End If;
        sp_onduty_details(
            p_application_id  => p_application_id,

            p_emp_name        => p_emp_name,

            p_onduty_type     => p_onduty_type,
            p_onduty_sub_type => p_onduty_sub_type,
            p_start_date      => p_start_date,
            p_end_date        => p_end_date,

            p_hh1             => p_hh1,
            p_mi1             => p_mi1,
            p_hh2             => p_hh2,
            p_mi2             => p_mi2,

            p_reason          => p_reason,

            p_lead_name       => p_lead_name,
            p_lead_approval   => p_lead_approval,
            p_hod_approval    => p_hod_approval,
            p_hr_approval     => p_hr_approval,

            p_message_type    => p_message_type,
            p_message_text    => p_message_text

        );
    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'Err - ' || sqlcode || ' - ' || sqlerrm;
    End;

    Procedure sp_onduty_approval(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_onduty_approvals typ_tab_string,
        p_approver_profile Number,
        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_app_no         Varchar2(70);
        v_approval       Number;
        v_remarks        Varchar2(70);
        c_onduty         Constant Varchar2(2) := 'OD';
        c_deputation     Constant Varchar2(2) := 'DP';
        v_count          Number;
        v_rec_count      Number;
        sqlpartod        Varchar2(60)         := 'Update SS_OnDutyApp ';
        sqlpartdp        Varchar2(60)         := 'Update SS_Depu ';
        sqlpart2         Varchar2(500);
        strsql           Varchar2(600);
        v_odappstat_rec  ss_odappstat%rowtype;
        v_approver_empno Varchar2(5);
        v_user_tcp_ip    Varchar2(30);
    Begin

        v_approver_empno := get_empno_from_meta_id(p_meta_id);
        If v_approver_empno = 'ERRRR' Then
            p_message_type := 'KO';
            p_message_text := 'Invalid employee number';
            Return;
        End If;
        sqlpart2         := ' set ApproverProfile_APPRL = :Approval, ApproverProfile_Code = :Approver_EmpNo, ApproverProfile_APPRL_DT = Sysdate,
                    ApproverProfile_TCP_IP = :User_TCP_IP , ApproverProfileREASON = :Reason where App_No = :paramAppNo';
        If p_approver_profile = user_profile.type_hod Or p_approver_profile = user_profile.type_sec Then
            sqlpart2 := replace(sqlpart2, 'ApproverProfile', 'HOD');
        Elsif p_approver_profile = user_profile.type_hrd Then
            sqlpart2 := replace(sqlpart2, 'ApproverProfile', 'HRD');
        Elsif p_approver_profile = user_profile.type_lead Then
            sqlpart2 := replace(sqlpart2, 'ApproverProfile', 'LEAD');
        End If;

        For i In 1..p_onduty_approvals.count
        Loop

            With
                csv As (
                    Select
                        p_onduty_approvals(i) str
                    From
                        dual
                )
            Select
                Trim(regexp_substr(str, '[^~!~]+', 1, 1))            app_no,
                to_number(Trim(regexp_substr(str, '[^~!~]+', 1, 2))) approval,
                Trim(regexp_substr(str, '[^~!~]+', 1, 3))            remarks
            Into
                v_app_no, v_approval, v_remarks
            From
                csv;

            Select
                *
            Into
                v_odappstat_rec
            From
                ss_odappstat
            Where
                Trim(app_no) = Trim(v_app_no);

            If (v_odappstat_rec.fromtab) = c_deputation Then
                strsql := sqlpartdp || ' ' || sqlpart2;
            Elsif (v_odappstat_rec.fromtab) = c_onduty Then
                strsql := sqlpartod || ' ' || sqlpart2;
            End If;
            /*
            p_message_type := 'OK';
            p_message_text := 'Debug 1 - ' || p_onduty_approvals(i);
            Return;
            */
            strsql := replace(strsql, 'LEADREASON', 'LEAD_REASON');
            Execute Immediate strsql
                Using v_approval, v_approver_empno, v_user_tcp_ip, v_remarks, trim(v_app_no);

            If v_odappstat_rec.fromtab = c_onduty And p_approver_profile = user_profile.type_hrd Then
                Insert Into ss_onduty value
                (
                    Select
                        empno,
                        hh,
                        mm,
                        pdate,
                        0,
                        dd,
                        mon,
                        yyyy,
                        type,
                        app_no,
                        description,
                        getodhh(app_no, 1),
                        getodmm(app_no, 1),
                        app_date,
                        reason,
                        odtype
                    From
                        ss_ondutyapp
                    Where
                        Trim(app_no)                   = Trim(v_app_no)
                        And nvl(hrd_apprl, ss.pending) = ss.approved
                );

                Insert Into ss_onduty value
                (
                    Select
                        empno,
                        hh1,
                        mm1,
                        pdate,
                        0,
                        dd,
                        mon,
                        yyyy,
                        type,
                        app_no,
                        description,
                        getodhh(app_no, 2),
                        getodmm(app_no, 2),
                        app_date,
                        reason,
                        odtype
                    From
                        ss_ondutyapp
                    Where
                        Trim(app_no)                   = Trim(v_app_no)
                        And (type                      = 'OD'
                            Or type                    = 'IO')
                        And nvl(hrd_apprl, ss.pending) = ss.approved
                );

                If p_approver_profile = user_profile.type_hrd And v_approval = ss.approved Then
                    generate_auto_punch_4od(v_app_no);
                End If;

            End If;

        End Loop;

        Commit;
        p_message_type   := 'OK';
        p_message_text   := 'Procedure executed successfully.';
    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
    End;

    Procedure sp_onduty_approval_lead(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_onduty_approvals typ_tab_string,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    )
    As
    Begin
        sp_onduty_approval(
            p_person_id        => p_person_id,
            p_meta_id          => p_meta_id,

            p_onduty_approvals => p_onduty_approvals,
            p_approver_profile => user_profile.type_lead,
            p_message_type     => p_message_type,
            p_message_text     => p_message_text
        );
    End;

    Procedure sp_onduty_approval_hod(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_onduty_approvals typ_tab_string,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    )
    As
    Begin
        sp_onduty_approval(
            p_person_id        => p_person_id,
            p_meta_id          => p_meta_id,

            p_onduty_approvals => p_onduty_approvals,
            p_approver_profile => user_profile.type_hod,
            p_message_type     => p_message_type,
            p_message_text     => p_message_text
        );
    End;

    Procedure sp_onduty_approval_hr(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_onduty_approvals typ_tab_string,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    )
    As
    Begin
        sp_onduty_approval(
            p_person_id        => p_person_id,
            p_meta_id          => p_meta_id,

            p_onduty_approvals => p_onduty_approvals,
            p_approver_profile => user_profile.type_hrd,
            p_message_type     => p_message_type,
            p_message_text     => p_message_text
        );
    End;

End iot_onduty;
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
    End get_desk_from_dms;

    Procedure get_planning_week_details(
        p_person_id           Varchar2,
        p_meta_id             Varchar2,
        p_start_date      Out Date,
        p_end_date        Out Date,
        p_planning_exists Out Varchar2,
        p_planning_open   Out Varchar2,
        p_message_type    Out Varchar2,
        p_message_text    Out Varchar2

    ) As
        v_count           Number;
        v_rec_config_week swp_config_weeks%rowtype;
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
            p_message_type    := 'OK';
            Return;
        End If;

        Select
            *
        Into
            v_rec_config_week
        From
            swp_config_weeks
        Where
            planning_flag = 2;
        p_start_date      := v_rec_config_week.start_date;
        p_end_date        := v_rec_config_week.end_date;
        p_planning_exists := 'OK';
        p_planning_open   := Case
                                 When nvl(v_rec_config_week.planning_open, 0) = 1 Then
                                     'OK'
                                 Else
                                     'KO'
                             End;
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
                        dm_vu_emp_desk_map c
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
    Begin
        Return itinv_stk.dist.is_laptop_user(p_empno);
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
        return c;
    End;

End iot_swp_common;
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

        If p_empno Is Null Or p_assign_code Is Not Null Then
            v_hod_sec_assign_code := iot_swp_common.get_default_costcode_hod_sec(
                                         p_hod_sec_empno => v_hod_sec_empno,
                                         p_assign_code   => p_assign_code
                                     );
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
            '%'|| upper(trim(p_generic_search)) || '%';

        Return c;

    End;

    /*
        Function fn_emp_primary_ws_list(
            p_person_id   Varchar2,
            p_meta_id     Varchar2,

            p_assign_code Varchar2 Default Null,
            p_start_date  Date     Default Null,

            p_empno       Varchar2 Default Null,

            p_row_number  Number,
            p_page_length Number
        ) Return Sys_Refcursor As
            c                     Sys_Refcursor;
            c_grades              Sys_Refcursor;
            v_hod_sec_empno       Varchar2(5);
            e_employee_not_found  Exception;
            Pragma exception_init(e_employee_not_found, -20001);
            v_friday_date         Date;
            v_hod_sec_assign_code Varchar2(4);

        Begin
            v_friday_date   := iot_swp_common.get_friday_date(nvl(p_start_date, sysdate));

            v_hod_sec_empno := get_empno_from_meta_id(p_meta_id);

            If v_hod_sec_empno = 'ERRRR' Then
                Raise e_employee_not_found;
                Return Null;
            End If;

            If p_empno Is Null Or p_assign_code Is Not Null Then
                v_hod_sec_assign_code := iot_swp_common.get_default_costcode_hod_sec(
                                             p_hod_sec_empno => v_hod_sec_empno,
                                             p_assign_code   => p_assign_code
                                         );
            End If;

            Open c For
                With
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
                            iot_swp_common.is_emp_laptop_user(a.empno)                        As is_laptop_user,
                            Case iot_swp_common.is_emp_laptop_user(a.empno)
                                When 1 Then
                                    'Yes'
                                Else
                                    'No'
                            End                                                               As is_laptop_user_text,
                            a.grade                                                           As emp_grade,
                            nvl(b.primary_workspace, 0)                                       As primary_workspace,
                            Row_Number() Over(Order By a.name)                                As row_number,
                            Case iot_swp_common.is_emp_eligible_for_swp(a.empno)
                                When 'OK' Then
                                    'Yes'
                                Else
                                    'No'
                            End                                                               As is_eligible_desc,
                            iot_swp_common.is_emp_eligible_for_swp(a.empno)                   As is_eligible,
                            Count(*) Over()                                                   As total_row
                        From
                            ss_emplmast        a,
                            primary_work_space b
                        Where
                            a.empno      = b.empno(+)
                            And a.assign = nvl(v_hod_sec_assign_code, a.assign)
                            And a.status = 1
                            And a.empno  = nvl(p_empno, a.empno)
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
                        Order By a.name
                    )
                Where
                    row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length);

            Return c;

        End fn_emp_primary_ws_list;
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
                        nvl(b.primary_workspace_desc, 0)                                  As primary_workspace,
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

End iot_swp_primary_workspace_qry;
/
---------------------------
--New PACKAGE BODY
--IOT_SWP_DMS
---------------------------
CREATE OR REPLACE PACKAGE BODY "SELFSERVICE"."IOT_SWP_DMS" As

    /*  p_unqid := 'SWPF'  -- fixed desk
        p_unqid := 'SWPV'  -- variable desk     */

    Procedure sp_add_desk_user(
        p_person_id         Varchar2,
        p_meta_id           Varchar2,

        p_empno             Varchar2,
        p_deskid            Varchar2,
        p_parent            Varchar2
    ) As
        v_exists     Number;         
    Begin        
        select 
            count(du.empno) into v_exists
        from 
            dms.dm_usermaster du
        where            
            du.empno = p_empno and
            du.deskid = p_deskid and
            du.costcode = p_parent;

        if v_exists = 0 then
            insert into 
                dms.dm_usermaster(empno, deskid, costcode, dep_flag)
            values
                (p_empno, p_deskid, p_parent, 0);
        end if;
    End sp_add_desk_user;

    Procedure sp_remove_desk_user(
        p_person_id         Varchar2,
        p_meta_id           Varchar2,

        p_empno             Varchar2,
        p_deskid            Varchar2,        
        p_unqid             Varchar2      
    ) As 
        v_pk                Varchar2(20); 
        v_create_by_empno   Varchar2(5);         
    Begin
        v_create_by_empno := get_empno_from_meta_id(p_meta_id);

        delete from
            dms.dm_usermaster du
        where
            du.empno = p_empno and
            du.deskid = p_deskid; 

        if p_unqid = 'SWPV' then
            /* send assets to orphan table */

            v_pk := dbms_random.string('X', 20);

            insert into 
                dms.dm_orphan_asset(unqid, empno, deskid, assetid, createdon, createdby, confirmed)
            select  
                v_pk, 
                p_empno, 
                deskid, 
                assetid, 
                sysdate, 
                v_create_by_empno,
                0         
            from 
                dms.dm_deskallocation
            where 
                deskid = p_deskid;

            /* release assets of desk from dm_deskallocation table */

            delete from            
                dms.dm_deskallocation
            where 
                deskid = p_deskid;
        end if;
    End sp_remove_desk_user;

    Procedure sp_lock_desk(
        p_person_id         Varchar2,
        p_meta_id           Varchar2,

        p_empno             Varchar2,
        p_deskid            Varchar2,
        p_unqid             Varchar2
    ) As
        v_exists     Number; 
    Begin       
        select 
            count(dl.empno) into v_exists
        from 
            dms.dm_desklock dl
        where            
            dl.empno = p_empno and
            dl.deskid = p_deskid;

        if v_exists = 0 then
            insert into 
                dms.dm_desklock(unqid, empno, deskid, targetdesk, blockflag, blockreason)
            values
                (p_unqid, p_empno, p_deskid, 0, 1, 1);
        else
            update 
                dms.dm_desklock
            set 
                unqid = p_unqid,
                targetdesk = 0, 
                blockflag = 1, 
                blockreason = 1
            where
                empno = p_empno and  
                deskid = p_deskid;
        end if;
    End sp_lock_desk;

    Procedure sp_unlock_desk(
        p_person_id         Varchar2,
        p_meta_id           Varchar2,

        p_empno             Varchar2,
        p_deskid            Varchar2
    ) As        
    Begin
        delete from
            dms.dm_desklock dl
        where
            dl.empno = p_empno and
            dl.deskid = p_deskid and
            dl.unqid = 'SWPV';  
    End sp_unlock_desk;

    Procedure sp_clear_desk(
        p_person_id         Varchar2,
        p_meta_id           Varchar2,        

        p_deskid            Varchar2
    ) As 
        v_pk                Varchar2(20); 
        v_create_by_empno   Varchar2(5);         
    Begin
        v_create_by_empno := get_empno_from_meta_id(p_meta_id);

        /* send assets to orphan table */

        v_pk := dbms_random.string('X', 20);

        insert into 
            dms.dm_orphan_asset(unqid, empno, deskid, assetid, createdon, createdby, confirmed)
        select  
            v_pk, 
            '', 
            deskid, 
            assetid, 
            sysdate, 
            v_create_by_empno,
            0         
        from 
            dms.dm_deskallocation
        where 
            deskid = p_deskid;

        /* release assets of desk from dm_deskallocation table */

        delete from            
            dms.dm_deskallocation
        where 
            deskid = p_deskid;

    End sp_clear_desk;

End iot_swp_dms;
/
---------------------------
--Changed PACKAGE BODY
--IOT_SWP_SMART_WORKSPACE_QRY
---------------------------
CREATE OR REPLACE PACKAGE BODY "SELFSERVICE"."IOT_SWP_SMART_WORKSPACE_QRY" As

   Function fn_reserved_area_list(
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

      Open cur_reserved_area_list(p_date, Null, Null, Null, p_row_number, p_page_length);
      Loop
         Fetch cur_reserved_area_list Bulk Collect Into tab_area_list_ok Limit 50;
         For i In 1..tab_area_list_ok.count
         Loop
            Pipe Row(tab_area_list_ok(i));

         End Loop;
         Exit When cur_reserved_area_list%notfound;
      End Loop;
      Close cur_reserved_area_list;
      Return;

   End fn_reserved_area_list;

   Function fn_general_area_list(
      p_person_id   Varchar2,
      p_meta_id     Varchar2,
      p_date        Date Default Null,

      p_row_number  Number,
      p_page_length Number
   ) Return typ_area_list
      Pipelined
   Is
      tab_area_list_ko     typ_area_list;
      v_count              Number;
      v_empno              Varchar2(5);
      e_employee_not_found Exception;
      Pragma exception_init(e_employee_not_found, -20001);

   Begin

      Open cur_general_area_list(Null, Null, Null, p_row_number, p_page_length);
      Loop
         Fetch cur_general_area_list Bulk Collect Into tab_area_list_ko Limit 50;
         For i In 1..tab_area_list_ko.count
         Loop
            Pipe Row(tab_area_list_ko(i));

         End Loop;
         Exit When cur_general_area_list%notfound;
      End Loop;
      Close cur_general_area_list;
      Return;

   End fn_general_area_list;

   Function fn_work_area_desk(
      p_person_id   Varchar2,
      p_meta_id     Varchar2,

      p_date        Date,
      p_work_area   Varchar2,
      p_wing        Varchar2 Default Null,

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

      Open c For
         Select *
           From (
                   Select mast.deskid As deskid,
                          mast.office As office,
                          mast.floor As floor,
                          mast.seatno As seat_no,
                          mast.wing As wing,
                          mast.assetcode As asset_code,
                          mast.bay As bay,
                          Row_Number() Over (Order By deskid Desc) row_number,
                          Count(*) Over () total_row
                     From dms.dm_deskmaster mast
                    Where mast.work_area = Trim(p_work_area)
                      And (p_wing Is Null Or mast.wing = p_wing)
                      And mast.deskid
                          Not In(
                             Select Distinct swptbl.deskid
                               From swp_smart_attendance_plan swptbl
                              Where (trunc(ATTENDANCE_DATE) = TRUNC(p_date) Or p_date Is Null)
                             Union
                             Select Distinct c.deskid
                               From dm_vu_emp_desk_map c
                          )
                )
          Where row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length)
          Order By deskid,
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
      v_start_date         Date := IOT_SWP_COMMON.get_monday_date(trunc(p_date));
      v_end_date           Date := IOT_SWP_COMMON.get_friday_date(trunc(p_date));
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
               Select w.empno,
                      Trim(w.attendance_date) As attendance_date,
                      Trim(w.deskid) As deskid,
                      1 As planned
                 From swp_smart_attendance_plan w
                Where w.empno = p_empno
                  And attendance_date Between v_start_date And v_end_date
            ),
            Holiday as (
            select holiday , 1 as is_holiday from SS_HOLIDAYS
               where holiday Between v_start_date And v_end_date
            )
         Select e.empno As empno,
                dd.d_day,
                dd.d_date,
                nvl(atnd_days.planned, 0) As planned,
                atnd_days.deskid As deskid ,
                nvl(hh.is_holiday,0) as is_holiday 
           From ss_emplmast e,
                ss_days_details dd,
                atnd_days ,
                Holiday hh
          Where e.empno = Trim(p_empno)

            And dd.d_date = atnd_days.attendance_date(+) 
            and dd.d_date = hh.holiday(+)
            And d_date Between v_start_date And v_end_date
          Order By dd.d_date;
      Return c;

   End;
   Function fn_week_attend_planning(
      p_person_id   Varchar2,
      p_meta_id     Varchar2,
      p_date        Date     Default sysdate,
      p_assign_code Varchar2 Default Null,
      p_row_number  Number,
      p_page_length Number
   ) Return Sys_Refcursor As
      c                    Sys_Refcursor;
      v_empno              Varchar2(5);
      e_employee_not_found Exception;
      Pragma exception_init(e_employee_not_found, -20001);
      v_query              Varchar2(4200);
      v_start_date         Date := IOT_SWP_COMMON.get_monday_date(p_date) - 1;
      v_end_date           Date := IOT_SWP_COMMON.get_friday_date(p_date);
      Cursor cur_days Is
         Select to_char(d_date, 'yyyymmdd') yymmdd, to_char(d_date, 'DY') dday
           From ss_days_details
          Where d_date Between v_start_date And v_end_date;
   Begin
      --v_start_date := get_monday_date(p_date);
      --v_end_date   := get_friday_date(p_date);

      v_query := c_qry_attendance_planning;
      For c1 In cur_days
      Loop
         If c1.dday = 'MON' Then
            v_query := replace(v_query, '!MON!', chr(39)
                          || c1.yymmdd
                          || chr(39));
         Elsif c1.dday = 'TUE' Then
            v_query := replace(v_query, '!TUE!', chr(39)
                          || c1.yymmdd
                          || chr(39));
         Elsif c1.dday = 'WED' Then
            v_query := replace(v_query, '!WED!', chr(39)
                          || c1.yymmdd
                          || chr(39));
         Elsif c1.dday = 'THU' Then
            v_query := replace(v_query, '!THU!', chr(39)
                          || c1.yymmdd
                          || chr(39));
         Elsif c1.dday = 'FRI' Then
            v_query := replace(v_query, '!FRI!', chr(39)
                          || c1.yymmdd
                          || chr(39));
         End If;
      End Loop;
      v_empno := get_empno_from_meta_id(p_meta_id);
      If v_empno = 'ERRRR' Then
         Raise e_employee_not_found;
      End If;
      /*
              Insert Into swp_mail_log (subject, mail_sent_to_cc_bcc, modified_on)
              Values (v_empno || '-' || p_row_number || '-' || p_page_length || '-' || to_char(v_start_date, 'yyyymmdd') || '-' ||
                  to_char(v_end_date, 'yyyymmdd'),
                  v_query, sysdate);
              Commit;
              */
      Open c For v_query Using v_empno, p_row_number, p_page_length, v_start_date, v_end_date, p_person_id, p_meta_id, p_assign_code;

      Return c;

   End;

End IOT_SWP_SMART_WORKSPACE_QRY;
/
---------------------------
--Changed PACKAGE BODY
--IOT_SWP_CONFIG_WEEK
---------------------------
CREATE OR REPLACE PACKAGE BODY "SELFSERVICE"."IOT_SWP_CONFIG_WEEK" As
    c_plan_close_code  Constant Number := 0;
    c_plan_open_code   Constant Number := 1;
    c_past_plan_code   Constant Number := 0;
    c_cur_plan_code    Constant Number := 1;
    c_future_plan_code Constant Number := 2;

    --
    Procedure init_configuration(p_sysdate Date) As
        v_next_week_mon       Date;
        v_next_week_fri       Date;
        v_next_week_key_id    Varchar2(8);
        v_current_week_key_id Varchar2(8);
        v_count               Number;
    Begin
        Select
            Count(*)
        Into
            v_count
        From
            swp_config_weeks;
        If v_count > 0 Then
            Return;
        End If;
        v_next_week_mon       := iot_swp_qry.get_monday_date(p_sysdate + 6);
        v_next_week_fri       := iot_swp_qry.get_friday_date(p_sysdate + 6);
        v_current_week_key_id := dbms_random.string('X', 8);
        --Insert New Plan dates
        Insert Into swp_config_weeks(
            key_id,
            start_date,
            end_date,
            planning_flag,
            planning_open
        )
        Values(
            v_current_week_key_id,
            v_next_week_mon,
            v_next_week_fri,
            c_future_plan_code,
            c_plan_close_code
        );

    End;

    --
    Procedure close_planning As
    Begin
        Update
            swp_config_weeks
        Set
            planning_open = c_plan_close_code
        Where
            planning_open = c_plan_open_code;
    End close_planning;
    --

    Procedure toggle_plan_future_to_curr As
    Begin
        --Close Planning
        close_planning;
        --toggle CURRENT to PAST
        Update
            swp_config_weeks
        Set
            planning_flag = c_past_plan_code
        Where
            planning_flag = c_cur_plan_code;
        --toggle FUTURE to CURRENT 
        Update
            swp_config_weeks
        Set
            planning_flag = c_cur_plan_code
        Where
            planning_flag = c_future_plan_code;

        --Toggle WorkSpace planning FUTURE to CURRENT
        Update
            swp_primary_workspace
        Set
            active_code = c_past_plan_code
        Where
            active_code = c_cur_plan_code
            And empno In (
                Select
                    empno
                From
                    swp_primary_workspace
                Where
                    active_code = c_future_plan_code
            );

        Update
            swp_primary_workspace
        Set
            active_code = c_cur_plan_code
        Where
            active_code = c_future_plan_code;

    End toggle_plan_future_to_curr;
    --
    Procedure rollover_n_open_planning(p_sysdate Date) As
        v_next_week_mon       Date;
        v_next_week_fri       Date;
        v_next_week_key_id    Varchar2(8);
        v_current_week_key_id Varchar2(8);
    Begin
        --Close and toggle existing planning
        toggle_plan_future_to_curr;

        v_next_week_mon    := iot_swp_qry.get_monday_date(p_sysdate + 6);
        v_next_week_fri    := iot_swp_qry.get_friday_date(p_sysdate + 6);
        v_next_week_key_id := dbms_random.string('X', 8);
        --Insert New Plan dates
        Insert Into swp_config_weeks(
            key_id,
            start_date,
            end_date,
            planning_flag,
            planning_open
        )
        Values(
            v_next_week_key_id,
            v_next_week_mon,
            v_next_week_fri,
            c_future_plan_code,
            c_plan_open_code
        );

        --Get current week key id
        Select
            key_id
        Into
            v_current_week_key_id
        From
            swp_config_weeks
        Where
            planning_flag = c_cur_plan_code;

        Insert Into swp_smart_attendance_plan(
            key_id,
            ws_key_id,
            empno,
            attendance_date,
            modified_on,
            modified_by,
            deskid,
            week_key_id
        )
        Select
            dbms_random.string('X', 10),
            a.ws_key_id,
            a.empno,
            trunc(a.attendance_date) + 7,
            p_sysdate,
            'Sys',
            a.deskid,
            v_next_week_key_id
        From
            swp_smart_attendance_plan a
        Where
            week_key_id = v_current_week_key_id;

    End rollover_n_open_planning;
    --
    Procedure do_cofiguration Is
        v_secondlast_workdate Date;
        v_sysdate             Date;
        Type rec Is Record(
                work_date     Date,
                work_day_desc Varchar2(100),
                rec_num       Number
            );

        Type typ_tab_work_day Is Table Of rec;
        tab_work_day          typ_tab_work_day;
    Begin

        v_sysdate := trunc(sysdate);
        --
        init_configuration(v_sysdate);
        --
        Select
            d_date As work_date,
            Case Rownum
                When 1 Then
                    'LAST'
                When 2 Then
                    'SECOND_LAST'
                Else
                    Null
            End    work_day_desc,
            Rownum As rec_num
        Bulk Collect
        Into
            tab_work_day
        From
            (
                Select
                    *
                From
                    ss_days_details
                Where
                    d_date <= (selfservice.iot_swp_qry.get_friday_date(trunc(v_sysdate)))
                    And d_date >= trunc(v_sysdate)
                    And d_date Not In
                    (
                        Select
                            trunc(holiday)
                        From
                            ss_holidays
                        Where
                            (holiday < (selfservice.iot_swp_qry.get_friday_date(trunc(v_sysdate)))
                                And holiday >= trunc(v_sysdate))
                    )
                Order By d_date Desc
            )
        Where
            Rownum In(1, 2);

        If tab_work_day.count = 2 Then
            --v_sysdate EQUAL SECOND_LAST working day "THURSDAY"
            If v_sysdate = tab_work_day(2).work_date Then --SECOND_LAST working day
                rollover_n_open_planning(v_sysdate);
                --v_sysdate EQUAL LAST working day "FRIDAY"
                --        ElsIf V_SYSDATE = tab_work_day(1).work_date Then --LAST working day
            Else
                toggle_plan_future_to_curr;

            End If;
        End If;
    End do_cofiguration;

End iot_swp_config_week;
/
