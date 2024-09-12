--------------------------------------------------------
--  DDL for Package Body PKG_DMS_ASSET_ON_HOLD
--------------------------------------------------------

Create Or Replace Package Body dms.pkg_dms_asset_on_hold As

    Procedure sp_add_dm_assetadd(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_deskid           Varchar2 Default Null,
        p_asset_id         Varchar2,
        p_empno            Varchar2 Default Null,
        p_action_type      Number,
        p_assign_code      Varchar2,
        p_remarks          Varchar2,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_exists       Number;
        v_empno        Varchar2(5);
        v_user_tcp_ip  Varchar2(5) := 'NA';
        v_message_type Number      := 0;
        v_unqid        Varchar2(20);
    Begin
        v_empno        := get_empno_from_meta_id(p_meta_id);

        If v_empno = 'ERRRR' Then
            p_message_type := 'KO';
            p_message_text := 'Invalid employee number';
            Return;
        End If;
        v_unqid        := dbms_random.string('X', 11);
        Insert Into dm_assetadd (unqid, deskid, assetid, empno, action_type, assign, remarks, action_date)
        Values (v_unqid, p_deskid, p_asset_id, p_empno, p_action_type, p_assign_code, p_remarks, sysdate);

        pkg_dms_asset_on_hold.sp_add_dm_action_trans(
            p_person_id      => p_person_id,
            p_meta_id        => p_meta_id,
            p_actiontrans_id => v_unqid,
            p_asset_id       => p_asset_id,
            p_source_desk    => p_deskid,
            p_target_asset   => Null,
            p_action_type    => p_action_type,
            p_remarks        => p_remarks || ' - ' || p_assign_code,
            p_action_date    => Null,
            p_action_by      => Null,
            p_source_emp     => p_empno,
            p_assetid_old    => Null,
            p_message_type   => p_message_type,
            p_message_text   => p_message_text
        );
        Commit;

        p_message_type := 'OK';
        p_message_text := 'Procedure executed successfully.';

    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;

    End sp_add_dm_assetadd;

    Procedure sp_update_dm_assetadd(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_unqid            Varchar2,
        p_deskid           Varchar2 Default Null,
        p_asset_id         Varchar2,
        p_empno            Varchar2 Default Null,
        p_action_type      Number,
        p_assign_code      Varchar2,
        p_remarks          Varchar2,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_exists       Number;
        v_empno        Varchar2(5);
        v_user_tcp_ip  Varchar2(5) := 'NA';
        v_message_type Number      := 0;
        v_unqid        Varchar2(20);

    Begin
        v_empno        := get_empno_from_meta_id(p_meta_id);

        If v_empno = 'ERRRR' Then
            p_message_type := 'KO';
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        v_unqid        := dbms_random.string('X', 11);

        Delete
          From dm_assetadd
         Where unqid = p_unqid;

        pkg_dms_asset_on_hold.sp_add_dm_action_trans(
            p_person_id      => p_person_id,
            p_meta_id        => p_meta_id,
            p_actiontrans_id => v_unqid,
            p_asset_id       => p_asset_id,
            p_source_desk    => p_deskid,
            p_target_asset   => Null,
            p_action_type    => p_action_type,
            p_remarks        => p_remarks,
            p_action_date    => Null,
            p_action_by      => Null,
            p_source_emp     => p_empno,
            p_assetid_old    => Null,
            p_message_type   => p_message_type,
            p_message_text   => p_message_text
        );

        Commit;

        p_message_type := 'OK';
        p_message_text := 'Procedure executed successfully.';

    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;

    End sp_update_dm_assetadd;

    Procedure sp_delete_dm_assetadd(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_unqid            Varchar2,

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
        Delete
          From dm_assetadd
         Where unqid = p_unqid;
        Commit;

        p_message_type := 'OK';
        p_message_text := 'Procedure executed successfully.';

    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;

    End sp_delete_dm_assetadd;

    Procedure sp_add_dm_action_trans(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_actiontrans_id   Varchar2,
        p_asset_id         Varchar2,
        p_source_desk      Varchar2,
        p_target_asset     Varchar2,
        p_action_type      Varchar2,
        p_remarks          Varchar2,
        p_action_date      Varchar2,
        p_action_by        Varchar2,
        p_source_emp       Varchar2 Default Null,
        p_assetid_old      Varchar2,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_exists       Number;
        v_empno        Varchar2(5);
        v_user_tcp_ip  Varchar2(5) := 'NA';
        v_message_type Number      := 0;
        v_item_type    Varchar2(2);
    Begin
        v_empno        := get_empno_from_meta_id(p_meta_id);

        If v_empno = 'ERRRR' Then
            p_message_type := 'KO';
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        Select assettype Into v_item_type From dm_assetcode Where barcode = Trim(p_asset_id);

        Insert Into dm_action_trans (actiontransid, assetid, sourcedesk, targetasset, action_type, remarks, action_date, action_by,
            source_emp, assetid_old,item_type)
        Values (p_actiontrans_id, p_asset_id, p_source_desk, p_target_asset, p_action_type, p_remarks, sysdate, v_empno, p_source_emp,
            p_assetid_old,v_item_type);

        Delete From dm_action_item_exclude Where assetid = p_asset_id;

        If (p_action_type != 3) Then

            Insert Into dm_action_item_exclude (actiontransid, assetid, sourcedesk, targetasset, action_type, remarks, action_date,
                action_by, source_emp, assetid_old, item_type)
            Values (p_actiontrans_id, p_asset_id, p_source_desk, p_target_asset, p_action_type, p_remarks, sysdate, v_empno,
                p_source_emp, p_assetid_old, v_item_type);

        End If;

        Commit;

        p_message_type := 'OK';
        p_message_text := 'Procedure executed successfully.';

    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;

    End sp_add_dm_action_trans;

    Procedure sp_update_dm_action_trans(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_actiontrans_id   Varchar2,
        p_asset_id         Varchar2,
        p_source_desk      Varchar2,
        p_target_asset     Varchar2,
        p_action_type      Varchar2,
        p_remarks          Varchar2,
        p_action_date      Varchar2,
        p_action_by        Varchar2,
        p_source_emp       Varchar2,
        p_assetid_old      Varchar2,

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

        If v_exists = 1 Then

            Commit;

            p_message_type := 'OK';
            p_message_text := 'Procedure executed successfully.';
        Else
            p_message_type := 'KO';
            p_message_text := 'No matching record exists !!!';
        End If;
    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;

    End sp_update_dm_action_trans;

    Procedure sp_delete_dm_action_trans(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_actiontrans_id   Varchar2,
        p_asset_id         Varchar2,
        p_source_desk      Varchar2,
        p_target_asset     Varchar2,
        p_action_type      Varchar2,
        p_remarks          Varchar2,
        p_action_date      Varchar2,
        p_action_by        Varchar2,
        p_source_emp       Varchar2,
        p_assetid_old      Varchar2,

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

        Commit;

        p_message_type := 'OK';
        p_message_text := 'Procedure executed successfully.';

    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;

    End sp_delete_dm_action_trans;

End pkg_dms_asset_on_hold;
/
  Grant Execute On dms.pkg_dms_asset_on_hold To tcmpl_app_config;