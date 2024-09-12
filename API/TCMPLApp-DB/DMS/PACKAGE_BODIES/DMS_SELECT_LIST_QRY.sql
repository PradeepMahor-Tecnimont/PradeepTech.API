Create Or Replace Package Body "DMS"."DMS_SELECT_LIST_QRY" As

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
        If v_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;

        Open c For
            Select
                description data_value_field,
                description data_text_field
            From
                dm_deskmaster_props
            Where
                type         = 'Office'
                And isactive = 1
            Order By
                description;

        Return c;
    End;

    Function fn_floor_list(
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
                description data_value_field,
                description data_text_field
            From
                dm_deskmaster_props
            Where
                type         = 'Floor'
                And isactive = 1
            Order By
                description;

        Return c;
    End;

    Function fn_wing_list(
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
                description data_value_field,
                description data_text_field
            From
                dm_deskmaster_props
            Where
                type         = 'Wing'
                And isactive = 1
            Order By
                description;

        Return c;
    End;

    Function fn_bay_list(
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
                bay_key_id data_value_field,
                bay_desc   data_text_field
            From
                dm_desk_bays
            Order By
                bay_desc;

        /*
        Open c For
            Select
                description data_value_field,
                description data_text_field
            From
                dm_deskmaster_props
            Where
                type         = 'BAY'
                And isactive = 1
            Order By
                description;
        */

        Return c;
    End;

    Function fn_area_list(
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
                a.area_key_id                               data_value_field,
                a.area_desc  data_text_field
            From
                dm_desk_areas                            a, dm_desk_area_categories c
            Where
                c.area_catg_code = a.area_catg_code
                And a.area_key_id Not In ('A59', 'A56', 'A57')
            Order By
                a.area_desc;

        Return c;
    End;

    Function fn_area_catg_code_list(
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
                a.area_catg_code data_value_field,
                a.description    data_text_field
            From
                dm_desk_area_categories a
            Order By
                a.description;

        Return c;
    End;

    Function fn_adm_hod_sec_dept_list(
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
                ss_costmast a
            Order By
                costcode;

        Return c;
    End;

    Function fn_project7_list(
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
                ss_projmast a
            Order By
                projno;

        Return c;
    End;

    Function fn_desks4guest_list(
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
                deskid data_value_field,
                deskid data_text_field
            From
                dm_deskmaster a
            Where
                Trim(upper(a.office)) != Trim(upper('HOME'))
                And a.isdeleted = 0
                And a.isblocked = 0
                And a.deskid Not In (
                    Select
                        b.deskid
                    From
                        dm_usermaster b
                )
                And a.deskid Not In(
                    Select
                        deskid
                    From
                        dm_desklock
                )

            Order By
                deskid;

        Return c;
    End;

    Function fn_desklock_reason_list(
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
                dm_desk_areas                            a, dm_desk_area_categories c
            Where
                c.area_catg_code     = a.area_catg_code
                And c.area_catg_code = 'A004'
            Order By
                a.area_desc;

        Return c;
    End;

    Function fn_emp_4_desk_asgmt_list(
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
                a.empno                    data_value_field,
                a.empno || ' - ' || a.name data_text_field
            From
                ss_emplmast a
            Where
                a.status = 1
                And a.empno Not In (
                    Select
                    Distinct b.empno
                    From
                        dm_usermaster b
                )
            Order By
                a.empno;
        Return c;
    End;

    Function fn_pc_model_list(
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
                Trim(model) As data_value_field,
                Trim(model) As data_text_field
            From
                dm_assetcode
            Where
                sub_asset_type = 'IT0PC'
                And scrap      = 0
            Order By
                Trim(model);
        Return c;
    End;

    Function fn_monitor_model_list(
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
                Trim(model) As data_value_field,
                Trim(model) As data_text_field
            From
                dm_assetcode
            Where
                sub_asset_type = 'IT0MO'
                And scrap      = 0
            Order By
                Trim(model);

        Return c;
    End;

    Function fn_telephone_model_list(
        p_person_id Varchar2,
        p_meta_id   Varchar2
    ) Return Sys_Refcursor As
        c                    Sys_Refcursor;
        v_empno              Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
    Begin
        Return Null;
    
        /*
            v_empno := get_empno_from_meta_id(p_meta_id);
            If v_empno = 'ERRRR' Then
                Raise e_employee_not_found;
                Return Null;
            End If;

            Open c For

                Select
                Distinct
                    Trim(telmodel) As data_value_field,
                    Trim(telmodel) As data_text_field
                From
                    desmas_allocation
                Order By
                    Trim(telmodel);

            Return c;
        */
    End;

    Function fn_printer_model_list(
        p_person_id Varchar2,
        p_meta_id   Varchar2
    ) Return Sys_Refcursor As
        c                    Sys_Refcursor;
        v_empno              Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
    Begin
        Return Null;
        /*
            v_empno := get_empno_from_meta_id(p_meta_id);
            If v_empno = 'ERRRR' Then
                Raise e_employee_not_found;
                Return Null;
            End If;

            Open c For

                Select
                Distinct
                    Trim(printmodel) As data_value_field,
                    Trim(printmodel) As data_text_field
                From
                    desmas_allocation
                Order By
                    Trim(printmodel);

            Return c;
        */
    End;

    Function fn_docstn_model_list(
        p_person_id Varchar2,
        p_meta_id   Varchar2
    ) Return Sys_Refcursor As
        c                    Sys_Refcursor;
        v_empno              Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
    Begin
        Return Null;
        /*
            v_empno := get_empno_from_meta_id(p_meta_id);
            If v_empno = 'ERRRR' Then
                Raise e_employee_not_found;
                Return Null;
            End If;

            Open c For

                Select
                Distinct
                    Trim(docstnmodel) As data_value_field,
                    Trim(docstnmodel) As data_text_field
                From
                    desmas_allocation
                Order By
                    Trim(docstnmodel);

            Return c;
        */
    End;
  
End;
/
  Grant Execute On "DMS"."DMS_SELECT_LIST_QRY" To "TCMPL_APP_CONFIG";