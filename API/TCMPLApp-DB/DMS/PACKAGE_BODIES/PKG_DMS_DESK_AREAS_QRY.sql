--------------------------------------------------------
--  DDL for Package Body PKG_DMS_DESK_AREAS_QRY
--------------------------------------------------------

Create Or Replace Package Body dms.pkg_dms_desk_areas_qry As

    Function fn_desk_areas(
        p_person_id      Varchar2,
        p_meta_id        Varchar2,
        p_generic_search Varchar2 Default Null,
        p_is_restricted  Number   Default Null,
        p_area_catg_code Varchar2 Default Null,
        p_area_type      Varchar2 Default Null,
        p_row_number     Number,
        p_page_length    Number
    ) Return Sys_Refcursor As
        c Sys_Refcursor;
    Begin
        Open c For
            Select area_id,
                   area_desc,
                   area_catg_code,
                   area_catg_desc,
                   area_info,
                   desk_area_type_val,
                   desk_area_type_text,
                   tag_id,
                   tag_name,
                   is_restricted As is_restricted_val,
                   Case
                       When is_restricted = 1 Then
                           'Yes'
                       Else
                           'No'
                   End           As is_restricted_text,
                   is_active     As is_active_val,
                   Case
                       When is_active = 1 Then
                           'Yes'
                       Else
                           'No'
                   End           As is_active_text,
                   pkg_dms_masters_qry.fn_check_work_area_exists(
                       p_person_id, p_meta_id, area_id
                   )             As area_id_count,
                   row_number,
                   total_row
              From (
                       With tags As (
                               Select (
                                          Select substr(sys_connect_by_path(key_id, ','), 2) csv
                                            From (
                                                     Select ta.key_id,
                                                            Row_Number() Over(Order By ta.key_id) rn,
                                                            Count(*) Over()                       cnt
                                                       From dm_tag_master      ta,
                                                            dm_tag_obj_mapping tm
                                                      Where ta.key_id = tm.tag_id
                                                        And a.area_key_id = tm.obj_id
                                                        And tm.obj_type_id = 3
                                                 )
                                           Where rn = cnt
                                           Start With rn = 1
                                         Connect By rn = Prior rn + 1
                                      ) As tag_id,
                                      (
                                          Select substr(sys_connect_by_path(tag_name, ','), 2) csv
                                            From (
                                                     Select ta.tag_name,
                                                            Row_Number() Over(Order By ta.tag_name) rn,
                                                            Count(*) Over()                         cnt
                                                       From dm_tag_master      ta,
                                                            dm_tag_obj_mapping tm
                                                      Where ta.key_id = tm.tag_id
                                                        And a.area_key_id = tm.obj_id
                                                        And tm.obj_type_id = 3
                                                 )
                                           Where rn = cnt
                                           Start With rn = 1
                                         Connect By rn = Prior rn + 1
                                      ) As tag_name,
                                      a.area_key_id
                                 From dm_desk_areas a
                           )
                       Select a.area_key_id                                  As area_id,
                              a.area_desc                                    As area_desc,
                              a.area_catg_code                               As area_catg_code,
                              c.description                                  As area_catg_desc,
                              a.area_info                                    As area_info,
                              a.desk_area_type                               As desk_area_type_val,
                              b.description                                  As desk_area_type_text,
                              --t.tag_id         As tag_id,
                              --d.tag_name       As tag_name,
                              tg.tag_id,
                              tg.tag_name,
                              a.is_restricted                                As is_restricted,
                              a.is_active                                    As is_active,
                              Row_Number() Over(Order By a.area_key_id Desc) row_number,
                              Count(*) Over()                                total_row
                         From dm_desk_areas           a
                         Join dm_desk_area_categories c
                           On c.area_catg_code = a.area_catg_code
                         Left Join dm_area_type       b
                           On a.desk_area_type = b.key_id,
                              tags                    tg
                        Where a.area_key_id = tg.area_key_id
                          And a.is_restricted = nvl(Trim(p_is_restricted), a.is_restricted)
                          And a.desk_area_type = nvl(Trim(p_area_type), a.desk_area_type)
                          And a.area_catg_code = nvl(Trim(p_area_catg_code), a.area_catg_code)
                          And (upper(a.area_key_id) Like '%' || upper(Trim(p_generic_search)) || '%'
                           Or upper(a.area_catg_code) Like '%' || upper(Trim(p_generic_search)) || '%'
                           Or upper(c.description) Like '%' || upper(Trim(p_generic_search)) || '%'
                           Or upper(a.area_desc) Like '%' || upper(Trim(p_generic_search)) || '%')
                   )
             Where row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length);
        Return c;
    End fn_desk_areas;

    Function fn_xl_download_desk_areas(
        p_person_id      Varchar2,
        p_meta_id        Varchar2,
        p_generic_search Varchar2 Default Null
    ) Return Sys_Refcursor As
        c Sys_Refcursor;
    Begin
        Open c For
            Select a.area_key_id    As area_id,
                   a.area_desc      As area_desc,
                   a.area_catg_code As area_catg_code,
                   c.description    As area_catg_desc,
                   a.area_info      As area_info,
                   Case
                       When a.is_restricted = 1 Then
                           'Yes'
                       Else
                           'No'
                   End              As is_restricted
              From dm_desk_areas a,
                   dm_desk_area_categories c
             Where c.area_catg_code = a.area_catg_code
               And (upper(a.area_key_id) Like '%' || upper(Trim(p_generic_search)) || '%'
                Or upper(a.area_catg_code) Like '%' || upper(Trim(p_generic_search)) || '%'
                Or upper(c.description) Like '%' || upper(Trim(p_generic_search)) || '%'
                Or upper(a.area_desc) Like '%' || upper(Trim(p_generic_search)) || '%')
             Order By a.area_key_id;
        Return c;
    End fn_xl_download_desk_areas;

    Procedure sp_desk_areas_details(
        p_person_id              Varchar2,
        p_meta_id                Varchar2,
        p_area_id                Varchar2,
        p_area_desc          Out Varchar2,
        p_area_catg_code     Out Varchar2,
        p_area_catg_desc     Out Varchar2,
        p_area_info          Out Varchar2,
        p_area_type_val      Out Varchar2,
        p_area_type_text     Out Varchar2,
        p_is_restricted_val  Out Number,
        p_is_restricted_text Out Varchar2,
        p_is_active_val      Out Number,
        p_is_active_text     Out Varchar2,
        p_tag_id             Out Varchar2,
        p_tag_name           Out Varchar2,
        p_message_type       Out Varchar2,
        p_message_text       Out Varchar2
    ) As
        v_empno        Varchar2(5);
        v_user_tcp_ip  Varchar2(5) := 'NA';
        v_message_type Number      := 0;
    Begin
        v_empno        := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            p_message_type := 'KO';
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        With tags As (
                Select (
                           Select substr(sys_connect_by_path(key_id, ','), 2) csv
                             From (
                                      Select ta.key_id,
                                             Row_Number() Over(Order By ta.key_id) rn,
                                             Count(*) Over()                       cnt
                                        From dm_tag_master      ta,
                                             dm_tag_obj_mapping tm
                                       Where ta.key_id = tm.tag_id
                                         And a.area_key_id = tm.obj_id
                                         And tm.obj_type_id = 3
                                  )
                            Where rn = cnt
                            Start With rn = 1
                          Connect By rn = Prior rn + 1
                       ) As tag_id,
                       (
                           Select substr(sys_connect_by_path(tag_name, ','), 2) csv
                             From (
                                      Select ta.tag_name,
                                             Row_Number() Over(Order By ta.tag_name) rn,
                                             Count(*) Over()                         cnt
                                        From dm_tag_master      ta,
                                             dm_tag_obj_mapping tm
                                       Where ta.key_id = tm.tag_id
                                         And a.area_key_id = tm.obj_id
                                         And tm.obj_type_id = 3
                                  )
                            Where rn = cnt
                            Start With rn = 1
                          Connect By rn = Prior rn + 1
                       ) As tag_name,
                       a.area_key_id
                  From dm_desk_areas a
            )
        Select a.area_desc      As area_desc,
               a.area_catg_code As area_catg_code,
               c.description    As area_catg_desc,
               a.area_info      As area_info,
               a.desk_area_type,
               b.description,
               a.is_restricted  As is_restricted_val,
               Case
                   When a.is_restricted = 1 Then
                       'Yes'
                   Else
                       'No'
               End              As is_restricted_text,
               a.is_active      As is_active_val,
               Case
                   When a.is_active = 1 Then
                       'Yes'
                   Else
                       'No'
               End              As is_active_text,
               tg.tag_id,
               tg.tag_name
          Into p_area_desc,
               p_area_catg_code,
               p_area_catg_desc,
               p_area_info,
               p_area_type_val,
               p_area_type_text,
               p_is_restricted_val,
               p_is_restricted_text,
               p_is_active_val,
               p_is_active_text,
               p_tag_id,
               p_tag_name
          From dm_desk_areas a,
               dm_desk_area_categories c,
               dm_area_type  b,
               tags          tg
         Where a.area_key_id = tg.area_key_id
           And a.area_key_id = p_area_id
           And a.desk_area_type = b.key_id (+)
           And c.area_catg_code = a.area_catg_code;

        p_message_type := 'OK';
        p_message_text := 'Procedure executed successfully.';
    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
    End sp_desk_areas_details;

    Function fn_check_area_catg_code_exists(
        p_person_id      Varchar2,
        p_meta_id        Varchar2,
        p_area_catg_code Varchar2
    ) Return Number As
        n_count Number;
    Begin
        Select Count(area_key_id)
          Into n_count
          From dm_desk_areas
         Where area_catg_code = Trim(p_area_catg_code);
        Return n_count;
    End;

     Function fn_check_area_type_exists (
        p_person_id Varchar2,
        p_meta_id   Varchar2,
        p_area_type Varchar2,
        p_area_id   Varchar2
    ) Return Number As
        n_count Number;
    Begin
        If ( p_area_type = 'AT01' ) Then
            Select
                Count(key_id)
              Into n_count
              From
                dm_area_type_dept_mapping
             Where
                area_id In (
                    Select
                        area_key_id
                      From
                        dm_desk_areas
                     Where
                            desk_area_type = p_area_type
                           And area_key_id = p_area_id
                );

            If ( n_count > 0 ) Then
                Return n_count;
            End If;
        End If;


        If ( p_area_type = 'AT02' ) Then
            Select
                Count(key_id)
              Into n_count
              From
                dm_area_type_project_mapping
             Where
                area_id In (
                    Select
                        area_key_id
                      From
                        dm_desk_areas
                     Where
                            desk_area_type = p_area_type
                           And area_key_id = p_area_id
                );
            If ( n_count > 0 ) Then
                Return n_count;
            End If;
        End If;

        If ( p_area_type = 'AT03' ) Then
            Select
                Count(key_id)
              Into n_count
              From
                dm_area_type_user_desk_mapping
             Where
                area_id In (
                    Select
                        area_key_id
                      From
                        dm_desk_areas
                     Where
                            desk_area_type = p_area_type
                           And area_key_id = p_area_id
                );

            If ( n_count > 0 ) Then
                Return n_count;
            End If;
        End If;
        If ( p_area_type = 'AT04' ) Then
            Select
                Count(key_id)
              Into n_count
              From
                dm_area_type_user_mapping
             Where
                area_id In (
                    Select
                        area_key_id
                      From
                        dm_desk_areas
                     Where
                            desk_area_type = p_area_type
                           And area_key_id = p_area_id
                );

            If ( n_count > 0 ) Then
                Return n_count;
            End If;
        End If;


        Return n_count;
    End;
    
End pkg_dms_desk_areas_qry;
/
Grant Execute On dms.pkg_dms_desk_areas_qry To tcmpl_app_config;