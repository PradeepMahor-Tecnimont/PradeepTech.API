Create Or Replace Package Body desk_book.pkg_obj_grants_to_orcl_users As
    --grants select on orcl object to orcl user
    v_grant_statement Varchar2(2000)      := ' grant :grant on :object to :orcl_account';

    --grants execute on orcl object to orcl user
    tab_proc_grants   typ_tab_obj_account := typ_tab_obj_account(

            rec_obj_account('PKG_DESKBOOKING', 'tcmpl_app_config'),
            rec_obj_account('pkg_db_emp_proj_map_qry', 'tcmpl_app_config'),
            rec_obj_account('pkg_db_emp_proj_map', 'tcmpl_app_config'),                        
            rec_obj_account('pkg_deskbooking_qry', 'tcmpl_app_config'),
            rec_obj_account('pkg_db_autobook_preferences', 'tcmpl_app_config'),
            rec_obj_account('pkg_db_autobook_preferences_qry', 'tcmpl_app_config'),
            rec_obj_account('pkg_db_autobook_exclude_date', 'tcmpl_app_config'),
            rec_obj_account('pkg_db_autobook_exclude_date_qry', 'tcmpl_app_config'),
            rec_obj_account('pkg_db_summary_qry', 'tcmpl_app_config'),
            rec_obj_account('pkg_db_summary_booking_qry', 'tcmpl_app_config'),
            rec_obj_account('pkg_booking_status_qry', 'tcmpl_app_config'),
            rec_obj_account('task_scheduler', 'tcmpl_app_config'),
            rec_obj_account('PKG_DESKBOOKING', 'SELFSERVICE'),
            rec_obj_account('PKG_DB_EMP_LOCATION_MAPPING_QRY', 'tcmpl_app_config'),
            rec_obj_account('PKG_FLEXI_DESK_TO_DMS', 'tcmpl_app_config'),
            rec_obj_account('PKG_FLEXI_DESK_TO_DMS', 'dms'),
            rec_obj_account('pkg_db_cabin_booking_qry', 'tcmpl_app_config'),
            rec_obj_account('pkg_cabinbooking', 'tcmpl_app_config'),
            rec_obj_account('pkg_manage_booking', 'tcmpl_app_config')
        );

    --grants select on orcl object to orcl user
    tab_select_grants typ_tab_obj_account  := typ_tab_obj_account(
            rec_obj_account('db_map_emp_location', 'tcmpl_app_config'),
            rec_obj_account('DB_CABIN_BOOKINGS', 'DMS')
        );
    --grants update on orcl object to orcl user
    tab_update_grants typ_tab_obj_account ;

    --grants delete on orcl object to orcl user
    tab_delete_grants typ_tab_obj_account:= typ_tab_obj_account(
            rec_obj_account('db_map_emp_location', 'tcmpl_app_config')
        );

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
                    'DMS.GRANT_' || p_grant_name,
                    v_statement
                );
            Else
                tcmpl_app_config.task_scheduler.sp_log_failure(
                    'DMS.GRANT_' || p_grant_name,
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