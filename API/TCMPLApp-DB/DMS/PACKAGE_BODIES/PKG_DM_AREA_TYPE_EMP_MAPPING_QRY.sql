Create Or Replace Package Body "DMS"."PKG_DM_AREA_TYPE_EMP_MAPPING_QRY" As

    Function fn_dm_area_type_emp_mapping_list (
        p_person_id      Varchar2,
        p_meta_id        Varchar2,
        p_generic_search Varchar2 Default Null,
        p_area_id        Varchar2 Default Null,
        p_row_number     Number,
        p_page_length    Number
    ) Return Sys_Refcursor As

        v_empno Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init ( e_employee_not_found, -20001 );
        c       Sys_Refcursor;
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;
        Open c For Select
                                  key_id,
                                  desk_id,
                                  area_id,
                                  area_desc,
                                  office_code                                       As office,
                                  emp_no,
                                  emp_name,
                                  modified_on                                       As modified_on,
                                  modified_by || ' : ' || get_emp_name(modified_by) As modified_by,
                                  row_number,
                                  total_row
                                From
                                  (
                                      Select
                                          a.key_id      As key_id,
                                          a.desk_id     As desk_id,
                                          a.area_id     As area_id,
                                          b.area_desc   As area_desc,
                                          a.office_code,
                                          a.empno       As emp_no,
                                          c.name        As emp_name,
                                          a.modified_on As modified_on,
                                          a.modified_by As modified_by,
                                          Row_Number()
                                          Over(
                                               Order By
                                                  a.area_id
                                          )             row_number,
                                          Count(*)
                                          Over()        total_row
                                        From
                                          dm_area_type_user_desk_mapping a,
                                          dm_desk_areas                  b,
                                          ss_emplmast                    c
                                       Where
                                              a.empno = c.empno
                                             And a.area_id = b.area_key_id
                                             And a.area_id = nvl(Trim(p_area_id),a.area_id)
                                             And ( 
                                                    upper(a.area_id) Like '%' || upper(Trim(p_generic_search)) || '%'
                                                    Or upper(c.name) Like '%' || upper(Trim(p_generic_search)) || '%' 
                                                    Or upper(a.empno) Like '%' || upper(Trim(p_generic_search)) || '%' 
                                                    Or upper(a.desk_id) Like '%' || upper(Trim(p_generic_search))
                                              )
                                  )
                    Where
                       row_number Between ( nvl(p_row_number, 0) + 1 ) And ( nvl(p_row_number, 0) + p_page_length );

        Return c;
    End fn_dm_area_type_emp_mapping_list;

    Procedure sp_dm_area_type_emp_mapping_details (
        p_person_id      Varchar2,
        p_meta_id        Varchar2,
        p_key_id         Varchar2,
        p_area_catg_code Out Varchar2,
        p_area_catg_desc Out Varchar2,
        p_area_id        Out Varchar2,
        p_area_desc      Out Varchar2,
        p_desk_id        Out Varchar2,
        p_emp_no         Out Varchar2,
        p_emp_name       Out Varchar2,
        p_office_code    Out Varchar2,
        p_office_desc    Out Varchar2,
        p_modified_by    Out Varchar2,
        p_modified_on    Out Date,
        p_message_type   Out Varchar2,
        p_message_text   Out Varchar2
    ) As

        v_exists       Number;
        v_empno        Varchar2(5);
        v_user_tcp_ip  Varchar2(5) := 'NA';
        v_message_type Number := 0;
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            p_message_type := not_ok;
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        Select
            Count(*)
          Into v_exists
          From
            dm_area_type_user_desk_mapping
         Where
            key_id = p_key_id;

        If v_exists = 1 Then
            Select
                a.desk_id                                             As desk_id,
                b.area_catg_code                                      As area_catg_code,
                e.description                                         As area_catg_desc,
                a.area_id                                             As area_id,
                b.area_desc                                           As area_desc,
                a.empno                                               As emp_no,
                c.name                                                As emp_name,
                a.office_code,
                a.modified_on                                         As modified_on,
                a.modified_by || ' : ' || get_emp_name(a.modified_by) As modified_by
              Into
                p_desk_id,
                p_area_catg_code,
                p_area_catg_desc,
                p_area_id,
                p_area_desc,
                p_emp_no,
                p_emp_name,
                p_office_code,
                p_modified_on,
                p_modified_by
              From
                dm_area_type_user_desk_mapping a,
                dm_desk_areas                  b,
                dm_desk_area_categories        e,
                ss_emplmast                    c
             Where
                    a.key_id = p_key_id
                   And a.empno          = c.empno
                   And a.area_id        = b.area_key_id
                   And b.area_catg_code = e.area_catg_code;

            p_message_type := ok;
            p_message_text := 'Procedure executed successfully.';
        Else
            p_message_type := not_ok;
            p_message_text := 'No matching employee desk area type mapping exists !!!';
        End If;

    Exception
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
    End sp_dm_area_type_emp_mapping_details;

    Function fn_dm_area_type_emp_mapping_xl_list (
        p_person_id      Varchar2,
        p_meta_id        Varchar2,
        p_generic_search Varchar2 Default Null,
        p_area_id        Varchar2 Default Null,
        p_modified_on    Date Default Null
    ) Return Sys_Refcursor As

        v_empno Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init ( e_employee_not_found, -20001 );
        c       Sys_Refcursor;
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;
        Open c For Select
                                  a.key_id                                              As key_id,
                                  a.desk_id                                             As desk_id,
                                  b.area_catg_code                                      As area_catg_code,
                                  e.description                                         As area_catg_desc,
                                  a.area_id                                             As area_id,
                                  b.area_desc                                           As area_desc,
                                  a.empno                                               As emp_no,
                                  c.name                                                As emp_name,
                                  a.modified_on                                         As modified_on,
                                  a.modified_by || ' : ' || get_emp_name(a.modified_by) As modified_by
                                From
                                  dm_area_type_user_desk_mapping a,
                                  dm_desk_areas                  b,
                                  dm_desk_area_categories        e,
                                  ss_emplmast                    c
                    Where
                           a.empno = c.empno
                          And a.area_id        = b.area_key_id
                          And b.area_catg_code = e.area_catg_code
                          And a.area_id        = nvl(Trim(p_area_id), a.area_id) 
                          And ( upper(b.area_desc) Like '%' || upper(Trim(p_generic_search)) || '%'
                           Or upper(c.name) Like '%' || upper(Trim(p_generic_search)) || '%' );

        Return c;
    End fn_dm_area_type_emp_mapping_xl_list;

End pkg_dm_area_type_emp_mapping_qry;