Create Or Replace Package Body "DMS"."PKG_DM_AREA_TYPE_USER_MAPPING" As

    Procedure sp_set_area_type_user_mapping (
        p_person_id    Varchar2,
        p_meta_id      Varchar2,
        p_key_id       Varchar2 Default Null,
        p_area_id      Varchar2,
        p_empno        Varchar2,
        p_office_code  Varchar2,
        p_start_date   Date,
        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_exists       Number;
        v_empno        Varchar2(5);
        v_keyid        Varchar2(5);
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
            dm_area_type_user_mapping
         Where
                empno = p_empno
               And office_code = p_office_code;

        If v_exists = 1 Then
            Insert Into dm_area_type_user_mapping_log (
                key_id,
                area_id,
                empno,
                from_date,
                office_code,
                modified_on,
                modified_by,
                status
            )
                (
                    Select
                        dbms_random.string(
                            'X',
                            5
                        ),
                        a.area_id,
                        a.empno,
                        a.from_date,
                        a.office_code,
                        sysdate,
                        v_empno,
                        'DELETE'
                      From
                        dm_area_type_user_mapping a
                     Where
                            a.empno = p_empno
                           And a.office_code = p_office_code
                );
            Delete From dm_area_type_user_mapping
             Where
                    empno = p_empno
                   And office_code = p_office_code;
            Commit;
        End If;


        v_keyid := dbms_random.string(
                                     'X',
                                     5
                   );
        Insert Into dm_area_type_user_mapping (
            key_id,
            area_id,
            empno,
            from_date,
            office_code,
            modified_on,
            modified_by
        ) Values (
            v_keyid,
            p_area_id,
            p_empno,
            p_start_date,
            p_office_code,
            sysdate,
            v_empno
        );

        Insert Into dm_area_type_user_mapping_log (
            key_id,
            area_id,
            empno,
            from_date,
            office_code,
            modified_on,
            modified_by,
            status
        ) Values (
            v_keyid,
            p_area_id,
            p_empno,
            p_start_date,
            p_office_code,
            sysdate,
            v_empno,
            'INSERT'
        );

        If ( Sql%rowcount > 0 ) Then
            Commit;
            p_message_type := ok;
            p_message_text := 'Procedure executed successfully.';
            Return;
        Else
            p_message_type := not_ok;
            p_message_text := 'Procedure not executed.';
        End If;

    Exception
        When dup_val_on_index Then
            p_message_type := not_ok;
            p_message_text := 'Employee area type mapping already exists !!!';
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'ERR :- '
                              || sqlcode
                              || ' - '
                              || sqlerrm;
    End sp_set_area_type_user_mapping;

    Procedure sp_delete_area_type_user_mapping (
        p_person_id    Varchar2,
        p_meta_id      Varchar2,
        p_key_id       Varchar2,
        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_empno        Varchar2(5);
        v_is_used      Number;
        v_exists       Number;
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
            dm_area_type_user_mapping
         Where
            key_id = p_key_id;

        If v_exists = 1 Then
            Insert Into dm_area_type_user_mapping_log (
                key_id,
                area_id,
                empno,
                from_date,
                office_code,
                modified_on,
                modified_by,
                status
            )
                (
                    Select
                        dbms_random.string(
                            'X',
                            5
                        ),
                        a.area_id,
                        a.empno,
                        a.from_date,
                        a.office_code,
                        sysdate,
                        v_empno,
                        'DELETE'
                      From
                        dm_area_type_user_mapping a
                     Where
                        a.key_id = p_key_id
                );

            Delete From dm_area_type_user_mapping
             Where
                key_id = p_key_id;

            If ( Sql%rowcount > 0 ) Then
                Commit;
                p_message_type := ok;
                p_message_text := 'Procedure executed successfully.';
                Return;
            Else
                p_message_type := not_ok;
                p_message_text := 'Procedure not executed.';
            End If;

        Else
            p_message_type := not_ok;
            p_message_text := 'No matching employee area type mapping exists !!!';
        End If;


    Exception
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'ERR :- '
                              || sqlcode
                              || ' - '
                              || sqlerrm;
    End sp_delete_area_type_user_mapping;

End pkg_dm_area_type_user_mapping;