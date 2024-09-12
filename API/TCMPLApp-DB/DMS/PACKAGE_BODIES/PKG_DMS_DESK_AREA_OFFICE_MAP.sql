Create Or Replace Package Body "DMS"."PKG_DMS_DESK_AREA_OFFICE_MAP" As

    Procedure sp_add_dm_desk_area_office_map (
        p_person_id    Varchar2,
        p_meta_id      Varchar2,
        p_area_id      Varchar2,
        p_office_code  Varchar2,
        p_message_type Out Varchar2,
        p_message_text Out Varchar2
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
            dm_desk_area_office_map
         Where
                office_code = p_office_code And
            area_id     = p_area_id;

        If v_exists = 0 Then
            Insert Into dm_desk_area_office_map (
                area_id,
                office_code
            ) Values (
                Trim(p_area_id),
                Trim(p_office_code)
            );


            Commit;
            p_message_type := ok;
            p_message_text := 'Area office map added successfully..';
        Else
            p_message_type := not_ok;
            p_message_text := 'Area office map already exists !!!';
        End If;

    Exception
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'ERR :- '
                              || sqlcode
                              || ' - '
                              || sqlerrm;
    End sp_add_dm_desk_area_office_map;

    Procedure sp_delete_dm_desk_area_office_map (
        p_person_id    Varchar2,
        p_meta_id      Varchar2,
        p_area_id      Varchar2,
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
            dm_desk_area_office_map
         Where
                office_code = p_office_code And
            area_id     = p_area_id;

        If v_exists = 1 Then
        
            Delete From dm_desk_area_office_map
             Where
                office_code = p_office_code And
                area_id     = p_area_id;
            Commit;
            p_message_type := ok;
            p_message_text := 'Record deleted successfully.';
        Else
            p_message_type := not_ok;
            p_message_text := 'No matching Area office map exists !!!';
        End If;
        
                       /* Select
                            Count(*)
                        Into
                            v_is_used
                        From
                            tblName
                        Where
                            keyId = p_keyId;

                        If v_is_used > 0 Then
                            p_message_type := not_ok;
                            p_message_text := 'Record cannot be delete, this record already used !!!';
                            Return;
                        End If;
                        */


    Exception
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'ERR :- '
                              || sqlcode
                              || ' - '
                              || sqlerrm;
    End sp_delete_dm_desk_area_office_map;

End pkg_dms_desk_area_office_map;