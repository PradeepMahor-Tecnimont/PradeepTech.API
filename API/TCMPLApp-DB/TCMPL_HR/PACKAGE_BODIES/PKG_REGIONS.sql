Create Or Replace Package Body tcmpl_hr.pkg_regions As

    Procedure sp_add_region(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,
        p_region_name      Varchar2,
        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_exists       Number;
        v_region_code  Number;
        v_keyid        Varchar2(5);
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
            hd_regions
        Where
            Trim(upper(region_name)) = Trim(upper(p_region_name));

        If v_exists = 0 Then
            Select
                (Max(region_code) + 1)
            Into
                v_region_code
            From
                hd_regions;

            Insert Into hd_regions (
                region_code,
                region_name,
                modified_on,
                modified_by
            )
            Values (
                v_region_code,
                p_region_name,
                sysdate,
                v_empno
            );

            Commit;
            p_message_type := ok;
            p_message_text := 'Region added successfully..';
        Else
            p_message_type := not_ok;
            p_message_text := 'Region already exists !!!';
        End If;

    Exception
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
    End sp_add_region;

    Procedure sp_update_region(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,
        p_region_code      Varchar2,
        p_region_name      Varchar2,
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
    Exception
        When dup_val_on_index Then
            p_message_type := not_ok;
            p_message_text := 'Region already exists !!!';
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
    End sp_update_region;

    Procedure sp_delete_region(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,
        p_region_code      Varchar2,
        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_is_used      Number;
        v_user_tcp_ip  Varchar2(5) := 'NA';
        v_message_type Number      := 0;
    Begin
        Delete
            From hd_regions
        Where
            region_code = p_region_code;

        Commit;
        p_message_type := ok;
        p_message_text := 'Record deleted successfully.';
    Exception
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
    End sp_delete_region;

End pkg_regions;
/