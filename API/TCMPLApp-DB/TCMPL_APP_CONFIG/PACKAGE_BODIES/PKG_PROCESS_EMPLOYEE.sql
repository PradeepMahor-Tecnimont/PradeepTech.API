Create Or Replace Package Body "TCMPL_APP_CONFIG"."PKG_PROCESS_EMPLOYEE" As

    Procedure sp_process_run(
        p_empno            Varchar2,
        p_empno_action     Varchar2,
        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As

    Begin
            --p_empno_action possible values : ADD / ACTIVATE / DEACTIVATE / CLONE        
            If p_empno_action in ( 'ADD', 'CLONE')  Then
                tcmpl_hr.eo_employee_office.sp_auto_create_4new_joinee(
                    p_empno => p_empno
                );
                selfservice.iot_swp_config_week.sp_add_new_joinees_to_pws;
            End If;
        
        sp_sample_app_process(
            p_empno,
            p_empno_action,
            p_message_type,
            p_message_text
        );

    Exception
        When Others Then
            task_scheduler.sp_log_failure(
                p_proc_name     => 'TCMPL_APP_CONFIG.PKG_PROCESS_EMPLOYEE.SP_PROCESS_RUN',
                p_business_name => p_empno || ' - ' || p_empno_action || ' - ',
                p_message       => 'Error - ' || sqlcode || ' - ' || sqlerrm
            );
    End sp_process_run;    

    --Process sample app ????.....
    Procedure sp_sample_app_process(
        p_empno            Varchar2,
        p_empno_action     Varchar2,
        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As

    Begin
        p_message_type       := 'OK';
        p_message_text       := 'OK';
        v_proc_name          := 'schema.package.stored procedure';
        v_proc_business_name := p_empno || ' - ' || p_empno_action || ' - ';

        If p_empno_action = 'ADD' Then
            --call stored procedure of app
            v_proc_business_name := v_proc_business_name;
            Null;
        End If;

    --task_scheduler.sp_log_success(
    --    p_proc_name     => v_proc_name,
    --    p_business_name => v_proc_business_name);

    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'Err - ' || sqlcode || ' - ' || sqlerrm;
            v_exec_message := substr(p_message_text, 1, 2000);

            task_scheduler.sp_log_failure(
                p_proc_name     => v_proc_name,
                p_business_name => v_proc_business_name,
                p_message       => v_exec_message);

    End sp_sample_app_process;

End pkg_process_employee;
