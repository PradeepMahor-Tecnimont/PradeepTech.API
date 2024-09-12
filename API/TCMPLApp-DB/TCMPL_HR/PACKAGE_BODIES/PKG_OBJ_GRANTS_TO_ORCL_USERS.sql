Create Or Replace Package Body tcmpl_hr.pkg_obj_grants_to_orcl_users As

    --grants select on orcl object to orcl user
    v_grant_statement Varchar2(2000)      := ' grant :grant on :object to :orcl_account';

    --grants execute on orcl object to orcl user
    tab_proc_grants   typ_tab_obj_account := typ_tab_obj_account(
            rec_obj_account('pkg_icard_photo_consent_qry', 'tcmpl_app_config'),
            rec_obj_account('pkg_icard_photo_consent', 'tcmpl_app_config'),
            rec_obj_account('pkg_base_common', 'tcmpl_app_config'),
            rec_obj_account('pkg_ofb_init_qry', 'tcmpl_app_config'),
            rec_obj_account('pkg_ofb_init', 'tcmpl_app_config'),
            rec_obj_account('pkg_ofb_rollback', 'tcmpl_app_config'),
            rec_obj_account('pkg_ofb_rollback_qry', 'tcmpl_app_config'),
            rec_obj_account('pkg_ofb_exits_print_qry', 'tcmpl_app_config'),
            rec_obj_account('PKG_OFB_APPROVAL', 'tcmpl_app_config'),
            rec_obj_account('PKG_OFB_APPROVAL_LIST', 'tcmpl_app_config'),
            rec_obj_account('PKG_OFB_HISTORICAL_LIST', 'tcmpl_app_config'),
            rec_obj_account('mis_resigned_employees', 'tcmpl_app_config'),
            rec_obj_account('PKG_COMMON', 'SELFSERVICE'),
            rec_obj_account('task_scheduler', 'tcmpl_app_config'),
            rec_obj_account('pkg_dg_mid_evaluation_qry', 'tcmpl_app_config'),
            rec_obj_account('pkg_dg_mid_evaluation', 'tcmpl_app_config'),
            rec_obj_account('pkg_vpp_config_qry', 'tcmpl_app_config'),
            rec_obj_account('pkg_vpp_config', 'tcmpl_app_config'),
            rec_obj_account('pkg_dg_mid_transfer_costcode_approvals', 'tcmpl_app_config'),
            rec_obj_account('pkg_dg_mid_transfer_costcode_qry', 'tcmpl_app_config'),
            rec_obj_account('pkg_dg_site_master_qry', 'tcmpl_app_config'),
            rec_obj_account('pkg_dg_site_master', 'tcmpl_app_config'),
            rec_obj_account('pkg_dg_select_qry', 'tcmpl_app_config'),
            rec_obj_account('pkg_dg_mid_transfer_costcode', 'tcmpl_app_config'),
            rec_obj_account('pkg_relatives_as_colleagues_qry', 'tcmpl_app_config'),
            rec_obj_account('pkg_relatives_as_colleagues', 'tcmpl_app_config'),
            rec_obj_account('pkg_emp_loa_addendum_acceptance_qry', 'tcmpl_app_config'),
            rec_obj_account('pkg_emp_loa_addendum_acceptance', 'tcmpl_app_config'),
            rec_obj_account('pkg_dg_transfer_costcode_job_scheduler', 'tcmpl_app_config'),
            rec_obj_account('pkg_dg_annu_evaluation_qry', 'tcmpl_app_config'),
            rec_obj_account('pkg_dg_annu_evaluation', 'tcmpl_app_config'),
            rec_obj_account('pkg_dg_transfer_costcode_job_scheduler', 'tcmpl_app_config'),
            rec_obj_account('pkg_employment_of_relatives', 'tcmpl_app_config'),
            rec_obj_account('PKG_COMMON', 'desk_book'),
            rec_obj_account('pkg_regions', 'tcmpl_app_config'),
            rec_obj_account('pkg_regions_qry', 'tcmpl_app_config'),
            rec_obj_account('pkg_region_holidays_qry', 'tcmpl_app_config'),
            rec_obj_account('pkg_region_holidays', 'tcmpl_app_config'),
            rec_obj_account('pkg_relatives_as_colleagues_send_email', 'tcmpl_app_config'),
            rec_obj_account('pkg_process_excel_import_errors', 'tcmpl_app_config'),
            rec_obj_account('eo_employee_office', 'tcmpl_app_config')

        );

    --grants select on orcl object to orcl user
    tab_select_grants typ_tab_obj_account := typ_tab_obj_account(
            rec_obj_account('ofb_emp_exits', 'tcmpl_app_config'),
            rec_obj_account('ofb_emp_exits', 'selfservice'),
            rec_obj_account('mis_mast_office_location', 'dms'),
            rec_obj_account('hd_region_office_loc_map', 'SELFSERVICE'),
            rec_obj_account('hd_region_holidays', 'SELFSERVICE')
            
        );

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
                    'TCMPL_HR.GRANT_' || p_grant_name,
                    v_statement
                );
            Else
                tcmpl_app_config.task_scheduler.sp_log_failure(
                    'TCMPL_HR.GRANT_' || p_grant_name,
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
/
Exec pkg_obj_grants_to_orcl_users.execute_grants;