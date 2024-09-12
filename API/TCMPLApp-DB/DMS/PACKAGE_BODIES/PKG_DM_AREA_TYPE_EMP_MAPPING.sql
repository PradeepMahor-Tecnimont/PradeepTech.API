Create Or Replace Package Body dms.pkg_dm_area_type_emp_mapping As

    Procedure sp_add_dm_area_type_emp_mapping(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,
        p_area_id          Varchar2,
        p_empno            Varchar2,
        p_desk_id          Varchar2,
        p_office_code      Varchar2,
        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_exists       Number;
        v_empno        Varchar2(5);
        v_keyid        Varchar2(5);
        v_user_tcp_ip  Varchar2(5) := 'NA';
        v_message_type Number      := 0;
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            p_message_type := not_ok;
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        v_keyid := dbms_random.string('X', 5);
        Select Count(*)
          Into v_exists
          From dm_area_type_user_desk_mapping
         Where  empno   = p_empno;

        If v_exists = 0 Then
            Insert Into dm_area_type_user_desk_mapping (
                key_id,
                area_id,
                empno,
                desk_id,
                office_code,
                modified_on,
                modified_by
            )
            Values (
                v_keyid,
                p_area_id,
                p_empno,
                p_desk_id,
                p_office_code,
                sysdate,
                v_empno
            );
            Commit;
            p_message_type := ok;
            p_message_text := 'Employee desk area type mapping added successfully..';
        Else
            p_message_type := not_ok;
            p_message_text := 'Employee desk area type mapping already exists !!!';
        End If;

    Exception
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
    End sp_add_dm_area_type_emp_mapping;

    Procedure sp_update_dm_area_type_emp_mapping(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,
        p_key_id           Varchar2,
        p_area_id          Varchar2,
        p_desk_id          Varchar2,
        p_empno            Varchar2,
        p_office_code      Varchar2,
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
            p_message_type := not_ok;
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        Select Count(*)
          Into v_exists
          From dm_area_type_user_desk_mapping
         Where key_id = p_key_id;

        If v_exists = 1 Then
            Update dm_area_type_user_desk_mapping
               Set area_id = p_area_id,
                   empno = p_empno,
                   desk_id = p_desk_id,
                   office_code = p_office_code,
                   modified_on = sysdate,
                   modified_by = v_empno
             Where key_id = p_key_id;

            Commit;
            p_message_type := ok;
            p_message_text := 'Employee desk area type mapping updated successfully.';
        Else
            p_message_type := not_ok;
            p_message_text := 'No matching employee desk area type mapping exists !!!';
        End If;
    Exception
        When dup_val_on_index Then
            p_message_type := not_ok;
            p_message_text := 'Employee desk area type mapping already exists !!!';
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
    End sp_update_dm_area_type_emp_mapping;

    Procedure sp_delete_dm_area_type_emp_mapping(
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

        Delete From dm_area_type_user_desk_mapping
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
    End sp_delete_dm_area_type_emp_mapping;

   Procedure sp_add_area_n_desk_emp_mapping (
        p_person_id    Varchar2,
        p_meta_id      Varchar2,
        p_area_id      Varchar2,
        p_empno        Varchar2,
        p_desk_id      Varchar2,
        p_office_code  Varchar2,
        p_start_date   Date Default sysdate,
        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As

        v_exists       Number;
        v_empno        Varchar2(5);
        v_Key_Id        Varchar2(5);
        v_user_tcp_ip  Varchar2(5) := 'NA';
        v_message_type Number := 0;
    Begin

           Begin
                  Select
                    Key_Id
                    Into v_Key_Id
                  From
                    dm_area_type_user_desk_mapping
                 Where
                    empno = p_empno;

           pkg_dm_area_type_emp_mapping.sp_delete_area_n_desk_emp_mapping (
               p_person_id => p_person_id,
               p_meta_id => p_meta_id,
               p_key_id => v_Key_Id,
               p_message_type => p_message_type,
               p_message_text => p_message_text
            );
            Exception
                When Others Then
                    Null;
        End;

        if p_office_code = 'MOC4' then
            pkg_dm_area_type_emp_mapping.sp_add_dm_area_type_emp_mapping
                    ( p_person_id => p_person_id,
                      p_meta_id => p_meta_id,
                      p_area_id => p_area_id,
                      p_empno => p_empno,
                      p_desk_id => p_desk_id,
                      p_office_code => p_office_code,
                      p_message_type => p_message_type,
                      p_message_text => p_message_text
                    );

            if (p_message_type = ok ) then

             Pkg_Dm_Area_Type_User_Mapping.Sp_Set_Area_Type_User_Mapping(
                    P_Person_Id => P_Person_Id,
                    P_Meta_Id => P_Meta_Id,
                    P_Key_Id => v_Key_Id,
                    P_Area_Id => P_Area_Id,
                    P_Empno => P_Empno,
                    P_Office_Code => P_Office_Code,
                    P_Start_Date => P_Start_Date,
                    P_Message_Type => P_Message_Type,
                    P_Message_Text => P_Message_Text
                  );
        end if;

            end if;

    Exception
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
    End sp_add_area_n_desk_emp_mapping;

     Procedure sp_delete_area_n_desk_emp_mapping (
        p_person_id    Varchar2,
        p_meta_id      Varchar2,
        p_key_id       Varchar2,
        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As

        v_exists       Number;
        v_empno        Varchar2(5);
        v_key_id       Varchar2(5);
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
            empno
          Into v_empno
          From
            dm_area_type_user_desk_mapping
         Where
            key_id = p_key_id;

        If ( v_empno Is Not Null ) Then
            Delete From dm_area_type_user_desk_mapping
             Where
                key_id = p_key_id;

            If ( Sql%rowcount > 0 ) Then
                Select
                    key_id
                  Into v_key_id
                  From
                    dm_area_type_user_mapping
                 Where
                    empno = v_empno;

                pkg_dm_area_type_user_mapping.sp_delete_area_type_user_mapping(p_person_id => p_person_id, p_meta_id => p_meta_id, p_key_id => v_key_id
                , p_message_type => p_message_type,
                                                                              p_message_text => p_message_text);

                If p_message_type = ok Then
                    Commit;
                    p_message_type := ok;
                    p_message_text := 'Procedure executed successfully.';
                Else
                    p_message_type := not_ok;
                    p_message_text := 'Procedure not executed.';
                End If;

            End If;

        Else
            p_message_type := not_ok;
            p_message_text := 'Procedure not executed.';
        End If;

    Exception
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
    End sp_delete_area_n_desk_emp_mapping;


End pkg_dm_area_type_emp_mapping;