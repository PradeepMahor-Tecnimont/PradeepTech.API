--------------------------------------------------------
--  DDL for Package Body PKG_BG_BANK_MAST
--------------------------------------------------------

Create Or Replace Package Body tcmpl_afc."PKG_BG_BANK_MAST" As

    Procedure sp_add_bank_mast(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_bank_name        Varchar2,
        p_comp             Varchar2,
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

        Insert Into bg_bank_mast (bankid, bankname, comp, isvisible, isdeleted, modifiedby, modifiedon)
        Values (dbms_random.string('X', 8), p_bank_name, p_comp, p_is_visible, 0, v_empno, sysdate);

        Commit;

        p_message_type := 'OK';
        p_message_text := 'Procedure executed successfully.';

    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;

    End sp_add_bank_mast;

    Procedure sp_update_bank_mast(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_bank_id          Varchar2,
        p_bank_name        Varchar2,
        p_comp             Varchar2,
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
            bg_bank_mast
        Set
            bankname = p_bank_name,
            comp = p_comp,
            isvisible = p_is_visible,
            modifiedby = v_empno,
            modifiedon = sysdate
        Where
            bankid        = p_bank_id
            And isdeleted = 0;

        Commit;

        p_message_type := 'OK';
        p_message_text := 'Procedure executed successfully.';

    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;

    End sp_update_bank_mast;

    Procedure sp_delete_bank_mast(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_bank_id          Varchar2,

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
            bg_bank_mast
        Set
            isdeleted = 1,
            modifiedby = v_empno,
            modifiedon = sysdate
        Where
            bankid = p_bank_id;

        Commit;

        p_message_type := 'OK';
        p_message_text := 'Procedure executed successfully.';

    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;

    End sp_delete_bank_mast;

End pkg_bg_bank_mast;
/
  Grant Execute On "TCMPL_AFC"."PKG_BG_BANK_MAST" To "TCMPL_APP_CONFIG";