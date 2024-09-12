Create Or Replace Package Body desk_book.pkg_db_emp_location_mapping As

    Procedure sp_add_emp_location_map(
        p_person_id            Varchar2,
        p_meta_id              Varchar2,
        p_empno                Varchar2,
        p_office_location_code Varchar2,
        p_message_type Out     Varchar2,
        p_message_text Out     Varchar2
    ) As
        v_exists       Number;
        v_empno        Varchar2(5);
        v_keyid        Varchar2(8);
        v_user_tcp_ip  Varchar2(5) := 'NA';
        v_message_type Number      := 0;
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            p_message_type := not_ok;
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        v_keyid := dbms_random.string('X', 8);
        Select Count(*)
          Into v_exists
          From db_map_emp_location
         Where empno = p_empno;

        If v_exists = 0 Then
            Insert Into db_map_emp_location (
                key_id,
                empno,
                office_location_code,
                modified_by,
                modified_on
            )
            Values (
                v_keyid,
                p_empno,
                p_office_location_code,
                v_empno,
                sysdate
            );
            Commit;
            p_message_type := ok;
            p_message_text := 'Employee location mapping added successfully..';
        Else
            p_message_type := not_ok;
            p_message_text := 'Employee location mapping already exists !!!';
        End If;

    Exception
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
    End sp_add_emp_location_map;

    Procedure sp_delete_emp_location_map(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,
        p_key_id           Varchar2,
        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_empno        Varchar2(5);
        v_is_used      Number;
        v_user_tcp_ip  Varchar2(5) := 'NA';
        v_message_type Number      := 0;
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            p_message_type := not_ok;
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        Delete From db_map_emp_location
         Where key_id = p_key_id;

        If (Sql%rowcount > 0) Then
            Commit;
            p_message_type := ok;
            p_message_text := 'Procedure executed successfully.';
        Else
            p_message_type := not_ok;
            p_message_text := 'Procedure not executed.';
        End If;
    Exception
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
    End sp_delete_emp_location_map;

End pkg_db_emp_location_mapping;
/

  Grant Execute On desk_book.pkg_db_emp_location_mapping To tcmpl_app_config;