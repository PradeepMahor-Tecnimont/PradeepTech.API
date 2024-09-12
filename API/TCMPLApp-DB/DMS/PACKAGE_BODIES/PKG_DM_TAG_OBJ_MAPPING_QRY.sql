Create Or Replace Package Body dms.pkg_dm_tag_obj_mapping_qry As

    Function fn_tag_obj_mapping_list(
        p_person_id      Varchar2,
        p_meta_id        Varchar2,
        p_generic_search Varchar2 Default Null,
        p_tag_id         Varchar2 Default Null,
        p_obj_type_id    Varchar2 Default Null,
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
            Select *
              From (
                       Select a.key_id                                              As key_id,
                              a.tag_id                                              As tag_id,
                              b.tag_name                                            As tag_name,
                              a.obj_type_id                                         As obj_type_id,
                              c.obj_type_name                                       As obj_type_name,
                              a.obj_id                                              As obj_id,
                              Case
                                  When a.obj_type_id = 1 Then
                                      (Select name From ss_emplmast Where empno = a.obj_id)
                                  When a.obj_type_id = 2 Then
                                      (a.obj_id)
                                  When a.obj_type_id = 3 Then
                                      (Select area_desc From dm_vu_desk_areas Where area_key_id = a.obj_id)
                                  Else
                                      ''
                              End                                                   As obj_desc,
                              a.modified_by || ' - ' || get_emp_name(a.modified_by) As modified_by,
                              a.modified_on                                         As modified_on,

                              Row_Number() Over(Order By a.tag_id)                  row_number,
                              Count(*) Over()                                       total_row
                         From dm_tag_obj_mapping a,
                              dm_tag_master b,
                              dm_tag_obj_type    c
                        Where a.tag_id = b.key_id
                          And a.obj_type_id = c.obj_type_id
                          And a.tag_id = nvl(p_tag_id, a.tag_id)
                          And a.obj_type_id = nvl(p_obj_type_id, a.obj_type_id)
                          And (upper(b.tag_name) Like '%' || upper(Trim(p_generic_search)) || '%'
                           Or upper(a.obj_id) Like '%' || upper(Trim(p_generic_search)) || '%')

                   )
             Where row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length);
        Return c;
    End fn_tag_obj_mapping_list;

    Procedure sp_tag_obj_mapping_details(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,
        p_key_id           Varchar2,
        p_tag_id       Out Varchar2,
        p_obj_id       Out Varchar2,
        p_obj_type_id  Out Varchar2,
        p_modified_by  Out Varchar2,
        p_modified_on  Out Date,
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
          From dm_tag_obj_mapping
         Where key_id = p_key_id;

        If v_exists = 1 Then
            Select tag_id,
                   obj_id,
                   obj_type_id,
                   modified_by,
                   modified_on
              Into p_tag_id,
                   p_obj_id,
                   p_obj_type_id,
                   p_modified_by,
                   p_modified_on
              From dm_tag_obj_mapping
             Where key_id = p_key_id;

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
    End sp_tag_obj_mapping_details;

    Function sp_tag_obj_mapping_xl_list(
        p_person_id      Varchar2,
        p_meta_id        Varchar2,
        p_generic_search Varchar2 Default Null
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
            Select a.key_id                                              As key_id,
                   a.tag_id                                              As tag_id,
                   b.tag_name                                            As tag_name,
                   a.obj_type_id                                         As obj_type_id,
                   c.obj_type_name                                       As obj_type_name,
                   a.obj_id                                              As obj_id,
                   Case
                       When a.obj_type_id = 1 Then
                           (Select name From ss_emplmast Where empno = a.obj_id)
                       When a.obj_type_id = 2 Then
                           (a.obj_id)
                       When a.obj_type_id = 3 Then
                           (Select area_desc From dm_vu_desk_areas Where area_key_id = a.obj_id)
                       Else
                           ''
                   End                                                   As obj_desc,
                   a.modified_by || ' - ' || get_emp_name(a.modified_by) As modified_by,
                   a.modified_on                                         As modified_on
              From dm_tag_obj_mapping a,
                   dm_tag_master b,
                   dm_tag_obj_type    c
             Where a.tag_id = b.key_id
               And a.obj_type_id = c.obj_type_id
             Order By tag_id;
        Return c;
    End sp_tag_obj_mapping_xl_list;

    Function fn_tag_master_list(
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
        Open c For Select to_char(key_id) data_value_field,
                   tag_name      data_text_field
                     From dm_tag_master
                    Order By key_id;

        Return c;
    End;

    Function fn_tag_object_type_list(
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
        Open c For Select to_char(obj_type_id) data_value_field,
                   obj_type_name               data_text_field
                     From dm_tag_obj_type
                    Order By obj_type_id;
        Return c;
    End;

    Function fn_object_id_list(
        p_person_id Varchar2,
        p_meta_id   Varchar2,
        p_obj_id    Varchar2
    ) Return Sys_Refcursor As
        c Sys_Refcursor;
    Begin
        If p_obj_id = '1' Then
            Open c For
                Select empno                  data_value_field,
                       empno || ' - ' || name data_text_field
                  From ss_emplmast
                 Where status = 1
                 Order By empno;
            Return c;
        Elsif p_obj_id = '2' Then
            Open c For
                Select a.deskid data_value_field,
                       a.deskid data_text_field
                  From dm_deskmaster a
                 Order By a.deskid;
            Return c;
        Elsif p_obj_id = '3' Then
            Open c For
                Select a.area_key_id data_value_field,
                       a.area_desc   data_text_field
                  From dm_vu_desk_areas a,
                       dm_desk_area_categories c
                 Where c.area_catg_code = a.area_catg_code
                 Order By a.area_desc;
            Return c;
        End If;
    End;
End pkg_dm_tag_obj_mapping_qry;
/
  Grant Execute On dms.pkg_dm_tag_obj_mapping_qry To tcmpl_app_config;