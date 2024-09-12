--------------------------------------------------------
--  DDL for Package Body PKG_BG_CURRENCY_MAST
--------------------------------------------------------

Create Or Replace Package Body tcmpl_afc."PKG_BG_CURRENCY_MAST" As

    Procedure sp_add_currency_mast(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_curr_id          Varchar2,
        p_curr_desc        Varchar2,
        p_comp_id          Varchar2,
        p_is_visible       Number,

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

        Insert Into bg_currency_mast (currid, currdesc, compid, isvisible, isdeleted, modifiedby, modifiedon)
        Values (p_curr_id, p_curr_desc, p_comp_id, p_is_visible, 0, v_empno, sysdate);

        Commit;

        p_message_type := 'OK';
        p_message_text := 'Procedure executed successfully.';

    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;

    End sp_add_currency_mast;

    Procedure sp_update_currency_mast(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_curr_id          Varchar2,
        p_curr_desc        Varchar2,
        p_comp_id          Varchar2,
        p_is_visible       Number,

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
            bg_currency_mast
        Set
            currdesc = p_curr_desc,
            compid = p_comp_id,
            isvisible = p_is_visible,
            modifiedby = v_empno,
            modifiedon = sysdate
        Where
            currid        = p_curr_id
            And isdeleted = 0;

        Commit;

        p_message_type := 'OK';
        p_message_text := 'Procedure executed successfully.';

    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;

    End sp_update_currency_mast;

    Procedure sp_delete_currency_mast(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_curr_id          Varchar2,

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
            bg_currency_mast
        Set
            isdeleted = 1,
            modifiedby = v_empno,
            modifiedon = sysdate
        Where
            currid = p_curr_id;

        Commit;

        p_message_type := 'OK';
        p_message_text := 'Procedure executed successfully.';

    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;

    End sp_delete_currency_mast;

End pkg_bg_currency_mast;
/
  Grant Execute On "TCMPL_AFC"."PKG_BG_CURRENCY_MAST" To "TCMPL_APP_CONFIG";