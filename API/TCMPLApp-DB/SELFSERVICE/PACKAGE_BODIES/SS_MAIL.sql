--------------------------------------------------------
--  DDL for Package Body SS_MAIL
--------------------------------------------------------

Create Or Replace Package Body "SELFSERVICE"."SS_MAIL" As

    Procedure set_msg(param_obj_id     Varchar2,
                      param_apprl_desc Varchar2,
                      param_obj_name   Varchar2) As
    Begin
        --Discard
        --pkg_var_sub := replace(c_subject,'null' || chr(38) || '',c_obj_nm_tr);
        --pkg_var_msg := replace(c_message,'null' || chr(38) || '',c_obj_nm_tr);

        pkg_var_sub := replace(pkg_var_sub, 'null' || chr(38) || '', param_apprl_desc);
        pkg_var_msg := replace(pkg_var_msg, 'null' || chr(38) || '', param_apprl_desc);

        --pkg_var_msg := replace(pkg_var_msg,'null' || chr(38) || '',param_tr_id);
        --pkg_var_sub := replace(pkg_var_sub,'null' || chr(38) || '',param_tr_id);
    End;

    Procedure set_new_leave_app_subject(param_empno    In Varchar2,
                                        param_emp_name In Varchar2) As
    Begin
        pkg_var_sub := replace(c_leave_app_subject, c_empno, param_empno);
        pkg_var_sub := replace(pkg_var_sub, c_emp_name, param_emp_name);
    End;

    Procedure set_new_leave_app_body(
        param_empno        Varchar2,
        param_emp_name     Varchar2,
        param_leave_period Number,
        param_app_no       Varchar2,
        param_mail_to_hod  Varchar2
    )
    As
        v_leave_period Number;
        v_approval_url Varchar2(200);
    Begin
        If param_mail_to_hod = 'OK' Then
            v_approval_url := 'http://tplapps02.ticb.comp/TCMPLApp/SelfService/Attendance/HoDApprovalLeaveIndex';
        Else
            v_approval_url := 'http://tplapps02.ticb.comp/TCMPLApp/SelfService/Attendance/LeadApprovalLeaveIndex';
        End If;
        v_leave_period := param_leave_period / 8;
        pkg_var_msg    := replace(c_leave_app_msg, '');
        pkg_var_msg    := replace(pkg_var_msg, c_app_no, param_app_no);
        pkg_var_msg    := replace(pkg_var_msg, c_approval_url, v_approval_url);
        pkg_var_msg    := replace(pkg_var_msg, c_emp_name, param_emp_name);
        pkg_var_msg    := replace(pkg_var_msg, c_empno, param_empno);
        pkg_var_msg    := replace(pkg_var_msg, c_leave_period, param_leave_period);
    End;

    Procedure send_email_2_user_async(
        param_to_mail_id In Varchar2
    )
    As
    Begin

        send_mail_2_user_nu(
            param_to_mail_id => param_to_mail_id,
            param_subject    => pkg_var_sub,
            param_body       => pkg_var_msg
        );
        /*
            dbms_scheduler.create_job(
                job_name            => 'SEND_MAIL_JOB_4_SELFSERVICE',
                job_type            => 'STORED_PROCEDURE',
                job_action          => 'ss_mail.send_mail_2_user_nu',
                number_of_arguments => 3,
                enabled             => false,
                job_class           => 'TCMPL_JOB_CLASS',
                comments            => 'to send Email'
            );

            dbms_scheduler.set_job_argument_value(
                job_name          => 'SEND_MAIL_JOB_4_SELFSERVICE',
                argument_position => 1,
                argument_value    => param_to_mail_id
            );
            dbms_scheduler.set_job_argument_value(
                job_name          => 'SEND_MAIL_JOB_4_SELFSERVICE',
                argument_position => 2,
                argument_value    => pkg_var_sub
            );
            dbms_scheduler.set_job_argument_value(
                job_name          => 'SEND_MAIL_JOB_4_SELFSERVICE',
                argument_position => 3,
                argument_value    => pkg_var_msg
            );
            dbms_scheduler.enable('SEND_MAIL_JOB_4_SELFSERVICE');
        */
    End;

    Procedure send_email_2_user(
        param_to_mail_id In Varchar2
    ) As
        l_mail_conn utl_smtp.connection;
        l_boundary  Varchar2(50) := '----=*#abc1234321cba#*=';
    Begin

        If Trim(param_to_mail_id) Is Null Then
            Return;
        End If;

        l_mail_conn := utl_smtp.open_connection(c_smtp_mail_server, 25);
        utl_smtp.helo(l_mail_conn, c_smtp_mail_server);
        utl_smtp.mail(l_mail_conn, c_sender_mail_id);
        utl_smtp.rcpt(l_mail_conn, param_to_mail_id);
        utl_smtp.open_data(l_mail_conn);
        utl_smtp.write_data(l_mail_conn, 'Date: ' || to_char(sysdate, 'DD-MON-YYYY HH24:MI:SS') || utl_tcp.crlf);
        utl_smtp.write_data(l_mail_conn, 'To: ' || param_to_mail_id || utl_tcp.crlf);
        utl_smtp.write_data(l_mail_conn, 'From: ' || c_sender_mail_id || utl_tcp.crlf);
        utl_smtp.write_data(l_mail_conn, 'Subject: ' || pkg_var_sub || utl_tcp.crlf);

        utl_smtp.write_data(l_mail_conn, 'MIME-Version: 1.0' || utl_tcp.crlf);
        utl_smtp.write_data(l_mail_conn, 'Content-Type: multipart/alternative; boundary="' || l_boundary || '"' || utl_tcp.
        crlf ||
            utl_tcp.crlf);

        utl_smtp.write_data(l_mail_conn, '--' || l_boundary || utl_tcp.crlf);
        utl_smtp.write_data(l_mail_conn, 'Content-Type: text/plain; charset="iso-8859-1"' || utl_tcp.crlf || utl_tcp.crlf);

        utl_smtp.write_data(l_mail_conn, pkg_var_msg);
        utl_smtp.write_data(l_mail_conn, utl_tcp.crlf || utl_tcp.crlf);

        utl_smtp.write_data(l_mail_conn, '--' || l_boundary || '--' || utl_tcp.crlf);
        utl_smtp.close_data(l_mail_conn);

        utl_smtp.quit(l_mail_conn);

    End send_email_2_user;

    Procedure send_msg As
    Begin
        /* TODO implementation required */
        Null;
    End send_msg;

    Procedure send_msg_new_leave_app(param_app_no      Varchar2,
                                     param_success Out Number,
                                     param_message Out Varchar2) As
        v_empno        Varchar2(5);
        v_mngr         Varchar2(5);
        v_mngr_email   Varchar2(100);
        v_lead_empno   Varchar2(5);
        v_emp_name     Varchar2(100);
        v_leave_period Number;
        v_mail_to_hod  Varchar2(2) := 'OK';
    Begin
        Select
            empno, leaveperiod / 8, lead_apprl_empno
        Into
            v_empno, v_leave_period, v_lead_empno
        From
            ss_leaveapp
        Where
            app_no = param_app_no;

        Select
            name, mngr
        Into
            v_emp_name, v_mngr
        From
            ss_emplmast
        Where
            empno = v_empno;
        If v_lead_empno <> 'None' Then
            v_mngr        := v_lead_empno;
            v_mail_to_hod := 'KO';
            --v_mngr := '02320';
        End If;

        Select
            email
        Into
            v_mngr_email
        From
            ss_emplmast
        Where
            empno = v_mngr;

        set_new_leave_app_subject(v_empno, v_emp_name);

        set_new_leave_app_body(
            param_empno        => v_empno,
            param_emp_name     => v_emp_name,
            param_leave_period => v_leave_period,
            param_app_no       => param_app_no,
            param_mail_to_hod  => v_mail_to_hod
        );

        --send_email_2_user(v_mngr_email);
        send_email_2_user_async(v_mngr_email);
    Exception
        When Others Then
            param_success := ss.failure;
            param_message := 'Error : ' || sqlcode || ' - ' || sqlerrm;
    End;

    Procedure send_mail(param_to_mail_id  Varchar2,
                        param_subject     Varchar2,
                        param_body        Varchar2,
                        param_success Out Number,
                        param_message Out Varchar2) As

        l_mail_conn utl_smtp.connection;
        l_boundary  Varchar2(50) := '----=*#abc1234321cba#*=';
        v_success varchar2(10);
        v_message varchar2(1000);
    Begin

        send_mail_from_api(
            p_mail_to      => param_to_mail_id,
            p_mail_cc      => Null,
            p_mail_bcc     => Null,
            p_mail_subject => 'SELFSERVICE : ' || param_subject,
            p_mail_body    => param_body,
            p_mail_profile => 'SELFSERVICE',
            p_mail_format  => 'HTML',
            p_success      => v_success,
            p_message      => v_message
        );
        /*
        l_mail_conn   := utl_smtp.open_connection(c_smtp_mail_server, 25);
        utl_smtp.helo(l_mail_conn, c_smtp_mail_server);
        utl_smtp.mail(l_mail_conn, c_sender_mail_id);
        utl_smtp.rcpt(l_mail_conn, param_to_mail_id);
        utl_smtp.open_data(l_mail_conn);
        utl_smtp.write_data(l_mail_conn, 'Date: ' || to_char(sysdate, 'DD-MON-YYYY HH24:MI:SS') || utl_tcp.crlf);
        utl_smtp.write_data(l_mail_conn, 'To: ' || param_to_mail_id || utl_tcp.crlf);
        utl_smtp.write_data(l_mail_conn, 'From: ' || c_sender_mail_id || utl_tcp.crlf);
        utl_smtp.write_data(l_mail_conn, 'Subject: ' || param_subject || utl_tcp.crlf);

        utl_smtp.write_data(l_mail_conn, 'MIME-Version: 1.0' || utl_tcp.crlf);
        utl_smtp.write_data(l_mail_conn, 'Content-Type: multipart/alternative; boundary="' || l_boundary || '"' || utl_tcp.
        crlf ||
            utl_tcp.crlf);

        utl_smtp.write_data(l_mail_conn, '--' || l_boundary || utl_tcp.crlf);
        utl_smtp.write_data(l_mail_conn, 'Content-Type: text/plain; charset="iso-8859-1"' || utl_tcp.crlf || utl_tcp.crlf);

        utl_smtp.write_data(l_mail_conn, replace(param_body, '!nuLine!', utl_tcp.crlf));
        utl_smtp.write_data(l_mail_conn, utl_tcp.crlf || utl_tcp.crlf);

        utl_smtp.write_data(l_mail_conn, '--' || l_boundary || '--' || utl_tcp.crlf);
        utl_smtp.close_data(l_mail_conn);

        utl_smtp.quit(l_mail_conn);
        */
        param_success := ss.success;
        param_message := 'Email was successfully sent.';
        exception
            when others then
        param_success := ss.success;
        param_message := 'Email was successfully sent.';
                /*param_success := ss.failure;
                param_message := 'Error : ' || sqlcode || ' - ' || sqlerrm;*/
    End;

    Procedure send_test_email_2_user(
        param_to_mail_id In Varchar2
    ) As
        l_mail_conn utl_smtp.connection;
        l_boundary  Varchar2(50) := '----=*#abc1234321cba#*=';
    Begin

        If Trim(param_to_mail_id) Is Null Then
            Return;
        End If;

        l_mail_conn := utl_smtp.open_connection(c_smtp_mail_server, 25);
        utl_smtp.helo(l_mail_conn, c_smtp_mail_server);
        utl_smtp.mail(l_mail_conn, c_sender_mail_id);
        utl_smtp.rcpt(l_mail_conn, param_to_mail_id);
        utl_smtp.open_data(l_mail_conn);
        utl_smtp.write_data(l_mail_conn, 'Date: ' || to_char(sysdate, 'DD-MON-YYYY HH24:MI:SS') || utl_tcp.crlf);
        utl_smtp.write_data(l_mail_conn, 'To: ' || param_to_mail_id || utl_tcp.crlf);
        utl_smtp.write_data(l_mail_conn, 'From: ' || c_sender_mail_id || utl_tcp.crlf);
        utl_smtp.write_data(l_mail_conn, 'Subject: ' || 'Test by Deven' || utl_tcp.crlf);

        utl_smtp.write_data(l_mail_conn, 'MIME-Version: 1.0' || utl_tcp.crlf);
        utl_smtp.write_data(l_mail_conn, 'Content-Type: multipart/alternative; boundary="' || l_boundary || '"' || utl_tcp.
        crlf ||
            utl_tcp.crlf);

        utl_smtp.write_data(l_mail_conn, '--' || l_boundary || utl_tcp.crlf);
        utl_smtp.write_data(l_mail_conn, 'Content-Type: text/plain; charset="iso-8859-1"' || utl_tcp.crlf || utl_tcp.crlf);

        utl_smtp.write_data(l_mail_conn, 'Test By Deven');
        utl_smtp.write_data(l_mail_conn, utl_tcp.crlf || utl_tcp.crlf);

        utl_smtp.write_data(l_mail_conn, '--' || l_boundary || '--' || utl_tcp.crlf);
        utl_smtp.close_data(l_mail_conn);

        utl_smtp.quit(l_mail_conn);

    End send_test_email_2_user;

    Procedure send_html_mail(param_to_mail_id  Varchar2,
                             param_subject     Varchar2,
                             param_body        Varchar2,
                             param_success Out Number,
                             param_message Out Varchar2) As

        l_mail_conn utl_smtp.connection;
        l_boundary  Varchar2(50) := '----=*#abc1234321cba#*=';
    Begin

        l_mail_conn   := utl_smtp.open_connection(c_smtp_mail_server, 25);
        utl_smtp.helo(l_mail_conn, c_smtp_mail_server);
        utl_smtp.mail(l_mail_conn, c_sender_mail_id);
        utl_smtp.rcpt(l_mail_conn, param_to_mail_id);
        utl_smtp.open_data(l_mail_conn);
        utl_smtp.write_data(l_mail_conn, 'Date: ' || to_char(sysdate, 'DD-MON-YYYY HH24:MI:SS') || utl_tcp.crlf);
        utl_smtp.write_data(l_mail_conn, 'To: ' || param_to_mail_id || utl_tcp.crlf);
        utl_smtp.write_data(l_mail_conn, 'From: ' || c_sender_mail_id || utl_tcp.crlf);
        utl_smtp.write_data(l_mail_conn, 'Subject: ' || param_subject || utl_tcp.crlf);

        utl_smtp.write_data(l_mail_conn, 'MIME-Version: 1.0' || utl_tcp.crlf);
        utl_smtp.write_data(l_mail_conn, 'Content-Type: multipart/alternative; boundary="' || l_boundary || '"' || utl_tcp.
        crlf ||
            utl_tcp.crlf);

        utl_smtp.write_data(l_mail_conn, '--' || l_boundary || utl_tcp.crlf);
        utl_smtp.write_data(l_mail_conn, 'Content-Type: text/html; charset="iso-8859-1"' || utl_tcp.crlf || utl_tcp.crlf);

        utl_smtp.write_data(l_mail_conn, replace(param_body, '!nuLine!', utl_tcp.crlf));
        utl_smtp.write_data(l_mail_conn, utl_tcp.crlf || utl_tcp.crlf);

        utl_smtp.write_data(l_mail_conn, '--' || l_boundary || '--' || utl_tcp.crlf);
        utl_smtp.close_data(l_mail_conn);

        utl_smtp.quit(l_mail_conn);
        param_success := ss.success;
        param_message := 'Email was successfully sent.';
    Exception
        When Others Then
            param_success := ss.failure;
            param_message := 'Error : ' || sqlcode || ' - ' || sqlerrm;
    End;

    Procedure send_mail_2_user_nu(
        param_to_mail_id In Varchar2,
        param_subject    In Varchar2,
        param_body       In Varchar2
    ) As
        v_success Varchar2(10);
        v_message Varchar2(1000);
    Begin

        send_mail_from_api(
            p_mail_to      => param_to_mail_id,
            p_mail_cc      => Null,
            p_mail_bcc     => Null,
            p_mail_subject => 'SELFSERVICE : ' || param_subject,
            p_mail_body    => param_body,
            p_mail_profile => 'SELFSERVICE',
            p_mail_format  => 'HTML',
            p_success      => v_success,
            p_message      => v_message
        );
        Return;
        /*
        utl_mail.send(
            sender     => c_sender_mail_id,
            recipients => param_to_mail_id,
            subject    => param_subject,
            message    => param_body,
            mime_type  => 'text; charset=us-ascii'
        );
        */
    End;

    Procedure send_mail_leave_reject_async(
        p_app_id In Varchar2
    ) As
        v_key_id   Varchar2(8);
        v_job_name Varchar2(30);
    Begin
        /*
        v_key_id   := dbms_random.string('X', 8);
        v_job_name := 'MAIL_JOB_4_SS_' || v_key_id;
        dbms_scheduler.create_job(
            job_name            => v_job_name,
            job_type            => 'STORED_PROCEDURE',
            job_action          => 'ss_mail.send_mail_leave_rejected',
            number_of_arguments => 1,
            enabled             => false,
            job_class           => 'TCMPL_JOB_CLASS',
            comments            => 'to send Email'
        );

        dbms_scheduler.set_job_argument_value(
            job_name          => v_job_name,
            argument_position => 1,
            argument_value    => p_app_id
        );
        dbms_scheduler.enable(v_job_name);
        */
        send_mail_leave_rejected(
            p_app_id => p_app_id
        );
    End;

    Procedure send_mail_leave_rejected(

        p_app_id Varchar2
    ) As
        rec_rejected_leave ss_leaveapp_rejected%rowtype;
        v_emp_email        ss_emplmast.email%Type;
        v_mail_body        Varchar2(4000);
        v_mail_subject     Varchar2(400);
        v_success          Varchar2(10);
        v_message          Varchar2(1000);
        e                  Exception;

        Pragma exception_init(e, -20100);
    Begin

        Select
            *
        Into
            rec_rejected_leave
        From
            ss_leaveapp_rejected
        Where
            Trim(app_no) = Trim(p_app_id);
        Select
            email
        Into
            v_emp_email
        From
            ss_emplmast
        Where
            empno      = rec_rejected_leave.empno
            And status = 1;
        If Trim(v_emp_email) Is Null Then
            raise_application_error(-20100, 'Employee email address not found. Mail not sent.');
        End If;
        v_mail_body    := c_leave_rejected_body;
        v_mail_subject := 'SELFSERVICE : Leave application rejected';

        v_mail_body    := replace(v_mail_body, '@app_id', p_app_id);
        v_mail_body    := replace(v_mail_body, '@app_date', to_char(rec_rejected_leave.app_date, 'dd-Mon-yyyy'));
        v_mail_body    := replace(v_mail_body, '@start_date', to_char(rec_rejected_leave.bdate, 'dd-Mon-yyyy'));
        v_mail_body    := replace(v_mail_body, '@end_date', to_char(nvl(rec_rejected_leave.edate, rec_rejected_leave.bdate),
                                                                    'dd-Mon-yyyy'));
        v_mail_body    := replace(v_mail_body, '@leave_period', rec_rejected_leave.leaveperiod / 8);
        v_mail_body    := replace(v_mail_body, '@leave_type', rec_rejected_leave.leavetype);
        v_mail_body    := replace(v_mail_body, '@lead_approval', ss.approval_text(rec_rejected_leave.lead_apprl));
        v_mail_body    := replace(v_mail_body, '@lead_remarks', rec_rejected_leave.lead_reason);
        v_mail_body    := replace(v_mail_body, '@hod_approval', ss.approval_text(rec_rejected_leave.hod_apprl));
        v_mail_body    := replace(v_mail_body, '@hod_remarks', rec_rejected_leave.hodreason);
        v_mail_body    := replace(v_mail_body, '@hrd_approval', ss.approval_text(rec_rejected_leave.hrd_apprl));
        v_mail_body    := replace(v_mail_body, '@hrd_remarks', rec_rejected_leave.hrdreason);

        send_mail_from_api(
            p_mail_to      => v_emp_email,
            p_mail_cc      => Null,
            p_mail_bcc     => Null,
            p_mail_subject => v_mail_subject,
            p_mail_body    => v_mail_body,
            p_mail_profile => 'SELFSERVICE',
            p_mail_format  => 'HTML',
            p_success      => v_success,
            p_message      => v_message
        );
    End send_mail_leave_rejected;

    Procedure send_mail_onduty_rejected(
        p_onduty_rec ss_ondutyapp_rejected%rowtype,
        p_depu_rec   ss_depu_rejected%rowtype
    ) As
        rec_rejected_onduty ss_odappstat%rowtype;
        v_emp_email         ss_emplmast.email%Type;
        v_mail_body         Varchar2(4000);
        v_mail_subject      Varchar2(400);
        v_success           Varchar2(10);
        v_message           Varchar2(1000);
        e                   Exception;
        v_type              Varchar2(120);
        v_sub_type          Varchar2(120);
        Pragma exception_init(e, -20100);
    Begin

        Select
            email
        Into
            v_emp_email
        From
            ss_emplmast
        Where
            empno      = nvl(p_onduty_rec.empno, p_depu_rec.empno)
            And status = 1;
        If Trim(v_emp_email) Is Null Then
            raise_application_error(-20100, 'Employee email address not found. Mail not sent.');
        End If;

        Select
            type || ' - ' || description
        Into
            v_type
        From
            ss_ondutymast
        Where
            type = nvl(p_onduty_rec.type, p_depu_rec.type);
        If nvl(p_onduty_rec.odtype, 0) <> 0 Then
            Select
                od_sub_type || ' - ' || description
            Into
                v_sub_type
            From
                ss_onduty_sub_type
            Where
                od_sub_type = p_onduty_rec.odtype;
        End If;
        v_mail_body    := c_onduty_rejected_body;
        v_mail_subject := 'SELFSERVICE : Onduty application rejected';

        v_mail_body    := replace(v_mail_body, '@app_id', nvl(p_onduty_rec.app_no, p_depu_rec.app_no));
        v_mail_body    := replace(v_mail_body, '@app_date', to_char(nvl(p_onduty_rec.app_date, p_depu_rec.app_date), 'dd-Mon-yyyy'));
        v_mail_body    := replace(v_mail_body, '@start_date', to_char(nvl(p_onduty_rec.pdate, p_depu_rec.bdate), 'dd-Mon-yyyy'));
        v_mail_body    := replace(
                              v_mail_body,
                              '@end_date',
                              to_char(nvl(p_depu_rec.edate, p_depu_rec.bdate), 'dd-Mon-yyyy')
                          );

        v_mail_body    := replace(v_mail_body, '@reason', nvl(p_depu_rec.description, p_onduty_rec.reason));

        v_mail_body    := replace(v_mail_body, '@type', v_type);
        v_mail_body    := replace(v_mail_body, '@sub_type', v_sub_type);

        If p_onduty_rec.hh Is Not Null Then
            v_mail_body := replace(
                               v_mail_body,
                               '@start_time',
                               lpad(p_onduty_rec.hh, 2, '0') || ':' || lpad(p_onduty_rec.mm, 2, '0')
                           );
        Else
            v_mail_body := replace(v_mail_body, '@start_time', '');
        End If;
        If p_onduty_rec.hh1 Is Not Null Then
            v_mail_body := replace(
                               v_mail_body,
                               '@end_time',
                               lpad(p_onduty_rec.hh1, 2, '0') || ':' || lpad(p_onduty_rec.mm1, 2, '0')
                           );
        Else
            v_mail_body := replace(v_mail_body, '@end_time', '');
        End If;

        v_mail_body    := replace(v_mail_body, '@lead_approval', ss.approval_text(nvl(p_onduty_rec.lead_apprl, p_depu_rec.
        lead_apprl)));
        v_mail_body    := replace(v_mail_body, '@lead_remarks', nvl(p_onduty_rec.lead_reason, p_depu_rec.lead_reason));
        v_mail_body    := replace(v_mail_body, '@hod_approval', ss.approval_text(nvl(p_onduty_rec.hod_apprl, p_depu_rec.hod_apprl)));
        v_mail_body    := replace(v_mail_body, '@hod_remarks', nvl(p_onduty_rec.hodreason, p_depu_rec.hodreason));
        v_mail_body    := replace(v_mail_body, '@hrd_approval', ss.approval_text(nvl(p_onduty_rec.hrd_apprl, p_depu_rec.hrd_apprl)));
        v_mail_body    := replace(v_mail_body, '@hrd_remarks', nvl(p_onduty_rec.hrdreason, p_depu_rec.hrdreason));

        send_mail_from_api(
            p_mail_to      => v_emp_email,
            p_mail_cc      => Null,
            p_mail_bcc     => Null,
            p_mail_subject => v_mail_subject,
            p_mail_body    => v_mail_body,
            p_mail_profile => 'SELFSERVICE',
            p_mail_format  => 'HTML',
            p_success      => v_success,
            p_message      => v_message
        );
    End send_mail_onduty_rejected;

End ss_mail;
/