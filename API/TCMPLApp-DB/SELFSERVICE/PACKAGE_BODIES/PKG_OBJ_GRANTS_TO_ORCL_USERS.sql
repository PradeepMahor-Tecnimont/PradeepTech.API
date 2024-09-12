Create Or Replace Package Body selfservice.pkg_obj_grants_to_orcl_users As
    --grants select on orcl object to orcl user
    v_grant_statement Varchar2(2000)      := ' grant :grant on :object to :orcl_account';

    --grants execute on orcl object to orcl user
    tab_proc_grants   typ_tab_obj_account := typ_tab_obj_account(
            rec_obj_account('pkg_obj_grants_to_orcl_users', 'tcmpl_deploy'),
            rec_obj_account('iot_swp_config_week', 'tcmpl_app_config'),
            rec_obj_account('PKG_LEAVE_CALENDAR_QRY', 'tcmpl_app_config'),
            rec_obj_account('EMP_CARD_RFID', 'tcmpl_app_config'),
            rec_obj_account('PKG_HSE_QUIZ_USER_QRY', 'tcmpl_app_config'),
            rec_obj_account('PKG_HSE_QUIZ_SELECT_LIST_QRY', 'tcmpl_app_config'),
            rec_obj_account('PKG_HSE_QUIZ_HSE_QRY', 'tcmpl_app_config'),
            rec_obj_account('pkg_deskbook_select_list_qry', 'tcmpl_app_config'),
            rec_obj_account('PKG_HSE_QUIZ_USER', 'tcmpl_app_config'),
            rec_obj_account('ANALYTICAL_REPORTS', 'tcmpl_app_config'),
            rec_obj_account('PKG_HSE_QUIZ_USER', 'tcmpl_app_config'),
            rec_obj_account('get_punch_num', 'desk_book'),
            rec_obj_account('IOT_SWP_COMMON', 'desk_book'),
            rec_obj_account('self_attendance', 'desk_book'),
            rec_obj_account('PKG_SS_ABSENT_EXCESS_LEAVE_LOP_EXCEL', 'tcmpl_app_config'),
            rec_obj_account('PKG_SS_ABSENT_EXCESS_LEAVE_LOP', 'tcmpl_app_config'),
            rec_obj_account('PKG_SS_ABSENT_EXCESS_LEAVE_LOP_QRY', 'tcmpl_app_config'),
            rec_obj_account('PKG_FLEXI_PUNCH_DETAILS', 'tcmpl_app_config'),
            rec_obj_account('PKG_SHIFT_MASTER', 'tcmpl_app_config'),
            rec_obj_account('PKG_SHIFT_MASTER_QRY', 'tcmpl_app_config')
        );

    --grants select on orcl object to orcl user
    tab_select_grants typ_tab_obj_account := typ_tab_obj_account(
            rec_obj_account('SWP_SMART_ATTENDANCE_PLAN', 'desk_book'),
            rec_obj_account('SWP_CONFIG_WEEKS', 'desk_book'),
            rec_obj_account('ss_days_details', 'desk_book'),
            rec_obj_account('SS_SHIFTMAST', 'desk_book'),
            rec_obj_account('SS_PUNCH', 'desk_book')
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
                    'SELFSERVICE.GRANT_' || p_grant_name,
                    v_statement
                );
            Else
                tcmpl_app_config.task_scheduler.sp_log_failure(
                    'SELFSERVICE.GRANT_' || p_grant_name,
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
exec PKG_OBJ_GRANTS_TO_ORCL_USERS.execute_grants;