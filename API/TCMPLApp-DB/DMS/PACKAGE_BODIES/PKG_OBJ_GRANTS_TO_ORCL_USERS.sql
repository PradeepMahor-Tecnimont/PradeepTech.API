Create Or Replace Package Body dms.pkg_obj_grants_to_orcl_users As
    --grants select on orcl object to orcl user
    v_grant_statement Varchar2(2000)      := ' grant :grant on :object to :orcl_account';

    --grants execute on orcl object to orcl user
    tab_proc_grants   typ_tab_obj_account := typ_tab_obj_account(
            rec_obj_account('pkg_obj_grants_to_orcl_users', 'tcmpl_deploy'),
            rec_obj_account('desk', 'tcmpl_app_config'),
            rec_obj_account('desk_mail', 'tcmpl_app_config'),
            rec_obj_account('dmsv2', 'tcmpl_app_config'),
            rec_obj_account('dms_select_list_qry', 'tcmpl_app_config'),
            rec_obj_account('generate_csharp_code', 'tcmpl_app_config'),
            rec_obj_account('health', 'tcmpl_app_config'),
            rec_obj_account('import_legacy_data', 'tcmpl_app_config'),
            rec_obj_account('inv_select_list_qry', 'tcmpl_app_config'),
            rec_obj_account('iot_dms', 'tcmpl_app_config'),
            rec_obj_account('iot_dms_qry', 'tcmpl_app_config'),
            rec_obj_account('iot_dms_ss', 'tcmpl_app_config'),
            rec_obj_account('iot_dms_ss_qry', 'tcmpl_app_config'),
            rec_obj_account('leave', 'tcmpl_app_config'),
            rec_obj_account('lesson', 'tcmpl_app_config'),
            rec_obj_account('meet', 'tcmpl_app_config'),
            rec_obj_account('mis_punch', 'tcmpl_app_config'),
            rec_obj_account('nu_emp', 'tcmpl_app_config'),
            rec_obj_account('od', 'tcmpl_app_config'),
            rec_obj_account('pc_data', 'tcmpl_app_config'),
            rec_obj_account('pkg_dms_area_categories_qry', 'tcmpl_app_config'),
            rec_obj_account('pkg_dms_asset_distribution_qry', 'tcmpl_app_config'),
            rec_obj_account('pkg_dms_asset_on_hold', 'tcmpl_app_config'),
            rec_obj_account('pkg_dms_asset_on_hold_qry', 'tcmpl_app_config'),
            rec_obj_account('pkg_dms_common', 'tcmpl_app_config'),
            rec_obj_account('pkg_dms_desk_areas', 'tcmpl_app_config'),
            rec_obj_account('pkg_dms_desk_areas_qry', 'tcmpl_app_config'),
            rec_obj_account('pkg_dms_desk_area_categories', 'tcmpl_app_config'),
            rec_obj_account('pkg_dms_desk_asgmt', 'tcmpl_app_config'),
            rec_obj_account('pkg_dms_desk_asgmt_4engg_qry', 'tcmpl_app_config'),
            rec_obj_account('pkg_dms_desk_asgmt_qry', 'tcmpl_app_config'),
            rec_obj_account('pkg_dms_desk_bays', 'tcmpl_app_config'),
            rec_obj_account('pkg_dms_desk_bays_qry', 'tcmpl_app_config'),
            rec_obj_account('pkg_dms_desk_block', 'tcmpl_app_config'),
            rec_obj_account('pkg_dms_desk_block_qry', 'tcmpl_app_config'),
            rec_obj_account('pkg_dms_general', 'tcmpl_app_config'),
            rec_obj_account('pkg_dms_guest', 'tcmpl_app_config'),
            rec_obj_account('pkg_dms_guest_qry', 'tcmpl_app_config'),
            rec_obj_account('pkg_dms_masters', 'tcmpl_app_config'),
            rec_obj_account('pkg_dms_masters_qry', 'tcmpl_app_config'),
            rec_obj_account('pkg_dms_movement', 'tcmpl_app_config'),
            rec_obj_account('pkg_dms_newjoin', 'tcmpl_app_config'),
            rec_obj_account('pkg_dms_newjoin_qry', 'tcmpl_app_config'),
            rec_obj_account('pkg_dms_reports', 'tcmpl_app_config'),
            rec_obj_account('pkg_dms_select_list_qry', 'tcmpl_app_config'),
            rec_obj_account('pkg_inv_addon_container', 'tcmpl_app_config'),
            rec_obj_account('pkg_inv_addon_container_qry', 'tcmpl_app_config'),
            rec_obj_account('pkg_inv_consumables', 'tcmpl_app_config'),
            rec_obj_account('pkg_inv_consumables_det_qry', 'tcmpl_app_config'),
            rec_obj_account('pkg_inv_consumables_qry', 'tcmpl_app_config'),
            rec_obj_account('pkg_inv_item_addon_trans', 'tcmpl_app_config'),
            rec_obj_account('pkg_inv_item_addon_trans_qry', 'tcmpl_app_config'),
            rec_obj_account('pkg_inv_item_ams_asset_mapping', 'tcmpl_app_config'),
            rec_obj_account('pkg_inv_item_ams_asset_mapping_qry', 'tcmpl_app_config'),
            rec_obj_account('pkg_inv_item_asgmt_types', 'tcmpl_app_config'),
            rec_obj_account('pkg_inv_item_asgmt_types_qry', 'tcmpl_app_config'),
            rec_obj_account('pkg_inv_item_category', 'tcmpl_app_config'),
            rec_obj_account('pkg_inv_item_category_qry', 'tcmpl_app_config'),
            rec_obj_account('pkg_inv_item_group', 'tcmpl_app_config'),
            rec_obj_account('pkg_inv_item_group_det_qry', 'tcmpl_app_config'),
            rec_obj_account('pkg_inv_item_group_qry', 'tcmpl_app_config'),
            rec_obj_account('pkg_inv_item_types', 'tcmpl_app_config'),
            rec_obj_account('pkg_inv_item_types_qry', 'tcmpl_app_config'),
            rec_obj_account('pkg_inv_laptop_lotwise_qry', 'tcmpl_app_config'),
            rec_obj_account('pkg_inv_transactions', 'tcmpl_app_config'),
            rec_obj_account('pkg_inv_transactions_detail', 'tcmpl_app_config'),
            rec_obj_account('pkg_inv_transactions_det_qry', 'tcmpl_app_config'),
            rec_obj_account('pkg_inv_transactions_qry', 'tcmpl_app_config'),
            rec_obj_account('pkg_obj_grants_to_orcl_users', 'tcmpl_app_config'),
            rec_obj_account('pkg_systemgrants', 'tcmpl_app_config'),
            rec_obj_account('pn', 'tcmpl_app_config'),
            rec_obj_account('print_log_mis', 'tcmpl_app_config'),
            rec_obj_account('sa', 'tcmpl_app_config'),
            rec_obj_account('ss', 'tcmpl_app_config'),
            rec_obj_account('ss_mail', 'tcmpl_app_config'),
            rec_obj_account('ss_phone', 'tcmpl_app_config'),
            rec_obj_account('tt1', 'tcmpl_app_config'),
            rec_obj_account('usb', 'tcmpl_app_config'),
            rec_obj_account('user_profile', 'tcmpl_app_config'),
            rec_obj_account('pkg_dms_offices_qry', 'tcmpl_app_config'),
            rec_obj_account('pkg_dms_offices', 'tcmpl_app_config'),
            rec_obj_account('pkg_dms_desk_area_office_map_qry', 'tcmpl_app_config'),
            rec_obj_account('pkg_dms_desk_area_office_map', 'tcmpl_app_config'),
            rec_obj_account('xlsx_read', 'tcmpl_app_config'),
            rec_obj_account('task_scheduler', 'tcmpl_app_config'),
            rec_obj_account('pkg_obj_grants_to_orcl_users', 'tcmpl_deploy'),
            rec_obj_account('desk', 'tcmpl_app_config'),
            rec_obj_account('desk_mail', 'tcmpl_app_config'),
            rec_obj_account('dmsv2', 'tcmpl_app_config'),
            rec_obj_account('dms_select_list_qry', 'tcmpl_app_config'),
            rec_obj_account('generate_csharp_code', 'tcmpl_app_config'),
            rec_obj_account('health', 'tcmpl_app_config'),
            rec_obj_account('import_legacy_data', 'tcmpl_app_config'),
            rec_obj_account('inv_select_list_qry', 'tcmpl_app_config'),
            rec_obj_account('iot_dms', 'tcmpl_app_config'),
            rec_obj_account('iot_dms_qry', 'tcmpl_app_config'),
            rec_obj_account('iot_dms_ss', 'tcmpl_app_config'),
            rec_obj_account('iot_dms_ss_qry', 'tcmpl_app_config'),
            rec_obj_account('leave', 'tcmpl_app_config'),
            rec_obj_account('lesson', 'tcmpl_app_config'),
            rec_obj_account('meet', 'tcmpl_app_config'),
            rec_obj_account('mis_punch', 'tcmpl_app_config'),
            rec_obj_account('nu_emp', 'tcmpl_app_config'),
            rec_obj_account('od', 'tcmpl_app_config'),
            rec_obj_account('pc_data', 'tcmpl_app_config'),
            rec_obj_account('pkg_dms_area_categories_qry', 'tcmpl_app_config'),
            rec_obj_account('pkg_dms_asset_distribution_qry', 'tcmpl_app_config'),
            rec_obj_account('pkg_dms_asset_on_hold', 'tcmpl_app_config'),
            rec_obj_account('pkg_dms_asset_on_hold_qry', 'tcmpl_app_config'),
            rec_obj_account('pkg_dms_common', 'tcmpl_app_config'),
            rec_obj_account('pkg_dms_desk_areas', 'tcmpl_app_config'),
            rec_obj_account('pkg_dms_desk_areas_qry', 'tcmpl_app_config'),
            rec_obj_account('pkg_dms_desk_area_categories', 'tcmpl_app_config'),
            rec_obj_account('pkg_dms_desk_asgmt', 'tcmpl_app_config'),
            rec_obj_account('pkg_dms_desk_asgmt_4engg_qry', 'tcmpl_app_config'),
            rec_obj_account('pkg_dms_desk_asgmt_qry', 'tcmpl_app_config'),
            rec_obj_account('pkg_dms_desk_bays', 'tcmpl_app_config'),
            rec_obj_account('pkg_dms_desk_bays_qry', 'tcmpl_app_config'),
            rec_obj_account('pkg_dms_desk_block', 'tcmpl_app_config'),
            rec_obj_account('pkg_dms_desk_block_qry', 'tcmpl_app_config'),
            rec_obj_account('pkg_dms_general', 'tcmpl_app_config'),
            rec_obj_account('pkg_dms_guest', 'tcmpl_app_config'),
            rec_obj_account('pkg_dms_guest_qry', 'tcmpl_app_config'),
            rec_obj_account('pkg_dms_masters', 'tcmpl_app_config'),
            rec_obj_account('pkg_dms_masters_qry', 'tcmpl_app_config'),
            rec_obj_account('pkg_dms_movement', 'tcmpl_app_config'),
            rec_obj_account('pkg_dms_newjoin', 'tcmpl_app_config'),
            rec_obj_account('pkg_dms_newjoin_qry', 'tcmpl_app_config'),
            rec_obj_account('pkg_dms_reports', 'tcmpl_app_config'),
            rec_obj_account('pkg_dms_select_list_qry', 'tcmpl_app_config'),
            rec_obj_account('pkg_inv_addon_container', 'tcmpl_app_config'),
            rec_obj_account('pkg_inv_addon_container_qry', 'tcmpl_app_config'),
            rec_obj_account('pkg_inv_consumables', 'tcmpl_app_config'),
            rec_obj_account('pkg_inv_consumables_det_qry', 'tcmpl_app_config'),
            rec_obj_account('pkg_inv_consumables_qry', 'tcmpl_app_config'),
            rec_obj_account('pkg_inv_item_addon_trans', 'tcmpl_app_config'),
            rec_obj_account('pkg_inv_item_addon_trans_qry', 'tcmpl_app_config'),
            rec_obj_account('pkg_inv_item_ams_asset_mapping', 'tcmpl_app_config'),
            rec_obj_account('pkg_inv_item_ams_asset_mapping_qry', 'tcmpl_app_config'),
            rec_obj_account('pkg_inv_item_asgmt_types', 'tcmpl_app_config'),
            rec_obj_account('pkg_inv_item_asgmt_types_qry', 'tcmpl_app_config'),
            rec_obj_account('pkg_inv_item_category', 'tcmpl_app_config'),
            rec_obj_account('pkg_inv_item_category_qry', 'tcmpl_app_config'),
            rec_obj_account('pkg_inv_item_group', 'tcmpl_app_config'),
            rec_obj_account('pkg_inv_item_group_det_qry', 'tcmpl_app_config'),
            rec_obj_account('pkg_inv_item_group_qry', 'tcmpl_app_config'),
            rec_obj_account('pkg_inv_item_types', 'tcmpl_app_config'),
            rec_obj_account('pkg_inv_item_types_qry', 'tcmpl_app_config'),
            rec_obj_account('pkg_inv_laptop_lotwise_qry', 'tcmpl_app_config'),
            rec_obj_account('pkg_inv_transactions', 'tcmpl_app_config'),
            rec_obj_account('pkg_inv_transactions_detail', 'tcmpl_app_config'),
            rec_obj_account('pkg_inv_transactions_det_qry', 'tcmpl_app_config'),
            rec_obj_account('pkg_inv_transactions_qry', 'tcmpl_app_config'),
            rec_obj_account('pkg_obj_grants_to_orcl_users', 'tcmpl_app_config'),
            rec_obj_account('pkg_systemgrants', 'tcmpl_app_config'),
            rec_obj_account('pn', 'tcmpl_app_config'),
            rec_obj_account('print_log_mis', 'tcmpl_app_config'),
            rec_obj_account('sa', 'tcmpl_app_config'),
            rec_obj_account('ss', 'tcmpl_app_config'),
            rec_obj_account('ss_mail', 'tcmpl_app_config'),
            rec_obj_account('ss_phone', 'tcmpl_app_config'),
            rec_obj_account('tt1', 'tcmpl_app_config'),
            rec_obj_account('usb', 'tcmpl_app_config'),
            rec_obj_account('user_profile', 'tcmpl_app_config'),
            rec_obj_account('xlsx_read', 'tcmpl_app_config'),
            rec_obj_account('pkg_dm_area_type_qry', 'tcmpl_app_config'),
            rec_obj_account('pkg_dm_area_type', 'tcmpl_app_config'),
            rec_obj_account('pkg_dm_area_type_dept_mapping_qry', 'tcmpl_app_config'),
            rec_obj_account('pkg_dm_area_type_dept_mapping', 'tcmpl_app_config'),
            rec_obj_account('pkg_dm_area_type_project_mapping_qry', 'tcmpl_app_config'),
            rec_obj_account('pkg_dm_area_type_project_mapping', 'tcmpl_app_config'),
            rec_obj_account('pkg_dm_area_type_user_mapping_qry', 'tcmpl_app_config'),
            rec_obj_account('pkg_dm_area_type_user_mapping', 'tcmpl_app_config'),
            rec_obj_account('pkg_dm_area_type_emp_mapping_qry', 'tcmpl_app_config'),
            rec_obj_account('pkg_dm_area_type_emp_mapping', 'tcmpl_app_config'),
            rec_obj_account('pkg_dm_area_type_emp_area_mapping_qry', 'tcmpl_app_config'),
            rec_obj_account('pkg_dm_area_type_emp_area_mapping', 'tcmpl_app_config'),
            rec_obj_account('pkg_dm_area_type_user_mapping_hod_qry', 'tcmpl_app_config'),
            rec_obj_account('db_select_list_qry', 'tcmpl_app_config'),
            rec_obj_account('pkg_dm_tag_obj_mapping_qry', 'tcmpl_app_config'),
            rec_obj_account('pkg_dm_tag_obj_mapping', 'tcmpl_app_config'),
            rec_obj_account('pkg_inv_item_exclude_qry', 'tcmpl_app_config'),
            rec_obj_account('pkg_dms_asset_asgmt_qry', 'tcmpl_app_config'),
            rec_obj_account('pkg_exclude_from_moc5_qry', 'tcmpl_app_config'),
            rec_obj_account('pkg_dm_management_qry', 'tcmpl_app_config'),
            rec_obj_account('pkg_dm_management', 'tcmpl_app_config'),
            rec_obj_account('PKG_DM_AREA_TYPE_EMP_MAPPING','desk_book'),
            rec_obj_account('pkg_dm_management', 'tcmpl_app_config'),
            rec_obj_account('PKG_DMS_MOVEMENT', 'desk_book'),
            rec_obj_account('PKG_DM_AREA_TYPE_EMP_MAPPING', 'desk_book'),
            rec_obj_account('pkg_dm_tag_obj_mapping', 'desk_book'),
            rec_obj_account('pkg_dms_asset_with_emp_qry', 'tcmpl_app_config'),
            rec_obj_account('PROC_DMS_DETAILS', 'tcmpl_app_config'),
            rec_obj_account('pkg_emp_desk_in_more_than_1places', 'tcmpl_app_config')
            


        );

    --grants select on orcl object to orcl user
    tab_select_grants typ_tab_obj_account := typ_tab_obj_account(
            rec_obj_account('dm_offices', 'selfservice'),
            rec_obj_account('dm_desk_area_office_map', 'selfservice'),
            rec_obj_account('inv_emp_item_mapping', 'selfservice'),
            rec_obj_account('dm_desk_areas', 'desk_book'),
            rec_obj_account('dm_area_type', 'desk_book'),
            rec_obj_account('dm_desk_area_office_map', 'desk_book'),
            rec_obj_account('dm_desk_area_dept_map', 'desk_book'),
            rec_obj_account('dm_area_type_user_mapping', 'desk_book'),
            rec_obj_account('dm_area_type_user_desk_mapping', 'desk_book'),

            rec_obj_account('dm_deskmaster', 'desk_book'),
            rec_obj_account('dm_desk_area_proj_map', 'desk_book'),
            rec_obj_account('dm_offices', 'desk_book'),
            rec_obj_account('dm_usermaster', 'desk_book'),
            rec_obj_account('dm_deskmaster', 'desk_book'),
            rec_obj_account('dm_offices', 'tcmpl_app_config'),
            rec_obj_account('dm_desk_area_categories', 'desk_book'),

            rec_obj_account('dm_assetcode', 'desk_book'),
            rec_obj_account('dm_deskallocation', 'desk_book'),


            rec_obj_account('DM_tag_obj_mapping', 'desk_book'),
            rec_obj_account('DM_tag_master', 'desk_book'),
            rec_obj_account('DM_tag_obj_type', 'desk_book'),
            rec_obj_account('dm_deskmaster', 'desk_book'),

            rec_obj_account('dm_desk_areas', 'selfservice'),
             rec_obj_account('dm_desk_areas', 'desk_book'),
            rec_obj_account('dm_area_type', 'selfservice'),
            rec_obj_account('dm_desk_area_categories', 'selfservice'),

            rec_obj_account('dm_deskallocation', 'tcmpl_app_config'),
            rec_obj_account('dm_usermaster', 'tcmpl_app_config'),
            rec_obj_account('dm_deskmaster', 'tcmpl_app_config')


        );
      --grants update on orcl object to orcl user
        tab_update_grants typ_tab_obj_account := typ_tab_obj_account(
            rec_obj_account('dm_deskmaster', 'desk_book')


        );

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

Exec pkg_obj_grants_to_orcl_users.execute_grants;