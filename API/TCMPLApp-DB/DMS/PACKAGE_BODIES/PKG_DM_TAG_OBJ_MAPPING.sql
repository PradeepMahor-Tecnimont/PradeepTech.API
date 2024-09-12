Create Or Replace Package Body dms.pkg_dm_tag_obj_mapping As

    Procedure sp_add_tag_object_mapping(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,
        p_tag_id           Number,
        p_obj_id           Varchar2,
        p_obj_type_id      Number,
        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_exists       Number;
        v_empno        Varchar2(5);
        v_keyid        Varchar2(8);
        v_user_tcp_ip  Varchar2(5) := 'NA';
        v_message_type Number      := 0;
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            p_message_type := not_ok;
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        v_keyid := dbms_random.string('X', 8);
        Select Count(*)
          Into v_exists
          From dm_tag_obj_mapping
         Where obj_id = p_obj_id
           And tag_id = p_tag_id;

        If v_exists = 0 Then
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
                p_tag_id,
                p_obj_id,
                p_obj_type_id,
                sysdate,
                v_empno
            );
            Commit;
            p_message_type := ok;
            p_message_text := 'Tag object mapping added successfully..';
        Else
            p_message_type := not_ok;
            p_message_text := 'Tag object mapping already exists !!!';
        End If;

    Exception
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
    End sp_add_tag_object_mapping;

    Procedure sp_update_tag_object_mapping(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,
        p_key_id           Varchar2,
        p_tag_id           Number,
        p_obj_id           Varchar2,
        p_obj_type_id      Number,
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
            Update dm_tag_obj_mapping
               Set tag_id = p_tag_id,
                   obj_id = p_obj_id,
                   obj_type_id = p_obj_type_id,
                   modified_on = sysdate,
                   modified_by = v_empno
             Where key_id = p_key_id;

            Commit;
            p_message_type := ok;
            p_message_text := 'Tag object mapping updated successfully.';
        Else
            p_message_type := not_ok;
            p_message_text := 'No matching tag object mapping exists !!!';
        End If;
    Exception
        When dup_val_on_index Then
            p_message_type := not_ok;
            p_message_text := 'Tag object mapping already exists !!!';
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
    End sp_update_tag_object_mapping;

    Procedure sp_delete_tag_object_mapping(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,
        p_key_id           Varchar2,
        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_empno        Varchar2(5);
        v_is_used      Number;
        v_user_tcp_ip  Varchar2(5) := 'NA';
        v_message_type Number      := 0;
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            p_message_type := not_ok;
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        Delete From dm_tag_obj_mapping
         Where key_id = p_key_id;

        If (Sql%rowcount > 0) Then
            Commit;
            p_message_type := ok;
            p_message_text := 'Procedure executed successfully.';
        Else
            p_message_type := not_ok;
            p_message_text := 'Procedure not executed.';
        End If;

    Exception
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
    End sp_delete_tag_object_mapping;

End pkg_dm_tag_obj_mapping;
/
  Grant Execute On dms.pkg_dm_tag_obj_mapping To tcmpl_app_config;