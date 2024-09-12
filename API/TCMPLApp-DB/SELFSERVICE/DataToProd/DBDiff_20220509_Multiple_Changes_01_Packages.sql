--------------------------------------------------------
--  File created - Monday-May-09-2022   
--------------------------------------------------------
---------------------------
--Changed PACKAGE
--IOT_SWP_EMP_PROJ_MAP_QRY
---------------------------
CREATE OR REPLACE PACKAGE "SELFSERVICE"."IOT_SWP_EMP_PROJ_MAP_QRY" As

Function fn_emp_proj_map_list(
      p_person_id   Varchar2,
      p_meta_id     Varchar2,
      
       p_generic_search varchar2 default null, 
        p_projno Varchar2 Default Null,
        p_assign_code Varchar2 Default Null,
      
      p_row_number  Number,
      p_page_length Number
   ) Return Sys_Refcursor;

procedure sp_Swp_Emp_Emp_Proj_details(
   p_person_id        varchar2,
   p_meta_id          varchar2,

   p_Application_Id   varchar2,

   p_Empno        out varchar2,
   p_Emp_name     out varchar2,
   P_Projno       out varchar2,
   P_Proj_Name    out varchar2,

   p_message_type out varchar2,
   p_message_text out varchar2
   ); 

end IOT_SWP_EMP_PROJ_MAP_QRY;
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

End iot_swp_primary_workspace_qry;
/
---------------------------
--Changed PACKAGE BODY
--IOT_SWP_EMP_PROJ_MAP_QRY
---------------------------
CREATE OR REPLACE PACKAGE BODY "SELFSERVICE"."IOT_SWP_EMP_PROJ_MAP_QRY" as

   function fn_emp_proj_map_list(
      p_person_id      varchar2,
      p_meta_id        varchar2,

      p_generic_search varchar2 default null,
      p_projno         varchar2 default null,
      p_assign_code    varchar2 default null,

      p_row_number     number,
      p_page_length    number
   ) return sys_refcursor
   is
      c                     sys_refcursor;
      v_count               number;
      v_empno               varchar2(5);
      v_hod_sec_assign_code varchar2(4);
      e_employee_not_found  exception;
      pragma exception_init(e_employee_not_found, -20001);

   begin

      v_empno := get_empno_from_meta_id(p_meta_id);
      if v_empno = 'ERRRR' then
         raise e_employee_not_found;
         return null;
      end if;

      if v_empno is null or p_assign_code is not null then
         v_hod_sec_assign_code := iot_swp_common.get_default_costcode_hod_sec(
                                     p_hod_sec_empno => v_empno,
                                     p_assign_code   => p_assign_code
                                  );
      end if;
      open c for
         with proj as (select distinct proj_no, name from ss_projmast  where active =1)
         select *
           from (
                   select empprojmap.key_id as keyid,
                          empprojmap.empno as empno,
                          a.name as empname,
                          empprojmap.projno as projno,
                          b.name as projname,
                          row_number() over (order by empprojmap.key_id desc) row_number,
                          count(*) over () total_row
                     from swp_emp_proj_mapping empprojmap,
                          ss_emplmast a,
                          proj b
                    where a.empno = empprojmap.empno
                      and b.proj_no = empprojmap.projno
                      and empprojmap.projno = nvl(p_projno, empprojmap.projno)
                      and (upper(a.name) like upper('%'
                                || p_generic_search
                                || '%')
                             or
                             upper(a.empno) like upper('%'
                                || p_generic_search
                                || '%')
                          )
                      and empprojmap.empno in (
                             select distinct empno
                               from ss_emplmast
                              where status = 1
                                and a.assign = nvl(v_hod_sec_assign_code, a.assign)
                          /*
                          And assign In (
                                  Select parent
                                    From ss_user_dept_rights
                                   Where empno = v_empno
                                  Union
                                  Select costcode
                                    From ss_costmast
                                   Where hod = v_empno
                               )
                          */
                          )

                )
          where row_number between (nvl(p_row_number, 0) + 1) and (nvl(p_row_number, 0) + p_page_length)
          order by empno,
                projno;
      return c;

   end fn_emp_proj_map_list;

   procedure sp_Swp_Emp_Emp_Proj_details(
      p_person_id        varchar2,
      p_meta_id          varchar2,

      p_Application_Id   varchar2,

      p_Empno        out varchar2,
      p_Emp_name     out varchar2,
      P_Projno       out varchar2,
      P_Proj_Name    out varchar2,

      p_message_type out varchar2,
      p_message_text out varchar2
   ) as
      v_empno        varchar2(5);
      v_user_tcp_ip  varchar2(5) := 'NA';
      v_message_type number      := 0;
   begin
      v_empno        := get_empno_from_meta_id(p_meta_id);

      if v_empno = 'ERRRR' then
         p_message_type := 'KO';
         p_message_text := 'Invalid employee number';
         return;
      end if;

      with proj as (select distinct proj_no, name from ss_projmast where active =1)
      select empprojmap.empno as empno,
             a.name as empname,
             empprojmap.projno as projno,
             b.name as projname
        into P_empno,
             P_emp_name,
             P_Projno,
             P_Proj_Name
        from swp_emp_proj_mapping empprojmap,
             ss_emplmast a,
             proj b
       where empprojmap.key_id = p_Application_Id
         and a.empno = empprojmap.empno
         and b.proj_no = empprojmap.projno;

      p_message_type := 'OK';
      p_message_text := 'Procedure executed successfully.';

   exception
      when others then
         p_message_type := 'KO';
         p_message_text := 'ERR :- '
                           || sqlcode
                           || ' - '
                           || sqlerrm;

   end sp_Swp_Emp_Emp_Proj_details;

   --  GRANT EXECUTE ON "IOT_SWP_EMP_PROJ_MAP_QRY" TO "TCMPL_APP_CONFIG";

end iot_swp_emp_proj_map_qry;
/
