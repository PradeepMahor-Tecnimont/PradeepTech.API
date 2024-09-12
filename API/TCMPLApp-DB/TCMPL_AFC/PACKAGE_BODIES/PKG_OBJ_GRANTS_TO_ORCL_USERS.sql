Create Or Replace Package Body tcmpl_afc.pkg_obj_grants_to_orcl_users As
    --grants select on orcl object to orcl user
    v_grant_statement Varchar2(2000)      := ' grant :grant on :object to :orcl_account';

    --grants execute on orcl object to orcl user
    tab_proc_grants   typ_tab_obj_account := typ_tab_obj_account(
        rec_obj_account('bg_select_list_qry', 'tcmpl_app_config'),
        rec_obj_account('lc_action', 'tcmpl_app_config'),
        rec_obj_account('lc_action_qry', 'tcmpl_app_config'),
        rec_obj_account('lc_common', 'tcmpl_app_config'),
        rec_obj_account('lc_email', 'tcmpl_app_config'),
        rec_obj_account('lc_masters', 'tcmpl_app_config'),
        rec_obj_account('lc_masters_qry', 'tcmpl_app_config'),
        rec_obj_account('lc_select_list_qry', 'tcmpl_app_config'),
        rec_obj_account('pkg_bg_acceptable_mast', 'tcmpl_app_config'),
        rec_obj_account('pkg_bg_acceptable_mast_qry', 'tcmpl_app_config'),
        rec_obj_account('pkg_bg_bank_mast', 'tcmpl_app_config'),
        rec_obj_account('pkg_bg_bank_mast_qry', 'tcmpl_app_config'),
        rec_obj_account('pkg_bg_common', 'tcmpl_app_config'),
        rec_obj_account('pkg_bg_company_mast', 'tcmpl_app_config'),
        rec_obj_account('pkg_bg_company_mast_qry', 'tcmpl_app_config'),
        rec_obj_account('pkg_bg_currency_mast', 'tcmpl_app_config'),
        rec_obj_account('pkg_bg_currency_mast_qry', 'tcmpl_app_config'),
        rec_obj_account('pkg_bg_guarantee_type_mast', 'tcmpl_app_config'),
        rec_obj_account('pkg_bg_guarantee_type_mast_qry', 'tcmpl_app_config'),
        rec_obj_account('pkg_bg_job_scheduler', 'tcmpl_app_config'),
        rec_obj_account('pkg_bg_main_amendment', 'tcmpl_app_config'),
        rec_obj_account('pkg_bg_main_amendment_qry', 'tcmpl_app_config'),
        rec_obj_account('pkg_bg_main_master', 'tcmpl_app_config'),
        rec_obj_account('pkg_bg_main_master_qry', 'tcmpl_app_config'),
        rec_obj_account('pkg_bg_main_status', 'tcmpl_app_config'),
        rec_obj_account('pkg_bg_main_status_qry', 'tcmpl_app_config'),
        rec_obj_account('pkg_bg_payable_mast', 'tcmpl_app_config'),
        rec_obj_account('pkg_bg_payable_mast_qry', 'tcmpl_app_config'),
        rec_obj_account('pkg_bg_ppc_mast', 'tcmpl_app_config'),
        rec_obj_account('pkg_bg_ppc_mast_qry', 'tcmpl_app_config'),
        rec_obj_account('pkg_bg_ppm_mast', 'tcmpl_app_config'),
        rec_obj_account('pkg_bg_ppm_mast_qry', 'tcmpl_app_config'),
        rec_obj_account('pkg_bg_project_mast', 'tcmpl_app_config'),
        rec_obj_account('pkg_bg_project_mast_qry', 'tcmpl_app_config'),
        rec_obj_account('pkg_bg_proj_contl_mast', 'tcmpl_app_config'),
        rec_obj_account('pkg_bg_proj_contl_mast_qry', 'tcmpl_app_config'),
        rec_obj_account('pkg_bg_proj_dir_mast', 'tcmpl_app_config'),
        rec_obj_account('pkg_bg_proj_dir_mast_qry', 'tcmpl_app_config'),
        rec_obj_account('pkg_bg_send_mail', 'tcmpl_app_config'),
        rec_obj_account('pkg_bg_vendor_mast', 'tcmpl_app_config'),
        rec_obj_account('pkg_bg_vendor_mast_qry', 'tcmpl_app_config'),
        rec_obj_account('pkg_bg_vendor_type_mast', 'tcmpl_app_config'),
        rec_obj_account('pkg_bg_vendor_type_mast_qry', 'tcmpl_app_config')
        );

    --grants select on orcl object to orcl user
    tab_select_grants typ_tab_obj_account;

    --grants update on orcl object to orcl user
    tab_update_grants typ_tab_obj_account;

    --grants delete on orcl object to orcl user
    tab_delete_grants typ_tab_obj_account;

    --grants insert on orcl object to orcl user
    tab_insert_grants typ_tab_obj_account;

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
                tcmpl_app_config.task_scheduler.sp_log_success(
                    'TCMPL_AFC.GRANT_' || p_grant_name,
                    v_statement
                );
            Else
                tcmpl_app_config.task_scheduler.sp_log_failure(
                    'TCMPL_AFC.GRANT_' || p_grant_name,
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
