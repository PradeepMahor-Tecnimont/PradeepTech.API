Create Or Replace Package Body dms.pkg_dms_asset_with_emp_qry As

    Function fn_asset_with_employee_list(
        p_person_id      Varchar2,
        p_meta_id        Varchar2,
        p_generic_search Varchar2 Default Null,
        p_group_type     Varchar2 Default Null,
        p_asset_type     Varchar2 Default Null,
        p_row_number     Number,
        p_page_length    Number
    ) Return Sys_Refcursor As
        c                    Sys_Refcursor;
        v_empno              Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
        v_asset_csv          Varchar2(1000);
        v_generic_search     Varchar2(100);
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;

        If p_asset_type Is Null Then
            Select
                Listagg(item_type_code, ',')
            Into
                v_asset_csv
            From
                inv_item_types;
        Else
            v_asset_csv := p_asset_type;
        End If;

        If p_generic_search Is Not Null Then
            v_generic_search := '%' || upper(p_generic_search) || '%';
        Else
            v_generic_search := '%';
        End If;
        Open c For
            Select
                *
            From
                (
                    Select
                        empno,
                        name,
                        group_type,
                        item_id,
                        type_desc,
                        asset_type,
                        description,
                        Row_Number() Over (Order By empno, group_type, asset_type) row_number,
                        Count(*) Over ()                                           total_row
                    From
                        dm_vu_asset_with_emp
                    Where
                        group_type = nvl(p_group_type, group_type)
                        And asset_type In (
                            Select
                                regexp_substr(v_asset_csv, '[^,]+', 1, level) value
                            From
                                dual
                            Connect By level <=
                                length(v_asset_csv) - length(replace(v_asset_csv, ',')) + 1
                        )
                        And (
                            empno Like v_generic_search
                            Or name Like v_generic_search
                            Or item_id Like v_generic_search
                        )
                )
            Where
                row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length);
        Return c;
    End fn_asset_with_employee_list;

    Function fn_asset_with_employee_excel(
        p_person_id      Varchar2,
        p_meta_id        Varchar2,
        p_generic_search Varchar2 Default Null,
        p_group_type     Varchar2 Default Null,
        p_asset_type     Varchar2 Default Null
    ) Return Sys_Refcursor As
        c                    Sys_Refcursor;
        v_generic_search     Varchar2(100);
        v_asset_csv          Varchar2(1000);
        v_empno              Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;
        
        If p_generic_search Is Not Null Then
            v_generic_search := '%' || upper(p_generic_search) || '%';
        Else
            v_generic_search := '%';
        End If;
        If p_asset_type Is Null Then
            Select
                Listagg(item_type_code, ',')
            Into
                v_asset_csv
            From
                inv_item_types;
        Else
            v_asset_csv := p_asset_type;
        End If;
        Open c For
            Select
                empno,
                name,
                group_type,
                item_id,
                type_desc,
                asset_type,
                description
            From
                dm_vu_asset_with_emp
            Where
                group_type = nvl(p_group_type, group_type)
                And asset_type In (
                    Select
                        regexp_substr(v_asset_csv, '[^,]+', 1, level) value
                    From
                        dual
                    Connect By
                        level <=
                        length(v_asset_csv) - length(replace(v_asset_csv, ',')) + 1
                )
                And (
                    empno Like v_generic_search
                    Or name Like v_generic_search
                    Or item_id Like v_generic_search
                )
            Order By
                empno,
                group_type,
                asset_type;
        Return c;
    End fn_asset_with_employee_excel;

End pkg_dms_asset_with_emp_qry;