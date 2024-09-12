Create Or Replace Package Body tcmpl_app_config.pkg_obj_grants_to_orcl_users As
    v_grant_statement Varchar2(2000)      := ' grant :grant on :object to :orcl_account';

    --grants execute on orcl object to orcl user
    tab_proc_grants   typ_tab_obj_account := typ_tab_obj_account(
            rec_obj_account('pkg_obj_grants_to_orcl_users', 'tcmpl_deploy'),
            rec_obj_account('task_scheduler', 'tcmpl_afc'),
            rec_obj_account('task_scheduler', 'tcmpl_hr'),
            rec_obj_account('task_scheduler', 'dms'),
            rec_obj_account('task_scheduler', 'selfservice'),
            rec_obj_account('task_scheduler', 'timecurr'),
            rec_obj_account('task_scheduler', 'commonmasters'),
            rec_obj_account('task_scheduler', 'desk_book'),
            rec_obj_account('pkg_generate_user_access', 'tcmpl_hr'),
            rec_obj_account('pkg_process_excel_import_errors', 'desk_book'),
            rec_obj_account('pkg_app_user_master_qry', 'tcmpl_app_config'),
            rec_obj_account('pkg_app_user_master', 'tcmpl_app_config')
        );

    --grants select on orcl object to orcl user
    tab_select_grants typ_tab_obj_account := typ_tab_obj_account(
            rec_obj_account('sec_actions', 'tcmpl_hr'),
            rec_obj_account('sec_module_role_actions', 'desk_book'),
            rec_obj_account('sec_module_users_roles_actions', 'desk_book'),
            rec_obj_account('sec_module_user_roles', 'dms'),
            rec_obj_account('sec_module_role_actions', 'dms')
        );

    --grants update on orcl object to orcl user
    tab_update_grants typ_tab_obj_account;

    --grants delete on orcl object to orcl user
    tab_delete_grants typ_tab_obj_account:= typ_tab_obj_account(
            rec_obj_account('sec_module_users_roles_actions', 'desk_book')
        );

    --grants insert on orcl object to orcl user
    tab_insert_grants typ_tab_obj_account := typ_tab_obj_account(
            rec_obj_account('sec_module_users_roles_actions', 'desk_book')
        );
    Procedure execute_grants(
        p_grant_name    Varchar2,
        p_tab_obj_accnt typ_tab_obj_account
    ) As
        v_exception Varchar2(1000);
        v_statement Varchar2(1000);
    Begin
        If p_tab_obj_accnt Is Null Then
            Return;
        End If;
        For i In 1..p_tab_obj_accnt.count
        Loop
            v_exception := Null;
            Begin
                v_statement := v_grant_statement;
                v_statement := replace(v_statement, ':grant', p_grant_name);
                v_statement := replace(v_statement, ':object', p_tab_obj_accnt(i).orcl_object);
                v_statement := replace(v_statement, ':orcl_account', p_tab_obj_accnt(i).orcl_account);

                Execute Immediate v_statement;
            Exception
                When Others Then
                    v_exception := 'Err : ' || sqlcode || ' - ' || sqlerrm || ' - ';
            End;
            If v_exception Is Null Then
                task_scheduler.sp_log_success(
                    'TCMPL_AFC_CONFIG.GRANT_' || p_grant_name,
                    v_statement
                );
            Else
                task_scheduler.sp_log_failure(
                    'TCMPL_AFC_CONFIG.GRANT_' || p_grant_name,
                    v_statement,
                    v_exception
                );
            End If;
        End Loop;
    End;

    Procedure execute_grants As
    Begin

        execute_grants(
            p_grant_name    => 'EXECUTE',
            p_tab_obj_accnt => tab_proc_grants
        );

        execute_grants(
            p_grant_name    => 'SELECT',
            p_tab_obj_accnt => tab_select_grants
        );

        execute_grants(
            p_grant_name    => 'INSERT',
            p_tab_obj_accnt => tab_insert_grants
        );

        execute_grants(
            p_grant_name    => 'UPDATE',
            p_tab_obj_accnt => tab_update_grants
        );

        execute_grants(
            p_grant_name    => 'DELETE',
            p_tab_obj_accnt => tab_delete_grants
        );

    End;

End;