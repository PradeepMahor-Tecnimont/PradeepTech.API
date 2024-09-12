Create Or Replace Package Body "SELFSERVICE"."PKG_DB_AUTOBOOK_PREFERENCES" As

    Procedure sp_add_db_autobook_preferences (
        p_person_id    Varchar2,
        p_meta_id      Varchar2,
        p_office       Varchar2,
        p_shift        Varchar2,
        p_desk_area    Varchar2,
        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_exists       Number;
        v_empno        Varchar2(5);
        v_keyid        Varchar2(8);
        v_user_tcp_ip  Varchar2(5) := 'NA';
        v_message_type Number := 0;
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            p_message_type := not_ok;
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        v_keyid := dbms_random.string( 'X', 8 );
        Select
            Count(*)
          Into v_exists
          From
            db_autobook_preferences
         Where
            Trim(upper(empno)) = Trim(upper(v_empno));

        If v_exists = 0 Then
            Insert Into db_autobook_preferences (
                key_id,
                empno,
                office,
                shift,
                desk_area,
                modified_on,
                modified_by
            ) Values (
                v_keyid,
                Trim(v_empno),
                Trim(p_office),
                Trim(p_shift),
                Trim(p_desk_area),
                sysdate,
                Trim(v_empno)
            );

            Commit;
            p_message_type := ok;
            p_message_text := 'Autobook preferences added successfully..';
        Else
            p_message_type := not_ok;
            p_message_text := 'Autobook preferences already exists !!!';
        End If;

    Exception
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'ERR :- '
                              || sqlcode
                              || ' - '
                              || sqlerrm;
    End sp_add_db_autobook_preferences;


    Procedure sp_update_db_autobook_preferences (
        p_person_id    Varchar2,
        p_meta_id      Varchar2,
        p_key_id       Varchar2,
        p_office       Varchar2,
        p_shift        Varchar2,
        p_desk_area    Varchar2,
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
            db_autobook_preferences
         Where
             key_id = p_key_id
             and empno = v_empno;

        If v_exists = 1 Then
            Update db_autobook_preferences
               Set                
                office = Trim(p_office),
                shift = Trim(p_shift),
                desk_area = Trim(p_desk_area),
                modified_on = sysdate,
                modified_by = Trim(v_empno)
             Where
                key_id = p_key_id
                and empno = v_empno;

            Commit;
            p_message_type := ok;
            p_message_text := 'Autobook preferences updated successfully.';
        Else
            p_message_type := not_ok;
            p_message_text := 'No matching Autobook preferences exists !!!';
        End If;
    Exception
        When dup_val_on_index Then
            p_message_type := not_ok;
            p_message_text := 'Autobook preferences already exists !!!';
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'ERR :- '
                              || sqlcode
                              || ' - '
                              || sqlerrm;
    End sp_update_db_autobook_preferences;


    Procedure sp_delete_db_autobook_preferences (
        p_person_id    Varchar2,
        p_meta_id      Varchar2,
        p_key_id       Varchar2,
        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_empno        Varchar2(5);
        v_is_used      Number;

    Begin
        v_empno        := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            p_message_type := not_ok;
            p_message_text := 'Invalid employee number';
            Return;
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

        Delete From db_autobook_preferences
         Where
            key_id = p_key_id
             and empno = v_empno;

            If ( Sql%rowcount > 0 ) Then
                Commit;
                p_message_type := 'OK';
                p_message_text := 'Procedure executed successfully.';
            Else
                p_message_type := 'KO';
                p_message_text := 'Procedure not executed.';
            End If;
 
    Exception
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'ERR :- '
                              || sqlcode
                              || ' - '
                              || sqlerrm;
    End sp_delete_db_autobook_preferences;

End pkg_db_autobook_preferences;