--------------------------------------------------------
--  DDL for Package Body PKG_DMS_DESK_AREAS
--------------------------------------------------------

Create Or Replace Package Body dms.pkg_dms_desk_areas As

    Procedure sp_add_desk_areas (
        p_person_id      Varchar2,
        p_meta_id        Varchar2,
        p_area_id        Varchar2,
        p_area_desc      Varchar2,
        p_area_catg_code Varchar2,
        p_area_info      Varchar2 Default Null,
        p_area_type      Varchar2,
        p_is_restricted  Number,
        p_is_active      Number,
        p_tag_id         Varchar2 Default Null,
        p_message_type   Out Varchar2,
        p_message_text   Out Varchar2
    ) As
        v_exists       Number;
        v_empno        Varchar2(5);
        v_keyid        Varchar2(8);
        v_user_tcp_ip  Varchar2(5) := 'NA';
        v_message_type Number := 0;
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            p_message_type := 'KO';
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        Select
            Count(*)
          Into v_exists
          From
            dm_desk_areas
         Where
            Trim(upper(area_key_id)) = Trim(upper(p_area_id));

        If v_exists = 0 Then
            Insert Into dm_desk_areas (
                area_key_id,
                area_desc,
                area_catg_code,
                area_info,
                desk_area_type,
                is_restricted,
                is_active
            ) Values (
                Trim(upper(p_area_id)),
                p_area_desc,
                p_area_catg_code,
                p_area_info,
                p_area_type,
                p_is_restricted,
                p_is_active
            );

            If length(p_tag_id) > 0 Then
                For i In (
                    Select
                        Trim(regexp_substr(
                            p_tag_id,
                            '[^,]+',
                            1,
                            level
                        )) tag
                      From
                        dual
                    Connect By
                        level <= regexp_count(
                            p_tag_id,
                            ','
                        ) + 1
                ) Loop
                    Select
                        Count(*)
                      Into v_exists
                      From dm_tag_obj_mapping
                     Where obj_id = p_area_id
                       And obj_type_id = c_obj_type_id
                       And tag_id = i.tag;

                    If v_exists = 0 Then
                        v_keyid := dbms_random.string(
                                                     'X',
                                                     8
                                   );
                        Insert Into dm_tag_obj_mapping (
                            key_id,
                            tag_id,
                            obj_id,
                            obj_type_id,
                            modified_on,
                            modified_by
                        ) Values (
                            v_keyid,
                            i.tag,
                            p_area_id,
                            c_obj_type_id,
                            sysdate,
                            v_empno
                        );
                    End If;

                End Loop;
            End If;

            Commit;
            p_message_type := 'OK';
            p_message_text := 'Procedure executed successfully.';
        Else
            p_message_type := 'KO';
            p_message_text := 'Bay ready exists !!!';
        End If;
    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'ERR :- '
                              || sqlcode
                              || ' - '
                              || sqlerrm;
    End sp_add_desk_areas;

    Procedure sp_update_desk_areas (
        p_person_id      Varchar2,
        p_meta_id        Varchar2,
        p_area_id        Varchar2,
        p_area_desc      Varchar2,
        p_area_catg_code Varchar2,
        p_area_info      Varchar2 Default Null,
        p_area_type      Varchar2,
        p_is_restricted  Number,
        p_is_active      Number,
        p_tag_id           Varchar2 Default Null,
        p_message_type   Out Varchar2,
        p_message_text   Out Varchar2
    ) As
        v_exists       Number;
        v_empno        Varchar2(5);
        v_keyid        Varchar2(8);
        v_area_type    Varchar2(8);
        v_user_tcp_ip  Varchar2(5) := 'NA';
        v_message_type Number := 0;
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            p_message_type := 'KO';
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        If p_is_active = 0 Then
            v_exists := pkg_dms_masters_qry.fn_check_work_area_exists(
                                                                     p_person_id,
                                                                     p_meta_id,
                                                                     p_area_id
                        );
            If v_exists > 0 Then
                p_message_type := not_ok;
                p_message_text := 'Error - Area already in use..';
                Return;
            End If;
        End If;

        Select
            Count(*)
          Into v_exists
          From
            dm_desk_areas
         Where
            area_key_id = p_area_id;

        If v_exists = 1 Then
            Select
                desk_area_type
              Into v_area_type
              From
                dm_desk_areas
             Where
                area_key_id = p_area_id;
            If v_area_type != p_area_type Then
                v_exists := pkg_dms_desk_areas_qry.fn_check_area_type_exists(
                                                                            p_person_id => p_person_id,
                                                                            p_meta_id => p_meta_id,
                                                                            p_area_type => v_area_type,
                                                                            p_area_id => p_area_id
                            );

                If v_exists > 0 Then
                    p_message_type := not_ok;
                    p_message_text := 'Error - Area type change not allowed, Area already in use mapped Area type..';
                    Return;
                End If;
            End If;
            Update dm_desk_areas
               Set
                area_desc = p_area_desc,
                area_catg_code = p_area_catg_code,
                area_info = p_area_info,
                desk_area_type = p_area_type,
                is_restricted = p_is_restricted,
                is_active = p_is_active
             Where
                area_key_id = p_area_id;

            If length(p_tag_id) > 0 Then
                delete from dm_tag_obj_mapping where Trim(obj_id) = Trim(p_area_id) And obj_type_id = 3 And Trim(tag_id) Not In (Select Trim(regexp_substr(p_tag_id, '[^,]+', 1, level)) tag
                      From dual
                   Connect By level <= regexp_count(p_tag_id, ',') + 1);
                
                For i In(
                    Select Trim(regexp_substr(p_tag_id, '[^,]+', 1, level)) tag
                      From dual
                   Connect By level <= regexp_count(p_tag_id, ',') + 1
                )
                Loop
                    
                        Select Count(*) Into v_exists
                          From dm_tag_obj_mapping
                         Where Trim(obj_id) = p_area_id
                           And Trim(obj_type_id) = '3'
                           And Trim(tag_id) = Trim(i.tag);

                        If v_exists = 0 Then
                            v_keyid := dbms_random.string('X', 8);

                            Insert Into dm_tag_obj_mapping (
                                key_id,
                                tag_id,
                                obj_id,
                                obj_type_id,
                                modified_on,
                                modified_by
                            )
                            Values (
                                v_keyid,
                                Trim(i.tag),
                                p_area_id,
                                '3',
                                sysdate,
                                v_empno
                            );
                        End If;
                    
                    
                End Loop;
           else 
           delete from dm_tag_obj_mapping where Trim(obj_id) = Trim(p_area_id)
                And obj_type_id = 3 ;
                --And Trim(tag_id) Not In (Select Trim(regexp_substr(p_tag_id, '[^,]+', 1, level)) tag From dual Connect By level <= regexp_count(p_tag_id, ',') + 1);
            End If;

            Commit;
            p_message_type := 'OK';
            p_message_text := 'Procedure executed successfully.';
        Else
            p_message_type := 'KO';
            p_message_text := 'No matching bay exists !!!';
        End If;
    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'ERR :- '
                              || sqlcode
                              || ' - '
                              || sqlerrm;
    End sp_update_desk_areas;

    Procedure sp_delete_desk_areas (
        p_person_id    Varchar2,
        p_meta_id      Varchar2,
        p_area_id      Varchar2,
        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_empno        Varchar2(5);
        v_user_tcp_ip  Varchar2(5) := 'NA';
        v_count        Number := 0;
        v_tag_count    Number := 0;
        v_message_type Number := 0;
    Begin
        v_empno        := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            p_message_type := 'KO';
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        v_count        := pkg_dms_masters_qry.fn_check_work_area_exists(
                                                                p_person_id,
                                                                p_meta_id,
                                                                p_area_id
                   );
        If v_count > 0 Then
            p_message_type := not_ok;
            p_message_text := 'Error - Area already in use..';
            Return;
        End If;

        Delete From dm_desk_areas
         Where
                area_key_id = Trim(p_area_id)
               And is_active = 0;

        Select
            Count(*)
          Into v_tag_count
          From dm_tag_obj_mapping
         Where obj_id = p_area_id
           And obj_type_id = '3';

        If v_tag_count > 0 Then
            Delete From dm_tag_obj_mapping
             Where
                    obj_id = p_area_id
                   And obj_type_id = 3;
        End If;

        If ( Sql%rowcount > 0 ) Then
            Commit;
            p_message_type := ok;
            p_message_text := 'Procedure executed successfully.';
        Else
            p_message_type := not_ok;
            p_message_text := 'Error - Procedure not executed..';
        End If;

        p_message_type := 'OK';
        p_message_text := 'Procedure executed successfully.';
    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'ERR :- '
                              || sqlcode
                              || ' - '
                              || sqlerrm;
    End sp_delete_desk_areas;

End pkg_dms_desk_areas;
/
Grant Execute On dms.pkg_dms_desk_areas To tcmpl_app_config;