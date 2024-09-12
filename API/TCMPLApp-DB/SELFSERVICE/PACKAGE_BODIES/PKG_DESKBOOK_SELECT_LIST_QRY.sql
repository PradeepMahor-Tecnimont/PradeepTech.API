Create Or Replace Package Body selfservice.pkg_deskbook_select_list_qry As

    Function fn_deskbook_date_list(
        p_person_id Varchar2,
        p_meta_id   Varchar2,
        p_for_empno Varchar2 Default Null
    ) Return Sys_Refcursor As
        c                Sys_Refcursor;
        v_next_work_date Date;
    Begin

        v_next_work_date := iot_swp_common.fn_get_next_work_date(sysdate + 1);

        Open c For
            Select
                to_char(d_date, 'yyyymmdd')         data_value_field,
                to_char(d_date, 'Dy - dd-Mon-yyyy') data_text_field
            From
                ss_days_details
            Where
                d_date Between trunc(sysdate) And v_next_work_date
            Order By
                d_date Desc;
        Return c;

    End;

    Function fn_deskbook_office_list(
        p_person_id Varchar2,
        p_meta_id   Varchar2,
        p_for_empno Varchar2 Default Null
    ) Return Sys_Refcursor As
        c       Sys_Refcursor;
        v_empno Varchar2(5);

    Begin

        If p_for_empno Is Null Then
            v_empno := get_empno_from_meta_id(p_meta_id);

            If v_empno = 'ERRRR' Then

                Return Null;
            End If;
        Else
            v_empno := p_for_empno;
        End If;

        Open c For

            With
                desk_book_offices As (
                    Select
                        office_code,
                        office_name,
                        office_location_code
                    From
                        dms.dm_offices
                    Where
                        smart_desk_booking_enabled = ok

                )

            Select
                office_code data_value_field,
                office_name data_text_field
            From
                desk_book_offices
            Where
                office_location_code = tcmpl_hr.pkg_common.fn_get_emp_office_location(v_empno)
            Union
            Select
                office_code data_value_field,
                office_name data_text_field
            From
                desk_book_offices
            Where
                office_code In (
                    Select
                        office_code
                    From
                        db_map_emp_office
                    Where
                        office_code In(
                            Select
                                office_code
                            From
                                dms.dm_offices
                            Where
                                smart_desk_booking_enabled = ok
                        )
                        And empno = v_empno
                );
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
                db_map_office_shifts os,
                ss_shiftmast         sm
            Where
                os.shiftcode  = sm.shiftcode
                And office_id = p_office;

        Return c;
    End;

    Function fn_deskbook_deskareas(
        p_person_id Varchar2,
        p_meta_id   Varchar2,
        p_office    Varchar2 Default Null,
        p_for_empno Varchar2 Default Null
    ) Return Sys_Refcursor As
        c            Sys_Refcursor;
        v_empno      Varchar2(5);
        v_emp_assign Varchar2(4);
    Begin

        If p_for_empno Is Null Then
            v_empno := get_empno_from_meta_id(p_meta_id);

            If v_empno = 'ERRRR' Then
                Return Null;
            End If;
        Else
            v_empno := p_for_empno;
        End If;

        Select
            assign
        Into
            v_emp_assign
        From
            ss_emplmast
        Where
            empno = v_empno;

        Open c For

            Select
                area_key_id data_value_field,
                area_desc   data_text_field
            From
                dms.dm_desk_areas
            Where
                area_key_id In (
                    Select
                        area_id
                    From
                        dms.dm_desk_area_office_map om,
                        dms.dm_desk_areas           da
                    Where
                        om.area_id            = da.area_key_id
                        And da.area_catg_code = 'A005'
                        And office_code       = p_office
                        And office_code In (

                            Select
                                office_code
                            From
                                dms.dm_offices
                            Where
                                smart_desk_booking_enabled = ok
                                And office_location_code   = tcmpl_hr.pkg_common.fn_get_emp_office_location(v_empno)
                            Union
                            Select
                                office_code
                            From
                                db_map_emp_office
                            Where
                                office_code In(
                                    Select
                                        office_code
                                    From
                                        dms.dm_offices
                                    Where
                                        smart_desk_booking_enabled = ok
                                )
                                And empno = v_empno
                        )
                    Union
                    Select
                        area_code
                    From
                        (
                            Select
                                area_code
                            From
                                dms.dm_desk_area_dept_map dd,
                                dms.dm_desk_areas         da
                            Where
                                dd.area_code          = da.area_key_id
                                And da.area_catg_code = 'A006'
                                And assign            = v_emp_assign
                            Union
                            Select
                                area_code
                            From
                                dms.dm_desk_area_proj_map dd,
                                dms.dm_desk_areas         da
                            Where
                                dd.area_code          = da.area_key_id
                                And da.area_catg_code = 'A006'
                                And
                                projno In (
                                    Select
                                        projno
                                    From
                                        db_map_emp_office
                                    Where
                                        empno = v_empno
                                )
                        )
                );
        Return c;
    End;

    Function fn_deskbook_availabledesks(
        p_person_id Varchar2,
        p_meta_id   Varchar2,
        p_date      Date,
        p_office    Varchar2,
        p_shift     Varchar2,
        p_area_id   Varchar2
    ) Return Sys_Refcursor As
        c                  Sys_Refcursor;
        v_shift_details    ss_shiftmast%rowtype;
        v_shift_start_time Number(4);
        v_shift_end_time   Number(4);
    Begin
        /*
                Select
                    *
                Into
                    v_shift_details
                From
                    ss_shiftmast
                Where
                    shiftcode = p_shift;
        
                v_shift_start_time := v_shift_details.timein_hh * 60 + v_shift_details.timein_mn + 1;
                v_shift_end_time   := v_shift_details.timeout_hh * 60 + v_shift_details.timeout_mn;
        */

        Open c For

            Select
                deskid data_value_field,
                deskid data_text_field
            From
                dms.dm_deskmaster
            Where
                Trim(office)  = p_office
                And work_area = p_area_id
                And deskid Not In (
                    Select
                        deskid
                    From
                        db_desk_bookings
                    Where
                        trunc(attendance_date) = p_date
                );

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
                ss_projmast
            Where
                active = 1
                And proj_no In(
                    Select
                        projno
                    From
                        dms.dm_desk_area_proj_map
                )
            Order By
                proj_no;
        Return c;
    End;
End;