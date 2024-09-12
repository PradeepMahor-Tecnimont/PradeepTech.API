------------------------------------------------------
--  DDL for Package Body PKG_INV_ITEM_ADDON_TRANS_QRY
------------------------------------------------------

Create Or Replace Package Body "DMS"."PKG_INV_ADDON_CONTAINER" As

    Procedure sp_update_addon_container(
        p_person_id         Varchar2,
        p_meta_id           Varchar2,

        p_addon_item_id     Varchar2,
        p_container_item_id Varchar2,

        p_message_type Out  Varchar2,
        p_message_text Out  Varchar2
    ) As
        v_exists       Number;
        v_empno        Varchar2(5);
        v_user_tcp_ip  Varchar2(5) := 'NA';
        v_message_type Number      := 0;
        v_key_id       Varchar2(5);
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
            inv_item_addon_container_mast
        Where
            addon_id         = Trim(upper(p_addon_item_id))
            And container_id = Trim(upper(p_container_item_id));

        If v_exists = 0 Then
            v_key_id       := dbms_random.string('X', 5);
            Insert Into inv_item_addon_container_mast (key_id, addon_id, container_id)
            Values (v_key_id, Trim(upper(p_addon_item_id)), upper(trim(p_container_item_id)));

            Commit;

            p_message_type := 'OK';
            p_message_text := 'Procedure executed successfully.';
        Else
            p_message_type := 'KO';
            p_message_text := 'Item Addon - Container mapping already exists !!!';
        End If;
    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;

    End;

    Procedure sp_delete_addon_container(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_key_id           Varchar2,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2

    ) As
    Begin

        Delete
            From inv_item_addon_container_mast
        Where
            key_id = p_key_id;
        p_message_type := ok;
        p_message_text := 'Procedure executed successfully.';
    Exception
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;

    End;

End pkg_inv_addon_container;
/
Grant Execute On "DMS"."PKG_INV_ADDON_CONTAINER" To "TCMPL_APP_CONFIG";