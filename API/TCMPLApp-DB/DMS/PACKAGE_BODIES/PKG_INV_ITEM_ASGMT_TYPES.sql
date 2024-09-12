--------------------------------------------------------
--  DDL for Package Body PKG_INV_ITEM_ASGMT_TYPES
--------------------------------------------------------

Create Or Replace Package Body "DMS"."PKG_INV_ITEM_ASGMT_TYPES" As

    Procedure sp_add_item_asgmt_types(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_asgmt_code       Varchar2,
        p_description      Varchar2,

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
            inv_item_asgmt_types
        Where
            asgmt_code = Trim(upper(p_asgmt_code));

        If v_exists = 0 Then
            Insert Into inv_item_asgmt_types (asgmt_code, asgmt_desc, is_active, modified_on, modified_by)
            Values (Trim(upper(p_asgmt_code)), Trim(p_description), 1, sysdate, v_empno);

            Commit;

            p_message_type := 'OK';
            p_message_text := 'Procedure executed successfully.';
        Else
            p_message_type := 'KO';
            p_message_text := 'Item assignment types ready exists !!!';
        End If;
    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;

    End sp_add_item_asgmt_types;

    Procedure sp_update_item_asgmt_types(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_asgmt_code       Varchar2,
        p_description      Varchar2,

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
            inv_item_asgmt_types
        Where
            asgmt_code    = Trim(upper(p_asgmt_code))
            And is_active = 1;

        If v_exists = 1 Then
            Update
                inv_item_asgmt_types
            Set
                asgmt_desc = Trim(p_description),
                modified_on = sysdate,
                modified_by = v_empno
            Where
                asgmt_code    = Trim(upper(p_asgmt_code))
                And is_active = 1;

            Commit;

            p_message_type := 'OK';
            p_message_text := 'Procedure executed successfully.';
        Else
            p_message_type := 'KO';
            p_message_text := 'No matching item assignment types exists !';
        End If;
    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;

    End sp_update_item_asgmt_types;

    Procedure sp_delete_item_asgmt_types(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_asgmt_code       Varchar2,

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
            inv_item_asgmt_types
        Set
            is_active = 0,
            modified_on = sysdate,
            modified_by = v_empno
        Where
            asgmt_code    = p_asgmt_code
            And is_active = 1;
        Commit;

        p_message_type := 'OK';
        p_message_text := 'Procedure executed successfully.';

    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;

    End sp_delete_item_asgmt_types;

  Procedure sp_active_item_asgmt_types(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_asgmt_code       Varchar2,

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
            inv_item_asgmt_types
        Set
            is_active = 1,
            modified_on = sysdate,
            modified_by = v_empno
        Where
            asgmt_code    = p_asgmt_code
            And is_active = 0;
        Commit;

        p_message_type := 'OK';
        p_message_text := 'Procedure executed successfully.';

    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;

    End sp_active_item_asgmt_types;

End pkg_inv_item_asgmt_types;
/
  Grant Execute On "DMS"."PKG_INV_ITEM_ASGMT_TYPES" To "TCMPL_APP_CONFIG";