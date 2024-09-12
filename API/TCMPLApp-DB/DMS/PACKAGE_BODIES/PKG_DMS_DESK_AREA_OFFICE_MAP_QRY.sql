Create Or Replace Package Body dms.pkg_dms_desk_area_office_map_qry As

    Function fn_dm_desk_area_office_map_list(
        p_person_id      Varchar2,
        p_meta_id        Varchar2,
        p_generic_search Varchar2 Default Null,
        p_area_id        Varchar2 Default Null,
        p_office_code    Varchar2 Default Null,
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
        Open c For Select *
                     From (
                       Select a.office_code                             As office,
                              c.office_desc                             As office_desc,
                              a.area_id,
                              b.area_desc,
                              b.area_info,
                              b.area_catg_code,
                              Row_Number() Over(Order By a.office_code) row_number,
                              Count(*) Over()                           total_row
                         From dm_desk_area_office_map a,
                              dm_desk_areas b,
                              dm_offices              c
                        Where a.area_id = b.area_key_id
                          And a.office_code = c.office_code
                          And a.area_id = nvl(Trim(p_area_id), a.area_id)
                          And a.office_code = nvl(Trim(p_office_code), a.office_code)
                          And (upper(a.area_id) Like '%' || upper(Trim(p_generic_search)) || '%'
                           Or upper(a.office_code) Like '%' || upper(Trim(p_generic_search)) || '%'
                              )
                   )
                    Where row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length);
        Return c;
    End fn_dm_desk_area_office_map_list;

    Procedure sp_dm_desk_area_office_map_details(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,
        p_area_id          Varchar2,
        p_office_code      Varchar2,
        p_area_text    Out Varchar2,
        p_office_text  Out Varchar2,
        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_exists       Number;
        v_empno        Varchar2(5);
        v_user_tcp_ip  Varchar2(5) := 'NA';
        v_message_type Number      := 0;
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            p_message_type := not_ok;
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        Select Count(*)
          Into v_exists
          From dm_desk_area_office_map
         Where area_id = p_area_id
           And office_code = p_office_code;

        If v_exists = 1 Then
            Select a.office_code As office,
                   b.area_desc
              Into p_office_text,
                   p_area_text
              From dm_desk_area_office_map a,
                   dm_desk_areas b
             Where a.area_id = b.area_key_id
               And a.area_id = p_area_id
               And a.office_code = p_office_code;

            Commit;
            p_message_type := ok;
            p_message_text := 'Procedure executed successfully.';
        Else
            p_message_type := not_ok;
            p_message_text := 'No matching Area office map exists !!!';
        End If;

    Exception
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
    End sp_dm_desk_area_office_map_details;

    Function sp_dm_desk_area_office_map_xl_list(
        p_person_id      Varchar2,
        p_meta_id        Varchar2,
        p_generic_search Varchar2 Default Null,
        p_area_id        Char     Default Null,
        p_office_code    Char Default Null
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
        Open c For Select a.office_code As office,
                   a.area_id,
                   b.area_desc,
                   b.area_info,
                   b.area_catg_code
                     From dm_desk_area_office_map a,
                   dm_desk_areas b
                    Where a.area_id = b.area_key_id
                      And a.area_id = nvl(Trim(p_area_id), a.area_id)
                      And a.office_code = nvl(Trim(p_office_code), a.office_code)
                      And (upper(a.area_id) Like '%' || upper(Trim(p_generic_search)) || '%'
                       Or upper(a.office_code) Like '%' || upper(Trim(p_generic_search)) || '%')
                    Order By a.office_code;
        Return c;
    End sp_dm_desk_area_office_map_xl_list;

End pkg_dms_desk_area_office_map_qry;
/
Grant Execute On dms.pkg_dms_desk_area_office_map_qry To tcmpl_app_config;