--------------------------------------------------------
--  DDL for Package Body PKG_INV_ITEM_CATEGORY
--------------------------------------------------------

Create Or Replace Package Body "DMS"."PKG_INV_ITEM_CATEGORY" As

    Procedure sp_add_item_category(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_category_code    Varchar2,
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
            inv_item_category
        Where
            Trim(upper(category_code)) = Trim(upper(p_category_code))
            And is_active              = 1;

        If v_exists = 0 Then
            Insert Into inv_item_category
                (category_code, description, is_active, modified_on, modified_by)
            Values
                (Trim(upper(p_category_code)), Trim(p_description), 1, sysdate, v_empno);

            Commit;

            p_message_type := 'OK';
            p_message_text := 'Procedure executed successfully.';
        Else
            p_message_type := 'KO';
            p_message_text := 'Item category ready exists !!!';
        End If;
    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;

    End sp_add_item_category;

    Procedure sp_update_item_category(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_category_code    Varchar2,
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
            inv_item_category
        Where
            category_code = p_category_code
            And is_active = 1;

        If v_exists = 1 Then
            Update
                inv_item_category
            Set
                description = Trim(p_description),
                modified_on = sysdate,
                modified_by = v_empno
            Where
                category_code = p_category_code
                And is_active = 1;

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

    End sp_update_item_category;

    Procedure sp_delete_item_category(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_category_code    Varchar2,

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
            inv_item_category
        Set
            is_active = 0,
            modified_on = sysdate,
            modified_by = v_empno
        Where
            category_code = p_category_code
            And is_active = 1;

        Commit;

        p_message_type := 'OK';
        p_message_text := 'Procedure executed successfully.';

    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;

    End sp_delete_item_category;

  Procedure sp_active_item_category(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_category_code    Varchar2,

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
            inv_item_category
        Set
            is_active = 1,
            modified_on = sysdate,
            modified_by = v_empno
        Where
            category_code = p_category_code
            And is_active = 0;

        Commit;

        p_message_type := 'OK';
        p_message_text := 'Procedure executed successfully.';

    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;

    End sp_active_item_category;

End pkg_inv_item_category;
/
  Grant Execute On "DMS"."PKG_INV_ITEM_CATEGORY" To "TCMPL_APP_CONFIG";