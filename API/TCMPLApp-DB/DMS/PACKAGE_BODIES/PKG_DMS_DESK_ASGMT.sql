--------------------------------------------------------
--  DDL for Package Body PKG_DMS_DESK_ASGMT
--------------------------------------------------------

Create Or Replace Package Body "DMS"."PKG_DMS_DESK_ASGMT" As

    Procedure sp_add_assets_to_desk(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_desk_id          Varchar2,
        p_asset_id         Varchar2,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_empno        Varchar2(5);
        v_user_tcp_ip  Varchar2(5) := 'NA';
        v_message_type Number      := 0;
        v_count        Number;
    Begin
        v_empno        := get_empno_from_meta_id(p_meta_id);

        If v_empno = 'ERRRR' Then
            p_message_type := 'KO';
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        Select
            Count(*)
        Into
            v_count
        From
            dm_deskallocation
        Where
            deskid      = p_desk_id
            And assetid = p_asset_id;

        If v_count > 0 Then
            p_message_type := 'KO';
            p_message_text := 'Assets assigned in another disk';
            Return;
        End If;

        Insert Into dm_deskallocation (deskid, assetid, barcode_old)
        Values (p_desk_id, p_asset_id, Null);

        Commit;

        p_message_type := 'OK';
        p_message_text := 'Procedure executed successfully.';

    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;

    End sp_add_assets_to_desk;

    Procedure sp_replace_assets_from_desk(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_desk_id          Varchar2,
        p_old_asset_id     Varchar2,
        p_asset_id         Varchar2,

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
            dm_deskallocation
        Set
            assetid = p_asset_id
        Where
            deskid      = p_desk_id
            And assetid = p_old_asset_id;

        Commit;

        p_message_type := 'OK';
        p_message_text := 'Procedure executed successfully.';

    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;

    End sp_replace_assets_from_desk;

    Procedure sp_delete_assets_from_desk(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_desk_id          Varchar2,
        p_asset_id         Varchar2,

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
            From dm_deskallocation
        Where
            deskid      = p_desk_id
            And assetid = p_asset_id;

        Commit;

        p_message_type := 'OK';
        p_message_text := 'Procedure executed successfully.';

    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;

    End sp_delete_assets_from_desk;

    Procedure sp_add_emp_to_desk(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_desk_id          Varchar2,
        p_empno            Varchar2,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_empno        Varchar2(5);
        v_user_tcp_ip  Varchar2(5) := 'NA';
        v_message_type Number      := 0;
        v_count        Number;
        v_perent       Varchar(5);
    Begin
        v_empno        := get_empno_from_meta_id(p_meta_id);

        If v_empno = 'ERRRR' Then
            p_message_type := 'KO';
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        Select
            Count(*)
        Into
            v_count
        From
            dm_usermaster
        Where
            empno = p_empno;

        If v_count > 0 Then
            p_message_type := 'KO';
            p_message_text := 'Employee already has desk';
            Return;
        End If;

        v_perent       := get_parent_from_empno(p_empno);

        Insert Into dm_usermaster
            (empno, deskid, costcode, dep_flag)
        Values
            (p_empno, p_desk_id, v_perent, 0);

        Commit;

        p_message_type := 'OK';
        p_message_text := 'Procedure executed successfully.';

    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;

    End sp_add_emp_to_desk;

    Procedure sp_delete_emp_from_desk(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_desk_id          Varchar2,
        p_empno            Varchar2,

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
            From dm_usermaster
        Where
            deskid    = p_desk_id
            And empno = p_empno;

        Commit;
        p_message_type := 'OK';
        p_message_text := 'Procedure executed successfully.';

    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;

    End sp_delete_emp_from_desk;

End pkg_dms_desk_asgmt;
/
Grant Execute On "DMS"."PKG_DMS_DESK_ASGMT" To "TCMPL_APP_CONFIG";