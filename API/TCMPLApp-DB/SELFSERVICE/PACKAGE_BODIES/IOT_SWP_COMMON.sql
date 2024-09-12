Create Or Replace Package Body selfservice.iot_swp_common As

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
        /*
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
                */
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
        --End If;
        --Return v_retval;
        /*
        Select
            Count(*)
        Into
            v_count
        From
            swp_temp_desk_allocation
        Where
            empno = p_empno;

        If v_count > 0 Then
            Select
                deskid
            Into
                v_retval
            From
                swp_temp_desk_allocation
            Where
                empno = Trim(p_empno);
            Return '*!-' || v_retval;
        End If;
*/
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
        v_day_num := To_Number(to_char(p_date, 'd'));
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
        v_emp_pws      Number;
        v_friday_date  Date;
        v_pws_for_date Date;
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
        p_empno Varchar2
    ) Return Number As
        v_is_swp_eligible Varchar2(2);
        v_is_dual_monitor Number(1);
        v_is_laptop_user  Number(1);
    Begin

        v_is_laptop_user  := is_emp_laptop_user(p_empno);
        v_is_dual_monitor := is_emp_dualmonitor_user(p_empno);
        v_is_swp_eligible := get_emp_is_eligible_4swp(p_empno);

        If v_is_laptop_user = 1 And v_is_swp_eligible = 'OK' And v_is_dual_monitor = 0 Then
            Return 1;
        Else
            Return 0;
        End If;
    Exception
        When Others Then
            Return Null;
    End;

    Function fn_can_work_smartly(
        p_empno Varchar2,
        p_date  Date
    ) Return Number As
        v_is_swp_eligible Varchar2(2);
        v_is_dual_monitor Number(1);
        v_is_laptop_user  Number(1);
        v_ret_val         Number;
        v_office_loc_code Varchar2(2);
        c_yes             Number := 1;
        c_no              Number := 0;
        d_may_2           Date   := To_Date('2-May-2023', 'dd-Mon-yyyy');
        d_sep_13          Date   := To_Date('13-Sep-2023', 'dd-Mon-yyyy');
        v_count           Number;
        v_is_emp_resigned Varchar2(2);
    Begin

        v_ret_val := fn_can_work_smartly(p_empno);

        If v_ret_val = c_yes And p_date >= d_may_2 Then
            v_office_loc_code := tcmpl_hr.pkg_common.fn_get_emp_office_location(p_empno, p_date);
            Select
                Count(*)
            Into
                v_count
            From
                swp_exclude_office_loc_4sws
            Where
                office_location_code = v_office_loc_code;
            If v_count > 0 Then
                v_ret_val := c_no;
            End If;
        End If;
        If v_ret_val = c_yes And p_date >= d_sep_13 Then
            --Is employee resigned.

            v_is_emp_resigned := tcmpl_hr.pkg_common.fn_is_emp_resigned(p_empno);
            If v_is_emp_resigned = ok Then
                v_ret_val := c_no;
            End If;
        End If;

        Return v_ret_val;

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
            dms.dm_usermaster     um
        Where
            um.deskid    = da.deskid
            And um.empno = p_empno
            And da.assetid Like 'IT084MO%'
            And um.deskid Not Like 'H%';

        If v_count >= 2 Then
            Return 1;
        Else
            Return 0;

        End If;

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
        v_count             Number;
        v_punch_exists      Boolean;
        row_depu_tour       ss_depu%rowtype;
        row_onduty          ss_ondutyapp%rowtype;
        row_leave           ss_leaveapp%rowtype;
        row_leaveledg       ss_leaveledg%rowtype;
        row_exclude_emp     swp_exclude_emp%rowtype;
        row_absent_lop      ss_absent_lop%rowtype;
        row_absent_ts_lop   ss_absent_ts_lop%rowtype;
        v_default_return    Varchar2(15);
        e_general_exception Exception;
        Pragma exception_init(e_general_exception, -20002);
    Begin
        v_default_return := 'Absent';
        /*
        Select
            Count(*)
        Into
            v_count
        From
            ss_holidays
        Where
            holiday = trunc(p_date);
        */
        v_count          := pkg_region_holiday_calc.fn_get_holiday(
                                p_empno      => p_empno,
                                p_start_date => p_date
                            );
        If v_count > 0 Then
            v_default_return := '';

        End If;
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
            Return 'Present';
        End If;

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

        Exception
            When Others Then
                Null;
        End;

        Begin

            --Check Missed / In-Out punch onduty

            Declare
                v_od_ret_val Varchar2(100);
            Begin
                Select
                    *
                Into
                    row_onduty
                From
                    ss_ondutyapp
                Where
                    type In (
                        'IO', 'MP', 'OD'
                    )
                    And empno = p_empno
                    And pdate = trunc(p_date);

                If row_onduty.type = 'IO' Then
                    v_od_ret_val := 'Onduty Forgot card';
                Else
                    v_od_ret_val := 'Onduty MP/OD';
                End If;

                If row_onduty.hrd_apprl = 1 Then
                    Return v_od_ret_val;
                Else
                    Return v_od_ret_val || ' applied';

                End If;
            Exception
                When Others Then
                    Null;
            End;

            --Check Leave app
            Declare
                v_leave_desc Varchar2(100);
            Begin
                Select
                    Count(*)
                Into
                    v_count
                From
                    ss_leaveapp
                Where
                    empno = p_empno
                    And p_date Between bdate And nvl(edate, bdate);
                If v_count > 0 Then
                    v_leave_desc := 'Leave applied';
                Else
                    Raise e_general_exception;
                End If;
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
                    v_leave_desc := 'Leave';
                Else
                    v_leave_desc := 'Leave applied';
                End If;
                If nvl(row_exclude_emp.is_active, 0) = 1 Then
                    Return v_leave_desc || ' + Exception';
                Else
                    Return v_leave_desc;
                End If;

            Exception
                When Others Then
                    If Trim(v_leave_desc) Is Not Null Then
                        Return v_leave_desc;
                    End If;
            End;

            -- Check Loss of pay PUNCH DETAILS...
            Begin
                Select
                    *
                Into
                    row_absent_lop
                From
                    ss_absent_lop
                Where
                    empno          = p_empno
                    And lop_4_date = p_date
                    And lop_4_date Not In(
                        Select
                            lop_4_date
                        From
                            ss_absent_lop_reverse
                        Where
                            empno          = p_empno
                            And lop_4_date = p_date
                    );
                Return 'LWP-PunchDetails';
            Exception
                When Others Then
                    Null;
            End;

            -- Check Loss of pay TIMESHEET...
            Begin
                Select
                    *
                Into
                    row_absent_ts_lop
                From
                    ss_absent_ts_lop
                Where
                    empno          = p_empno
                    And lop_4_date = p_date;

                Return 'LWP-Timesheet';
            Exception
                When Others Then
                    Null;
            End;

            --Check Leave LEDG for Leave Claim & Smart Work Leave deduction
            Declare
                v_leave_desc Varchar2(100);
            Begin
                Select
                    *
                Into
                    row_leaveledg
                From
                    ss_leaveledg
                Where
                    empno     = p_empno
                    And p_date Between bdate And nvl(edate, bdate)
                    And adj_type In ('LC', 'SW')
                    And db_cr = 'D';
                If row_leaveledg.adj_type = 'SW' Then
                    v_leave_desc := 'SWP-Leave';
                Else
                    v_leave_desc := 'Leave';
                End If;
                If nvl(row_exclude_emp.is_active, 0) = 1 Then
                    Return v_leave_desc || ' + Exception';
                Else
                    Return v_leave_desc;
                End If;
            Exception
                When Others Then
                    Null;
            End;

            --Check deputation / tour / remote work
            Begin
                Select
                    Count(*)
                Into
                    v_count
                From
                    ss_depu
                Where
                    type In ('TR', 'DP', 'RW')
                    And empno = p_empno
                    And p_date Between bdate And edate;

                If v_count > 1 Then
                    Return 'Tour-Deputation-err';
                End If;

                Select
                    *
                Into
                    row_depu_tour
                From
                    ss_depu
                Where
                    type In ('TR', 'DP', 'RW', 'SW')
                    And empno = p_empno
                    And p_date Between bdate And edate;

                If row_depu_tour.hrd_apprl = 1 Then
                    If row_depu_tour.type In ('RW', 'SW') Then
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

            If row_exclude_emp.is_active = 1 Then
                Return 'Exception';
            End If;

            Return v_default_return;
        Exception
            When Others Then
                Return 'ERR';
        End;
    End;

    Function fn_get_attendance_status(
        p_empno Varchar2,
        p_date  Date,
        p_pws   Number
    ) Return Varchar2 As
        v_count             Number;
        v_ret_val           Varchar2(100);
        v_fri_date          Date;
        v_swp_start_date    Date;
        v_primary_workspase Number;
    Begin
        v_primary_workspase := nvl(p_pws, 1);
        If p_empno Is Null Or p_date Is Null Or v_primary_workspase Is Null Then
            Return Null;
        End If;
        v_swp_start_date    := To_Date('18-Apr-2022');
        /*
        Select
            Count(*)
        Into
            v_count
        From
            ss_holidays
        Where
            holiday = trunc(p_date);
        */
        v_count             := pkg_region_holiday_calc.fn_is_holiday(p_empno, p_date);

        If v_count > 0 Then
            --Return '';
            Null;
        End If;
        v_ret_val           := fn_get_attendance_status(
                                   p_empno => p_empno,
                                   p_date  => p_date
                               );
        If v_primary_workspase Not In (2, 3) Then --Office workspace
            Return v_ret_val;
        End If;
        If v_primary_workspase = 3 Then -- Deputation workspace
            If v_ret_val = 'Absent' Then
                Return 'OnSite';
            Elsif v_ret_val In ('Present', 'Onduty Forgot card') Then
                Return 'OutOfTurn ' || v_ret_val;
            Else
                Return v_ret_val;
            End If;
        End If;

        v_fri_date          := get_friday_date(sysdate);

        --Smart workspace
        If trunc(p_date) <= v_fri_date And trunc(p_date) >= v_swp_start_date Then
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
                If v_ret_val = 'Present' Then
                    Return 'OutOfTurn Present';
                Elsif v_ret_val = 'Absent' Then
                    Return 'Smartly Present';
                End If;
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
        If p_date > (sysdate) Then
            Return 'No';
        End If;
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

    Function fn_get_prev_work_date(
        p_prev_date Date Default Null
    ) Return Date
    As
        v_prev_date Date;
        v_count     Number;
    Begin
        v_prev_date := trunc(nvl(p_prev_date, sysdate));
        Select
            Count(*)
        Into
            v_count
        From
            ss_holidays
        Where
            holiday = v_prev_date;
        If v_count = 0 Then
            Return v_prev_date;
        Else
            Return fn_get_prev_work_date(v_prev_date - 1);
        End If;

    End;

    Function fn_get_next_work_date(
        p_from_date Date Default Null
    ) Return Date
    As
        v_from_date Date;
        v_count     Number;
        v_ret_date  Date;
    Begin
        v_from_date := trunc(nvl(p_from_date, sysdate));

        Select
            d_date
        Into
            v_ret_date
        From
            (
                Select
                    d_date
                From
                    ss_days_details
                Where
                    d_date Between v_from_date And v_from_date + 7
                    And d_date Not In (
                        Select
                            holiday
                        From
                            ss_holidays
                        Where
                            holiday Between v_from_date And v_from_date + 7
                        Union
                        Select
                            holiday_leave_date
                        From
                            ss_holiday_against_leave
                        Where
                            holiday_leave_date Between v_from_date And v_from_date + 7
                    )
                Order By d_date
            )
        Where
            Rownum = 1;
        Return v_ret_date;
    Exception
        When Others Then
            Return Null;

    End;

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
                p_curr_desk_id := get_desk_from_dms(p_empno);
                Select
                    dm.office,
                    dm.floor,
                    dm.wing,
                    dm.bay
                Into
                    p_curr_office,
                    p_curr_floor,
                    p_curr_wing,
                    p_curr_bay
                From
                    dms.dm_deskmaster dm
                Where
                    dm.deskid = p_curr_desk_id;
            Exception
                When Others Then
                    Null;
            End;
        End If;

        If p_planning_pws = 1 Then --Office
            Begin
                p_plan_desk_id := get_desk_from_dms(p_empno);
                Select
                    dm.office,
                    dm.floor,
                    dm.wing,
                    dm.bay
                Into
                    p_plan_office,
                    p_plan_floor,
                    p_plan_wing,
                    p_plan_bay
                From
                    dms.dm_deskmaster dm
                Where
                    dm.deskid = p_plan_desk_id;
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

    Procedure get_dept_planning_weekdetails(
        p_person_id                 Varchar2,
        p_meta_id                   Varchar2,
        p_assign_code               Varchar2 Default Null,
        p_plan_start_date       Out Date,
        p_plan_end_date         Out Date,
        p_curr_start_date       Out Date,
        p_curr_end_date         Out Date,
        p_planning_exists       Out Varchar2,
        p_pws_open              Out Varchar2,
        p_sws_open              Out Varchar2,
        p_ows_open              Out Varchar2,
        p_dept_ows_quota_exists Out Varchar2,
        p_dept_ows_quota        Out Number,
        p_message_type          Out Varchar2,
        p_message_text          Out Varchar2
    ) As
        v_by_empno           Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
        v_assign_code        Varchar2(4);
        v_rec_plan_week      swp_config_weeks%rowtype;
        v_dept_quota         swp_dept_workspace_summary%rowtype;
    Begin

        v_by_empno     := get_empno_from_meta_id(p_meta_id);

        If v_by_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return;
        End If;

        get_planning_week_details(
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
        If p_message_type = 'KO' Then
            Return;
        End If;
        v_assign_code  := p_assign_code;
        If v_assign_code Is Null Then
            v_assign_code := iot_swp_common.get_default_costcode_hod_sec(
                                 p_hod_sec_empno => v_by_empno,
                                 p_assign_code   => p_assign_code
                             );

        End If;
        If p_planning_exists = 'OK' Then
            Select
                *
            Into
                v_rec_plan_week
            From
                swp_config_weeks
            Where
                planning_flag = 2;
            p_dept_ows_quota_exists := iot_swp_primary_workspace.fn_dept_ows_quota_exists(
                                           p_assign       => v_assign_code,
                                           p_week_key_id  => v_rec_plan_week.key_id,
                                           p_message_type => p_message_type,
                                           p_message_text => p_message_text
                                       );
            Begin
                --Get quota from dept summary
                Select
                    *
                Into
                    v_dept_quota
                From
                    swp_dept_workspace_summary
                Where
                    week_key_id = v_rec_plan_week.key_id
                    And assign  = v_assign_code;
                p_dept_ows_quota := nvl(v_dept_quota.ows_emp_count, 0) + nvl(v_dept_quota.sws_emp_count, 0) + nvl(v_dept_quota.
                dws_emp_count, 0);
            Exception
                When Others Then
                    p_dept_ows_quota := 0;
            End;

        Else
            p_dept_ows_quota_exists := 'KO';
            p_dept_ows_quota        := 0;
        End If;
        p_message_type := 'OK';
        p_message_text := 'Procedure executed successfully.';
    Exception
        When Others Then
            p_dept_ows_quota_exists := 'KO';
            p_message_type          := 'KO';
            p_message_text          := 'Err ' || sqlcode || ' - ' || sqlerrm;

    End;

    Function fn_emp_office_loc_sws_elig(
        p_empno      Varchar2,
        p_start_date Date,
        p_end_date   Date

    ) Return Varchar2 As
        v_count                Number;
        v_office_location_code Varchar2(2);
    Begin
    
        --Check if record exists for employee / location mapping
        Select
            Count(*)
        Into
            v_count
        From
            tcmpl_hr.eo_employee_office_map
        Where
            empno = p_empno;
        If v_count = 0 Then
            Return not_ok;
        End If;

        --check if record exists between two date
        Select
            Count(*)
        Into
            v_count
        From
            tcmpl_hr.eo_employee_office_map
        Where
            empno = p_empno
            And start_date Between p_start_date And p_end_date;

        If v_count > 0 Then
            Return not_ok;
        End If;
        
        --Get office location code
        Begin
            Select
                    Max(office_location_code) Keep (Dense_Rank Last Order By
                    start_date) office_location_code
            Into
                v_office_location_code
            From
                tcmpl_hr.eo_employee_office_map
            Where
                empno = p_empno
                And start_date <= p_end_date
            Group By
                empno
            Order By
                empno,
                start_date;
        Exception
            When Others Then
                Return not_ok;
        End;
        --check location is excluded from sws
        Select
            Count(*)
        Into
            v_count
        From
            swp_exclude_office_loc_4sws
        Where
            office_location_code = v_office_location_code;
        If v_count = 0 Then
            Return ok;
        Else
            Return not_ok;
        End If;
    Exception
        When Others Then
            Return not_ok;
    End;

End iot_swp_common;