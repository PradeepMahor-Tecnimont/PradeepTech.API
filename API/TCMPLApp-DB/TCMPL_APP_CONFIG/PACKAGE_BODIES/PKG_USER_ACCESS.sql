--------------------------------------------------------
--  DDL for Package Body PKG_USER_ACCESS
--------------------------------------------------------

Create Or Replace Package Body "TCMPL_APP_CONFIG"."PKG_USER_ACCESS" As

    Procedure sp_add_modules (
        p_person_id                 Varchar2,
        p_meta_id                   Varchar2,
        p_module_name               Varchar2,
        p_module_long_desc          Varchar2,
        p_is_active_char            Varchar2,
        p_module_schema_name        Varchar2,
        p_func_to_check_user_access Varchar2,
        p_module_short_desc         Varchar2,
        p_message_type              Out Varchar2,
        p_message_text              Out Varchar2
    ) As

        v_exists       Number;
        v_empno        Varchar2(5);
        v_module_id    Varchar2(3);
        v_user_tcp_ip  Varchar2(5) := 'NA';
        v_message_type Number := 0;
    Begin
        v_empno := app_users.get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            p_message_type := not_ok;
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        Select
            Count(*)
          Into v_exists
          From
            sec_modules
         Where
            module_name = Trim(upper(p_module_name));

        If v_exists = 0 Then
            Select
                'M' || to_char((substr(
                    module_id,
                    2,
                    3
                ) + 1))
              Into v_module_id
              From
                sec_modules
             Where
                Rownum <= 1
             Order By
                module_id Desc;

            Insert Into sec_modules (
                module_id,
                module_name,
                module_long_desc,
                module_is_active,
                module_schema_name,
                func_to_check_user_access,
                module_short_desc
            ) Values (
                v_module_id,
                Trim(upper(p_module_name)),
                p_module_long_desc,
                p_is_active_char,
                Trim(upper(p_module_schema_name)),
                p_func_to_check_user_access,
                p_module_short_desc
            );

            Commit;
            p_message_type := ok;
            p_message_text := 'Procedure executed successfully.';
        Else
            p_message_type := not_ok;
            p_message_text := 'Module name ready exists !!!';
        End If;

    Exception
        When dup_val_on_index Then
            p_message_type := not_ok;
            p_message_text := 'Record already exists !!!';
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'ERR :- '
                              || sqlcode
                              || ' - '
                              || sqlerrm;
    End sp_add_modules;

    Procedure sp_delete_modules (
        p_person_id    Varchar2,
        p_meta_id      Varchar2,
        p_module_id    Varchar2,
        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As

        v_empno        Varchar2(5);
        v_count        Number;
        v_user_tcp_ip  Varchar2(5) := 'NA';
        v_message_type Number := 0;
    Begin
        v_empno := app_users.get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            p_message_type := not_ok;
            p_message_text := 'Invalid employee number';
            Return;
        End If;
        /*

            Update
                    sec_modules
                Set
                    module_is_active = not_ok
                Where
                    module_id = p_module_id
                    And pkg_user_access_qry.func_is_delete_allowed('MODULE_ID', p_module_id) = 0;
        */

        Select
            Count(*)
          Into v_count
          From
            vu_module_user_role_actions a
         Where
            a.module_id = p_module_id;

        If ( v_count > 0 ) Then
            p_message_type := not_ok;
            p_message_text := 'module is in use should not be deleted.';
        End If;

        Delete From sec_modules
         Where
            module_id = p_module_id;

        Commit;
        p_message_type := ok;
        p_message_text := 'Procedure executed successfully.';
    Exception
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'ERR :- '
                              || sqlcode
                              || ' - '
                              || sqlerrm;
    End sp_delete_modules;

    Procedure sp_add_actions (
        p_person_id    Varchar2,
        p_meta_id      Varchar2,
        p_action_id    Varchar2 Default Null,
        p_action_name  Varchar2,
        p_action_desc  Varchar2,
        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As

        v_exists       Number;
        v_empno        Varchar2(5);
        v_action_id    Varchar2(4);
        v_user_tcp_ip  Varchar2(5) := 'NA';
        v_message_type Number := 0;
    Begin
        v_empno := app_users.get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            p_message_type := not_ok;
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        Select
            Count(*)
          Into v_exists
          From
            sec_actions_master
         Where
            action_name = Trim(upper(p_action_name));

        If v_exists = 0 Then
            v_action_id := p_action_id;
            If p_action_id Is Null Then
                Select
                    Case
                        When length(
                            to_char((substr(
                                action_id,
                                2,
                                5
                            ) + 1))
                        ) <= 1 Then
                            ( 'A00' || to_char((substr(
                                action_id,
                                2,
                                5
                            ) + 1)) )
                        When length(
                            to_char((substr(
                                action_id,
                                2,
                                5
                            ) + 1))
                        ) <= 2 Then
                            ( 'A0' || to_char((substr(
                                action_id,
                                2,
                                5
                            ) + 1)) )
                        Else
                            'A' || to_char((substr(
                                action_id,
                                2,
                                5
                            ) + 1))
                    End As val
                  Into v_action_id
                  From
                    sec_actions_master
                 Where
                    action_id Like 'A%'
                       And Rownum <= 1
                 Order By
                    action_id Desc;

            End If;

            Insert Into sec_actions_master (
                action_id,
                action_name,
                action_desc
            ) Values (
                v_action_id,
                p_action_name,
                p_action_desc
            );

            Commit;
            p_message_type := ok;
            p_message_text := 'Procedure executed successfully.';
        Else
            p_message_type := not_ok;
            p_message_text := 'action ready exists !!!';
        End If;

    Exception
        When dup_val_on_index Then
            p_message_type := not_ok;
            p_message_text := 'Record already exists !!!';
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'ERR :- '
                              || sqlcode
                              || ' - '
                              || sqlerrm;
    End sp_add_actions;

    Procedure sp_delete_actions (
        p_person_id    Varchar2,
        p_meta_id      Varchar2,
        p_action_id    Varchar2,
        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As

        v_empno        Varchar2(5);
        v_count        Number;
        v_user_tcp_ip  Varchar2(5) := 'NA';
        v_message_type Number := 0;
    Begin
        v_empno := app_users.get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            p_message_type := not_ok;
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        Select
            Count(*)
          Into v_count
          From
            sec_actions a
         Where
            a.action_id = p_action_id;

        If ( v_count > 0 ) Then
            p_message_type := not_ok;
            p_message_text := 'action is in use should not be deleted.';
        End If;

        Delete From sec_actions_master
         Where
            action_id = p_action_id;

        Commit;
        p_message_type := ok;
        p_message_text := 'Procedure executed successfully.';
    Exception
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'ERR :- '
                              || sqlcode
                              || ' - '
                              || sqlerrm;
    End sp_delete_actions;

    Procedure sp_add_roles (
        p_person_id      Varchar2,
        p_meta_id        Varchar2,
        p_role_id        Varchar2 Default Null,
        p_role_name      Varchar2,
        p_role_desc      Varchar2,
        p_is_active_char Varchar2,
        p_flag_id        Varchar2,
        p_message_type   Out Varchar2,
        p_message_text   Out Varchar2
    ) As

        v_exists       Number;
        v_empno        Varchar2(5);
        v_role_id      Varchar2(4);
        v_user_tcp_ip  Varchar2(5) := 'NA';
        v_message_type Number := 0;
    Begin
        v_empno := app_users.get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            p_message_type := not_ok;
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        Select
            Count(*)
          Into v_exists
          From
            sec_roles
         Where
            role_name = Trim(upper(p_role_name));

        If v_exists = 0 Then
            v_role_id := p_role_id;
            If p_role_id Is Null Then
                Select
                    Case
                        When length(
                            to_char((substr(
                                role_id,
                                2,
                                5
                            ) + 1))
                        ) <= 2 Then
                            ( 'R0' || to_char((substr(
                                role_id,
                                2,
                                5
                            ) + 1)) )
                        Else
                            'R' || to_char((substr(
                                role_id,
                                2,
                                5
                            ) + 1))
                    End As val
                  Into v_role_id
                  From
                    sec_roles
                 Where
                    Rownum <= 1
                 Order By
                    role_id Desc;

            End If;

            Insert Into sec_roles (
                role_id,
                role_name,
                role_desc,
                role_is_active,
                role_flag
            ) Values (
                v_role_id,
                p_role_name,
                p_role_desc,
                p_is_active_char,
                p_flag_id
            );

            Commit;
            p_message_type := ok;
            p_message_text := 'Procedure executed successfully.';
        Else
            p_message_type := not_ok;
            p_message_text := 'Role ready exists !!!';
        End If;

    Exception
        When dup_val_on_index Then
            p_message_type := not_ok;
            p_message_text := 'Record already exists !!!';
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'ERR :- '
                              || sqlcode
                              || ' - '
                              || sqlerrm;
    End sp_add_roles;

    Procedure sp_delete_roles (
        p_person_id    Varchar2,
        p_meta_id      Varchar2,
        p_role_id      Varchar2,
        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As

        v_empno        Varchar2(5);
        v_count        Number;
        v_user_tcp_ip  Varchar2(5) := 'NA';
        v_message_type Number := 0;
    Begin
        v_empno := app_users.get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            p_message_type := not_ok;
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        Select
            Count(*)
          Into v_count
          From
            vu_module_user_role_actions a
         Where
            a.role_id = p_role_id;

        If ( v_count > 0 ) Then
            p_message_type := not_ok;
            p_message_text := 'Role is in use should not be deleted.';
        End If;

        Delete From sec_roles
         Where
            role_id = p_role_id;

        Commit;
        p_message_type := ok;
        p_message_text := 'Procedure executed successfully.';
    Exception
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'ERR :- '
                              || sqlcode
                              || ' - '
                              || sqlerrm;
    End sp_delete_roles;

    Procedure sp_add_module_actions (
        p_person_id            Varchar2,
        p_meta_id              Varchar2,
        p_module_id            Varchar2,
        p_action_id            Varchar2,
        p_is_active_char       Varchar2,
        p_module_action_key_id Varchar2 Default Null,
        p_message_type         Out Varchar2,
        p_message_text         Out Varchar2
    ) As

        v_exists       Number;
        v_empno        Varchar2(5);
        v_user_tcp_ip  Varchar2(5) := 'NA';
        v_message_type Number := 0;
    Begin
        v_empno := app_users.get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            p_message_type := not_ok;
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        Select
            Count(*)
          Into v_exists
          From
            sec_actions
         Where
                module_id = p_module_id
               And action_id = p_action_id;

        If v_exists = 0 Then
            Insert Into sec_actions (
                module_id,
                action_id,
                action_is_active
            ) Values (
                p_module_id,
                p_action_id,
                p_is_active_char
            );

            Commit;
            p_message_type := ok;
            p_message_text := 'Procedure executed successfully.';
        Else
            p_message_type := not_ok;
            p_message_text := 'Action ready exists !!!';
        End If;

    Exception
        When dup_val_on_index Then
            p_message_type := not_ok;
            p_message_text := 'Record already exists !!!';
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'ERR :- '
                              || sqlcode
                              || ' - '
                              || sqlerrm;
    End sp_add_module_actions;

    Procedure sp_delete_module_actions (
        p_person_id    Varchar2,
        p_meta_id      Varchar2,
        p_module_id    Varchar2,
        p_action_id    Varchar2,
        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As

        v_empno        Varchar2(5);
        v_count        Number := 0;
        v_user_tcp_ip  Varchar2(5) := 'NA';
        v_message_type Number := 0;
    Begin
        v_empno := app_users.get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            p_message_type := not_ok;
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        Select
            Case Count(*)
                When 0 Then
                    0
                Else
                    1
            End As count
          Into v_count
          From
            sec_module_role_actions
         Where
                action_id = p_action_id
               And module_id = p_module_id;

        If v_count = 1 Then
            p_message_type := not_ok;
            p_message_text := 'Error : Record already in use. This record cannot be deleted';
            Return;
        End If;

        Delete From sec_actions
         Where
                action_id = p_action_id
               And module_id = p_module_id;

        If ( Sql%rowcount > 0 ) Then
            Commit;
            p_message_type := ok;
            p_message_text := 'Procedure executed successfully.';
        Else
            p_message_type := not_ok;
            p_message_text := 'Error : Procedure not executed';
            Rollback;
        End If;

    Exception
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'ERR :- '
                              || sqlcode
                              || ' - '
                              || sqlerrm;
    End sp_delete_module_actions;

    Procedure sp_add_module_roles (
        p_person_id    Varchar2,
        p_meta_id      Varchar2,
        p_module_id    Varchar2,
        p_role_id      Varchar2,
        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As

        v_exists       Number;
        v_empno        Varchar2(5);
        v_user_tcp_ip  Varchar2(5) := 'NA';
        v_message_type Number := 0;
    Begin
        v_empno := app_users.get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            p_message_type := not_ok;
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        Select
            Count(*)
          Into v_exists
          From
            sec_module_roles
         Where
                module_id = p_module_id
               And role_id = p_role_id;

        If v_exists = 0 Then
            Insert Into sec_module_roles (
                module_id,
                role_id
            ) Values (
                p_module_id,
                p_role_id
            );

            Commit;
            p_message_type := ok;
            p_message_text := 'Procedure executed successfully.';
        Else
            p_message_type := not_ok;
            p_message_text := 'Module roles ready exists !!!';
        End If;

    Exception
        When dup_val_on_index Then
            p_message_type := not_ok;
            p_message_text := 'Record already exists !!!';
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'ERR :- '
                              || sqlcode
                              || ' - '
                              || sqlerrm;
    End sp_add_module_roles;

    Procedure sp_delete_module_roles (
        p_person_id          Varchar2,
        p_meta_id            Varchar2,
        p_module_role_key_id Varchar2,
        p_message_type       Out Varchar2,
        p_message_text       Out Varchar2
    ) As

        v_empno        Varchar2(5);
        v_user_tcp_ip  Varchar2(5) := 'NA';
        v_message_type Number := 0;
    Begin
        v_empno := app_users.get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            p_message_type := not_ok;
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        Delete From sec_module_roles
         Where
            module_role_key_id = p_module_role_key_id;

        Commit;
        p_message_type := ok;
        p_message_text := 'Procedure executed successfully.';
    Exception
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'ERR :- '
                              || sqlcode
                              || ' - '
                              || sqlerrm;
    End sp_delete_module_roles;

    Procedure sp_add_module_roles_actions (
        p_person_id    Varchar2,
        p_meta_id      Varchar2,
        p_module_id    Varchar2,
        p_role_id      Varchar2,
        p_action_id    Varchar2,
        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As

        v_exists       Number;
        v_empno        Varchar2(5);
        v_user_tcp_ip  Varchar2(5) := 'NA';
        v_message_type Number := 0;
    Begin
        v_empno := app_users.get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            p_message_type := not_ok;
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        Select
            Count(*)
          Into v_exists
          From
            sec_module_role_actions
         Where
                module_id = p_module_id
               And role_id = p_role_id
               And action_id = p_action_id;

        If v_exists = 0 Then
            Insert Into sec_module_role_actions (
                module_id,
                role_id,
                action_id
            ) Values (
                p_module_id,
                p_role_id,
                p_action_id
            );

            Commit;
            p_message_type := ok;
            p_message_text := 'Procedure executed successfully.';
        Else
            p_message_type := not_ok;
            p_message_text := 'Item type ready exists !!!';
        End If;

    Exception
        When dup_val_on_index Then
            p_message_type := not_ok;
            p_message_text := 'Record already exists !!!';
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'ERR :- '
                              || sqlcode
                              || ' - '
                              || sqlerrm;
    End sp_add_module_roles_actions;

    Procedure sp_delete_module_roles_actions (
        p_person_id                 Varchar2,
        p_meta_id                   Varchar2,
        p_module_role_action_key_id Varchar2,
        p_module_role_key_id        Varchar2,
        p_message_type              Out Varchar2,
        p_message_text              Out Varchar2
    ) As

        v_empno        Varchar2(5);
        v_user_tcp_ip  Varchar2(5) := 'NA';
        v_message_type Number := 0;
    Begin
        v_empno := app_users.get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            p_message_type := not_ok;
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        Delete From sec_module_role_actions
         Where
                module_role_action_key_id = p_module_role_action_key_id
               And module_role_key_id = p_module_role_key_id;

        Commit;
        p_message_type := ok;
        p_message_text := 'Procedure executed successfully.';
    Exception
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'ERR :- '
                              || sqlcode
                              || ' - '
                              || sqlerrm;
    End sp_delete_module_roles_actions;

    Procedure sp_add_module_user_roles (
        p_person_id    Varchar2,
        p_meta_id      Varchar2,
        p_module_id    Varchar2,
        p_role_id      Varchar2,
        p_empno        Varchar2,
        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As

        v_exists       Number;
        v_empno        Varchar2(5);
        v_user_tcp_ip  Varchar2(5) := 'NA';
        v_message_type Number := 0;
        v_count  Number;
    Begin
        v_empno := app_users.get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            p_message_type := not_ok;
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        Select
            Count(*)
          Into v_count
          From
            vu_emplmast
         Where
            empno = p_empno;

        If v_count = 0 Then
            p_message_type := not_ok;
            p_message_text := 'Incorrect EMPNO.';
            Return;
        End If;
        
        Select
            Count(*)
          Into v_exists
          From
            sec_module_user_roles
         Where
                module_id = p_module_id
               And role_id = p_role_id
               And empno = p_empno;

        If v_exists = 0 Then
            Insert Into sec_module_user_roles (
                module_id,
                role_id,
                empno
            ) Values (
                p_module_id,
                p_role_id,
                p_empno
            );

            If ( Sql%rowcount > 0 ) Then
                Insert Into sec_module_user_roles_log (
                    key_id,
                    module_id,
                    role_id,
                    empno,
                    module_role_key_id,
                    modified_by,
                    modified_on
                ) Values (
                    dbms_random.string(
                        'X',
                        10
                    ),
                    upper(
                        Trim(p_module_id)
                    ),
                    upper(
                        Trim(p_role_id)
                    ),
                    upper(
                        Trim(p_empno)
                    ),
                    upper(
                        Trim(p_module_id)
                    ) || upper(
                        Trim(p_role_id)
                    ),
                    upper(
                        Trim(v_empno)
                    ),
                    sysdate
                );

                Commit;
                p_message_type := ok;
                p_message_text := 'Procedure executed successfully.';
                Return;
            End If;

            p_message_type := not_ok;
            p_message_text := 'Error : No record updated ';
        Else
            p_message_type := not_ok;
            p_message_text := 'Record ready exists !!!';
        End If;

    Exception
        When dup_val_on_index Then
            p_message_type := not_ok;
            p_message_text := 'Record already exists !!!';
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'ERR :- '
                              || sqlcode
                              || ' - '
                              || sqlerrm;
    End sp_add_module_user_roles;

    Procedure sp_delete_module_user_roles (
        p_person_id    Varchar2,
        p_meta_id      Varchar2,
        p_module_id    Varchar2,
        p_role_id      Varchar2,
        p_empno        Varchar2,
        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As

        v_empno        Varchar2(5);
        v_user_tcp_ip  Varchar2(5) := 'NA';
        v_message_type Number := 0;
    Begin
        v_empno := app_users.get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            p_message_type := not_ok;
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        Delete From sec_module_user_roles
         Where
                module_id = p_module_id
               And role_id = p_role_id
               And empno = p_empno;

        If ( Sql%rowcount > 0 ) Then
            Insert Into sec_module_user_roles_delete (
                key_id,
                module_id,
                role_id,
                empno,
                module_role_key_id,
                modified_by,
                modified_on
            ) Values (
                dbms_random.string(
                    'X',
                    10
                ),
                upper(
                    Trim(p_module_id)
                ),
                upper(
                    Trim(p_role_id)
                ),
                upper(
                    Trim(p_empno)
                ),
                upper(
                    Trim(p_module_id)
                ) || upper(
                    Trim(p_role_id)
                ),
                upper(
                    Trim(v_empno)
                ),
                sysdate
            );

            Commit;
            p_message_type := ok;
            p_message_text := 'Procedure executed successfully.';
            Return;
        End If;

        p_message_type := not_ok;
        p_message_text := 'Error : No record updated ';
    Exception
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'ERR :- '
                              || sqlcode
                              || ' - '
                              || sqlerrm;
    End sp_delete_module_user_roles;

    Procedure sp_add_mdl_user_role_actions (
        p_person_id    Varchar2,
        p_meta_id      Varchar2,
        p_module_id    Varchar2,
        p_role_id      Varchar2,
        p_action_id    Varchar2,
        p_empno        Varchar2,
        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As

        v_exists       Number;
        v_empno        Varchar2(5);
        v_user_tcp_ip  Varchar2(5) := 'NA';
        v_message_type Number := 0;
    Begin
        v_empno := app_users.get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            p_message_type := not_ok;
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        Select
            Count(*)
          Into v_exists
          From
            sec_module_users_roles_actions
         Where
                module_id = p_module_id
               And role_id = p_role_id
               And empno = p_empno
               And action_id = p_action_id;

        If v_exists = 0 Then
            Insert Into sec_module_users_roles_actions (
                module_id,
                empno,
                role_id,
                action_id
            ) Values (
                p_module_id,
                p_empno,
                p_role_id,
                p_action_id
            );

            Commit;
            p_message_type := ok;
            p_message_text := 'Procedure executed successfully.';
        Else
            p_message_type := not_ok;
            p_message_text := 'Record ready exists !!!';
        End If;

    Exception
        When dup_val_on_index Then
            p_message_type := not_ok;
            p_message_text := 'Record already exists !!!';
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'ERR :- '
                              || sqlcode
                              || ' - '
                              || sqlerrm;
    End sp_add_mdl_user_role_actions;

    Procedure sp_del_mdl_user_role_actions (
        p_person_id    Varchar2,
        p_meta_id      Varchar2,
        p_module_id    Varchar2,
        p_role_id      Varchar2,
        p_action_id    Varchar2,
        p_empno        Varchar2,
        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As

        v_empno        Varchar2(5);
        v_user_tcp_ip  Varchar2(5) := 'NA';
        v_message_type Number := 0;
    Begin
        v_empno := app_users.get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            p_message_type := not_ok;
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        Delete From sec_module_users_roles_actions
         Where
                module_id = p_module_id
               And role_id = p_role_id
               And empno = p_empno
               And action_id = p_action_id;

        Commit;
        p_message_type := ok;
        p_message_text := 'Procedure executed successfully.';
    Exception
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'ERR :- '
                              || sqlcode
                              || ' - '
                              || sqlerrm;
    End sp_del_mdl_user_role_actions;

    Procedure sp_add_delegate_log (
        p_person_id       Varchar2,
        p_meta_id         Varchar2,
        p_module_id       Varchar2,
        p_principal_empno Varchar2,
        p_on_behalf_empno Varchar2,
        p_log_status      Varchar2,
        p_message_type    Out Varchar2,
        p_message_text    Out Varchar2
    ) As

        v_exists       Number;
        v_empno        Varchar2(5);
        v_module_id    Varchar2(3);
        v_user_tcp_ip  Varchar2(5) := 'NA';
        v_message_type Number := 0;
    Begin
        v_empno := app_users.get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            p_message_type := not_ok;
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        Insert Into sec_module_delegate_log (
            key_id,
            module_id,
            principal_empno,
            on_behalf_empno,
            log_status,
            modified_by,
            modified_on
        ) Values (
            dbms_random.string(
                'X',
                10
            ),
            upper(
                Trim(p_module_id)
            ),
            upper(
                Trim(p_principal_empno)
            ),
            upper(
                Trim(p_on_behalf_empno)
            ),
            upper(
                Trim(p_log_status)
            ),
            upper(
                Trim(v_empno)
            ),
            sysdate
        );

        Commit;
        p_message_type := ok;
        p_message_text := 'Procedure executed successfully.';
    Exception
        When dup_val_on_index Then
            p_message_type := not_ok;
            p_message_text := 'Record already exists !!!';
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'ERR :- '
                              || sqlcode
                              || ' - '
                              || sqlerrm;
    End sp_add_delegate_log;

    Procedure sp_add_delegate (
        p_person_id       Varchar2,
        p_meta_id         Varchar2,
        p_module_id       Varchar2,
        p_principal_empno Varchar2,
        p_on_behalf_empno Varchar2,
        p_message_type    Out Varchar2,
        p_message_text    Out Varchar2
    ) As

        v_exists       Number;
        v_empno        Varchar2(5);
        v_module_id    Varchar2(3);
        v_user_tcp_ip  Varchar2(5) := 'NA';
        v_message_type Number := 0;
    Begin
        v_empno := app_users.get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            p_message_type := not_ok;
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        Insert Into sec_module_delegate (
            module_id,
            principal_empno,
            on_behalf_empno,
            modified_by,
            modified_on
        ) Values (
            upper(
                Trim(p_module_id)
            ),
            upper(
                Trim(p_principal_empno)
            ),
            upper(
                Trim(p_on_behalf_empno)
            ),
            upper(
                Trim(v_empno)
            ),
            sysdate
        );

        If ( Sql%rowcount > 0 ) Then
            pkg_user_access.sp_add_delegate_log(
                                               p_person_id => p_person_id,
                                               p_meta_id => p_meta_id,
                                               p_module_id => p_module_id,
                                               p_principal_empno => p_principal_empno,
                                               p_on_behalf_empno => p_on_behalf_empno,
                                               p_log_status => 'INSERT',
                                               p_message_type => p_message_type,
                                               p_message_text => p_message_text
            );

            p_message_type := ok;
            p_message_text := 'Procedure executed successfully.';
        Else
            p_message_type := not_ok;
            p_message_text := 'Error - Procedure not executed..';
        End If;

        Commit;
        p_message_type := ok;
        p_message_text := 'Procedure executed successfully.';
    Exception
        When dup_val_on_index Then
            p_message_type := not_ok;
            p_message_text := 'Duplicate record is not allowed.!!!';
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'ERR :- '
                              || sqlcode
                              || ' - '
                              || sqlerrm;
    End sp_add_delegate;

    Procedure sp_delete_delegate (
        p_person_id       Varchar2,
        p_meta_id         Varchar2,
        p_module_id       Varchar2,
        p_principal_empno Varchar2,
        p_on_behalf_empno Varchar2,
        p_message_type    Out Varchar2,
        p_message_text    Out Varchar2
    ) As

        v_empno        Varchar2(5);
        v_count        Number;
        v_user_tcp_ip  Varchar2(5) := 'NA';
        v_message_type Number := 0;
    Begin
        v_empno := app_users.get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            p_message_type := not_ok;
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        Delete From sec_module_delegate
         Where
                module_id = p_module_id
               And principal_empno = p_principal_empno
               And on_behalf_empno = p_on_behalf_empno;

        If ( Sql%rowcount > 0 ) Then
            pkg_user_access.sp_add_delegate_log(
                                               p_person_id => p_person_id,
                                               p_meta_id => p_meta_id,
                                               p_module_id => p_module_id,
                                               p_principal_empno => p_principal_empno,
                                               p_on_behalf_empno => p_on_behalf_empno,
                                               p_log_status => 'DELETE',
                                               p_message_type => p_message_type,
                                               p_message_text => p_message_text
            );

            p_message_type := ok;
            p_message_text := 'Procedure executed successfully.';
        Else
            p_message_type := not_ok;
            p_message_text := 'Error - Procedure not executed..';
        End If;

        Commit;
    Exception
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'ERR :- '
                              || sqlcode
                              || ' - '
                              || sqlerrm;
    End sp_delete_delegate;

    Procedure sp_add_module_user_role_costcode (
        p_person_id    Varchar2,
        p_meta_id      Varchar2,
        p_module_id    Varchar2,
        p_empno        Varchar2,
        p_parent       Varchar2,
        p_role_id      Varchar2,
        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As

        v_exists       Number;
        v_empno        Varchar2(5);
        v_module_id    Varchar2(3);
        v_user_tcp_ip  Varchar2(5) := 'NA';
        v_message_type Number := 0;
    Begin
        v_empno := app_users.get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            p_message_type := not_ok;
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        Select
            Count(*)
          Into v_exists
          From
            sec_module_user_roles_costcode
         Where
                module_id = p_module_id
               And empno = p_empno
               And costcode = p_parent
               And role_id = p_role_id;

        If v_exists = 0 Then
            Insert Into sec_module_user_roles_costcode (
                module_id,
                empno,
                costcode,
                role_id
            ) Values (
                p_module_id,
                p_empno,
                p_parent,
                p_role_id
            );

            If ( Sql%rowcount > 0 ) Then
                Commit;
                p_message_type := ok;
                p_message_text := 'Procedure executed successfully.';
            Else
                p_message_type := not_ok;
                p_message_text := 'Error - Record not inserted..';
            End If;

        Else
            p_message_type := not_ok;
            p_message_text := 'Record ready exists !!!';
        End If;

    Exception
        When dup_val_on_index Then
            p_message_type := not_ok;
            p_message_text := 'Record already exists !!!';
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'ERR :- '
                              || sqlcode
                              || ' - '
                              || sqlerrm;
    End sp_add_module_user_role_costcode;

    Procedure sp_delete_module_user_role_costcode (
        p_person_id    Varchar2,
        p_meta_id      Varchar2,
        p_module_id    Varchar2,
        p_empno        Varchar2,
        p_parent       Varchar2,
        p_role_id      Varchar2,
        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As

        v_empno        Varchar2(5);
        v_exists       Number;
        v_user_tcp_ip  Varchar2(5) := 'NA';
        v_message_type Number := 0;
    Begin
        v_empno := app_users.get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            p_message_type := not_ok;
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        Select
            Count(*)
          Into v_exists
          From
            sec_module_user_roles_costcode
         Where
                module_id = p_module_id
               And empno = p_empno
               And costcode = p_parent
               And role_id = p_role_id;

        If v_exists = 0 Then
            p_message_type := not_ok;
            p_message_text := 'Record not exists !!!';
            Return;
        End If;

        Delete From sec_module_user_roles_costcode
         Where
                module_id = p_module_id
               And empno = p_empno
               And costcode = p_parent
               And role_id = p_role_id;

        If ( Sql%rowcount > 0 ) Then
            Commit;
            p_message_type := ok;
            p_message_text := 'Procedure executed successfully.';
        Else
            p_message_type := not_ok;
            p_message_text := 'Error - Record not inserted..';
        End If;

    Exception
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'ERR :- '
                              || sqlcode
                              || ' - '
                              || sqlerrm;
    End sp_delete_module_user_role_costcode;

    Procedure sp_add_user_roles_booking (
        p_person_id    Varchar2,
        p_meta_id      Varchar2,
        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As

        v_exists       Number;
        v_user_tcp_ip  Varchar2(5) := 'NA';
        v_message_type Number := 0;
        v_module_id    Varchar2(5) := 'M20';
        v_role_id      Varchar2(5) := 'R103';
        v_module_role  Varchar2(7) := 'M20R103';
        v_empno        Varchar2(5);
    Begin
        v_empno := app_users.get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            p_message_type := not_ok;
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        Commit;
        Delete From sec_module_user_roles
         Where
                module_id = v_module_id
               And role_id = v_role_id
               And module_role_key_id = v_module_role;

        Insert Into sec_module_user_roles
            ( Select
                  v_module_id,
                  v_role_id,
                  empno,
                  '',
                  v_module_role
                From
                  ( With emp_office_by_hr As ( Select
                                                                                    vu_emplmast.empno                        As
                                                                                    empno,
                                                                                    tcmpl_hr.pkg_common.fn_get_office_location_desc
                                                                                    (
                                                                                        tcmpl_hr.pkg_common.fn_get_emp_office_location
                                                                                        (
                                                                                            vu_emplmast.empno,
                                                                                            sysdate
                                                                                        )
                                                                                    )                                        As
                                                                                    office_location,
                                                                                    Case
                                                                                        When db_map_emp_location.office_location_code
                                                                                        Is Null Then
                                                                                            tcmpl_hr.pkg_common.fn_get_emp_office_location
                                                                                            (
                                                                                                vu_emplmast.empno,
                                                                                                sysdate
                                                                                            )
                                                                                        Else
                                                                                            db_map_emp_location.office_location_code
                                                                                    End                                      As
                                                                                    office_location_code,
                                                                                    db_map_emp_location.office_location_code As
                                                                                    emp_map_location_code
                                                                                  From
                                                                                    vu_emplmast
                                                                                      Left Outer Join desk_book.db_map_emp_location
                                                                                      db_map_emp_location On vu_emplmast.empno = db_map_emp_location.empno
                                                    Where
                                                       vu_emplmast.status = 1
                      )
                      Select
                          vu_emplmast.empno,
                          vu_emplmast.name,
                          emp_office_by_hr.office_location,
                          emp_office_by_hr.office_location_code
                        From
                               vu_emplmast
                           Inner Join emp_office_by_hr On vu_emplmast.empno = emp_office_by_hr.empno
                     Where
                            vu_emplmast.status = 1
                           And vu_emplmast.empno Not In ( Select
                                                                                          empno
                                                                                        From
                                                                                          sec_module_user_roles
                                                        Where
                                                               role_id = 'R103'
                                                              And module_id = 'M20'
                                                        )
                           And emp_office_by_hr.office_location_code In ( Select
                                                                                                                          office_location_code
                                                                                                                        From
                                                                                                                          dms.dm_offices
                                                                        Where
                                                                           smart_desk_booking_enabled = ok
                                                                        )
                  )
            );

        Commit;
        If ( Sql%rowcount = 0 ) Then
            p_message_type := ok;
            p_message_text := 'Procedure executed successfully. All data uptodate';
            Return;
        Else
            p_message_type := not_ok;
            p_message_text := 'Error - Procedure not executed..';
        End If;

/*
    Insert Into sec_module_user_roles_log
            (
                Select
                    dbms_random.string(
                        'X',
                        10
                    ),
                    v_module_id,
                    v_role_id,
                    empno,
                    v_module_role,
                    v_empno,
                    sysdate
                  From
                    (
                        With emp_office_by_hr As (
                            Select
                                vu_emplmast.empno                        As empno,
                                tcmpl_hr.pkg_common.fn_get_office_location_desc(
                                    tcmpl_hr.pkg_common.fn_get_emp_office_location(
                                        vu_emplmast.empno,
                                        sysdate
                                    )
                                )                                        As office_location,
                                Case
                                    When db_map_emp_location.office_location_code Is Null Then
                                        tcmpl_hr.pkg_common.fn_get_emp_office_location(
                                            vu_emplmast.empno,
                                            sysdate
                                        )
                                    Else
                                        db_map_emp_location.office_location_code
                                End                                      As office_location_code,
                                db_map_emp_location.office_location_code As emp_map_location_code
                              From
                                vu_emplmast
                                  Left Outer Join desk_book.db_map_emp_location db_map_emp_location
                                On vu_emplmast.empno = db_map_emp_location.empno
                             Where
                                vu_emplmast.status = 1
                        )
                        Select
                            vu_emplmast.empno,
                            vu_emplmast.name,
                            emp_office_by_hr.office_location,
                            emp_office_by_hr.office_location_code
                          From
                                 vu_emplmast
                             Inner Join emp_office_by_hr
                            On vu_emplmast.empno = emp_office_by_hr.empno
                         Where
                                vu_emplmast.status = 1
                               And vu_emplmast.empno In (
                                Select
                                    empno
                                  From
                                    sec_module_user_roles
                                 Where
                                        role_id = 'R103'
                                       And module_id = 'M20'
                            )
                               And emp_office_by_hr.office_location_code In (
                                Select
                                    office_location_code
                                  From
                                    dms.dm_offices
                                 Where
                                    smart_desk_booking_enabled = ok
                            )
                    )
            );
*/



        p_message_type := ok;
        p_message_text := 'Procedure executed successfully.';
    Exception
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'ERR :- '
                              || sqlcode
                              || ' - '
                              || sqlerrm;
    End sp_add_user_roles_booking;

    Procedure sp_import_module_user_roles_json (
        p_person_id                   Varchar2,
        p_meta_id                     Varchar2,
        p_module_id                   Varchar2,
        p_role_id                     Varchar2,
        p_module_user_roles_bulk_json Blob,
        p_empno_errors                Out Sys_Refcursor,
        p_message_type                Out Varchar2,
        p_message_text                Out Varchar2
    ) As
        v_empno          Varchar2(5);
        v_err_num        Number;
        v_is_empno_valid Number;
        v_invalid_msg    Varchar2(9000);
        v_section        Varchar2(2000);
        v_xl_row_number  Number := 0;
        is_error_in_row  Boolean;
        Cursor cur_json Is
        Select
            jt.*
          From
                Json_Table ( p_module_user_roles_bulk_json Format Json, '$[*]'
                    Columns (
                        empno Varchar2 ( 5 ) Path '$.Empno'
                    )
                )
            As jt;
    Begin
        v_err_num := 0;
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            p_message_type := 'KO';
            p_message_text := 'Invalid employee number';
            Return;
        End If;
        For c1 In cur_json Loop
            Begin
                is_error_in_row := False;
                v_xl_row_number := v_xl_row_number
                                   + 1;
                Select
                    Count(*)
                  Into v_is_empno_valid
                  From
                    sec_module_user_roles
                 Where
                        module_id = p_module_id
                       And role_id = p_role_id
                       And empno = c1.empno;

                If v_is_empno_valid = 0 Then
                     
                    sp_add_module_user_roles(
                                            p_person_id => p_person_id,
                                            p_meta_id => p_meta_id,
                                            p_empno => c1.empno,
                                            p_module_id => p_module_id,
                                            p_role_id => p_role_id,
                                            p_message_type => p_message_type,
                                            p_message_text => p_message_text
                    );
                Else
                    p_message_type := not_ok;
                    p_message_text := 'Employee Already Insert';
                End If;

                If p_message_type = not_ok Then
                    v_err_num := v_err_num
                                 + 1;
                    is_error_in_row := True;
                    pkg_process_excel_import_errors.sp_insert_errors(
                                                                    p_person_id => p_person_id,
                                                                    p_meta_id => p_meta_id,
                                                                    p_id => v_err_num,
                                                                    p_section => '',
                                                                    p_excel_row_number => v_xl_row_number,
                                                                    p_field_name => 'Empno : ' || c1.empno,
                                                                    p_error_type => 1,
                                                                    p_error_type_string => 'Warning',
                                                                    p_message => 'Error message : ' || p_message_text,
                                                                    p_message_type => p_message_type,
                                                                    p_message_text => p_message_text
                    );
                Else
                    is_error_in_row := False;
                    pkg_process_excel_import_errors.sp_insert_errors(
                                                                    p_person_id => p_person_id,
                                                                    p_meta_id => p_meta_id,
                                                                    p_id => v_err_num,
                                                                    p_section => '',
                                                                    p_excel_row_number => v_xl_row_number,
                                                                    p_field_name => 'Empno : ' || c1.empno,
                                                                    p_error_type => 2,
                                                                    p_error_type_string => 'Success',
                                                                    p_message => 'Success.',
                                                                    p_message_type => p_message_type,
                                                                    p_message_text => p_message_text
                    );
                End If;

            Exception
                When Others Then
                    p_message_type := 'KO';
                    p_message_text := 'ERR :- '
                                      || sqlcode
                                      || ' - '
                                      || sqlerrm;
            End;
        End Loop;
        p_empno_errors := pkg_process_excel_import_errors.fn_read_error_list(
                                                                            p_person_id => p_person_id,
                                                                            p_meta_id => p_meta_id
                          );
        Commit;
        If ( v_err_num = 0 ) Then
            p_message_type := 'OK';
            p_message_text := 'Procedure executed successfully.';
        Else
            p_message_type := 'KO';
            p_message_text := 'Procedure executed successfully.';
        End If;
    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'ERR :- '
                              || sqlcode
                              || ' - '
                              || sqlerrm;
    End sp_import_module_user_roles_json;
End pkg_user_access;