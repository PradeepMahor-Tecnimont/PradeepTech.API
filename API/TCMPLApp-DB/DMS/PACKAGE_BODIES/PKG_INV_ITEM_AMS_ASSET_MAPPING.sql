--------------------------------------------------------
--  DDL for Package Body PKG_INV_ITEM_AMS_ASSET_MAPPING
--------------------------------------------------------

Create Or Replace Package Body "DMS"."PKG_INV_ITEM_AMS_ASSET_MAPPING" As

    Procedure sp_add_ams_asset_mapping(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_item_type_key_id Varchar2,
        p_sub_asset_type   Varchar2,

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
            p_message_type := 'KO';
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        Select
            Count(*)
        Into
            v_exists
        From
            inv_item_ams_asset_mapping
        Where
            item_type_key_id = p_item_type_key_id
            and sub_asset_type = p_sub_asset_type
            and IS_ACTIVE = 1;

        If v_exists = 0 Then
            Insert Into inv_item_ams_asset_mapping (key_id, item_type_key_id, sub_asset_type, is_active, modified_on, modified_by)
            Values (dbms_random.string('X', 8), p_item_type_key_id, p_sub_asset_type, 1, sysdate, v_empno);

            Commit;

            p_message_type := 'OK';
            p_message_text := 'Procedure executed successfully.';
        Else
            p_message_type := 'KO';
            p_message_text := 'Item AMS asset mapping ready exists !!!';
        End If;
    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;

    End sp_add_ams_asset_mapping;

    Procedure sp_update_ams_asset_mapping(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_key_id           Varchar2,
        p_item_type_key_id Varchar2,
        p_sub_asset_type   Varchar2,

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
            p_message_type := 'KO';
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        Select
            Count(*)
        Into
            v_exists
        From
            inv_item_ams_asset_mapping
        Where
            key_id = p_key_id
             And is_active = 1;

        If v_exists = 1 Then
            Update
                inv_item_ams_asset_mapping
            Set
                 sub_asset_type = p_sub_asset_type,
                modified_on = sysdate, modified_by = v_empno
            Where
                key_id        = p_key_id
                and item_type_key_id = p_item_type_key_id
                And is_active = 1;

            Commit;

            p_message_type := 'OK';
            p_message_text := 'Procedure executed successfully.';
        Else
            p_message_type := 'KO';
            p_message_text := 'No matching or duplicate item AMS asset mapping exists !!!';
        End If;
    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;

    End sp_update_ams_asset_mapping;

    Procedure sp_delete_ams_asset_mapping(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_key_id           Varchar2,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
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

        Update
            inv_item_ams_asset_mapping
        Set
            is_active = 0,
            modified_on = sysdate, modified_by = v_empno
        Where
            key_id        = p_key_id
            And is_active = 1;

        Commit;

        p_message_type := 'OK';
        p_message_text := 'Procedure executed successfully.';

    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;

    End sp_delete_ams_asset_mapping;

 Procedure sp_active_ams_asset_mapping(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_key_id           Varchar2,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
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

        Update
            inv_item_ams_asset_mapping
        Set
            is_active = 1,
            modified_on = sysdate, modified_by = v_empno
        Where
            key_id        = p_key_id
            And is_active = 0;

        Commit;

        p_message_type := 'OK';
        p_message_text := 'Procedure executed successfully.';

    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;

    End sp_active_ams_asset_mapping;

End pkg_inv_item_ams_asset_mapping;
/
  Grant Execute On "DMS"."PKG_INV_ITEM_AMS_ASSET_MAPPING" To "TCMPL_APP_CONFIG";