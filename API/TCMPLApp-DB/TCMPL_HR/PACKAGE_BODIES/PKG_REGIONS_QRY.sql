Create Or Replace Package Body tcmpl_hr.pkg_regions_qry As

    Function fn_regions_list(
        p_person_id      Varchar2,
        p_meta_id        Varchar2,
        p_generic_search Varchar2 Default Null,
        p_row_number     Number,
        p_page_length    Number
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
                region_code,
                region_name,
                modified_on,
                modified_by || ' : ' || get_emp_name(modified_by) As modified_by,
                Row_Number() Over(Order By
                        region_code)                              row_number,
                Count(*) Over()                                   total_row
            From
                hd_regions
            Where
                (upper(region_name) Like '%' || upper(Trim(p_generic_search)) || '%')
            Order By
                region_code;
        Return c;
    End fn_regions_list;

    Procedure sp_region_detail(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,
        p_region_code      Varchar2,
        p_region_name  Out Varchar2,
        p_modified_on  Out Date,
        p_modified_by  Out Varchar2,
        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_exists       Number;
        v_share_pcnt   Number;
        v_empno        Varchar2(5);
        v_keyid        Varchar2(5);
        v_user_tcp_ip  Varchar2(5) := 'NA';
        v_message_type Number      := 0;
    Begin
        v_empno        := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            p_message_type := 'KO';
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        Select
            region_name,
            modified_on,
            modified_by || ' : ' || get_emp_name(modified_by)
        Into
            p_region_name,
            p_modified_on,
            p_modified_by
        From
            hd_regions
        Where
            region_code = p_region_code;

        p_message_type := ok;
        p_message_text := 'Procedure executed successfully.';
    Exception
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
    End sp_region_detail;

End pkg_regions_qry;
/