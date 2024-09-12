Create Or Replace Package Body "TCMPL_HR"."PKG_DG_SITE_MASTER" As

    Procedure sp_add_dg_site_master (
        p_person_id     Varchar2,
        p_meta_id       Varchar2,
        p_site_name     Varchar2,
        p_site_location Varchar2,
        p_is_active     Number,
        p_message_type  Out Varchar2,
        p_message_text  Out Varchar2
    ) As
        v_exists       Number;
        v_empno        Varchar2(5);
        v_keyid        Varchar2(4);
        v_user_tcp_ip  Varchar2(5) := 'NA';
        v_message_type Number := 0;
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            p_message_type := not_ok;
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        v_keyid := dbms_random.string( 'X', 4 );
        Select
            Count(*)
          Into v_exists
          From
            dg_site_master
         Where
            Trim(upper(site_name)) = Trim(upper(p_site_name))
            and is_active = 1;

        If v_exists = 0 Then
            Insert Into dg_site_master (
                key_id,
                site_name,
                site_location,
                is_active,
                modified_by,
                modified_on
            ) Values (
                v_keyid,
                Trim(p_site_name),
                Trim(p_site_location),
                p_is_active,
                v_empno,
                sysdate
            );


            Commit;
            p_message_type := ok;
            p_message_text := 'Dg site master added successfully..';
        Else
            p_message_type := not_ok;
            p_message_text := 'Dg site master already exists !!!';
        End If;

    Exception
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'ERR :- '
                              || sqlcode
                              || ' - '
                              || sqlerrm;
    End sp_add_dg_site_master;


    Procedure sp_update_dg_site_master (
        p_person_id     Varchar2,
        p_meta_id       Varchar2,
        p_key_id        Varchar2,
        p_site_name     Varchar2,
        p_site_location Varchar2,
        p_is_active     Number,
        p_message_type  Out Varchar2,
        p_message_text  Out Varchar2
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
            dg_site_master
         Where
            key_id = p_key_id;

        If v_exists = 1 Then
            Update dg_site_master
               Set
                site_name = Trim(p_site_name),
                site_location = Trim(p_site_location),
                is_active = p_is_active,
                modified_by = v_empno,
                modified_on = sysdate
             Where
                key_id = p_key_id;

            Commit;
            p_message_type := ok;
            p_message_text := 'Dg site master updated successfully.';
        Else
            p_message_type := not_ok;
            p_message_text := 'No matching Dg site master exists !!!';
        End If;
    Exception
        When dup_val_on_index Then
            p_message_type := not_ok;
            p_message_text := 'Dg site master already exists !!!';
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'ERR :- '
                              || sqlcode
                              || ' - '
                              || sqlerrm;
    End sp_update_dg_site_master;
 
End pkg_dg_site_master; 