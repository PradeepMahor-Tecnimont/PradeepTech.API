--------------------------------------------------------
--  DDL for Package Body PKG_BG_VENDOR_TYPE_MAST
--------------------------------------------------------

Create Or Replace Package Body tcmpl_afc."PKG_BG_VENDOR_TYPE_MAST" As

    Procedure sp_add_vendor_type_mast(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_vendor_type      Varchar2,
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

        Insert Into bg_vendor_type_mast (vendortypeid, vendortype, isvisible, isdeleted, modifiedby, modifiedon)
        Values (dbms_random.string('X', 2), p_vendor_type, p_is_visible, 0, v_empno, sysdate);

        Commit;

        p_message_type := 'OK';
        p_message_text := 'Procedure executed successfully.';

    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;

    End sp_add_vendor_type_mast;

    Procedure sp_update_vendor_type_mast(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_vendor_type_id   Varchar2,
        p_vendor_type      Varchar2,
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
            bg_vendor_type_mast
        Set
            vendortype = p_vendor_type,
            isvisible = p_is_visible,
            modifiedby = v_empno,
            modifiedon = sysdate
        Where
            vendortypeid    = p_vendor_type_id
            And isdeleted = 0;

        Commit;

        p_message_type := 'OK';
        p_message_text := 'Procedure executed successfully.';

    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;

    End sp_update_vendor_type_mast;

    Procedure sp_delete_vendor_type_mast(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_vendor_type_id   Varchar2,

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
            bg_vendor_type_mast
        Set
            isdeleted = 1,
            modifiedby = v_empno,
            modifiedon = sysdate
        Where
            vendortypeid = p_vendor_type_id;

        Commit;

        p_message_type := 'OK';
        p_message_text := 'Procedure executed successfully.';

    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;

    End sp_delete_vendor_type_mast;

End pkg_bg_vendor_type_mast;
/
  Grant Execute On "TCMPL_AFC"."PKG_BG_VENDOR_TYPE_MAST" To "TCMPL_APP_CONFIG";