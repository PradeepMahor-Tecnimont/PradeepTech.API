Create Or Replace Package Body tcmpl_app_config.task_scheduler As
    c_daily Constant Number := 1;
    Procedure sp_log_success(
        p_proc_name     Varchar2,
        p_business_name Varchar2,
        p_message       Varchar2
    ) As
        v_key_id Char(8);
    Begin
        v_key_id := dbms_random.string('X', 8);

        Insert Into app_task_scheduler_log(
            key_id,
            run_date,
            proc_name,
            proc_business_name,
            exec_status,
            exec_message
        )
        Values(
            v_key_id,
            sysdate,
            p_proc_name,
            p_business_name,
            1,
            p_message
        );
        Commit;
    Exception
        When Others Then
            Null;
    End;

    Procedure sp_log_success(
        p_proc_name     Varchar2,
        p_business_name Varchar2
    ) As
        v_key_id Char(8);
    Begin
        v_key_id := dbms_random.string('X', 8);

        Insert Into app_task_scheduler_log(
            key_id,
            run_date,
            proc_name,
            proc_business_name,
            exec_status,
            exec_message
        )
        Values(
            v_key_id,
            sysdate,
            p_proc_name,
            p_business_name,
            1,
            'Procedure executed successfully.'

        );
        Commit;
    Exception
        When Others Then
            Null;
    End;
    Procedure sp_log_failure(
        p_proc_name     Varchar2,
        p_business_name Varchar2,
        p_message       Varchar2
    ) As
        v_key_id Char(8);
    Begin
        v_key_id := dbms_random.string('X', 8);

        Insert Into app_task_scheduler_log(
            key_id,
            run_date,
            proc_name,
            proc_business_name,
            exec_status,
            exec_message
        )
        Values(
            v_key_id,
            sysdate,
            p_proc_name,
            p_business_name,
            0,
            p_message

        );

        Commit;
    Exception
        When Others Then
            Null;
    End;

    Procedure sp_daily_punch_data_upload As
        v_proc_start_date_1      Date;
        v_proc_start_date_2      Date;
        v_proc_start_date_3      Date;
        v_success                Varchar2(10);
        v_message                Varchar2(1000);
        c_mail_to                Constant Varchar2(100) := 'd.bhavsar@tecnimont.in;a.kotian@tecnimont.in';
        c_process_id_punch_uplod Constant Varchar2(10)  := 'PUNCHUPLOD';
        c_process_desc           Constant Varchar2(100) := 'Upload punch data';
        c_module_id_selfservice  Constant Varchar2(3)   := 'M04';
        c_service_account_metaid Constant Varchar2(30)  := '-APPS02SRV012345';
    Begin

        v_proc_start_date_1 := trunc(sysdate) + ((7 * 60) + 15) / (24 * 60);
        v_proc_start_date_2 := trunc(sysdate) + (11 * 60) / (24 * 60);
        v_proc_start_date_3 := trunc(sysdate) + (16 * 60) / (24 * 60);

        If sysdate <= v_proc_start_date_1 Then
            pkg_app_process_queue.sp_process_add_planning(
                p_person_id          => Null,
                p_meta_id            => c_service_account_metaid,

                p_module_id          => c_module_id_selfservice,
                p_process_id         => c_process_id_punch_uplod,
                p_process_desc       => c_process_desc,
                p_parameter_json     => Null,
                p_planned_start_date => v_proc_start_date_1,

                p_mail_to            => c_mail_to,
                p_mail_cc            => Null,
                p_message_type       => v_success,
                p_message_text       => v_message
            );
        End If;

        If sysdate <= v_proc_start_date_2 Then
            pkg_app_process_queue.sp_process_add_planning(
                p_person_id          => Null,
                p_meta_id            => c_service_account_metaid,

                p_module_id          => c_module_id_selfservice,
                p_process_id         => c_process_id_punch_uplod,
                p_process_desc       => c_process_desc,
                p_parameter_json     => Null,
                p_planned_start_date => v_proc_start_date_2,

                p_mail_to            => c_mail_to,
                p_mail_cc            => Null,
                p_message_type       => v_success,
                p_message_text       => v_message
            );
        End If;

        If sysdate <= v_proc_start_date_3 Then
            pkg_app_process_queue.sp_process_add_planning(
                p_person_id          => Null,
                p_meta_id            => c_service_account_metaid,

                p_module_id          => c_module_id_selfservice,
                p_process_id         => c_process_id_punch_uplod,
                p_process_desc       => c_process_desc,
                p_parameter_json     => Null,
                p_planned_start_date => v_proc_start_date_3,

                p_mail_to            => c_mail_to,
                p_mail_cc            => Null,
                p_message_type       => v_success,
                p_message_text       => v_message
            );
        End If;

        sp_log_success(
            p_proc_name     => 'tcmpl_app_config.task_scheduler.sp_daily_punch_data_upload',
            p_business_name => 'SELFSERVICE Punch data upload'
        );

    Exception
        When Others Then
            sp_log_failure(
                p_proc_name     => 'tcmpl_app_config.task_scheduler.sp_daily_punch_data_upload',
                p_business_name => 'SELFSERVICE Punch data upload',
                p_message       => 'Err : ' || sqlcode || ' - ' || sqlerrm
            );

    End;

    Procedure sp_daily_emp_rfid_upload As
        v_proc_start_date_1      Date;
        v_proc_start_date_2      Date;
        v_proc_start_date_3      Date;
        v_success                Varchar2(10);
        v_message                Varchar2(1000);
        c_mail_to                Constant Varchar2(100) := 'd.bhavsar@tecnimont.in;a.kotian@tecnimont.in';
        c_process_id_rfid_uplod  Constant Varchar2(10)  := 'EMPRFIDUPD';
        c_process_desc           Constant Varchar2(100) := 'Upload employee RFID';
        c_module_id_selfservice  Constant Varchar2(3)   := 'M04';
        c_service_account_metaid Constant Varchar2(30)  := '-APPS02SRV012345';
    Begin

        v_proc_start_date_1 := trunc(sysdate) + ((7 * 60) + 45) / (24 * 60);
        --v_proc_start_date_2 := trunc(sysdate) + (11 * 60) / (24 * 60);
        --v_proc_start_date_3 := trunc(sysdate) + (16 * 60) / (24 * 60);

        If sysdate <= v_proc_start_date_1 Then
            pkg_app_process_queue.sp_process_add_planning(
                p_person_id          => Null,
                p_meta_id            => c_service_account_metaid,

                p_module_id          => c_module_id_selfservice,
                p_process_id         => c_process_id_rfid_uplod,
                p_process_desc       => c_process_desc,
                p_parameter_json     => Null,
                p_planned_start_date => v_proc_start_date_1,

                p_mail_to            => c_mail_to,
                p_mail_cc            => Null,
                p_message_type       => v_success,
                p_message_text       => v_message
            );
        End If;

        sp_log_success(
            p_proc_name     => 'tcmpl_app_config.task_scheduler.sp_daily_emp_rfid_upload',
            p_business_name => 'SELFSERVICE Employee Card RFID data upload'
        );

    Exception
        When Others Then
            sp_log_failure(
                p_proc_name     => 'tcmpl_app_config.task_scheduler.sp_daily_emp_rfid_upload',
                p_business_name => 'SELFSERVICE Employee Card RFID data upload',
                p_message       => 'Err : ' || sqlcode || ' - ' || sqlerrm
            );

    End;

    Procedure sp_daily_swp_sendmail As
    Begin

        selfservice.task_scheduler.sp_daily_swp_sendmail;
        sp_log_success(
            p_proc_name     => 'selfservice.task_scheduler.sp_daily_swp_sendmail',
            p_business_name => 'SWP Send auto emails'
        );

    Exception
        When Others Then
            sp_log_failure(
                p_proc_name     => 'selfservice.task_scheduler.sp_daily_swp_sendmail',
                p_business_name => 'SWP Send auto emails',
                p_message       => 'Err : ' || sqlcode || ' - ' || sqlerrm
            );
    End;

    Procedure sp_daily_swp_add_new_joinees As
    Begin
        selfservice.task_scheduler.sp_daily_swp_add_nu_joinees;
        sp_log_success(
            p_proc_name     => 'selfservice.task_scheduler.sp_daily_swp_add_nu_joinees',
            p_business_name => 'Add new joinees to Primary Workspace'
        );
    Exception
        When Others Then
            sp_log_failure(
                p_proc_name     => 'selfservice.task_scheduler.sp_daily_swp_add_nu_joinees',
                p_business_name => 'Add new joinees to Primary Workspace',
                p_message       => 'Err : ' || sqlcode || ' - ' || sqlerrm
            );
    End;

    Procedure sp_daily_rap_clear_batch_rep As
    Begin
        timecurr.task_scheduler.sp_daily_del_rap_batch_reports;
        sp_log_success(
            p_proc_name     => 'timecurr.task_scheduler.sp_daily_del_rap_batch_reports',
            p_business_name => 'Clear RAP_REPORTING shceduled reports'
        );
    Exception
        When Others Then
            sp_log_failure(
                p_proc_name     => 'timecurr.task_scheduler.sp_daily_del_rap_batch_reports',
                p_business_name => 'Clear RAP_REPORTING shceduled reports',
                p_message       => 'Err : ' || sqlcode || ' - ' || sqlerrm
            );

    End;

    Procedure sp_daily_travel_remind_hod_pm As
    Begin
        travel.task_scheduler.sp_weekly_reminder_hod_pm;
        sp_log_success(
            p_proc_name     => 'travel.task_scheduler.sp_weekly_reminder_hod_pm',
            p_business_name => 'Travel Management Send auto emails	'
        );
    Exception
        When Others Then
            sp_log_failure(
                p_proc_name     => 'travel.task_scheduler.sp_weekly_reminder_hod_pm',
                p_business_name => 'Travel Management Send auto emails',
                p_message       => 'Err : ' || sqlcode || ' - ' || sqlerrm
            );

    End;

    Procedure sp_daily_training_remind_emp As
    Begin
        trainingnew.task_scheduler.sp_weekly_reminder_emp;
        sp_log_success(
            p_proc_name     => 'trainingnew.task_scheduler.sp_weekly_reminder_emp',
            p_business_name => 'eTraining Send auto emails'
        );
    Exception
        When Others Then
            sp_log_failure(
                p_proc_name     => 'trainingnew.task_scheduler.sp_weekly_reminder_emp',
                p_business_name => 'eTraining Send auto emails',
                p_message       => 'Err : ' || sqlcode || ' - ' || sqlerrm
            );

    End;

    Procedure sp_daily_del_rap_batch_reports As
    Begin
        timecurr.task_scheduler.sp_daily_del_rap_batch_reports;
        sp_log_success(
            p_proc_name     => 'timecurr.task_scheduler.sp_daily_del_rap_batch_reports',
            p_business_name => 'Clear RAP_REPORTING shceduled reports'
        );
    Exception
        When Others Then
            sp_log_failure(
                p_proc_name     => 'timecurr.task_scheduler.sp_daily_del_rap_batch_reports',
                p_business_name => 'Clear RAP_REPORTING shceduled reports',
                p_message       => 'Err : ' || sqlcode || ' - ' || sqlerrm
            );

    End;

    Procedure sp_daily_update_emp_count As
    Begin
        timecurr.task_scheduler.sp_daily_update_emp_count;
        sp_log_success(
            p_proc_name     => 'timecurr.task_scheduler.sp_daily_update_emp_count',
            p_business_name => 'TIMECURR - Update employee count'
        );
    Exception
        When Others Then
            sp_log_failure(
                p_proc_name     => 'timecurr.task_scheduler.sp_daily_update_emp_count',
                p_business_name => 'TIMECURR - Update employee count',
                p_message       => 'Err : ' || sqlcode || ' - ' || sqlerrm
            );

    End;

    Procedure sp_daily_remove_ex_userids As
    Begin
        selfservice.task_scheduler.sp_remove_ex_emp_from_userids;
        sp_log_success(
            p_proc_name     => 'task_shceduler.sp_remove_ex_emp_from_userids',
            p_business_name => 'TCMPL APP CONFIG - Remove EX emp from userids'
        );
    Exception
        When Others Then
            sp_log_failure(
                p_proc_name     => 'task_shceduler.sp_remove_ex_emp_from_userids',
                p_business_name => 'TCMPL APP CONFIG - Remove EX emp from userids',
                p_message       => 'Err : ' || sqlcode || ' - ' || sqlerrm
            );

    End;

    Procedure sp_daily_update_jobform_mode As
    Begin
        timecurr.task_scheduler.sp_daily_update_jobform_mode;
        sp_log_success(
            p_proc_name     => 'timecurr.task_shceduler.sp_daily_update_jobform_mode',
            p_business_name => 'TCMPL APP CONFIG - Update JOBFORM mode status'
        );
    Exception
        When Others Then
            sp_log_failure(
                p_proc_name     => 'task_shceduler.sp_remove_ex_emp_from_userids',
                p_business_name => 'TCMPL APP CONFIG - Update JOBFORM mode status',
                p_message       => 'Err : ' || sqlcode || ' - ' || sqlerrm
            );

    End;

    Procedure sp_daily_generate_roles As
    Begin
        pkg_generate_user_access.sp_generate;
        sp_log_success(
            p_proc_name     => 'pkg_generate_user_access.sp_generate',
            p_business_name => 'TCMPL APP CONFIG - Generate roles'
        );
    Exception
        When Others Then
            sp_log_failure(
                p_proc_name     => 'pkg_generate_user_access.sp_generate',
                p_business_name => 'TCMPL APP CONFIG - Generate roles',
                p_message       => 'Err : ' || sqlcode || ' - ' || sqlerrm
            );

    End;

    Procedure sp_daily_jobs_old As

    Begin
        Delete
          From app_task_scheduler_log
         Where trunc(run_date) <= trunc(sysdate) - 14;

        --RAP
        sp_daily_rap_clear_batch_rep;

        --SWP
        sp_daily_swp_add_new_joinees;

        sp_daily_swp_sendmail;

        --TRAVEL
        sp_daily_travel_remind_hod_pm;

        --eTraining reminders
        sp_daily_training_remind_emp;

        --Delete Timesheet Batch Reports
        sp_daily_del_rap_batch_reports;

        --Daily punch data upload
        sp_daily_punch_data_upload;

        --Daily Employee Card RFID data upload
        sp_daily_emp_rfid_upload;

        --Update emp count
        sp_daily_update_emp_count;

        --Remove EX emp from userids',
        sp_daily_remove_ex_userids;

        --TCMPL APP CONFIG - Generate roles
        sp_daily_generate_roles;

        --TCMPL APP CONFIG - Log file cleaner
        sp_daily_tcmplapp_log_cleaner;
        
    End sp_daily_jobs_old;

    Procedure sp_daily_jobs As
        Type rec_obj_proc Is Record(
                proc_name Varchar2(200),
                proc_desc Varchar2(200)
            );
        Type typ_tab_proc_list Is Table Of rec_obj_proc;

        tab_proc_list typ_tab_proc_list := typ_tab_proc_list(
                rec_obj_proc(
                    proc_name => 'timecurr.task_scheduler.sp_daily_del_rap_batch_reports',
                    proc_desc => 'Clear RAP_REPORTING shceduled reports'
                ),
                rec_obj_proc(
                    proc_name => 'pkg_generate_user_access.sp_generate',
                    proc_desc => 'TCMPL APP CONFIG - Generate roles'
                ),
                rec_obj_proc(
                    proc_name => 'task_scheduler.sp_daily_punch_data_upload',
                    proc_desc => 'SELFSERVICE Punch data upload'
                ),
                rec_obj_proc(
                    proc_name => 'task_scheduler.sp_daily_emp_rfid_upload',
                    proc_desc => 'SELFSERVICE Punch data upload'
                ),
                rec_obj_proc(
                    proc_name => 'timecurr.task_scheduler.sp_daily_del_rap_batch_reports',
                    proc_desc => 'Clear RAP_REPORTING shceduled reports'
                ),
                rec_obj_proc(
                    proc_name => 'selfservice.task_scheduler.sp_remove_ex_emp_from_userids',
                    proc_desc => 'TCMPL APP CONFIG - Remove EX emp from userids'
                ),
                rec_obj_proc(
                    proc_name => 'selfservice.task_scheduler.sp_daily_swp_add_nu_joinees',
                    proc_desc => 'Add new joinees to Primary Workspace'
                ),
                rec_obj_proc(
                    proc_name => 'selfservice.task_scheduler.sp_daily_swp_sendmail',
                    proc_desc => 'SWP Send auto emails'
                ),
                rec_obj_proc(
                    proc_name => 'trainingnew.task_scheduler.sp_weekly_reminder_emp',
                    proc_desc => 'eTraining Send auto emails'
                ),
                rec_obj_proc(
                    proc_name => 'travel.task_scheduler.sp_weekly_reminder_hod_pm',
                    proc_desc => 'Travel Management Send auto emails'
                ),
                rec_obj_proc(
                    proc_name => 'timecurr.task_scheduler.sp_daily_update_emp_count',
                    proc_desc => 'TIMECURR - Update employee count'
                ),
                rec_obj_proc(
                    proc_name => 'tcmpl_hr.task_scheduler.sp_daily_set_resign_emp_pws',
                    proc_desc => 'TCMPL_HR - Set Primary workspace for resigned employees.'
                ),
                rec_obj_proc(
                    proc_name => 'tcmpl_hr.task_scheduler.sp_daily_set_pws_4loc_chg_emp',
                    proc_desc => 'TCMPL_HR - Set Primary workspace for office location change.'
                ),
                rec_obj_proc(
                    proc_name => 'tcmpl_hr.task_scheduler.sp_daily_de_activate_vpp_config',
                    proc_desc => 'TCMPL_HR - VPP Config auto DeActivate When on Enddate = Current date.'
                ),
                rec_obj_proc(
                    proc_name => 'tcmpl_hr.task_scheduler.sp_send_mail_mid_term_hod_pending',
                    proc_desc => 'DIGI - Mid term Progress Evaluation Pending'
                ),
                rec_obj_proc(
                    proc_name => 'timecurr.task_scheduler.sp_daily_update_jobform_mode',
                    proc_desc => 'TIMECURR - Set flag for blocking Timesheet booking'
                ),
                rec_obj_proc(
                    proc_name => 'desk_book.task_scheduler.sp_daily_generate_desk_dates_lock',
                    proc_desc => 'DESK_BOOK - Generate desk dates lock'
                ),
                rec_obj_proc(
                    proc_name => 'tcmpl_hr.task_scheduler.sp_daily_dg_transfer_costcode',
                    proc_desc => 'DIGI - Costcode change'
                ),
                rec_obj_proc(
                    proc_name => 'tcmpl_hr.task_scheduler.sp_send_mail_ofb_reminder',
                    proc_desc => 'OFB - Reminder'
                ),
                 rec_obj_proc(
                    proc_name => 'task_scheduler.sp_daily_tcmplapp_log_cleaner',
                    proc_desc => 'TCMPLAPP - Cleaning'
                ),
                 rec_obj_proc(
                    proc_name => 'dms.task_scheduler.sp_daily_update_emp_exclude_moc5',
                    proc_desc => 'DMS - update Moc5 employee exclude'
                ),
                rec_obj_proc(
                    proc_name => 'desk_book.task_scheduler.sp_daily_cabin_booking_emp_role_update',
                    proc_desc => 'DESK_BOOK - insert cabin booking role to employee'
                ),
                rec_obj_proc(
                    proc_name => 'tcmpl_hr.task_scheduler.sp_send_mail_annual_evaluation_hod_pending',
                    proc_desc => 'DIGI - Annual Progress Evaluation Pending'
                )
            );
        c_plsql_block Varchar2(1000)    := 'begin  !PROC_NAME!; :p_ok := ok; exception when others then :p_ko := ''Err - ''  || sqlcode || '' - '' || sqlerrm; end;';
        v_ret_ok      Varchar2(10);
        v_ret_ko      Varchar2(1000);
        v_plsql_block Varchar2(1000);
    Begin
        For i In 1..tab_proc_list.count
        Loop
            v_ret_ok      := Null;
            v_ret_ko      := Null;
            v_plsql_block := replace(c_plsql_block, '!PROC_NAME!', tab_proc_list(i).proc_name);
            Execute Immediate v_plsql_block Using Out v_ret_ok, Out v_ret_ko;
            If v_ret_ok = ok Then
                task_scheduler.sp_log_success(
                    p_proc_name     => upper(tab_proc_list(i).proc_name),
                    p_business_name => tab_proc_list(i).proc_desc
                );
            Else
                task_scheduler.sp_log_failure(
                    p_proc_name     => upper(tab_proc_list(i).proc_name),
                    p_business_name => tab_proc_list(i).proc_desc,
                    p_message       => v_ret_ko
                );
            End If;

        End Loop;
    End;

    Procedure sp_daily_tcmplapp_log_cleaner As
        v_proc_start_date        Date;
        v_success                  Varchar2(10);
        v_message                  Varchar2(1000);
        c_mail_to                  Constant Varchar2(100) := 'd.bhavsar@tecnimont.in;';
        c_process_clean_log_file   Constant Varchar2(25)  := 'TcmplAppLogCleaner';
        c_process_desc             Constant Varchar2(100) := 'Clean Log Files';
        c_module_id_tcmplappconfig Constant Varchar2(3)   := 'M13';
        c_service_account_metaid   Constant Varchar2(30)  := '-APPS02SRV012345';
    Begin

        v_proc_start_date := trunc(sysdate + 1) + ((6 * 60) + 15) / (24 * 60);

        If sysdate <= v_proc_start_date Then
            pkg_app_process_queue.sp_process_add_planning(
                p_person_id          => Null,
                p_meta_id            => c_service_account_metaid,

                p_module_id          => c_module_id_tcmplappconfig,
                p_process_id         => c_process_clean_log_file,
                p_process_desc       => c_process_desc,
                p_parameter_json     => Null,
                p_planned_start_date => v_proc_start_date,

                p_mail_to            => c_mail_to,
                p_mail_cc            => Null,
                p_message_type       => v_success,
                p_message_text       => v_message
            );
        End If;

        sp_log_success(
            p_proc_name     => 'tcmpl_app_config.task_scheduler.sp_daily_tcmplapp_log_cleaner',
            p_business_name => 'TCMPLAPP - Cleaning'
        );

    Exception
        When Others Then
            sp_log_failure(
                p_proc_name     => 'tcmpl_app_config.task_scheduler.sp_daily_tcmplapp_log_cleaner',
                p_business_name => 'TCMPLAPP - Cleaning',
                p_message       => 'Err : ' || sqlcode || ' - ' || sqlerrm
            );

    End;
End task_scheduler;