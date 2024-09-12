--------------------------------------------------------
--  DDL for Package Body PKG_DESKBOOK_SELECT_LIST_QRY
--------------------------------------------------------

Create Or Replace Package Body desk_book.pkg_deskbook_select_list_qry As

    Function fn_deskbook_date_list(
        p_person_id Varchar2,
        p_meta_id   Varchar2,
        p_for_empno Varchar2 Default Null
    ) Return Sys_Refcursor As
        c                Sys_Refcursor;
        v_next_work_date Date;
    Begin
        v_next_work_date := selfservice.iot_swp_common.fn_get_next_work_date(sysdate + 1);
        Open c For
            Select
                to_char(d_date, 'yyyymmdd')         data_value_field,
                to_char(d_date, 'Dy - dd-Mon-yyyy') data_text_field
            From
                selfservice.ss_days_details
            Where
                d_date Between trunc(sysdate) And v_next_work_date
            Order By
                d_date Desc;

        Return c;
    End;

    Function fn_deskbook_date_range_list(
        p_person_id Varchar2,
        p_meta_id   Varchar2,
        p_for_empno Varchar2 Default Null
    ) Return Sys_Refcursor As
        c                    Sys_Refcursor;
        v_next_work_date     Date;
        v_previous_work_date Date;
    Begin
        v_previous_work_date := selfservice.iot_swp_common.fn_get_prev_work_date(sysdate - 7);
        v_next_work_date     := selfservice.iot_swp_common.fn_get_next_work_date(sysdate + 1);
        Open c For
            Select
                to_char(d_date, 'yyyymmdd')         data_value_field,
                to_char(d_date, 'Dy - dd-Mon-yyyy') data_text_field
            From
                selfservice.ss_days_details
            Where
                d_date Between v_previous_work_date And v_next_work_date
            Order By
                d_date;

        Return c;
    End;

    Function fn_deskbook_previous_date_list(
        p_person_id Varchar2,
        p_meta_id   Varchar2,
        p_for_empno Varchar2 Default Null
    ) Return Sys_Refcursor As
        c                    Sys_Refcursor;
        v_previous_work_date Date;
    Begin
        v_previous_work_date := selfservice.iot_swp_common.fn_get_prev_work_date(sysdate - 7);
        Open c For
            Select
                to_char(d_date, 'yyyymmdd')         data_value_field,
                to_char(d_date, 'Dy - dd-Mon-yyyy') data_text_field
            From
                selfservice.ss_days_details
            Where
                trunc(d_date) < trunc(sysdate)
                And trunc(d_date) >= trunc(v_previous_work_date)
            Order By
                d_date;

        Return c;
    End;

    Function fn_deskbook_office_shiftlist(
        p_person_id Varchar2,
        p_meta_id   Varchar2,
        p_office    Varchar2
    ) Return Sys_Refcursor As
        c Sys_Refcursor;
    Begin
        Open c For
            Select
                os.shiftcode data_value_field,
                sm.shiftdesc data_text_field
            From
                db_map_office_shifts     os,
                selfservice.ss_shiftmast sm
            Where
                os.shiftcode  = sm.shiftcode
                And office_id = p_office;

        Return c;
    End;

    Function fn_deskbook_availabledesks(
        p_person_id Varchar2,
        p_meta_id   Varchar2,
        p_date      Date,
        p_office    Varchar2,
        p_shift     Varchar2
    ) Return Sys_Refcursor As

        c                        Sys_Refcursor;
        v_shift_details          selfservice.ss_shiftmast%rowtype;
        v_shift_start_time       Number(4);
        v_shift_end_time         Number(4);
        v_empno                  Varchar2(5);
        v_emp_assign             Varchar2(4);
        v_assigned_area_id       Varchar2(3);
        v_area_desc              Varchar2(150);
        v_assigned_office_code   Varchar2(4);
        v_assigned_area_type     Varchar2(4);
        v_assigned_desk          Varchar2(7);
        c_area_fixed_pc_cabin    Constant Varchar2(4) := 'AT03';
        c_area_open              Constant Varchar2(4) := 'AT05';
        c_area_proj              Constant Varchar2(4) := 'AT02';
        c_area_dept              Constant Varchar2(4) := 'AT01';
        v_count                  Number;
        v_desk_available_in_area Varchar2(4);

        rec_shift                selfservice.ss_shiftmast%rowtype;
    Begin
        v_empno            := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            Return Null;
        End If;

        --Get Area assigned to employee
        Begin
            Select
                --am.empno,
                am.area_id,
                am.office_code,
                da.desk_area_type,
                udm.desk_id,
                da.area_desc
            Into
                v_assigned_area_id,
                v_assigned_office_code,
                v_assigned_area_type,
                v_assigned_desk,
                v_area_desc
            From
                dms.dm_area_type_user_mapping                      am
                Join dms.dm_desk_areas                             da
                On am.area_id = da.area_key_id
                And am.empno  = v_empno
                Left Outer Join dms.dm_area_type_user_desk_mapping udm
                On am.area_id    = udm.area_id
                And da.is_active = 1;

            --Fixed PC/Cabin
            If v_assigned_area_type = c_area_fixed_pc_cabin Then
                Open c For
                    Select
                        v_assigned_desk data_value_field,
                        v_assigned_desk data_text_field,
                        v_area_desc     data_group_field
                    From
                        dual
                    Where
                        Not Exists (
                            Select
                                deskid
                            From
                                db_desk_bookings
                            Where
                                trunc(attendance_date) = p_date
                                And deskid             = v_assigned_desk
                        );

                Return c;
            End If;

        Exception
            When Others Then
                Null;
        End;
        --
        Begin
            Select
                *
            Into
                rec_shift
            From
                selfservice.ss_shiftmast
            Where
                shiftcode = p_shift;
        Exception
            When Others Then
                Return Null;

        End;

        v_shift_start_time := rec_shift.timein_hh * 60 + rec_shift.timein_mn + 1;
        v_shift_end_time   := (rec_shift.timeout_hh * 60) + rec_shift.timeout_mn;

        -- Check desks available in Assigned Area
        Select
            Count(*)
        Into
            v_count
        From
            dms.dm_deskmaster
        Where
            Trim(office)  = p_office
            And work_area = v_assigned_area_id
            And deskid Not In (
                Select
                    deskid
                From
                    db_desk_bookings
                Where
                    trunc(attendance_date) = p_date
                    And end_time >= v_shift_start_time
            );

        If v_count > 0 Then
            v_desk_available_in_area := v_assigned_area_id;
        Else
            -- Check desks available in Open Area
            Select
                Count(*)
            Into
                v_count
            From
                dms.dm_deskmaster
            Where
                Trim(office)  = p_office
                And work_area = c_area_open
                And deskid Not In (
                    Select
                        deskid
                    From
                        db_desk_bookings
                    Where
                        trunc(attendance_date) = p_date
                        And end_time >= v_shift_start_time
                );

            If v_count > 0 Then
                v_desk_available_in_area := c_area_open;
            End If;
        End If;
        --When desk is available in Assigned / Open area
        If v_desk_available_in_area Is Not Null Then
            Open c For
                Select
                    a.deskid    data_value_field,
                    a.deskid    data_text_field,
                    b.area_desc data_group_field
                From
                    dms.dm_deskmaster a,
                    dms.dm_desk_areas b
                Where
                    Trim(a.office)  = p_office
                    And a.work_area = b.area_key_id
                    And b.is_active = 1
                    And a.work_area = v_desk_available_in_area
                    And a.deskid Not In (
                        Select
                            deskid
                        From
                            db_desk_bookings
                        Where
                            trunc(attendance_date) = p_date
                            And end_time >= v_shift_start_time
                    )
                Order By
                    b.area_desc,
                    a.deskid;

            Return c;
        End If;
        
        --When desks not available in Assigned & Open areas
        --Get Desks available from all non restricted areas
        Open c For
            Select
                a.deskid    data_value_field,
                a.deskid    data_text_field,
                b.area_desc data_group_field
            From
                dms.dm_deskmaster a,
                dms.dm_desk_areas b
            Where
                Trim(a.office)  = p_office
                And a.work_area = b.area_key_id
                And b.is_active = 1
                And a.work_area In (
                    Select
                        area_key_id
                    From
                        dms.dm_desk_areas
                    Where
                        desk_area_type In (c_area_proj, c_area_dept)
                        And is_restricted = 0
                )
                And a.deskid Not In (
                    Select
                        deskid
                    From
                        db_desk_bookings
                    Where
                        trunc(attendance_date) = p_date
                        And end_time >= v_shift_start_time
                )
            Order By
                b.area_desc,
                a.deskid;

        Return c;
    End;

    Function fn_project_list(
        p_person_id Varchar2,
        p_meta_id   Varchar2
    ) Return Sys_Refcursor As
        c Sys_Refcursor;
    Begin
        Open c For
            Select
            Distinct
                proj_no                  data_value_field,
                proj_no || ' - ' || name data_text_field
            From
                vu_projmast
            Where
                active = 1
                And proj_no In (
                    Select
                        projno
                    From
                        dms.dm_desk_area_proj_map
                )
            Order By
                proj_no;

        Return c;
    End;

    Function fn_tag_list_4_emp(
        p_person_id Varchar2,
        p_meta_id   Varchar2,
        p_empno     Varchar2 Default Null
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
        If p_empno Is Not Null Then
            v_empno := p_empno;
        End If;
        Open c For
            Select
                to_char(a.tag_id) As data_value_field,
                b.tag_name        As data_text_field
            From
                dms.dm_tag_obj_mapping a,
                dms.dm_tag_master      b,
                dms.dm_tag_obj_type    c
            Where
                a.tag_id          = b.key_id
                And a.obj_type_id = c.obj_type_id
                And a.obj_type_id = 1
                And a.obj_id      = v_empno
            Order By
                b.tag_name;

        Return c;
    End;

    Function fn_area_list_area_catg_code_wise(
        p_person_id      Varchar2,
        p_meta_id        Varchar2,
        p_area_catg_code Varchar2 Default Null
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
                a.area_key_id data_value_field,
                a.area_desc   data_text_field
            From
                dms.dm_desk_areas           a,
                dms.dm_desk_area_categories c
            Where
                c.area_catg_code     = a.area_catg_code
                And a.area_key_id Not In ('A59', 'A56', 'A57')
                And a.area_catg_code = nvl(p_area_catg_code, a.area_catg_code)
            Order By
                a.area_desc;

        Return c;
    End;

    Function fn_today_availabledesks(
        p_person_id Varchar2,
        p_meta_id   Varchar2,
        p_office    Varchar2,
        p_shift     Varchar2
    ) Return Sys_Refcursor As

        c                        Sys_Refcursor;
        v_shift_details          selfservice.ss_shiftmast%rowtype;
        v_shift_start_time       Number(4);
        v_shift_end_time         Number(4);
        v_empno                  Varchar2(5);
        v_emp_assign             Varchar2(4);
        v_assigned_area_id       Varchar2(3);
        v_assigned_office_code   Varchar2(4);
        v_assigned_area_type     Varchar2(4);
        v_assigned_desk          Varchar2(7);
        c_area_fixed_pc_cabin    Constant Varchar2(4) := 'AT03';
        c_area_open              Constant Varchar2(4) := 'AT05';
        c_area_proj              Constant Varchar2(4) := 'AT02';
        c_area_dept              Constant Varchar2(4) := 'AT01';
        v_count                  Number;
        v_desk_available_in_area Varchar2(4);
        v_sysdate                Date;
    --rec_user_area_map  dms.dm_area_type_user_mapping;
    Begin
        v_empno   := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            Return Null;
        End If;
        v_sysdate := trunc(sysdate);
        
        --When desks not available in Assigned & Open areas
        --Get Desks available from all non restricted areas
        Open c For
            Select
                deskid data_value_field,
                deskid data_text_field
            From
                dms.dm_deskmaster
            Where
                Trim(office) = p_office
                And work_area In (
                    Select
                        area_key_id
                    From
                        dms.dm_desk_areas
                    Where
                        desk_area_type In (c_area_proj, c_area_dept)
                        And is_restricted = 0
                )
                And Trim(deskid) Not In (
                    Select
                        Trim(deskid)
                    From
                        db_desk_bookings
                    Where
                        trunc(attendance_date) = v_sysdate
                );

        Return c;
    End;

    Function fn_office_list(
        p_person_id Varchar2,
        p_meta_id   Varchar2
    ) Return Sys_Refcursor As

        c                    Sys_Refcursor;
        v_empno              Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'errrr' Then
            Raise e_employee_not_found;
            Return Null;
        End If;
        Open c For
            Select
                office_location_code data_value_field,
                office_desc          data_text_field
            From
                dms.dm_offices
            Where
                smart_desk_booking_enabled = ok
            Order By
                office_location_code;

        Return c;
    End;

    Function fn_book_desk_list(
        p_person_id       Varchar2,
        p_meta_id         Varchar2,
        p_attendance_date Date
    ) Return Sys_Refcursor As

        c                    Sys_Refcursor;
        v_empno              Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'errrr' Then
            Raise e_employee_not_found;
            Return Null;
        End If;
        Open c For
            Select
                dm.deskid,
                da.area_catg_code,
                da.desk_area_type,
                at.description,
                Case
                    When db.deskid Is Not Null Then
                        ok
                    Else
                        not_ok
                End is_booked
            From
                dms.dm_deskmaster                dm
                Left Join dms.dm_desk_areas      da
                On dm.work_area = da.area_key_id
                Join dms.dm_desk_area_categories dac
                On da.area_catg_code = dac.area_catg_code
                Join dms.dm_area_type            at
                On da.desk_area_type = at.key_id
                Left Join db_desk_bookings       db
                On dm.deskid           = db.deskid
                And db.attendance_date = trunc(p_attendance_date)
            Where
                dm.office = 'MOC4';

        Return c;
    End;

    Function fn_get_empno(
        p_person_id Varchar2,
        p_meta_id   Varchar2,
        p_deskid    Varchar2,
        p_date      Date
    ) Return Varchar2 As
        v_return Varchar2(5);
    Begin
        --Select Empno, deskid, attendance_date from db_desk_bookings where deskid ='ZA065' and trunc(attendance_date) = trunc(:P_date);
        Select
            empno
        Into
            v_return
        From
            db_desk_bookings
        Where
            deskid                     = p_deskid
            And trunc(attendance_date) = trunc(p_date);
        Return v_return;
    End;

    Function fn_paging_cabin_list_4_cabin_booking(
        p_person_id       Varchar2,
        p_meta_id         Varchar2,
        p_attendance_date Date     Default Null,
        p_generic_search  Varchar2 Default Null,
        p_row_number      Number,
        p_page_length     Number
    ) Return Sys_Refcursor As
        v_generic_search     Varchar2(100);
        c                    Sys_Refcursor;
        v_empno              Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'errrr' Then
            Raise e_employee_not_found;
            Return Null;
        End If;

        If p_generic_search Is Not Null Then
            v_generic_search := '%' || upper(trim(p_generic_search)) || '%';
        Else
            v_generic_search := '%';
        End If;

        Open c For
            Select
                a.deskid                                          As data_value_field,
                a.deskid || ' - ' || a.office || ' - ' || a.floor As data_text_field,
                Row_Number() Over(Order By
                        deskid)                                   As row_number,
                Count(*) Over()                                   As total_row
            From
                db_cabins a
            Where
                a.deskid Not In (
                    Select
                        b.deskid
                    From
                        db_cabin_bookings b
                    Where
                        b.attendance_date = p_attendance_date
                )
                And (a.deskid Like v_generic_search)
            Order By
                a.deskid;

        Return c;
    End;
End;
/