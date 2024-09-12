--------------------------------------------------------
--  DDL for Package Body PKG_DMS_DESK_BAYS
--------------------------------------------------------

Create Or Replace Package Body "DMS"."PKG_DMS_DESK_AREA_CATEGORIES" As

    Procedure sp_add_desk_area_categories(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_area_catg_code   Varchar2,
        p_area_desc        Varchar2,

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
            dm_desk_area_categories
        Where
            Trim(upper(area_catg_code)) = Trim(upper(p_area_catg_code));

        If v_exists = 0 Then
            Insert Into dm_desk_area_categories
                (area_catg_code, description)
            Values
                (Trim(upper(p_area_catg_code)), Trim(p_area_desc));

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

    End sp_add_desk_area_categories;

    Procedure sp_update_desk_area_categories(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_area_catg_code   Varchar2,
        p_area_desc        Varchar2,

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
            dm_desk_area_categories
        Where
            area_catg_code = p_area_catg_code;

        If v_exists = 1 Then
            Update
                dm_desk_area_categories
            Set
                description = p_area_desc
            Where
                area_catg_code = p_area_catg_code;

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

    End sp_update_desk_area_categories;

    Procedure sp_delete_desk_area_categories(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_area_catg_code   Varchar2,

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
            From dm_desk_area_categories
        Where
            Trim(upper(area_catg_code)) = Trim(upper(p_area_catg_code));

        Commit;

        p_message_type := 'OK';
        p_message_text := 'Procedure executed successfully.';

    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;

    End sp_delete_desk_area_categories;

End pkg_dms_desk_area_categories;
/
  Grant Execute On "DMS"."PKG_DMS_DESK_AREA_CATEGORIES" To "TCMPL_APP_CONFIG";