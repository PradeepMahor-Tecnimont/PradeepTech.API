create or replace Package Body tcmpl_afc.pkg_bg_job_scheduler As

    Procedure sp_bg_check_4_notification(
        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        Cursor cur_bg Is
            Select
                ma.refnum,
                lpad(Max(To_Number(amendmentnum)), 3, '0') amendmentnum,
                Max(pkg_bg_main_status_qry.sp_bg_get_current_status(
                        ma.refnum, ma.amendmentnum))       status_type_id
            From
                bg_main_amendments ma

            Where
                refnum In (
                    Select
                        refnum
                    From
                        bg_main_master
                    Where
                        trunc(bgvaldt) > trunc(sysdate)
                        And isdelete = 0
                )
            Group By
                refnum;

        v_status_type_id bg_main_status.status_type_id%Type;
        v_months_between Number;
        v_days_between   Number;
        v_projno         bg_main_master.projnum%Type;
        v_compid         bg_main_master.compid%Type;
        v_expiry_param   Varchar2(20);
    Begin
        For c1 In cur_bg
        Loop
            If c1.status_type_id = c_s01 Then
                Select
                    months_between(bgvaldt, sysdate), projnum, compid
                Into
                    v_months_between, v_projno, v_compid
                From
                    bg_main_master
                Where
                    refnum       = c1.refnum
                    And isdelete = 0;

                If v_months_between = c_4 Then
                    pkg_bg_main_status.sp_bg_status_add(
                        p_refnum         => c1.refnum,
                        p_amendmentnum   => c1.amendmentnum,
                        p_status_type_id => c_s02,
                        p_message_type   => p_message_type,
                        p_message_text   => p_message_text
                    );

                    v_expiry_param := c_4_months;
                    pkg_bg_send_mail.proc_notification_mail(
                        p_refnum       => c1.refnum,
                        p_projno       => v_projno,
                        p_compid       => v_compid,
                        p_expiry_param => v_expiry_param,
                        p_message_type => p_message_type,
                        p_message_text => p_message_text);

                End If;
            Elsif c1.status_type_id = c_s02 Then
                Select
                    trunc(bgvaldt) - trunc(sysdate)
                Into
                    v_days_between
                From
                    bg_main_master
                Where
                    refnum       = c1.refnum
                    And isdelete = 0;

                If v_days_between = c_30 Then
                    pkg_bg_main_status.sp_bg_status_add(
                        p_refnum         => c1.refnum,
                        p_amendmentnum   => c1.amendmentnum,
                        p_status_type_id => c_s03,
                        p_message_type   => p_message_type,
                        p_message_text   => p_message_text
                    );

                    v_expiry_param := c_30_days;
                    pkg_bg_send_mail.proc_notification_mail(
                        p_refnum       => c1.refnum,
                        p_projno       => v_projno,
                        p_compid       => v_compid,
                        p_expiry_param => v_expiry_param,
                        p_message_type => p_message_type,
                        p_message_text => p_message_text);

                End If;
            End If;

        End Loop;

        p_message_type := 'OK';
        p_message_text := 'Job executed successfully.';

    End sp_bg_check_4_notification;

End pkg_bg_job_scheduler;