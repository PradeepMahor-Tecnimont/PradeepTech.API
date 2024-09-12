Create Or Replace Package Body dms.db_select_list_qry As

    Function fn_area_list_4_desk_booking(
        p_person_id Varchar2,
        p_meta_id   Varchar2,
        p_area_type Varchar2 Default Null,
        p_office    Varchar2 Default Null,
        p_dept      Varchar2 Default Null,
        p_proj      Varchar2 Default Null
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
                dm_desk_areas           a,
                dm_desk_area_office_map b,
                dm_desk_area_categories c
            Where
                c.area_catg_code = a.area_catg_code
                And a.area_key_id = b.area_id
                And a.desk_area_type = nvl(p_area_type, a.desk_area_type)
                And b.office_code = nvl(p_office, b.office_code)
                And a.is_active = 1
            Order By
                a.area_desc;
        Return c;
    End;

    Function fn_area_list_4_assignment(
        p_person_id Varchar2,
        p_meta_id   Varchar2,
        p_empno     Varchar2 Default Null,
        p_area_type Varchar2 Default Null,
        p_office    Varchar2 Default Null
    ) Return Sys_Refcursor As
        c                    Sys_Refcursor;
        v_empno              Varchar2(5);
        v_count              Number;
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;
        If p_empno Is Not Null Then
            Select
                Count(*)
            Into
                v_count
            From
                (
                    Select
                        a.area_key_id data_value_field,
                        a.area_desc   data_text_field
                    From
                        dm_desk_areas a
                    Where
                        a.is_active = 1
                        And a.area_key_id In (
                            Select
                                Trim(c.obj_id) As area_id
                            From
                                dm_tag_obj_mapping c
                            Where
                                c.tag_id In (
                                    Select
                                        tag_id
                                    From
                                        dm_tag_obj_mapping
                                    Where
                                        obj_type_id = 1 -- Employee Only
                                        And Trim(obj_id) = p_empno
                                )
                                And obj_type_id = 3--Desk Area Only
                        )
                    Order By a.area_desc
                );
            If v_count > 0 Then
                Open c For
                    Select
                        a.area_key_id data_value_field,
                        a.area_desc   data_text_field
                    From
                        dm_desk_areas a
                    Where
                        a.is_active = 1
                        And a.area_key_id In (
                            Select
                                Trim(c.obj_id) As area_id
                            From
                                dm_tag_obj_mapping c
                            Where
                                c.tag_id In (
                                    Select
                                        tag_id
                                    From
                                        dm_tag_obj_mapping
                                    Where
                                        obj_type_id = 1 -- Employee Only
                                        And Trim(obj_id) = p_empno
                                )
                                And obj_type_id = 3--Desk Area Only
                        )
                    Order By
                        a.area_desc;

                Return c;
            End If;

        End If;

        Open c For
            Select
                a.area_key_id data_value_field,
                a.area_desc   data_text_field
            From
                dm_desk_areas           a,
                dm_desk_area_office_map b
            Where
                a.area_key_id = b.area_id
                And a.desk_area_type In (c_dept_area, c_proj_area)
                And b.office_code = p_office
                And a.is_active = 1
            Order By
                a.area_desc;
        Return c;
    End;

    Function fn_area_list_4_assignment_dms(
        p_person_id Varchar2,
        p_meta_id   Varchar2,
        p_empno     Varchar2 Default Null,
        p_area_type Varchar2 Default Null,
        p_office    Varchar2 Default Null,
        p_dept      Varchar2 Default Null,
        p_proj      Varchar2 Default Null
    ) Return Sys_Refcursor As
        c                    Sys_Refcursor;
        v_empno              Varchar2(5);
        v_count              Number;
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;
        If p_empno Is Not Null Then
            Select
                Count(*)
            Into
                v_count
            From
                (
                    Select
                        a.area_key_id data_value_field,
                        a.area_desc   data_text_field
                    From
                        dm_desk_areas a
                    Where
                        a.is_active = 1
                        And a.area_key_id In (
                            Select
                                Trim(c.obj_id) As area_id
                            From
                                dm_tag_obj_mapping c
                            Where
                                c.tag_id In (
                                    Select
                                        tag_id
                                    From
                                        dm_tag_obj_mapping
                                    Where
                                        obj_type_id = 1 -- Employee Only
                                        And obj_id = p_empno
                                )
                                And obj_type_id = 3--Desk Area Only
                        )
                    Order By a.area_desc
                );
            If v_count > 0 Then
                Open c For
                    Select
                        a.area_key_id data_value_field,
                        a.area_desc   data_text_field
                    From
                        dm_desk_areas a
                    Where
                        a.is_active = 1
                        And a.area_key_id In (
                            Select
                                Trim(c.obj_id) As area_id
                            From
                                dm_tag_obj_mapping c
                            Where
                                c.tag_id In (
                                    Select
                                        tag_id
                                    From
                                        dm_tag_obj_mapping
                                    Where
                                        obj_type_id = 1 -- Employee Only
                                        And obj_id = p_empno
                                )
                                And obj_type_id = 3--Desk Area Only
                        )
                    Order By
                        a.area_desc;

                Return c;
            End If;

        End If;

        If p_area_type = 'DEPT+PROJ' Then
            Open c For
                Select
                    a.area_key_id data_value_field,
                    a.area_desc   data_text_field
                From
                    dm_desk_areas           a,
                    dm_desk_area_office_map b
                Where
                    a.area_key_id = b.area_id
                    And a.desk_area_type In (c_dept_area, c_proj_area)
                    And Trim(b.office_code) = nvl(Trim(p_office), Trim(b.office_code))
                    And a.is_active = 1
                Order By
                    a.area_desc;
            Return c;
        End If;

        Open c For
            Select
                a.area_key_id data_value_field,
                a.area_desc   data_text_field
            From
                dm_desk_areas           a,
                dm_desk_area_office_map b
            Where
                a.area_key_id = b.area_id
                And a.desk_area_type = nvl(p_area_type, a.desk_area_type)
                And Trim(b.office_code) = nvl(Trim(p_office), Trim(b.office_code))
                And a.is_active = 1
            Order By
                a.area_desc;
        Return c;
    End;

    Function fn_costcode_4_desk_booking(
        p_person_id Varchar2,
        p_meta_id   Varchar2
    ) Return Sys_Refcursor As
        c                 Sys_Refcursor;
        v_empno           Varchar2(5);
        timesheet_allowed Number;
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        Open c For
            Select
                costcode                  data_value_field,
                costcode || ' - ' || name data_text_field
            From
                ss_costmast
            Where
                active = 1;

        Return c;
        Return c;
    End;

    Function fn_costcode_4_hod_desk_booking(
        p_person_id Varchar2,
        p_meta_id   Varchar2
    ) Return Sys_Refcursor As
        c                 Sys_Refcursor;
        v_empno           Varchar2(5);
        timesheet_allowed Number;
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        Open c For
            Select
                costcode                  data_value_field,
                costcode || ' - ' || name data_text_field
            From
                ss_costmast
            Where
                costcode In (
                    Select
                        costcode
                    From
                        ss_costmast
                    Where
                        hod = v_empno
                    Union
                    Select
                        costcode
                    From
                        tcmpl_app_config.sec_module_user_roles_costcode
                    Where
                        empno = v_empno
                        And module_id = 'M20'  -- Need to finalized
                        And role_id = 'R003' -- Need to finalized
                )
                And active = 1;
        Return c;
    End;

    Function fn_project_4_desk_booking(
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
            Distinct
                proj_no                  data_value_field,
                proj_no || ' : ' || name data_text_field
            From
                ss_projmast
            Where
                active = 1
            -- and prjmngr = v_empno
            --or prjdymngr = :v_empno
            Order By
                proj_no;

        Return c;
    End;

    Function fn_employee_4_desk_booking(
        p_person_id Varchar2,
        p_meta_id   Varchar2
    ) Return Sys_Refcursor As
        c                    Sys_Refcursor;
        v_mngr_empno         Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
    Begin
        v_mngr_empno := get_empno_from_meta_id(p_meta_id);
        If v_mngr_empno = 'ERRRR' Then
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
            --and ( mngr = v_mngr_empno or empno = v_mngr_empno )
            Order By
                empno;

        Return c;
    End;

    Function fn_desk_list_4_desk_booking(
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
                a.deskid                         data_value_field,
                a.deskid || ' : ' || b.area_desc data_text_field
            From
                dm_deskmaster a,
                dm_desk_areas b
            Where
                a.work_area = b.area_key_id
                And b.is_active = 1
            Order By
                a.deskid;

        Return c;
    End;

    Function fn_desk_area_type_master_list(
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
                a.description data_value_field,
                a.description data_text_field
            From
                dm_area_type a
            Order By
                a.description;

        Return c;
    End;

    Function fn_desk_area_type_list(
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
                a.key_id                               As data_value_field,
                a.short_desc || ' - ' || a.description As data_text_field
            From
                dm_area_type a
            Where
                a.is_active = 1
            Order By
                a.short_desc;

        Return c;
    End;

    Function fn_area_4_desk_booking_list(
        p_person_id Varchar2,
        p_meta_id   Varchar2,
        p_area_type Varchar2
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
                ss_projmast a
            Order By
                projno;

        Return c;
    End;

    Function fn_dept_in_area_list(
        p_person_id Varchar2,
        p_meta_id   Varchar2,
        p_area_id   Varchar2
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
                a.key_id                       data_value_field,
                a.cost_code || ' : ' || b.name data_text_field
            From
                dm_area_type_dept_mapping a,
                ss_costmast               b
            Where
                a.cost_code = b.costcode
                And area_id = p_area_id
            Order By
                a.cost_code;
        Return c;
    End;

    Function fn_project_in_area_list(
        p_person_id Varchar2,
        p_meta_id   Varchar2,
        p_area_id   Varchar2
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
                a.key_id data_value_field,
                (
                    Select
                    Distinct
                        b.proj_no || ' : ' || b.name
                    From
                        ss_projmast b
                    Where
                        b.proj_no = a.project_no
                )        data_text_field
            From
                dm_area_type_project_mapping a
            Where
                area_id = p_area_id
            Order By
                a.project_no;
        Return c;
    End;

    Function fn_user_in_area_list(
        p_person_id Varchar2,
        p_meta_id   Varchar2,
        p_area_id   Varchar2
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
                a.key_id                   data_value_field,
                a.empno || ' : ' || b.name data_text_field
            From
                dm_area_type_user_mapping a,
                ss_emplmast               b
            Where
                a.empno = b.empno
                And area_id = p_area_id
            Order By
                a.empno;
        Return c;
    End;

    Function fn_emp_n_desk_in_area_list(
        p_person_id Varchar2,
        p_meta_id   Varchar2,
        p_area_id   Varchar2
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
                a.key_id                                               data_value_field,
                a.empno || ' : ' || b.name || ' (' || a.desk_id || ')' As data_text_field
            From
                dm_area_type_user_desk_mapping a,
                ss_emplmast                    b
            Where
                a.empno = b.empno
                And area_id = p_area_id
            Order By
                a.empno;
        Return c;
    End;

    Function fn_emp_n_desk_type_in_area_list(
        p_person_id Varchar2,
        p_meta_id   Varchar2,
        p_area_id   Varchar2
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
        Return Null;
        /*
         open c for select a.key_id data_value_field,
                           a.empno
                           || ' : '
                           || b.name
                           || ' - '
                           || c.short_desc as data_text_field
                                 from dm_area_type_emp_area_mapping a,
                                      ss_emplmast b,
                                      dm_area_type c
                     where a.empno = b.empno
                       and a.desk_type = c.key_id
                       and area_id = p_area_id
                     order by a.empno;
                     */
        Return c;
    End;

    Function fn_deskbook_emp_office_list(
        p_person_id Varchar2,
        p_meta_id   Varchar2,
        p_location  Varchar2 Default Null,
        p_empno     Varchar2 Default Null
    ) Return Sys_Refcursor As
        c                    Sys_Refcursor;
        v_empno              Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
        v_base_loc           Varchar2(2);
    Begin
        v_empno    := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;
        If p_empno Is Not Null Then
            v_empno := p_empno;
        End If;
        v_base_loc := tcmpl_hr.pkg_common.fn_get_emp_office_location(v_empno);
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
                office_location_code = v_base_loc
            Union
            Select
                office_code data_value_field,
                office_name data_text_field
            From
                desk_book_offices
            Where
                office_location_code In (
                    Select
                        office_location_code
                    From
                        desk_book.db_map_emp_location
                    Where
                        empno = v_empno
                        And office_location_code = nvl(p_location, office_location_code)
                );
        Return c;
    End;

    Function fn_emp_office_list(
        p_person_id Varchar2 Default Null,
        p_meta_id   Varchar2 Default Null,
        p_location  Varchar2 Default Null,
        p_empno     Varchar2 Default Null
    ) Return Sys_Refcursor As
        c                    Sys_Refcursor;
        v_empno              Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
        v_location_code      Varchar2(2);
    Begin
        If p_empno Is Not Null Then
            v_empno := p_empno;
        Else
            v_empno := get_empno_from_meta_id(p_meta_id);
            If v_empno = 'ERRRR' Then
                Raise e_employee_not_found;
                Return Null;
            End If;
        End If;
        v_location_code := tcmpl_hr.pkg_common.fn_get_emp_office_location(v_empno);
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
                office_location_code In (v_location_code, nvl(p_location, office_location_code))
            Union
            Select
                office_code data_value_field,
                office_name data_text_field
            From
                desk_book_offices
            Where
                office_location_code In (
                    Select
                        office_location_code
                    From
                        desk_book.db_map_emp_location
                    Where
                        empno = v_empno
                        And office_location_code = nvl(v_location_code, office_location_code)
                );

        Return c;
    End;

    Function fn_employee_4_hod_desk_booking(
        p_person_id Varchar2,
        p_meta_id   Varchar2,
        p_cost_code Varchar2
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
                empno                  As data_value_field,
                empno || ' : ' || name As data_text_field
            From
                ss_emplmast
            Where
                parent = p_cost_code
                And status = 1
            Order By
                empno;
        Return c;
    End;

    Function fn_project_4_hod_desk_booking(
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
            Distinct
                proj_no                  data_value_field,
                proj_no || ' : ' || name data_text_field
            From
                ss_projmast
            Where
                active = 1
                And prjmngr = v_empno
            --or prjdymngr = :v_empno
            Order By
                proj_no;
        Return c;
    End;

    Function fn_desk_list_4_area_desk_booking(
        p_person_id Varchar2,
        p_meta_id   Varchar2,
        p_office    Varchar2,
        p_area_id   Varchar2
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
                a.deskid                                                                  As data_value_field,
                a.deskid || ' - ' || a.office || ' - ' || a.floor || ' - ' || b.area_desc As data_text_field
            From
                dm_vu_desk_list a,
                dm_desk_areas   b
            Where
                a.work_area = b.area_key_id
                And Trim(office) = Trim(p_office)
                And Trim(work_area) = Trim(p_area_id)
                And b.is_active = 1
            Order By
                a.deskid;
        Return c;
    End;

    Function fn_area_list_4_dept_proj(
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
                a.area_key_id data_value_field,
                a.area_desc   data_text_field
            From
                dm_desk_areas           a,
                dm_desk_area_categories c
            Where
                c.area_catg_code = a.area_catg_code
                And a.desk_area_type In ('AT01', 'AT02')
                And a.is_active = 1
            Order By
                a.area_desc;
        Return c;
    End;

    Function fn_area_list_4_fixed_pc(
        p_person_id Varchar2,
        p_meta_id   Varchar2,
        p_office    Varchar2 Default Null,
        p_empno     Varchar2 Default Null
    ) Return Sys_Refcursor As
        c                    Sys_Refcursor;
        v_empno              Varchar2(5);
        v_count              Number;
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;
        If p_empno Is Not Null Then
            Select
                Count(*)
            Into
                v_count
            From
                (
                    Select
                        a.area_key_id data_value_field,
                        a.area_desc   data_text_field
                    From
                        dm_desk_areas a
                    Where
                        a.is_active = 1
                        And a.area_key_id In (
                            Select
                                Trim(c.obj_id) As area_id
                            From
                                dm_tag_obj_mapping c
                            Where
                                c.tag_id In (
                                    Select
                                        tag_id
                                    From
                                        dm_tag_obj_mapping
                                    Where
                                        obj_type_id = 1 -- Employee Only
                                        And obj_id = p_empno
                                )
                                And obj_type_id = 3--Desk Area Only
                        )
                    Order By a.area_desc
                );
            If v_count > 0 Then
                Open c For
                    Select
                        a.area_key_id data_value_field,
                        a.area_desc   data_text_field
                    From
                        dm_desk_areas a
                    Where
                        a.is_active = 1
                        And a.area_key_id In (
                            Select
                                Trim(c.obj_id) As area_id
                            From
                                dm_tag_obj_mapping c
                            Where
                                c.tag_id In (
                                    Select
                                        tag_id
                                    From
                                        dm_tag_obj_mapping
                                    Where
                                        obj_type_id = 1 -- Employee Only
                                        And obj_id = p_empno
                                )
                                And obj_type_id = 3--Desk Area Only
                        )
                    Order By
                        a.area_desc;

                Return c;
            End If;

        End If;

        Open c For
            Select
                a.area_key_id data_value_field,
                a.area_desc   data_text_field
            From
                dm_desk_areas           a,
                dm_desk_area_office_map b
            Where
                a.area_key_id = b.area_id
                And a.desk_area_type In (c_fixed_pc_area)
                And Trim(b.office_code) = nvl(Trim(p_office), Trim(b.office_code))
                And a.is_active = 1
            Order By
                a.area_desc;
        Return c;
    End;

    Function fn_deskbook_enabled_office_list(
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
                office_code data_value_field,
                office_name data_text_field,
                office_location_code
            From
                dms.dm_offices
            Where
                smart_desk_booking_enabled = ok;
        Return c;
    End;
    
    
End;
/