-----------------------------------------------------
--  DDL for Package Body PKG_INV_TRANSACTIONS
-----------------------------------------------------

Create Or Replace Package Body "DMS"."PKG_INV_ITEM_ADDON_TRANS" As

    Procedure sp_add_transaction(
        p_person_id              Varchar2,
        p_meta_id                Varchar2,

        p_addon_item_type_id     Varchar2,
        p_addon_item_id          Varchar2,
        p_container_item_type_id Varchar2,
        p_container_item_id      Varchar2,
        p_remarks                Varchar2 Default Null,

        p_message_type Out       Varchar2,
        p_message_text Out       Varchar2
    ) As
        v_empno                Varchar2(5);
        v_trans_id             inv_transaction_master.trans_id%Type;
        v_trans_details        Varchar2(22);
        row_consumables_detail inv_consumables_detail%rowtype;
        c_usable               Constant Varchar2(1) := 'U';
    Begin
        v_empno        := get_empno_from_meta_id(p_meta_id);

        If v_empno = 'ERRRR' Then
            p_message_type := not_ok;
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        v_trans_id     := dbms_random.string('X', 10);

        Select
            *
        Into
            row_consumables_detail
        From
            inv_consumables_detail
        Where
            item_id = p_addon_item_id;
        If row_consumables_detail.usable_type <> c_usable Then
            p_message_type := not_ok;
            p_message_text := 'Selecte item is not usable.';
            Return;
        End If;
        Insert Into inv_item_addon_trans(
            trans_id,
            trans_date,
            trans_type,
            container_item_type,
            container_item_id,
            addon_item_type,
            addon_item_id,
            modified_by,
            remarks,
            usable_type
        )
        Values(
            v_trans_id,
            sysdate,
            c_trans_issue_id,
            p_container_item_type_id,
            p_container_item_id,
            p_addon_item_type_id,
            p_addon_item_id,
            v_empno,
            p_remarks,
            row_consumables_detail.usable_type
        );

        Insert Into inv_item_addon_map(
            fk_trans_id,
            container_item_type,
            container_item_id,
            addon_item_type,
            addon_item_id
        )
        Values(
            v_trans_id,
            p_container_item_type_id,
            p_container_item_id,
            p_addon_item_type_id,
            p_addon_item_id
        );

        p_message_type := ok;
        p_message_text := 'Procedure executed successfully.';

    Exception
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;

    End sp_add_transaction;

    Procedure sp_add_return(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_trans_id         Varchar2,
        p_item_usable      Varchar2,
        p_remarks          Varchar2,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_empno              Varchar2(5);
        v_new_trans_id       inv_transaction_master.trans_id%Type;
        row_inv_add_on_trans inv_item_addon_trans%rowtype;
        v_count              Number;
    Begin
        v_empno        := get_empno_from_meta_id(p_meta_id);

        If v_empno = 'ERRRR' Then
            p_message_type := not_ok;
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        v_new_trans_id := dbms_random.string('X', 10);

        Select
            Count(*)
        Into
            v_count
        From
            inv_item_addon_trans
        Where
            trans_id = p_trans_id;
        If v_count = 0 Then
            p_message_type := not_ok;
            p_message_text := 'Error - Invalid transaction Id';
            Return;

        End If;
        Select
            *
        Into
            row_inv_add_on_trans
        From
            inv_item_addon_trans
        Where
            trans_id = p_trans_id;

        Delete
            From inv_item_addon_map
        Where
            fk_trans_id = row_inv_add_on_trans.trans_id;

        Insert Into inv_item_addon_trans(
            trans_id,
            trans_date,
            trans_type,
            container_item_type,
            container_item_id,
            addon_item_type,
            addon_item_id,
            modified_by,
            remarks,
            usable_type
        )
        Select
            v_new_trans_id,
            sysdate,
            c_trans_return_id,
            container_item_type,
            container_item_id,
            addon_item_type,
            addon_item_id,
            modified_by,
            p_remarks,
            p_item_usable
        From
            inv_item_addon_trans
        Where
            trans_id = p_trans_id;

        If Sql%rowcount != 1 Then
            p_message_type := not_ok;
            p_message_text := 'Error - Item Addon return transaction not executed.';
            Rollback;
            Return;

        End If;

        Update
            inv_consumables_detail
        Set
            usable_type = p_item_usable,
            is_new = 'N'
        Where
            item_id = row_inv_add_on_trans.addon_item_id;

        p_message_type := ok;
        p_message_text := 'Procedure executed successfully.';

    Exception
        When Others Then
            Rollback;
            p_message_type := not_ok;
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;

    End sp_add_return;

End pkg_inv_item_addon_trans;
/
  Grant Execute On "DMS"."PKG_INV_ITEM_ADDON_TRANS" To "TCMPL_APP_CONFIG";