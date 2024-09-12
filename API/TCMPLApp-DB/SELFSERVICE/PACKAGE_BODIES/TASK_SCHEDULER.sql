Create Or Replace Package Body selfservice.task_scheduler As

    Procedure sp_daily_swp_add_nu_joinees As
    Begin
        iot_swp_config_week.sp_add_new_joinees_to_pws;
    End;

    Procedure sp_daily_swp_config_week As
    Begin
        iot_swp_config_week.sp_configuration;
    End;

    Procedure sp_remove_ex_emp_from_userids
    As
    Begin
        Delete
            From userids
        Where
            empno In (
                Select
                    empno
                From
                    ss_emplmast
                Where
                    status = 0
            );
    End;

    Procedure sp_daily_swp_sendmail As
    Begin
        iot_swp_config_week.sp_configuration;
        iot_swp_mail.sp_send_to_ows_absent_emp;
        iot_swp_mail.sp_send_to_sws_absent_emp;
    End;

End task_scheduler;