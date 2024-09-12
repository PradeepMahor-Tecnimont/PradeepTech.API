Create Or Replace Package Body tcmpl_hr.task_scheduler As

    Procedure sp_daily_set_resign_emp_pws As

        Cursor cur_resigned_emp Is
            Select
                empno
            From
                mis_resigned_emp
            Where
                modified_on >= trunc(sysdate - 2);

        Type typ_tab_resign_emp Is
            Table Of cur_resigned_emp%rowtype;
        tab_resign_emp  typ_tab_resign_emp;
        n_pws           Varchar2(2);
        v_message_type  Varchar2(2);
        v_message_text  Varchar2(1000);
        v_proc_name     Varchar2(200);
        v_business_name Varchar2(300);
    Begin
        v_proc_name     := 'tcmpl_hr.mis_resigned_employees.sp_set_pws_for_resigned_emp';
        v_business_name := 'Set PWS for resigned employees.';
        Open cur_resigned_emp;
        Loop
            Fetch cur_resigned_emp
                Bulk Collect Into tab_resign_emp Limit 50;
            For i In 1..tab_resign_emp.count
            Loop
                n_pws := selfservice.iot_swp_common.fn_get_emp_pws(
                             tab_resign_emp(i).empno,
                             trunc(sysdate)
                         );

                If n_pws = 2 Then
                    selfservice.iot_swp_primary_workspace.sp_task_set_ows_of_resign_emp(
                        p_empno        => tab_resign_emp(i).empno,
                        p_message_type => v_message_type,
                        p_message_text => v_message_text
                    );
                End If;
                If v_message_type = ok Then
                    tcmpl_app_config.task_scheduler.sp_log_success(
                        p_proc_name     => v_proc_name,
                        p_business_name => v_business_name,
                        p_message       => 'Procedure successfully executed.'
                    );
                Else
                    tcmpl_app_config.task_scheduler.sp_log_failure(
                        p_proc_name     => v_proc_name,
                        p_business_name => v_business_name,
                        p_message       => v_message_text
                    );
                End If;
            End Loop;
            Exit When cur_resigned_emp%notfound;
        End Loop;

    End;

    Procedure sp_daily_set_pws_4loc_chg_emp As
        c_loc_outsourced  Constant Varchar2(2) := '05';
        c_loc_site_india  Constant Varchar2(2) := '04';
        c_loc_site_abroad Constant Varchar2(2) := '06';
        c_loc_n_a         Constant Varchar2(2) := '07';
        c_sysdate         Constant Date        := trunc(sysdate);
        Cursor cur_loc_chg_emp Is
            Select
                *
            From
                (
                    Select
                        empno,
                            Max(office_location_code) Keep(Dense_Rank Last Order By start_date) location_code,
                            Max(start_date) Keep(Dense_Rank Last Order By start_date)           begin_date
                    From
                        eo_employee_office_map
                    Where
                        start_date Between (c_sysdate - 20) And c_sysdate
                        And modified_on > (c_sysdate - 2)
                        And (empno, start_date) Not In (
                            Select
                                empno,
                                doj
                            From
                                vu_emplmast
                            Where
                                doj > (c_sysdate - 20)
                        )
                    Group By empno
                )
            Where
                location_code <> c_loc_outsourced;

        Type typ_tab_loc_chg_emp Is
            Table Of cur_loc_chg_emp%rowtype;
        tab_loc_chg_emp   typ_tab_loc_chg_emp;
        v_message_type    Varchar2(2);
        v_message_text    Varchar2(1000);
        v_proc_name       Varchar2(200);
        v_business_name   Varchar2(300);
        b_write_log       Boolean;
    Begin
        v_proc_name     := 'tcmpl_hr.eo_employee_office.sp_update_emp_pws';
        v_business_name := ' - Set PWS for location changed employees.';
        Open cur_loc_chg_emp;
        Loop
            Fetch cur_loc_chg_emp
                Bulk Collect Into tab_loc_chg_emp Limit 50;
            For i In 1..tab_loc_chg_emp.count
            Loop
                --Site employees
                b_write_log := False;
                If tab_loc_chg_emp(i).location_code In (c_loc_site_india, c_loc_site_abroad, c_loc_n_a) Then
                    selfservice.iot_swp_primary_workspace.sp_task_set_dws_of_onsite_emp(
                        p_empno        => tab_loc_chg_emp(i).empno,
                        p_date         => tab_loc_chg_emp(i).begin_date,
                        p_message_type => v_message_type,
                        p_message_text => v_message_text
                    );
                    b_write_log := True;

                    --Employees other than OutSource
                Elsif tab_loc_chg_emp(i).location_code <> c_loc_outsourced Then
                    selfservice.iot_swp_primary_workspace.sp_task_set_ows_of_rejoin_emp(
                        p_empno        => tab_loc_chg_emp(i).empno,
                        p_date         => tab_loc_chg_emp(i).begin_date,
                        p_message_type => v_message_type,
                        p_message_text => v_message_text
                    );
                    b_write_log := True;
                End If;
                If b_write_log Then
                    If v_message_type = ok Then
                        tcmpl_app_config.task_scheduler.sp_log_success(
                            p_proc_name     => v_proc_name,
                            p_business_name => tab_loc_chg_emp(i).empno || v_business_name,
                            p_message       => 'Procedure successfully executed.'
                        );
                    Else
                        tcmpl_app_config.task_scheduler.sp_log_failure(
                            p_proc_name     => v_proc_name,
                            p_business_name => tab_loc_chg_emp(i).empno || v_business_name,
                            p_message       => v_message_text
                        );
                    End If;
                End If;
            End Loop;
            Exit When cur_loc_chg_emp%notfound;
        End Loop;
    End;

    Procedure sp_daily_de_activate_vpp_config As
        c_loc_outsourced  Constant Varchar2(2) := '05';
        c_loc_site_india  Constant Varchar2(2) := '04';
        c_loc_site_abroad Constant Varchar2(2) := '06';
        c_loc_n_a         Constant Varchar2(2) := '07';
        c_sysdate         Constant Date        := trunc(sysdate);
        v_message_type    Varchar2(2);
        v_message_text    Varchar2(1000);
        v_proc_name       Varchar2(200);
        v_business_name   Varchar2(300);
        b_write_log       Boolean;
    Begin
        v_proc_name     := 'tcmpl_hr.pkg_vpp_config.sp_auto_de_activate_vpp_config';
        v_business_name := ' TCMPL_HR - VPP Config auto DeActivate When on EndDate is Current date ';
        If b_write_log Then
            If v_message_type = ok Then
                tcmpl_app_config.task_scheduler.sp_log_success(
                    p_proc_name     => v_proc_name,
                    p_business_name => v_business_name,
                    p_message       => 'Procedure successfully executed.'
                );
            Else
                tcmpl_app_config.task_scheduler.sp_log_failure(
                    p_proc_name     => v_proc_name,
                    p_business_name => v_business_name,
                    p_message       => v_message_text
                );
            End If;
        End If;

    End;

    Procedure sp_daily_dg_transfer_costcode As
        v_proc_name     Varchar2(200);
        v_business_name Varchar2(300);
    Begin
        tcmpl_hr.pkg_dg_transfer_costcode_job_scheduler.sp_job_schedule_approval_cycle;
    End;

    Procedure sp_send_mail_mid_term_hod_pending As
        v_proc_name     Varchar2(200);
        v_business_name Varchar2(300);
        b_write_log     Boolean;
        v_message_type  Varchar2(2);
        v_message_text  Varchar2(1000);
        v_is_monday     Varchar2(3);
    Begin

        Select
            to_char(sysdate, 'DY', 'NLS_DATE_LANGUAGE=ENGLISH')
        Into
            v_is_monday
        From
            dual;

        If v_is_monday != 'MON' Then
            Return;
        End If;

        pkg_dg_mail.sp_send_reminder_mid_term_pending_hod;
         
        /*
        v_proc_name     := 'tcmpl_hr.pkg_dg_mail.sp_send_reminder_mid_term_pending_hod';
        v_business_name := 'DIGI - Mid term Progress Evaluation Pending';
        if b_write_log then
           tcmpl_app_config.task_scheduler.sp_log_success(
                                                         p_proc_name => v_proc_name,
                                                         p_business_name => v_business_name,
                                                         p_message => 'Procedure successfully executed - ' || v_message_text
           );
        else
           tcmpl_app_config.task_scheduler.sp_log_failure(
                                                         p_proc_name => v_proc_name,
                                                         p_business_name => v_business_name,
                                                         p_message => v_message_text
           );
        end if;

        */
    End;

    Procedure sp_send_mail_ofb_reminder As
        v_is_sun_mon Varchar2(3);
    Begin

        Select
            to_char(sysdate, 'DY', 'NLS_DATE_LANGUAGE=ENGLISH')
        Into
            v_is_sun_mon
        From
            dual;

        If v_is_sun_mon In ('SUN', 'MON') Then
            Return;
        End If;
        pkg_ofb_mail.send_mail_reminder;
    End;

    Procedure sp_send_mail_annual_evaluation_hod_pending As
        v_is_monday     Varchar2(3);
    Begin

        Select
            to_char(sysdate, 'DY', 'NLS_DATE_LANGUAGE=ENGLISH')
        Into
            v_is_monday
        From
            dual;

        If v_is_monday != 'MON' Then
            Return;
        End If;

        pkg_dg_mail.sp_send_reminder_annual_evaluation_pending_hod;        
        
    End;

End task_scheduler;