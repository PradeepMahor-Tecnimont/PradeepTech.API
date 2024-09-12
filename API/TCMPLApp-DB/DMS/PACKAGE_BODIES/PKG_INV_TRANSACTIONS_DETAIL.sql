------------------------------------------------------
--  DDL for Package Body PKG_INV_TRANSACTIONS_DETAIL
------------------------------------------------------

Create Or Replace Package Body dms.pkg_inv_transactions_detail As

    Procedure sp_add_consumable(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_trans_id         Varchar2,
        p_item_id          Varchar2,
        p_item_usable      Char,
        p_item_type        Varchar2 Default Null,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_empno Char(5);
    Begin
        v_empno        := get_empno_from_meta_id(p_meta_id);

        If v_empno = 'ERRRR' Then
            p_message_type := 'KO';
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        Insert Into inv_transaction_detail
            (trans_det_id, item_id, item_usable, trans_id, item_type)
        Values
            (dbms_random.string('X', 15), Trim(p_item_id), p_item_usable, p_trans_id, p_item_type);

        p_message_type := 'OK';
        p_message_text := 'Procedure executed successfully.';

    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;

    End sp_add_consumable;

    Procedure sp_delete_consumable(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_trans_id         Varchar2,
        p_trans_det_id     Varchar2,
        p_trans_type_desc  Varchar2,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_empno Varchar2(5);
        ncount  Number;
    Begin
        v_empno        := get_empno_from_meta_id(p_meta_id);

        If v_empno = 'ERRRR' Then
            p_message_type := 'KO';
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        If p_trans_type_desc = c_trans_return_mode Then
            Delete
              From inv_emp_item_mapping_reserve_return
             Where item_id = (
                       Select item_id
                         From inv_transaction_detail
                        Where trans_det_id = Trim(p_trans_det_id)
                   );
        Else
            /*
                Update
                    inv_consumables_detail
                Set
                    is_issued = 'N'
                Where
                    item_id = (
                        Select
                            item_id
                        From
                            inv_transaction_detail
                        Where
                            trans_det_id = Trim(p_trans_det_id)
                    );
                */
            Null;
        End If;

        Delete
          From inv_transaction_detail
         Where trans_det_id = Trim(p_trans_det_id);

        Select Count(*)
          Into ncount
          From inv_transaction_detail
         Where trans_id = Trim(p_trans_id);
        If ncount = 0 Then
            Delete
              From inv_transaction_master
             Where trans_id = Trim(p_trans_id);
        End If;

        Commit;

        p_message_type := 'OK';
        p_message_text := 'Procedure executed successfully.';

    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;

    End sp_delete_consumable;

End pkg_inv_transactions_detail;
/
  Grant Execute On dms.pkg_inv_transactions_detail To tcmpl_app_config;