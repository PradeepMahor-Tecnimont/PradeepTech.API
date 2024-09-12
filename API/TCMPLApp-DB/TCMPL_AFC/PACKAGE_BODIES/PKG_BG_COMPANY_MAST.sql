--------------------------------------------------------
--  DDL for Package Body PKG_BG_COMPANY_MAST
--------------------------------------------------------

Create Or Replace Package Body tcmpl_afc."PKG_BG_COMPANY_MAST" As

    Procedure sp_add_company_mast(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_comp_id          Varchar2,
        p_comp_desc        Varchar2,
        p_domain           Varchar2,
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

        Insert Into bg_company_mast (compid, compdesc, domain, isvisible, isdeleted, modifiedby, modifiedon)
        Values (p_comp_id, p_comp_desc, p_domain, p_is_visible, 0, v_empno, sysdate);

        Commit;

        p_message_type := 'OK';
        p_message_text := 'Procedure executed successfully.';

    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;

    End sp_add_company_mast;

    Procedure sp_update_company_mast(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_comp_id          Varchar2,
        p_comp_desc        Varchar2,
        p_domain           Varchar2,
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
            bg_company_mast
        Set
            compdesc = p_comp_desc,
            domain = p_domain,
            isvisible = p_is_visible,
            modifiedby = v_empno,
            modifiedon = sysdate
        Where
            compid        = p_comp_id
            And isdeleted = 0;

        Commit;

        p_message_type := 'OK';
        p_message_text := 'Procedure executed successfully.';

    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;

    End sp_update_company_mast;

    Procedure sp_delete_company_mast(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_comp_id          Varchar2,

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
            bg_company_mast
        Set
            isdeleted = 1,
            modifiedby = v_empno,
            modifiedon = sysdate
        Where
            compid = p_comp_id;

        Commit;

        p_message_type := 'OK';
        p_message_text := 'Procedure executed successfully.';

    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;

    End sp_delete_company_mast;

End pkg_bg_company_mast;
/
  Grant Execute On "TCMPL_AFC"."PKG_BG_COMPANY_MAST" To "TCMPL_APP_CONFIG";