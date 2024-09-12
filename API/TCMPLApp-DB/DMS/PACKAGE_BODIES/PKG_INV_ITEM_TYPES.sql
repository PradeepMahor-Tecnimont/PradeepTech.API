--------------------------------------------------------
--  DDL for Package Body PKG_INV_ITEM_TYPES
--------------------------------------------------------

Create Or Replace Package Body "DMS"."PKG_INV_ITEM_TYPES" As

    Procedure sp_add_item_types(
        p_person_id            Varchar2,
        p_meta_id              Varchar2,

        p_item_type_code       Varchar2,
        p_category_code        Varchar2,
        p_item_assignment_type Varchar2,
        p_description          Varchar2,
        p_print_order          Varchar2,        
        p_action_id             Varchar2,
        
        p_message_type Out     Varchar2,
        p_message_text Out     Varchar2
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
            inv_item_types
        Where
            item_type_code           = upper(p_item_type_code)
            And category_code        = p_category_code
            And item_assignment_type = p_item_assignment_type
            And is_active            = 1;

        If v_exists = 0 Then

            Insert Into inv_item_types
            (item_type_key_id, item_type_code, category_code, item_assignment_type, item_type_desc,
                is_active, print_order,ACTION_ID, modified_on, modified_by)
            Values (dbms_random.string('X', 5), upper(p_item_type_code), p_category_code, p_item_assignment_type,
                p_description, 1, p_print_order,p_action_id, sysdate, v_empno);

            Commit;

            p_message_type := 'OK';
            p_message_text := 'Procedure executed successfully.';
        Else
            p_message_type := 'KO';
            p_message_text := 'Item type ready exists !!!';
        End If;
    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;

    End sp_add_item_types;

    Procedure sp_update_item_types(
        p_person_id            Varchar2,
        p_meta_id              Varchar2,

        p_key_id               Varchar2,
        p_item_type_code       Varchar2,
        p_category_code        Varchar2,
        p_item_assignment_type Varchar2,
        p_description          Varchar2,
        p_print_order          Varchar2,
        p_action_id             Varchar2,
        
        p_message_type Out     Varchar2,
        p_message_text Out     Varchar2
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
            inv_item_types
        Where
            item_type_key_id = p_key_id
            And is_active    = 1;

        If v_exists = 1 Then
            Update
                inv_item_types
            Set
                item_type_code = p_item_type_code,
                category_code = p_category_code,
                item_assignment_type = p_item_assignment_type,
                item_type_desc = p_description,
                print_order = p_print_order,
                modified_on = sysdate,
                modified_by = v_empno,
                action_id = p_action_id
            Where
                item_type_key_id = p_key_id
                And is_active    = 1;

            Commit;

            p_message_type := 'OK';
            p_message_text := 'Procedure executed successfully.';
        Else
            p_message_type := 'KO';
            p_message_text := 'No matching item type exists !!!';
        End If;
    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;

    End sp_update_item_types;

    Procedure sp_delete_item_types(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_key_id           Varchar2,

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
            inv_item_types
        Set
            is_active = 0,
            modified_on = sysdate,
            modified_by = v_empno
        Where
            item_type_key_id = p_key_id
            And is_active    = 1;

        Commit;

        p_message_type := 'OK';
        p_message_text := 'Procedure executed successfully.';

    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;

    End sp_delete_item_types;

    Procedure sp_active_item_types(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_key_id           Varchar2,

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
            inv_item_types
        Set
            is_active = 1,
            modified_on = sysdate,
            modified_by = v_empno
        Where
            item_type_key_id = p_key_id
            And is_active    = 0;

        Commit;

        p_message_type := 'OK';
        p_message_text := 'Procedure executed successfully.';

    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;

    End sp_active_item_types;

End pkg_inv_item_types;
/
  Grant Execute On "DMS"."PKG_INV_ITEM_TYPES" To "TCMPL_APP_CONFIG";