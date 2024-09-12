Create Or Replace Package Body "DMS"."PKG_DMS_OFFICES" As

    Procedure sp_add_dm_offices (
        p_person_id                  Varchar2,
        p_meta_id                    Varchar2,
        p_office_code                Varchar2,
        p_office_name                Varchar2,
        p_office_desc                Varchar2,
        p_office_location_code       Varchar2,
        p_smart_desk_booking_enabled Varchar2,
        p_message_type               Out Varchar2,
        p_message_text               Out Varchar2
    ) As
        v_exists       Number;
        v_empno        Varchar2(5);
        v_user_tcp_ip  Varchar2(5) := 'NA';
        v_message_type Number := 0;
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            p_message_type := not_ok;
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        Select
            Count(*)
          Into v_exists
          From
            dm_offices
         Where
                Trim(upper(office_code)) = Trim(upper(p_office_code)) And
            Trim(upper(office_name)) = Trim(upper(p_office_name));

        If v_exists = 0 Then
            Insert Into dm_offices (
                office_code,
                office_name,
                office_desc,
                office_location_code,
                smart_desk_booking_enabled
            ) Values (
                Trim(upper(p_office_code)),
                Trim(upper(p_office_name)),
                Trim(p_office_desc),
                Trim(p_office_location_code),
                Trim(p_smart_desk_booking_enabled)
            );

            Commit;
            p_message_type := ok;
            p_message_text := 'Office added successfully..';
        Else
            p_message_type := not_ok;
            p_message_text := 'Office already exists !!!';
        End If;

    Exception
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'ERR :- '
                              || sqlcode
                              || ' - '
                              || sqlerrm;
    End sp_add_dm_offices;

    Procedure sp_update_dm_offices (
        p_person_id                  Varchar2,
        p_meta_id                    Varchar2,
        p_office_code                Varchar2,
        p_office_name                Varchar2,
        p_office_desc                Varchar2,
        p_office_location_code       Varchar2,
        p_smart_desk_booking_enabled Varchar2,
        p_message_type               Out Varchar2,
        p_message_text               Out Varchar2
    ) As
        v_exists       Number;
        v_empno        Varchar2(5);
        v_user_tcp_ip  Varchar2(5) := 'NA';
        v_message_type Number := 0;
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            p_message_type := not_ok;
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        Select
            Count(*)
          Into v_exists
          From
            dm_offices
         Where
            office_code = p_office_code;

        If v_exists = 1 Then
            Update dm_offices
               Set
                office_name = Trim(upper(p_office_name)),
                office_desc = Trim(p_office_desc),
                office_location_code = Trim(p_office_location_code),
                smart_desk_booking_enabled = Trim(p_smart_desk_booking_enabled)
             Where
                office_code = p_office_code;

            Commit;
            p_message_type := ok;
            p_message_text := 'Office updated successfully.';
        Else
            p_message_type := not_ok;
            p_message_text := 'No matching Office exists !!!';
        End If;
    Exception
        When dup_val_on_index Then
            p_message_type := not_ok;
            p_message_text := 'Office already exists !!!';
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'ERR :- '
                              || sqlcode
                              || ' - '
                              || sqlerrm;
    End sp_update_dm_offices;

    Procedure sp_delete_dm_offices (
        p_person_id    Varchar2,
        p_meta_id      Varchar2,
        p_office_code  Varchar2,
        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        
        v_empno        Varchar2(5);
        v_exists      Number;
        v_user_tcp_ip  Varchar2(5) := 'NA';
        v_message_type Number := 0;
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            p_message_type := not_ok;
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        Select
            Count(*)
          Into v_exists
          From
            dm_offices
         Where
            office_code = p_office_code;

        If v_exists = 1 Then
            Delete From dm_offices
             Where
                office_code = p_office_code;

            Commit;
            p_message_type := ok;
            p_message_text := 'Record deleted successfully.';
        Else
            p_message_type := not_ok;
            p_message_text := 'No matching Office exists !!!';
        End If;

    Exception
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'ERR :- '
                              || sqlcode
                              || ' - '
                              || sqlerrm;
    End sp_delete_dm_offices;

End pkg_dms_offices; 