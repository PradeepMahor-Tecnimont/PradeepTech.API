--------------------------------------------------------
--  File created - Tuesday-May-24-2022   
--------------------------------------------------------
---------------------------
--Changed PACKAGE
--IOT_SWP_COMMON
---------------------------
CREATE OR REPLACE PACKAGE "SELFSERVICE"."IOT_SWP_COMMON" As

    Function fn_get_pws_text(
        p_pws_type_code Number
    ) Return Varchar2;

    Function fn_get_dept_group(
        p_costcode Varchar2
    ) Return Varchar2;

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

    Function get_swp_planned_desk(
        p_empno In Varchar2
    ) Return Varchar2;

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

    Function get_default_dept4plan_hod_sec(
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

    Function fn_get_emp_pws(
        p_empno Varchar2,
        p_date  Date Default Null
    ) Return Number;

    Function fn_get_emp_pws_planning(
        p_empno Varchar2 Default Null
    ) Return Varchar2;

    Function is_desk_in_general_area(
        p_deskid Varchar2
    ) Return Boolean;

    Function fn_can_do_desk_plan_4_emp(
        p_empno Varchar2
    ) Return Boolean;

    Function fn_can_work_smartly(
        p_empno Varchar2
    ) Return Number;

    Function fn_is_present_4_swp(
        p_empno Varchar2,
        p_date  Date
    ) Return Number;

    Function get_emp_is_eligible_4swp(
        p_empno Varchar2 Default Null
    ) Return Varchar2;

    Function is_emp_dualmonitor_user(
        p_empno Varchar2 Default Null
    ) Return Number;

    Function get_emp_projno_desc(
        p_empno Varchar2
    ) Return Varchar2;

    Function fn_get_attendance_status(
        p_empno Varchar2,
        p_date  Date
    ) Return Varchar2;

    Function fn_get_attendance_status(
        p_empno Varchar2,
        p_date  Date,
        p_pws   Number
    ) Return Varchar2;

    Function fn_is_attendance_required(
        p_empno Varchar2,
        p_date  Date,
        p_pws   Number
    ) Return Varchar2;

    -----------------------
    Procedure get_planning_week_details(
        p_person_id           Varchar2,
        p_meta_id             Varchar2,
        p_plan_start_date Out Date,
        p_plan_end_date   Out Date,
        p_curr_start_date Out Date,
        p_curr_end_date   Out Date,
        p_planning_exists Out Varchar2,
        p_pws_open        Out Varchar2,
        p_sws_open        Out Varchar2,
        p_ows_open        Out Varchar2,
        p_message_type    Out Varchar2,
        p_message_text    Out Varchar2

    );

    Procedure sp_primary_workspace(
        p_person_id                   Varchar2,
        p_meta_id                     Varchar2,
        p_empno                       Varchar2 Default Null,

        p_current_workspace_text  Out Varchar2,
        p_current_workspace_val   Out Varchar2,
        p_current_workspace_date  Out Varchar2,

        p_planning_workspace_text Out Varchar2,
        p_planning_workspace_val  Out Varchar2,
        p_planning_workspace_date Out Varchar2,

        p_message_type            Out Varchar2,
        p_message_text            Out Varchar2

    );

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
    );

    Procedure sp_get_emp_workspace_details(
        p_person_id             Varchar2,
        p_meta_id               Varchar2,
        p_empno                 Varchar2,
        p_current_pws       Out Number,
        p_planning_pws      Out Number,
        p_current_pws_text  Out Varchar2,
        p_planning_pws_text Out Varchar2,
        p_curr_desk_id      Out Varchar2,
        p_curr_office       Out Varchar2,
        p_curr_floor        Out Varchar2,
        p_curr_wing         Out Varchar2,
        p_curr_bay          Out Varchar2,
        p_plan_desk_id      Out Varchar2,
        p_plan_office       Out Varchar2,
        p_plan_floor        Out Varchar2,
        p_plan_wing         Out Varchar2,
        p_plan_bay          Out Varchar2,
        p_message_type      Out Varchar2,
        p_message_text      Out Varchar2
    );

