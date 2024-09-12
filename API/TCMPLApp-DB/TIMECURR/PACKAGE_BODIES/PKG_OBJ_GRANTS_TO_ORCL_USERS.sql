Create Or Replace Package Body timecurr.pkg_obj_grants_to_orcl_users As

     --grants select on orcl object to orcl user
    v_grant_statement Varchar2(2000)      := ' grant :grant on :object to :orcl_account';

    --grants execute on orcl object to orcl user
    tab_proc_grants   typ_tab_obj_account := typ_tab_obj_account(
            rec_obj_account('pkg_obj_grants_to_orcl_users', 'tcmpl_deploy'),
            rec_obj_account('pkg_ts_osc_mhrs', 'tcmpl_app_config'),
            rec_obj_account('pkg_ts_osc_mhrs_qry', 'tcmpl_app_config'),
            rec_obj_account('iot_jobs_update_pm_js_bulk', 'tcmpl_app_config'),
            rec_obj_account('pkg_expdp_remap_data', 'PUBLIC'),
            rec_obj_account('pkg_ts_status', 'tcmpl_app_config'),
            rec_obj_account('pkg_ts_status_qry', 'tcmpl_app_config'),            
            rec_obj_account('pkg_ts_posted_hours_total_qry', 'tcmpl_app_config'),
            rec_obj_account('pkg_dg_process_employee', 'tcmpl_app_config'),
            rec_obj_account('pkg_ts_mhrs_adj', 'tcmpl_app_config'),
            rec_obj_account('pkg_ts_timesheet_qry', 'tcmpl_app_config'),
            rec_obj_account('pkg_ts_posted_hours_qry', 'tcmpl_app_config'),
            rec_obj_account('pkg_ts_mhrs_adj_qry', 'tcmpl_app_config'),
            rec_obj_account('pkg_ts_emp_timesheet_qry', 'tcmpl_app_config'),
            rec_obj_account('pkg_act_mast', 'tcmpl_app_config'),
            rec_obj_account('pkg_projact_mast', 'tcmpl_app_config'),
            rec_obj_account('pkg_rap_hours', 'tcmpl_app_config'),
            rec_obj_account('pkg_wrk_hours', 'tcmpl_app_config'),
            rec_obj_account('pkg_tlp_mast', 'tcmpl_app_config'),
            rec_obj_account('pkg_tsconfig', 'tcmpl_app_config'),
            rec_obj_account('pkg_ot_mast', 'tcmpl_app_config'),
            rec_obj_account('pkg_movemast', 'tcmpl_app_config'),
            rec_obj_account('pkg_expt_jobs_mhr_projections','tcmpl_app_config'),
            rec_obj_account('pkg_prjc_mast','tcmpl_app_config'),
            rec_obj_account('pkg_update_no_of_employees','tcmpl_app_config')
            
            
        );

    --grants select on orcl object to orcl user
    tab_select_grants typ_tab_obj_account  := typ_tab_obj_account(
            rec_obj_account('rap_secretary', 'tcmpl_app_config'),
            rec_obj_account('rap_hod', 'tcmpl_app_config'),
            rec_obj_account('rap_dyhod', 'tcmpl_app_config'),
            rec_obj_account('time_secretary', 'tcmpl_app_config')
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
                    'TIMECURR.GRANT_' || p_grant_name,
                    v_statement
                );
            Else
                tcmpl_app_config.task_scheduler.sp_log_failure(
                    'TIMECURR.GRANT_' || p_grant_name,
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