--------------------------------------------------------
--  DDL for Package Body PKG_DMS_DESK_BAYS
--------------------------------------------------------

Create Or Replace Package Body "DMS"."PKG_DMS_DESK_BAYS" As

    Procedure sp_add_desk_bays(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_bay_id           Varchar2,
        p_bay_desc         Varchar2,

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
            dm_desk_bays
        Where
            Trim(upper(bay_key_id)) = Trim(upper(p_bay_id));

        If v_exists = 0 Then
            Insert Into dm_desk_bays
                (bay_key_id, bay_desc)
            Values
                (Trim(upper(p_bay_id)), Trim(p_bay_desc));

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
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;

    End sp_add_desk_bays;

    Procedure sp_update_desk_bays(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_bay_id           Varchar2,
        p_bay_desc         Varchar2,

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
            dm_desk_bays
        Where
            bay_key_id = p_bay_id;
        If v_exists = 1 Then
            Update
                dm_desk_bays
            Set
                bay_desc = p_bay_desc
            Where
                bay_key_id = p_bay_id;

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
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;

    End sp_update_desk_bays;

    Procedure sp_delete_desk_bays(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_bay_id           Varchar2,

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
            From dm_desk_bays
        Where
            bay_key_id = Trim(p_bay_id);

        Commit;

        p_message_type := 'OK';
        p_message_text := 'Procedure executed successfully.';

    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;

    End sp_delete_desk_bays;

End pkg_dms_desk_bays;
/
  Grant Execute On "DMS"."PKG_DMS_DESK_BAYS" To "TCMPL_APP_CONFIG";