End iot_swp_common;
/
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
--IOT_SWP_COMMON
---------------------------
CREATE OR REPLACE PACKAGE BODY "SELFSERVICE"."IOT_SWP_COMMON" As


    Function fn_get_pws_text(
        p_pws_type_code Number
    ) Return Varchar2 As
        v_ret_val Varchar2(100);
    Begin
        If p_pws_type_code Is Null Or p_pws_type_code = -1 Then
            Return Null;
        End If;
        Select
            type_desc
        Into
            v_ret_val
        From
            swp_primary_workspace_types
        Where
            type_code = p_pws_type_code;
        Return v_ret_val;
    Exception
        When Others Then
            Return Null;
    End;

    Function fn_get_dept_group(
        p_costcode Varchar2
    ) Return Varchar2 As
        v_retval Varchar2(100);
    Begin
        Select
            group_name
        Into
            v_retval
        From
            ss_dept_grouping
        Where
            parent = p_costcode;
        Return v_retval;
    Exception
        When Others Then
            Return Null;
    End;

    Function get_emp_work_area(
        p_person_id Varchar2,
        p_meta_id   Varchar2,
        p_empno     Varchar2
    ) Return Varchar2 As
        v_count  Number;
        v_projno Varchar2(5);
        v_area   Varchar2(60);
    Begin

        Select
            Count(dapm.office || ' - ' || ep.projno || ' - ' || da.area_desc)
        Into
            v_count
        From
            swp_emp_proj_mapping      ep,
            dms.dm_desk_area_proj_map dapm,
            dms.dm_desk_areas         da
        Where
            ep.projno          = dapm.projno
            And dapm.area_code = da.area_key_id
            And ep.empno       = p_empno;

        If (v_count > 0) Then

            Select
                dapm.office || ' - ' || ep.projno || ' - ' || da.area_desc
            Into
                v_area
            From
                swp_emp_proj_mapping      ep,
                dms.dm_desk_area_proj_map dapm,
                dms.dm_desk_areas         da
            Where
                ep.projno          = dapm.projno
                And dapm.area_code = da.area_key_id
                And ep.empno       = p_empno
                And Rownum         = 1;

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
        v_retval Varchar(50);
        v_count  Number;
    Begin

        Select
            Count(*)
        Into
            v_count
        From
            dms.dm_usermaster
        Where
            empno = Trim(p_empno)
            And deskid Not Like 'H%';

        If v_count > 0 Then
            Select
                deskid
            Into
                v_retval
            From
                dms.dm_usermaster
            Where
                empno = Trim(p_empno)
                And deskid Not Like 'H%';
            Return v_retval;
        End If;

        Select
            Count(*)
        Into
            v_count
        From
            dms.dm_usermaster
        Where
            empno = p_empno
            And deskid Not Like 'H%';

        If v_count > 0 Then
            Select
                deskid
            Into
                v_retval
            From
                swp_temp_desk_allocation
            Where
                empno = Trim(p_empno);
            Return v_retval;
        End If;

        Return v_retval;
    Exception
        When Others Then
            Return Null;
    End get_desk_from_dms;

    Function get_swp_planned_desk(
        p_empno In Varchar2
    ) Return Varchar2 As
        v_retval Varchar(50) := 'NA';
    Begin

        Select
        Distinct deskid As desk
        Into
            v_retval
        From
            dms.dm_usermaster_swp_plan dmst
        Where
            dmst.empno = Trim(p_empno)
            And dmst.deskid Not Like 'H%';

        Return v_retval;
    Exception
        When Others Then
            Return Null;
    End get_swp_planned_desk;

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

    Function fn_get_emp_pws(
        p_empno Varchar2,
        p_date  Date Default Null
    ) Return Number As
        v_plan_start_date Date;
        v_plan_end_date   Date;
        v_curr_start_date Date;
        v_curr_end_date   Date;
        v_planning_exists Varchar2(2);
        v_pws_open        Varchar2(2);
        v_sws_open        Varchar2(2);
        v_ows_open        Varchar2(2);
        v_msg_type        Varchar2(10);
        v_msg_text        Varchar2(1000);
        v_emp_pws         Number;
        v_friday_date     Date;
        v_pws_for_date    Date;
    Begin
        v_pws_for_date := trunc(nvl(p_date, sysdate));
        Begin
            Select
                a.primary_workspace
            Into
                v_emp_pws
            From
                swp_primary_workspace a
            Where
                a.empno             = p_empno
                And
                trunc(a.start_date) = (
                    Select
                        Max(trunc(start_date))
                    From
                        swp_primary_workspace b
                    Where
                        b.empno = a.empno
                        And b.start_date <= v_pws_for_date
                );
            Return v_emp_pws;
        Exception
            When Others Then
                Return Null;
        End;
    End;

    Function fn_get_emp_pws_planning(
        p_empno Varchar2 Default Null
    ) Return Varchar2 As
        v_emp_pws        Number;
        v_pws_for_date   Date;
        row_config_weeks swp_config_weeks%rowtype;
    Begin
        If p_empno Is Null Then
            Return Null;
        End If;
        Begin
            Select
                *
            Into
                row_config_weeks
            From
                swp_config_weeks
            Where
                planning_flag = 2;
            v_pws_for_date := row_config_weeks.end_date;
        Exception
            When Others Then
                Null;
        End;
        v_emp_pws := fn_get_emp_pws(p_empno, v_pws_for_date);
        v_emp_pws := nvl(v_emp_pws, -1);
        Return fn_get_pws_text(v_emp_pws);
    Exception
        When Others Then
            Return Null;
    End;

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

    Function fn_can_work_smartly(
        p_empno varchar2
    ) Return number As
        v_is_swp_eligible number(1);
        v_is_dual_monitor number(1);
        v_is_laptop_user number(1);
    Begin

        v_is_laptop_user := is_emp_laptop_user(p_empno);
        v_is_dual_monitor := is_emp_dualmonitor_user(p_empno);
        v_is_swp_eligible := get_emp_is_eligible_4swp(p_empno);

        If v_is_laptop_user = 1 and v_is_swp_eligible = 1 and v_is_dual_monitor = 0 Then
            return 1;
            else return 0;
        End If;
    Exception
        When Others Then
            Return Null;
    End;


    Function fn_is_present_4_swp(
        p_empno Varchar2,
        p_date  Date
    ) Return Number
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
            empno     = p_empno
            And pdate = p_date
            And type  = 'IO';
        If v_count > 0 Then
            Return 1;
        End If;

        --OnTour / Deputation / Remote Work
        Select
            Count(*)
        Into
            v_count
        From
            ss_depu
        Where
            empno         = Trim(p_empno)
            And bdate <= p_date
            And nvl(edate, bdate) >= p_date

            And hrd_apprl = 1;

        If v_count > 0 Then
            Return 1;
        End If;

        --Exception
        Select
            Count(*)
        Into
            v_count
        From
            swp_exclude_emp
        Where
            empno         = Trim(p_empno)
            And p_date Between start_date And end_date
            And is_active = 1;
        If v_count > 0 Then
            Return 1;
        End If;
        Return 0;
    End;

    Function get_emp_is_eligible_4swp(
        p_empno Varchar2 Default Null
    ) Return Varchar2 As
    Begin
        If Trim(p_empno) Is Null Then
            Return Null;
        End If;
        Return is_emp_eligible_for_swp(p_empno);
    End;

    Function is_emp_dualmonitor_user(
        p_empno Varchar2 Default Null
    ) Return Number As
        v_count Number;
    Begin
        Select
            Count(da.assetid)
        Into
            v_count
        From
            dms.dm_deskallocation da,
            dms.dm_usermaster     um,
            dms.dm_assetcode      ac
        Where
            um.deskid             = da.deskid
            And um.empno          = p_empno
            And ac.sub_asset_type = 'IT0MO'
            And da.assetid        = ac.barcode
            And um.deskid Not Like 'H%';
        If v_count >= 2 Then
            Return 1;
        Else
            Return 0;

        End If;

        --
        Select
            Count(da.assetid)
        Into
            v_count
        From
            dms.dm_deskallocation da,
            dms.dm_usermaster     um,
            dms.dm_assetcode      ac
        Where
            um.deskid             = da.deskid
            And um.empno          = p_empno
            And ac.sub_asset_type = 'IT0MO'
            And da.assetid        = ac.barcode
            And um.deskid Like 'H%';
        If v_count >= 2 Then
            Return 1;
        Else
            Return 0;

        End If;

    Exception
        When Others Then
            Return 0;
    End;

    Function get_emp_projno_desc(
        p_empno Varchar2
    ) Return Varchar2 As
        v_projno    Varchar2(5);
        v_proj_name ss_projmast.name%Type;
    Begin
        Select
            projno
        Into
            v_projno
        From
            swp_emp_proj_mapping
        Where
            empno = p_empno;
        Select
        Distinct name
        Into
            v_proj_name
        From
            ss_projmast
        Where
            proj_no = v_projno;
        Return v_projno || ' - ' || v_proj_name;
    Exception
        When Others Then
            Return '';
    End;

    Function fn_get_attendance_status(
        p_empno Varchar2,
        p_date  Date
    ) Return Varchar2 As
        v_count         Number;
        v_punch_exists  Boolean;
        row_depu_tour   ss_depu%rowtype;
        row_onduty      ss_ondutyapp%rowtype;
        row_leave       ss_leaveapp%rowtype;
        row_exclude_emp swp_exclude_emp%rowtype;
    Begin
        Select
            Count(*)
        Into
            v_count
        From
            ss_integratedpunch

        Where
            empno     = p_empno
            And pdate = p_date
            And mach <> 'WFH0';

        If v_count > 0 Then
            Return 'Punch exists';
        End If;

        --Check Leave
        Begin
            Select
                *
            Into
                row_leave
            From
                ss_leaveapp
            Where
                empno = p_empno
                And p_date Between bdate And nvl(edate, bdate);
            If row_leave.hrd_apprl = 1 Then
                Return 'Leave';
            Else
                Return 'Leave applied';
            End If;
        Exception
            When Others Then
                Null;
        End;

        --Check deputation / tour / remote work
        Begin
            Select
                *
            Into
                row_depu_tour
            From
                ss_depu
            Where
                type In ('TR', 'DP', 'RW')
                And empno = p_empno
                And p_date Between bdate And edate;

            If row_depu_tour.hrd_apprl = 1 Then
                If row_depu_tour.type = 'RW' Then
                    Return 'Smart Work Applied';
                End If;
                Return 'Tour-Deputation';
            Else
                Return 'Tour-Deputation applied';
            End If;
        Exception
            When Others Then
                Null;
        End;
        --Check Missed / In-Out punch onduty
        Begin
            Select
                *
            Into
                row_onduty
            From
                ss_ondutyapp
            Where
                type In (
                    'MP', 'IO'
                )
                And empno = p_empno
                And pdate = trunc(p_date);
            If row_onduty.hrd_apprl = 1 Then
                Return 'Onduty MP/IO';
            Else
                Return 'Onduty MP/IO applied';

            End If;
        Exception
            When Others Then
                Null;
        End;

        --Check Exception
        Begin
            Select
                *
            Into
                row_exclude_emp
            From
                swp_exclude_emp
            Where
                p_date Between start_date And end_date
                And empno = p_empno;

            If row_exclude_emp.is_active = 1 Then
                Return 'Exception';
            End If;
        Exception
            When Others Then
                Null;
        End;

        Return 'Punch not exists';
    Exception
        When Others Then
            Return 'ERR';
    End;

    Function fn_get_attendance_status(
        p_empno Varchar2,
        p_date  Date,
        p_pws   Number
    ) Return Varchar2 As
        v_count   Number;
        v_ret_val Varchar2(100);
    Begin
        If p_empno Is Null Or p_date Is Null Or p_pws Is Null Then
            Return Null;
        End If;
        v_ret_val := fn_get_attendance_status(
                         p_empno => p_empno,
                         p_date  => p_date
                     );
        If p_pws Not In (2, 3) Then --Office workspace
            Return v_ret_val;
        End If;
        If p_pws = 3 Then -- Deputation workspace
            If v_ret_val = 'Punch not exists' Then
                Return 'OnSite';
            Else
                Return v_ret_val;
            End If;
        End If;
        --Smart workspace
        Select
            Count(*)
        Into
            v_count
        From
            swp_smart_attendance_plan
        Where
            empno               = p_empno
            And attendance_date = p_date;
        If v_count = 0 Then
            If v_ret_val = 'Punch exists' Then
                Return 'OutOfTurn Present';
            Elsif v_ret_val = 'Punch not exists' Then
                Return 'Smartly Present';
            End If;
        End If;
        Return v_ret_val;
    End;

    Function fn_is_attendance_required(
        p_empno Varchar2,
        p_date  Date,
        p_pws   Number
    ) Return Varchar2 As
        v_count   Number;
        v_ret_val Varchar2(100);
    Begin
        If p_pws = 1 Then
            Return 'Yes';
        End If;
        If p_pws = 3 Then
            Return 'No';
        End If;
        If p_pws = 2 Then
            Select
                Count(*)
            Into
                v_count
            From
                swp_smart_attendance_plan
            Where
                empno               = p_empno
                And attendance_date = p_date;
            If v_count > 0 Then
                Return 'Yes';
            Else
                Return 'No';
            End If;
        End If;
        Return '--';
    End;
    --

    Procedure sp_get_emp_workspace_details(
        p_person_id             Varchar2,
        p_meta_id               Varchar2,
        p_empno                 Varchar2,
        p_current_pws       Out Number,
        p_planning_pws      Out Number,
        p_current_pws_text  Out Varchar2,
        p_planning_pws_text Out Varchar2,
        p_curr_desk_id      Out Varchar2,
        p_curr_office       Out Varchar2,
        p_curr_floor        Out Varchar2,
        p_curr_wing         Out Varchar2,
        p_curr_bay          Out Varchar2,
        p_plan_desk_id      Out Varchar2,
        p_plan_office       Out Varchar2,
        p_plan_floor        Out Varchar2,
        p_plan_wing         Out Varchar2,
        p_plan_bay          Out Varchar2,
        p_message_type      Out Varchar2,
        p_message_text      Out Varchar2
    ) As
        v_current_pws     Number;
        v_planning_pws    Number;
        v_plan_start_date Date;
        v_plan_end_date   Date;
        v_curr_start_date Date;
        v_curr_end_date   Date;
        v_planning_exists Varchar2(2);
        v_pws_open        Varchar2(2);
        v_sws_open        Varchar2(2);
        v_ows_open        Varchar2(2);
        v_msg_type        Varchar2(10);
        v_msg_text        Varchar2(1000);
        v_emp_pws         Number;
        v_friday_date     Date;
    Begin
        get_planning_week_details(
            p_person_id       => p_person_id,
            p_meta_id         => p_meta_id,
            p_plan_start_date => v_plan_start_date,
            p_plan_end_date   => v_plan_end_date,
            p_curr_start_date => v_curr_start_date,
            p_curr_end_date   => v_curr_end_date,
            p_planning_exists => v_planning_exists,
            p_pws_open        => v_pws_open,
            p_sws_open        => v_sws_open,
            p_ows_open        => v_ows_open,
            p_message_type    => v_msg_type,
            p_message_text    => v_msg_text

        );

        p_current_pws       := fn_get_emp_pws(
                                   p_empno => p_empno,
                                   p_date  => trunc(sysdate)
                               );
        If v_plan_end_date Is Not Null Then
            p_planning_pws := fn_get_emp_pws(
                                  p_empno => p_empno,
                                  p_date  => v_plan_end_date
                              );
        End If;
        p_current_pws_text  := fn_get_pws_text(p_current_pws);
        p_planning_pws_text := fn_get_pws_text(p_planning_pws);
        If p_current_pws = 1 Then --Office
            Begin
                Select
                    u.deskid,
                    dm.office,
                    dm.floor,
                    dm.wing,
                    dm.bay
                Into
                    p_curr_desk_id,
                    p_curr_office,
                    p_curr_floor,
                    p_curr_wing,
                    p_curr_bay
                From
                    dms.dm_usermaster u,
                    dms.dm_deskmaster dm
                Where
                    u.empno      = p_empno
                    And u.deskid = dm.deskid;
            Exception
                When Others Then
                    Null;
            End;
        End If;

        If p_planning_pws = 1 Then --Office
            Begin
                Select
                    u.deskid,
                    dm.office,
                    dm.floor,
                    dm.wing,
                    dm.bay
                Into
                    p_plan_desk_id,
                    p_plan_office,
                    p_plan_floor,
                    p_plan_wing,
                    p_plan_bay
                From
                    dms.dm_usermaster u,
                    dms.dm_deskmaster dm
                Where
                    u.empno      = p_empno
                    And u.deskid = dm.deskid;
            Exception
                When Others Then
                    Null;
            End;
            /*
        Elsif p_planning_pws = 2 Then --SMART
            p_plan_sws := iot_swp_smart_workspace_qry.fn_emp_week_attend_planning(
                              p_person_id => p_person_id,
                              p_meta_id   => p_meta_id,
                              p_empno     => p_empno,
                              p_date      => v_plan_start_date
                          );
*/
        End If;
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

    Procedure sp_primary_workspace(
        p_person_id                   Varchar2,
        p_meta_id                     Varchar2,
        p_empno                       Varchar2 Default Null,

        p_current_workspace_text  Out Varchar2,
        p_current_workspace_val   Out Varchar2,
        p_current_workspace_date  Out Varchar2,

        p_planning_workspace_text Out Varchar2,
        p_planning_workspace_val  Out Varchar2,
        p_planning_workspace_date Out Varchar2,

        p_message_type            Out Varchar2,
        p_message_text            Out Varchar2

    ) As
        v_count              Number;
        v_empno              Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);

    Begin

        If p_empno Is Not Null Then
            v_empno := p_empno;
        Else
            v_empno := get_empno_from_meta_id(p_meta_id);
        End If;

        If v_empno = 'ERRRR' Then
            Raise e_employee_not_found;
        End If;
        Begin
            Select
            Distinct
                a.primary_workspace As p_primary_workspace_val,
                b.type_desc         As p_primary_workspace_text,
                a.start_date        As p_primary_workspace_date
            Into
                p_current_workspace_val,
                p_current_workspace_text,
                p_current_workspace_date
            From
                swp_primary_workspace       a,
                swp_primary_workspace_types b
            Where
                a.primary_workspace = b.type_code
                And a.empno         = v_empno
                And a.active_code   = 1;
        Exception
            When Others Then
                p_current_workspace_text := 'NA';
        End;

        Begin
            Select
            Distinct
                a.primary_workspace As p_primary_workspace_val,
                b.type_desc         As p_primary_workspace_text,
                a.start_date        As p_primary_workspace_date
            Into
                p_planning_workspace_val,
                p_planning_workspace_text,
                p_planning_workspace_date
            From
                swp_primary_workspace       a,
                swp_primary_workspace_types b
            Where
                a.primary_workspace = b.type_code
                And a.empno         = v_empno
                And a.active_code   = 2;
        Exception
            When Others Then
                p_planning_workspace_text := 'NA';
        End;
        p_message_type := 'OK';
        p_message_text := 'Procedure executed successfully.';
    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
    End sp_primary_workspace;

    Procedure get_planning_week_details(
        p_person_id           Varchar2,
        p_meta_id             Varchar2,
        p_plan_start_date Out Date,
        p_plan_end_date   Out Date,
        p_curr_start_date Out Date,
        p_curr_end_date   Out Date,
        p_planning_exists Out Varchar2,
        p_pws_open        Out Varchar2,
        p_sws_open        Out Varchar2,
        p_ows_open        Out Varchar2,
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
            p_pws_open        := 'KO';
            p_sws_open        := 'KO';
            p_ows_open        := 'KO';
            p_planning_exists := 'KO';
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
            p_pws_open        := Case
                                     When nvl(v_rec_plan_week.pws_open, 0) = 1 Then
                                         'OK'
                                     Else
                                         'KO'
                                 End;
            p_sws_open        := Case
                                     When nvl(v_rec_plan_week.sws_open, 0) = 1 Then
                                         'OK'
                                     Else
                                         'KO'
                                 End;
            p_ows_open        := Case
                                     When nvl(v_rec_plan_week.ows_open, 0) = 1 Then
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

End iot_swp_common;
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

End iot_swp_attendance_qry;
/
