--------------------------------------------------------
--  DDL for Package Body PKG_BG_PROJ_CONTL_MAST
--------------------------------------------------------

Create Or Replace Package Body tcmpl_afc."PKG_BG_PROJ_CONTL_MAST" As

    Procedure sp_add_proj_contl_mast(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_empno            Varchar2,
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

        Insert Into bg_proj_contl_mast (projcontlid, empno, compid, isvisible, isdeleted, modifiedby, modifiedon)
        Values (dbms_random.string('X', 8), p_empno, p_comp_id, p_is_visible, 0, v_empno, sysdate);

        Commit;

        p_message_type := 'OK';
        p_message_text := 'Procedure executed successfully.';

    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;

    End sp_add_proj_contl_mast;

    Procedure sp_update_proj_contl_mast(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_proj_contl_id    Varchar2,
        p_empno            Varchar2,
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
            bg_proj_contl_mast
        Set
            empno = p_empno,
            compid = p_comp_id,
            isvisible = p_is_visible,
            modifiedby = v_empno,
            modifiedon = sysdate
        Where
            projcontlid   = p_proj_contl_id
            And isdeleted = 0;

        Commit;

        p_message_type := 'OK';
        p_message_text := 'Procedure executed successfully.';

    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;

    End sp_update_proj_contl_mast;

    Procedure sp_delete_proj_contl_mast(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_proj_contl_id    Varchar2,

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
            bg_proj_contl_mast
        Set
            isdeleted = 1,
            modifiedby = v_empno,
            modifiedon = sysdate
        Where
            projcontlid = p_proj_contl_id;

        Commit;

        p_message_type := 'OK';
        p_message_text := 'Procedure executed successfully.';

    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;

    End sp_delete_proj_contl_mast;

End pkg_bg_proj_contl_mast;
/
  Grant Execute On "TCMPL_AFC"."PKG_BG_PROJ_CONTL_MAST" To "TCMPL_APP_CONFIG";