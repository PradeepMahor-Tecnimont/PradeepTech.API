--------------------------------------------------------
--  File created - Sunday-April-24-2022   
--------------------------------------------------------
---------------------------
--Changed PACKAGE
--SWP_VACCINEDATE
---------------------------
CREATE OR REPLACE PACKAGE "SELFSERVICE"."SWP_VACCINEDATE" As

    Procedure add_new(
        param_win_uid      Varchar2,
        param_vaccine_type Varchar2,
        param_first_jab    Date,
        param_second_jab   Date,
        param_success Out  Varchar2,
        param_message Out  Varchar2
    );

    Procedure add_emp_vaccine_dates(
        param_win_uid         Varchar2,
        param_vaccine_type    Varchar2,
        param_for_empno       Varchar2,
        param_first_jab_date  Date,
        param_second_jab_date Date Default Null,
        param_booster_jab_date Date Default Null,
        param_success Out     Varchar2,
        param_message Out     Varchar2
    );

    Procedure update_second_jab(
        param_win_uid     Varchar2,
        param_second_jab  Date,
        param_success Out Varchar2,
        param_message Out Varchar2
    );

    Procedure delete_emp_vaccine_dates(
        param_empno       Varchar2,
        param_hr_win_uid  Varchar2,
        param_success Out Varchar2,
        param_message Out Varchar2
    );

    Procedure update_vaccine_type(
        param_win_uid      Varchar2,
        param_vaccine_type Varchar2,
        param_second_jab   Date,
        param_success Out  Varchar2,
        param_message Out  Varchar2
    );

    Procedure update_emp_second_jab(
        param_win_uid         Varchar2,
        param_for_empno       Varchar2,
        param_second_jab_date Date,
        param_success Out     Varchar2,
        param_message Out     Varchar2
    );
    Procedure update_emp_jab(
        param_win_uid          Varchar2,
        param_for_empno        Varchar2,
        param_second_jab_date  Date,
        param_booster_jab_date Date,
        param_success Out      Varchar2,
        param_message Out      Varchar2
    );

    Procedure update_self_jab(
        param_win_uid          Varchar2,

        param_second_jab_date  Date,
        param_booster_jab_date Date,
        param_success Out      Varchar2,
        param_message Out      Varchar2
    );
End swp_vaccinedate;
/
---------------------------
--Changed PACKAGE BODY
--SS_MAIL
---------------------------
CREATE OR REPLACE PACKAGE BODY "SELFSERVICE"."SS_MAIL" As

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
        v_mngr_email   Varchar2(60);
        v_lead_empno   Varchar2(5);
        v_emp_name     Varchar2(60);
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
        utl_smtp.write_data(l_mail_conn, 'Content-Type: text/plain; charset="iso-8859-1"' || utl_tcp.crlf || utl_tcp.crlf);

        utl_smtp.write_data(l_mail_conn, replace(param_body, '!nuLine!', utl_tcp.crlf));
        utl_smtp.write_data(l_mail_conn, utl_tcp.crlf || utl_tcp.crlf);

        utl_smtp.write_data(l_mail_conn, '--' || l_boundary || '--' || utl_tcp.crlf);
        utl_smtp.close_data(l_mail_conn);

        utl_smtp.quit(l_mail_conn);
        param_success := ss.success;
        param_message := 'Email was successfully sent.';
        /*exception
            when others then
                param_success := ss.failure;
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
            p_mail_subject => 'SELFSERVICE : ' + param_subject,
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

End ss_mail;
/
---------------------------
--Changed PACKAGE BODY
--SWP_VACCINE_REMINDER
---------------------------
CREATE OR REPLACE PACKAGE BODY "SELFSERVICE"."SWP_VACCINE_REMINDER" As

    Procedure remind_vaccine_type_not_update As

        Cursor cur_vaccine_type_null Is
            Select
                group_id,
                Listagg(user_email, ';') Within
                    Group (Order By
                        empno) email_csv_list
            From
                (
                    Select
                        e.empno,
                        e.name,
                        replace(e.email, ',', '.')                       user_email,
                        ceil((Row_Number() Over(Order By e.empno)) / 50) group_id
                    From
                        ss_emplmast       e,
                        swp_vaccine_dates v
                    Where
                        e.empno      = v.empno
                        And e.status = 1
                        And e.parent <> '0187'
                        And v.vaccine_type Is Null
                        And e.email Is Not Null
                        And e.empno Not In ('04132', '04600')
                    Order By e.empno
                )
            Group By
                group_id;

        Type typ_tab_vaccine_type_null Is
            Table Of cur_vaccine_type_null%rowtype;
        tab_vaccine_type_null typ_tab_vaccine_type_null;
        v_count               Number;
        v_mail_csv            Varchar2(2000);
        v_subject             Varchar2(1000);
        v_msg_body            Varchar2(2000);
        v_success             Varchar2(100);
        v_message             Varchar2(500);
    Begin
        v_msg_body := v_mail_body_vaccine_type;
        v_subject  := 'SELFSERVICE : Vaccine type not updated';
        For email_csv_row In cur_vaccine_type_null
        Loop
            v_mail_csv := email_csv_row.email_csv_list;
            send_mail_from_api(
                p_mail_to      => Null,
                p_mail_cc      => Null,
                p_mail_bcc     => v_mail_csv,
                p_mail_subject => v_subject,
                p_mail_body    => v_msg_body,
                p_mail_profile => 'SELFSERVICE',
                --(example --> SQSI, OSD, ALHR, etc...)
                p_mail_format  => 'HTML',
                p_success      => v_success,
                p_message      => v_message
            );

        End Loop;

    End;

    Procedure remind_vaccine_not_done As

        Cursor cur_vaccine_not_done(
            p_date_for_calc Date
        ) Is
            Select
                group_id,
                Listagg(user_email, ';') Within
                    Group (Order By
                        empno) email_csv_list
            From
                (
                    Select
                        e.empno,
                        e.name,
                        replace(e.email, ',', '.')                       user_email,
                        ceil((Row_Number() Over(Order By e.empno)) / 50) group_id
                    From
                        ss_emplmast e
                    Where
                        e.status = 1
                        And e.parent <> '0187'
                        And e.email Is Not Null
                        And e.empno Not In ('04132', '04600')
                        And e.empno Not In (
                            Select
                                empno
                            From
                                swp_vaccine_dates
                        )
                        And e.empno Not In (
                            Select
                                empno
                            From
                                swp_vaccine_covid_emp
                            Group By empno
                            Having
                                ceil(trunc(p_date_for_calc) - trunc(Max(covid_start_date))) < 90
                            Union
                            Select
                                empno
                            From
                                swp_vaccine_pregnent_emp
                        -- Exclude Covid Infected  & Pergnent Employees
                        )
                        And emptype In (
                            'R', 'S', 'C', 'F'
                        )
                    Order By e.empno
                )
            Group By
                group_id;

        v_count         Number;
        v_mail_csv      Varchar2(2000);
        v_subject       Varchar2(500);
        v_msg_body      Varchar2(2000);
        v_success       Varchar2(100);
        v_message       Varchar2(1000);
        v_date_for_calc Date := to_date('5-Sep-2021');
    Begin
        v_msg_body := v_mail_body_no_vaccine_regn;
        v_subject  := 'Vaccine second jab due';
        If trunc(sysdate) > v_date_for_calc Then
            v_msg_body      := v_mail_body_without_vaccine;
            v_date_for_calc := sysdate;
        End If;

        v_subject  := 'SELFSERVICE : Get yourself vaccinated';
        For email_csv_row In cur_vaccine_not_done(v_date_for_calc)
        Loop
            v_mail_csv := email_csv_row.email_csv_list;
            send_mail_from_api(
                p_mail_to      => Null,
                p_mail_cc      => Null,
                p_mail_bcc     => v_mail_csv,
                p_mail_subject => v_subject,
                p_mail_body    => v_msg_body,
                p_mail_profile => 'SELFSERVICE',
                --(example --> SQSI, OSD, ALHR, etc...)
                p_mail_format  => 'HTML',
                p_success      => v_success,
                p_message      => v_message
            );

        End Loop;

    End;

    Procedure remind_covishield_second_jab As

        Cursor cur_vaccine2_pending(
            p_date_for_calc Date
        ) Is
            Select
                group_id,
                Listagg(user_email, ';') Within
                    Group (Order By
                        empno) email_csv_list
            From
                (
                    Select
                        e.empno,
                        e.name,
                        replace(e.email, ',', '.')                       user_email,
                        ceil((Row_Number() Over(Order By e.empno)) / 50) group_id
                    From
                        ss_emplmast       e,
                        swp_vaccine_dates v
                    Where
                        e.empno            = v.empno
                        And e.empno Not In ('04132', '04600')
                        And e.status       = 1
                        And e.parent <> '0187'
                        And e.email Is Not Null
                        And v.vaccine_type = 'COVISHIELD'
                        And (trunc((p_date_for_calc)) - trunc(v.jab1_date)) >= 84
                        And v.jab2_date Is Null
                        And v.empno Not In (
                            Select
                                empno
                            From
                                swp_vaccine_covid_emp
                            Group By empno
                            Having
                                (trunc((p_date_for_calc)) - trunc(Max(covid_start_date))) < 90
                            Union
                            Select
                                empno
                            From
                                swp_vaccine_pregnent_emp

                        -- Exclude Covid Infected  & Pergnent Employees
                        )
                        And v.empno Not In (
                            Select
                                empno
                            From
                                swp_vaccination_office
                            Where
                                trunc((p_date_for_calc)) != trunc(sysdate)
                        -- Exclude registered
                        )
                    Order By e.empno
                )
            Group By
                group_id;

        v_count         Number;
        v_mail_csv      Varchar2(2000);
        v_subject       Varchar2(1000);
        v_msg_body      Varchar2(2000);
        v_success       Varchar2(100);
        v_message       Varchar2(500);
        v_date_for_calc Date := to_date('5-Sep-2021');
    Begin
        v_msg_body := v_mail_body_second_jab_regn;
        v_subject  := 'SELFSERVICE : Vaccine second jab due';
        If trunc(sysdate) > v_date_for_calc Then
            v_date_for_calc := sysdate;
            v_msg_body      := v_mail_body_second_jab;
        End If;

        For email_csv_row In cur_vaccine2_pending(v_date_for_calc)
        Loop
            v_mail_csv := email_csv_row.email_csv_list;
            send_mail_from_api(
                p_mail_to      => Null,
                p_mail_cc      => Null,
                p_mail_bcc     => v_mail_csv,
                p_mail_subject => v_subject,
                p_mail_body    => v_msg_body,
                p_mail_profile => 'SELFSERVICE',
                --(example --> SQSI, OSD, ALHR, etc...)
                p_mail_format  => 'HTML',
                p_success      => v_success,
                p_message      => v_message
            );

        End Loop;

    End;

    Procedure remind_covaxin_second_jab As

        Cursor cur_vaccine_type_null Is
            Select
                group_id,
                Listagg(user_email, ';') Within
                    Group (Order By
                        empno) email_csv_list
            From
                (
                    Select
                        e.empno,
                        e.name,
                        replace(e.email, ',', '.')                       user_email,
                        ceil((Row_Number() Over(Order By e.empno)) / 50) group_id
                    From
                        ss_emplmast       e,
                        swp_vaccine_dates v
                    Where
                        e.empno            = v.empno
                        And e.empno Not In ('04132', '04600')
                        And e.status       = 1
                        And e.parent <> '0187'
                        And e.email Is Not Null
                        And v.vaccine_type = 'COVAXIN'
                        And (trunc(sysdate) - trunc(v.jab1_date)) >= 28
                        And v.empno Not In (
                            Select
                                empno
                            From
                                swp_vaccine_covid_emp
                            Group By empno
                            Having
                                ceil(trunc(sysdate) - trunc(Max(covid_start_date))) < 90
                            Union
                            Select
                                empno
                            From
                                swp_vaccine_pregnent_emp

                        -- Exclude Covid Infected  & Pergnent Employees
                        )
                        And v.jab2_date Is Null
                    Order By e.empno
                )
            Group By
                group_id;

        Type typ_tab_vaccine_type_null Is
            Table Of cur_vaccine_type_null%rowtype;
        tab_vaccine_type_null typ_tab_vaccine_type_null;
        v_count               Number;
        v_mail_csv            Varchar2(2000);
        v_subject             Varchar2(500);
        v_msg_body            Varchar2(2000);
        v_success             Varchar2(100);
        v_message             Varchar2(1000);
    Begin
        v_msg_body := v_mail_body_second_jab;
        v_subject  := 'SELFSERVICE : Vaccine second jab due';
        For email_csv_row In cur_vaccine_type_null
        Loop
            v_mail_csv := email_csv_row.email_csv_list;
            send_mail_from_api(
                p_mail_to      => Null,
                p_mail_cc      => Null,
                p_mail_bcc     => v_mail_csv,
                p_mail_subject => v_subject,
                p_mail_body    => v_msg_body,
                p_mail_profile => 'SELFSERVICE',
                --(example --> SQSI, OSD, ALHR, etc...)
                p_mail_format  => 'HTML',
                p_success      => v_success,
                p_message      => v_message
            );

        End Loop;

    End;

    Procedure remind_training_pending As

        Cursor cur_pending_trainings Is
            Select
                group_id,
                Listagg(user_email, ';') Within
                    Group (Order By
                        empno) email_csv_list
            From
                (
                    Select
                        e.empno,
                        e.name,
                        replace(e.email, ',', '.')                       user_email,
                        ceil((Row_Number() Over(Order By e.empno)) / 50) group_id
                    From
                        ss_emplmast      e,
                        swp_emp_training t
                    Where
                        e.empno      = t.empno
                        And e.empno Not In ('04132', '04600')
                        And e.status = 1
                        And e.parent <> '0187'
                        And e.email Is Not Null
                        And 0 In (t.security, t.sharepoint16, t.onedrive365, t.teams, t.planner)
                    Order By e.empno
                )
            Group By
                group_id;

        v_count    Number;
        v_mail_csv Varchar2(2000);
        v_subject  Varchar2(500);
        v_msg_body Varchar2(2000);
        v_success  Varchar2(100);
        v_message  Varchar2(1000);
    Begin
        v_msg_body := v_mail_body_pend_train;
        v_subject  := 'SELFSERVICE : Smart Working Policy - Mandatory Courses Pending';
        For email_csv_row In cur_pending_trainings
        Loop
            v_mail_csv := email_csv_row.email_csv_list;
            send_mail_from_api(
                p_mail_to      => Null,
                p_mail_cc      => Null,
                p_mail_bcc     => v_mail_csv,
                p_mail_subject => v_subject,
                p_mail_body    => v_msg_body,
                p_mail_profile => 'SELFSERVICE',
                --(example --> SQSI, OSD, ALHR, etc...)
                p_mail_format  => 'HTML',
                p_success      => v_success,
                p_message      => v_message
            );
        End Loop;

    End;

    Procedure send_mail As
    Begin

        remind_vaccine_type_not_update;
        remind_vaccine_not_done;
        remind_covishield_second_jab;
        remind_covaxin_second_jab;

        --remind_training_pending;
    End send_mail;

End swp_vaccine_reminder;
/
---------------------------
--Changed PACKAGE BODY
--SWP_VACCINEDATE
---------------------------
CREATE OR REPLACE PACKAGE BODY "SELFSERVICE"."SWP_VACCINEDATE" As

    Procedure sendmail(
        param_empno Varchar2
    ) As

        v_email         ss_emplmast.email%Type;
        v_name          ss_emplmast.name%Type;
        v_email_body    Varchar2(4000);
        v_email_subject Varchar2(200);
        v_success       Varchar2(10);
        v_message       Varchar2(1000);
    Begin
        Select
            name,
            email
        Into
            v_name,
            v_email
        From
            ss_emplmast
        Where
            empno = param_empno;

        v_email_subject := 'Vaccine Date deletion.';
        v_email_body    := 'Dear User,

Your input in Employee Vaccine Dates has been deleted as it was for a future date.

Please input your actual 1st vaccine date after taking the 1st jab and follow the same for the 2nd vaccine date.';
        v_email_body    := v_email_body || chr(13) || chr(10) || chr(13) || chr(10);

        v_email_body    := v_email_body || 'Thanks,' || chr(13) || chr(10);

        v_email_body    := v_email_body || 'This is an automated TCMPL Mail.';
        If v_email Is Not Null Then
            send_mail_from_api(
                p_mail_to      => v_email,
                p_mail_cc      => Null,
                p_mail_bcc     => Null,
                p_mail_subject => v_email_subject,
                p_mail_body    => v_email_body,
                p_mail_profile => 'SELFSERVICE',
                p_mail_format  => 'Text',
                p_success      => v_success,
                p_message      => v_message
            );
        End If;

    End sendmail;

    Procedure add_new(
        param_win_uid      Varchar2,
        param_vaccine_type Varchar2,
        param_first_jab    Date,
        param_second_jab   Date,
        param_success Out  Varchar2,
        param_message Out  Varchar2
    ) As
        v_empno Char(5);
    Begin
        v_empno       := swp_users.get_empno_from_win_uid(param_win_uid => param_win_uid);
        If v_empno Is Null Then
            param_success := 'KO';
            param_message := 'Error while retrieving EMPNO';
            Return;
        End If;

        Insert Into swp_vaccine_dates (
            empno,
            vaccine_type,
            jab1_date,
            is_jab1_by_office,
            jab2_date,
            is_jab2_by_office,
            modified_on,
            modified_by
        )
        Values (
            v_empno,
            param_vaccine_type,
            param_first_jab,
            'KO',
            param_second_jab,
            'KO',
            sysdate,
            v_empno
        );

        Commit;
        param_success := 'OK';
        param_message := 'Procedure executed successfully';
    Exception
        When Others Then
            param_success := 'KO';
            param_message := 'Err - ' || sqlcode || ' - ' || sqlerrm;
    End add_new;

    Procedure add_emp_vaccine_dates(
        param_win_uid         Varchar2,
        param_vaccine_type    Varchar2,
        param_for_empno       Varchar2,
        param_first_jab_date  Date,
        param_second_jab_date Date default null,
        param_booster_jab_date Date default null,
        param_success Out     Varchar2,
        param_message Out     Varchar2
    ) As
        v_empno Char(5);
        v_second_jab_by_office varchar2(2);
    Begin
        v_empno       := swp_users.get_empno_from_win_uid(param_win_uid => param_win_uid);
        If v_empno Is Null Then
            param_success := 'KO';
            param_message := 'Error while retrieving EMPNO';
            Return;
        End If;
        v_second_jab_by_office := case when param_second_jab_date is null then null else 'KO' end;
        Insert Into swp_vaccine_dates (
            empno,
            vaccine_type,
            jab1_date,
            is_jab1_by_office,
            jab2_date,
            is_jab2_by_office,
            booster_jab_date,
            modified_on,
            modified_by
        )
        Values (
            param_for_empno,
            param_vaccine_type,
            param_first_jab_date,
            'KO',
            param_second_jab_date,
            'KO',
            param_booster_jab_date,
            sysdate,
            v_empno
        );

        Commit;
        param_success := 'OK';
        param_message := 'Procedure executed successfully';
    Exception
        When Others Then
            param_success := 'KO';
            param_message := 'Err - ' || sqlcode || ' - ' || sqlerrm;
    End add_emp_vaccine_dates;

    Procedure update_emp_second_jab(
        param_win_uid         Varchar2,
        param_for_empno       Varchar2,
        param_second_jab_date Date,
        
        param_success Out     Varchar2,
        param_message Out     Varchar2
    ) As
        by_empno Char(5);
    Begin
        by_empno      := swp_users.get_empno_from_win_uid(param_win_uid => param_win_uid);
        If by_empno Is Null Then
            param_success := 'KO';
            param_message := 'Error while retrieving EMPNO';
            Return;
        End If;

        Update
            swp_vaccine_dates
        Set
            jab2_date = param_second_jab_date,
            is_jab2_by_office = 'KO',
            
            modified_on = sysdate,
            modified_by = by_empno
        Where
            empno = param_for_empno;

        If Sql%rowcount = 0 Then
            param_success := 'OK';
            param_message := 'Second Jab info could not be updated.';
            Return;
        End If;

        Commit;
        param_success := 'OK';
        param_message := 'Procedure executed';
    Exception
        When Others Then
            param_success := 'KO';
            param_message := 'Err - ' || sqlcode || ' - ' || sqlerrm;
    End update_emp_second_jab;

    Procedure update_emp_jab(
        param_win_uid         Varchar2,
        param_for_empno       Varchar2,
        param_second_jab_date Date,
        param_booster_jab_date Date,
        param_success Out     Varchar2,
        param_message Out     Varchar2
    ) As
        by_empno Char(5);
    Begin
        by_empno      := swp_users.get_empno_from_win_uid(param_win_uid => param_win_uid);
        If by_empno Is Null Then
            param_success := 'KO';
            param_message := 'Error while retrieving EMPNO';
            Return;
        End If;

        Update
            swp_vaccine_dates
        Set
            jab2_date = param_second_jab_date,
            booster_jab_date = param_booster_jab_date,
            is_jab2_by_office = 'KO',
            modified_on = sysdate,
            modified_by = by_empno
        Where
            empno = param_for_empno;

        If Sql%rowcount = 0 Then
            param_success := 'OK';
            param_message := 'Second Jab info could not be updated.';
            Return;
        End If;

        Commit;
        param_success := 'OK';
        param_message := 'Procedure executed';
    Exception
        When Others Then
            param_success := 'KO';
            param_message := 'Err - ' || sqlcode || ' - ' || sqlerrm;
    End update_emp_jab;

    Procedure update_self_jab(
        param_win_uid         Varchar2,
        
        param_second_jab_date Date,
        param_booster_jab_date Date,
        param_success Out     Varchar2,
        param_message Out     Varchar2
    ) As
        v_empno Char(5);
    Begin
        v_empno      := swp_users.get_empno_from_win_uid(param_win_uid => param_win_uid);
        If v_empno Is Null Then
            param_success := 'KO';
            param_message := 'Error while retrieving EMPNO';
            Return;
        End If;

        Update
            swp_vaccine_dates
        Set
            jab2_date = param_second_jab_date,
            booster_jab_date = param_booster_jab_date,
            is_jab2_by_office = 'KO',
            modified_on = sysdate,
            modified_by = v_empno
        Where
            empno = v_empno;

        If Sql%rowcount = 0 Then
            param_success := 'OK';
            param_message := 'Second Jab info could not be updated.';
            Return;
        End If;

        Commit;
        param_success := 'OK';
        param_message := 'Procedure executed';
    Exception
        When Others Then
            param_success := 'KO';
            param_message := 'Err - ' || sqlcode || ' - ' || sqlerrm;
    End update_self_jab;


    Procedure update_second_jab(
        param_win_uid     Varchar2,
        param_second_jab  Date,
        param_success Out Varchar2,
        param_message Out Varchar2
    ) As
        v_empno Char(5);
    Begin
        v_empno       := swp_users.get_empno_from_win_uid(param_win_uid => param_win_uid);
        If v_empno Is Null Then
            param_success := 'KO';
            param_message := 'Error while retrieving EMPNO';
            Return;
        End If;

        Update
            swp_vaccine_dates
        Set
            jab2_date = param_second_jab,
            is_jab2_by_office = 'KO',
            modified_on = sysdate,
            modified_by = v_empno
        Where
            empno = v_empno;

        If Sql%rowcount = 0 Then
            param_success := 'OK';
            param_message := 'Second Jab info could not be updated.';
            Return;
        End If;

        Commit;
        param_success := 'OK';
        param_message := 'Procedure executed';
    Exception
        When Others Then
            param_success := 'KO';
            param_message := 'Err - ' || sqlcode || ' - ' || sqlerrm;
    End update_second_jab;

    Procedure update_vaccine_type(
        param_win_uid      Varchar2,
        param_vaccine_type Varchar2,
        param_second_jab   Date,
        param_success Out  Varchar2,
        param_message Out  Varchar2
    ) As
        v_empno Char(5);
    Begin
        v_empno       := swp_users.get_empno_from_win_uid(param_win_uid => param_win_uid);
        If v_empno Is Null Then
            param_success := 'KO';
            param_message := 'Error while retrieving EMPNO';
            Return;
        End If;

        Update
            swp_vaccine_dates
        Set
            vaccine_type = param_vaccine_type,
            jab2_date = param_second_jab,
            modified_on = sysdate
        Where
            empno = v_empno;

        If Sql%rowcount = 0 Then
            param_success := 'OK';
            param_message := 'Second Jab info could not be updated.';
            Return;
        End If;

        Commit;
        param_success := 'OK';
        param_message := 'Procedure executed';
    Exception
        When Others Then
            param_success := 'KO';
            param_message := 'Err - ' || sqlcode || ' - ' || sqlerrm;
    End update_vaccine_type;

    Procedure delete_emp_vaccine_dates(
        param_empno       Varchar2,
        param_hr_win_uid  Varchar2,
        param_success Out Varchar2,
        param_message Out Varchar2
    ) As
        --v_empno          Char(5);
        v_hr_empno Char(5);
        v_count    Number;
    Begin
        v_hr_empno    := swp_users.get_empno_from_win_uid(param_win_uid => param_hr_win_uid);
        If v_hr_empno Is Null Then
            param_success := 'KO';
            param_message := 'Error while retrieving HR EMP Detials';
            Return;
        End If;

        Select
            Count(*)
        Into
            v_count
        From
            ss_emplmast
        Where
            empno      = param_empno
            And status = 1;

        If v_hr_empno Is Null Then
            param_success := 'KO';
            param_message := 'Err - Select Employee details not found.';
            Return;
        End If;

        Delete
            From swp_vaccine_dates
        Where
            empno = param_empno;

        If Sql%rowcount = 0 Then
            param_success := 'OK';
            param_message := 'Jab info could not be updated.';
            Return;
        End If;

        Commit;
        sendmail(param_empno);
        param_success := 'OK';
        param_message := 'Procedure executed';
    Exception
        When Others Then
            param_success := 'KO';
            param_message := 'Err - ' || sqlcode || ' - ' || sqlerrm;
    End delete_emp_vaccine_dates;

End swp_vaccinedate;
/
---------------------------
--Changed PACKAGE BODY
--PKG_ABSENT_TS
---------------------------
CREATE OR REPLACE PACKAGE BODY "SELFSERVICE"."PKG_ABSENT_TS" As

    Function get_payslip_month Return Varchar2 Is
        v_payslip_month_rec ss_absent_payslip_period%rowtype;
        v_ret_val           Varchar2(7);
    Begin
        Select
            *
        Into
            v_payslip_month_rec
        From
            ss_absent_payslip_period
        Where
            is_open = 'OK';

        Return v_payslip_month_rec.period;
    Exception
        When Others Then
            Return 'ERR';
    End;

    Procedure check_payslip_month_isopen(
        param_payslip_yyyymm Varchar2,
        param_success Out    Varchar2,
        param_message Out    Varchar2
    ) As
        v_open_payslip_yyyymm Varchar2(10);
    Begin
        v_open_payslip_yyyymm := get_payslip_month;
        If v_open_payslip_yyyymm <> param_payslip_yyyymm Then
            param_success := 'KO';
            param_message := 'Err - Payslip month "' || param_payslip_yyyymm || '" is not open in the system';
            Return;
        Else
            param_success := 'OK';
        End If;

    End;

    Procedure generate_list(
        param_absent_yyyymm  Varchar2,
        param_payslip_yyyymm Varchar2,
        param_empno          Varchar2,
        param_requester      Varchar2,
        param_success Out    Varchar2,
        param_message Out    Varchar2
    ) As

        v_key_id      Varchar2(8);
        v_first_day   Date;
        v_last_day    Date;
        v_requester   Varchar2(5);
        v_param_empno Varchar2(10);
    Begin
        v_first_day   := to_date(param_absent_yyyymm || '01', 'yyyymmdd');
        If param_absent_yyyymm = '202003' Then
            v_last_day := To_Date('20-Mar-2020', 'dd-Mon-yyyy');
        Else
            v_last_day := last_day(v_first_day);
        End If;

        v_key_id      := dbms_random.string('X', 8);
        v_requester   := ss.get_empno(param_requester);
        If param_empno = 'ALL' Then
            v_param_empno := '%';
        Else
            v_param_empno := param_empno || '%';
        End If;

        Delete
            From ss_absent_ts_detail
        Where
            absent_yyyymm      = param_absent_yyyymm
            And payslip_yyyymm = param_payslip_yyyymm
            And empno Like v_param_empno;
        --commit;
        --param_success   := 'OK';
        --return;
        If param_empno = 'ALL' Then
            Delete
                From ss_absent_ts_master
            Where
                absent_yyyymm      = param_absent_yyyymm
                And payslip_yyyymm = param_payslip_yyyymm;

            Insert Into ss_absent_ts_master (
                absent_yyyymm,
                payslip_yyyymm,
                modified_on,
                modified_by,
                key_id
            )
            Values (
                param_absent_yyyymm,
                param_payslip_yyyymm,
                sysdate,
                v_requester,
                v_key_id
            );

        Else
            Select
                key_id
            Into
                v_key_id
            From
                ss_absent_ts_master
            Where
                absent_yyyymm      = param_absent_yyyymm
                And payslip_yyyymm = param_payslip_yyyymm;

        End If;

        Commit;
        Insert Into ss_absent_ts_detail (
            key_id,
            absent_yyyymm,
            payslip_yyyymm,
            empno,
            absent_days,
            cl_bal,
            sl_bal,
            pl_bal,
            co_bal
        )
        Select
            v_key_id,
            param_absent_yyyymm,
            param_payslip_yyyymm,
            empno,
            absent_days,
            closingclbal(
                empno,
                trunc(last_day(to_date(param_payslip_yyyymm, 'yyyymm'))),
                0
            ) cl_bal,
            closingslbal(
                empno,
                trunc(last_day(to_date(param_payslip_yyyymm, 'yyyymm'))),
                0
            ) sl_bal,
            closingplbal(
                empno,
                trunc(last_day(to_date(param_payslip_yyyymm, 'yyyymm'))),
                0
            ) pl_bal,
            closingcobal(
                empno,
                trunc(last_day(to_date(param_payslip_yyyymm, 'yyyymm'))),
                0
            ) co_bal
        From
            (
                Select
                    empno,
                    Listagg(dy, ', ') Within
                        Group (Order By dy) As absent_days
                From
                    (
                        Select
                            a.empno,
                            b.day_no                        dy,
                            is_emp_absent(a.empno, b.tdate) is_emp_absent
                        From
                            ss_emplmast        a,
                            ss_absent_ts_leave b
                        Where
                            b.yyyymm     = Trim(Trim(param_absent_yyyymm))
                            And a.empno  = b.empno
                            And a.status = 1
                            And a.parent Not In (
                                Select
                                    parent
                                From
                                    ss_dept_not_4_absent
                            )
                            And a.emptype In (
                                'R', 'F'
                            )
                            And a.empno Like v_param_empno
                            And b.leave_hrs > 0
                    )
                Where
                    is_emp_absent = 1
                Group By empno
            );

        Commit;
        param_success := 'OK';
    Exception
        When Others Then
            param_success := 'KO';
            param_message := 'Err - ' || sqlcode || ' - ' || sqlerrm;
    End generate_list;

    Procedure generate_nu_list_4_all_emp(
        param_absent_yyyymm  Varchar2,
        param_payslip_yyyymm Varchar2,
        param_requester      Varchar2,
        param_success Out    Varchar2,
        param_message Out    Varchar2
    ) As
    Begin
        check_payslip_month_isopen(
            param_payslip_yyyymm,
            param_success,
            param_message
        );
        If param_success = 'KO' Then
            Return;
        End If;
        Delete
            From ss_absent_as_lop
        Where
            payslip_yyyymm                    = param_payslip_yyyymm
            And to_char(lop_4_date, 'yyyymm') = param_absent_yyyymm;

        pop_timesheet_leave_data(
            param_yyyymm  => param_absent_yyyymm,
            param_success => param_success,
            param_message => param_message
        );
        If param_success = 'KO' Then
            Return;
        End If;
        generate_list(
            param_absent_yyyymm,
            param_payslip_yyyymm,
            'ALL',
            param_requester,
            param_success,
            param_message
        );
    End generate_nu_list_4_all_emp;

    Procedure pop_timesheet_leave_data(
        param_yyyymm      Varchar2,
        param_success Out Varchar2,
        param_message Out Varchar2
    ) As
    Begin
        Delete
            From ss_absent_ts_leave
        Where
            yyyymm = param_yyyymm;

        Insert Into ss_absent_ts_leave (
            yyyymm,
            empno,
            projno,
            wpcode,
            activity,
            day_no,
            tdate,
            leave_hrs
        )
        Select
            yymm,
            empno,
            projno,
            wpcode,
            activity,
            day_no,
            t_date,
            Sum(colvalue)
        From
            (
                Select
                    yymm,
                    empno,
                    projno,
                    wpcode,
                    activity,
                    day_no,
                    to_date(yymm || '-' || day_no, 'yyyymm-dd') t_date,
                    colvalue
                From
                    (
                        With
                            t As (
                                Select
                                    yymm,
                                    empno,
                                    parent,
                                    assign,
                                    a.projno,
                                    wpcode,
                                    activity,
                                    d1,
                                    d2,
                                    d3,
                                    d4,
                                    d5,
                                    d6,
                                    d7,
                                    d8,
                                    d9,
                                    d10,
                                    d11,
                                    d12,
                                    d13,
                                    d14,
                                    d15,
                                    d16,
                                    d17,
                                    d18,
                                    d19,
                                    d20,
                                    d21,
                                    d22,
                                    d23,
                                    d24,
                                    d25,
                                    d26,
                                    d27,
                                    d28,
                                    d29,
                                    d30,
                                    d31
                                From
                                    timecurr.time_daily a,
                                    timecurr.tm_leave   b
                                Where
                                    substr(a.projno, 1, 5) = b.projno
                                    And a.wpcode <> 4
                                    And yymm               = param_yyyymm
                            )
                        Select
                            yymm,
                            empno,
                            parent,
                            assign,
                            projno,
                            wpcode,
                            activity,
                            to_number(replace(col, 'D', '')) day_no,
                            colvalue
                        From
                            t Unpivot (colvalue
                            For col
                            In (d1,
                            d2,
                            d3,
                            d4,
                            d5,
                            d6,
                            d7,
                            d8,
                            d9,
                            d10,
                            d11,
                            d12,
                            d13,
                            d14,
                            d15,
                            d16,
                            d17,
                            d18,
                            d19,
                            d20,
                            d21,
                            d22,
                            d23,
                            d24,
                            d25,
                            d26,
                            d27,
                            d28,
                            d29,
                            d30,
                            d31))
                    )
                Where
                    day_no <= to_number(to_char(last_day(to_date(param_yyyymm, 'yyyymm')), 'dd'))
            )
        --Where
        --colvalue > 0
        Group By
            yymm,
            empno,
            projno,
            wpcode,
            activity,
            day_no,
            t_date;

        Commit;
        param_success := 'OK';
    Exception
        When Others Then
            param_success := 'KO';
            param_message := 'Err - ' || sqlcode || ' - ' || sqlerrm;
    End;

    Procedure update_no_mail_list(
        param_absent_yyyymm      Varchar2,
        param_payslip_yyyymm     Varchar2,
        param_emp_list_4_no_mail Varchar2,
        param_requester          Varchar2,
        param_success Out        Varchar2,
        param_message Out        Varchar2
    ) As
    Begin
        Null;
        check_payslip_month_isopen(
            param_payslip_yyyymm,
            param_success,
            param_message
        );
        If param_success = 'KO' Then
            Return;
        End If;
        If Trim(param_emp_list_4_no_mail) Is Null Then
            param_success := 'KO';
            param_message := 'Err - Employee List for NO-MAIL is blank.';
            Return;
        End If;

        Update
            ss_absent_ts_detail
        Set
            no_mail = Null
        Where
            absent_yyyymm      = param_absent_yyyymm
            And payslip_yyyymm = param_payslip_yyyymm;

        Commit;
        Update
            ss_absent_ts_detail
        Set
            no_mail = 'OK'
        Where
            absent_yyyymm      = param_absent_yyyymm
            And payslip_yyyymm = param_payslip_yyyymm
            And empno In (
                Select
                    column_value empno
                From
                    Table (ss.csv_to_table(param_emp_list_4_no_mail))
            );

        Commit;
        param_success := 'OK';
        param_message := 'Employee List for NO-MAIL successfully updated';
    Exception
        When Others Then
            param_success := 'KO';
            param_message := 'Err - ' || sqlcode || ' - ' || sqlerrm;
            Rollback;
    End;

    Function get_lop(
        param_empno Varchar2,
        param_pdate Date
    ) Return Number Is
        v_lop Number;
    Begin
        Select
            half_full
        Into
            v_lop
        From
            ss_absent_ts_lop
        Where
            empno          = param_empno
            And lop_4_date = param_pdate;

        Return v_lop;
    Exception
        When Others Then
            Return 0;
    End;

    Procedure set_lop_4_emp(
        param_empno          Varchar2,
        param_absent_yyyymm  Varchar2,
        param_payslip_yyyymm Varchar2,
        param_lop_val        Varchar2,
        param_requester      Varchar2,
        param_success Out    Varchar2,
        param_message Out    Varchar2
    ) As

        Cursor c1 Is
            Select
                column_value
            From
                Table (ss.csv_to_table(param_lop_val));

        Type typ_tab Is
            Table Of c1%rowtype Index By Binary_Integer;
        v_tab  typ_tab;
        v_day  Varchar2(5);
        v_lop  Varchar2(5);
        v_cntr Number;
    Begin
        check_payslip_month_isopen(
            param_payslip_yyyymm,
            param_success,
            param_message
        );
        If param_success = 'KO' Then
            Return;
        End If;
        param_success := 'KO';
        v_cntr        := 0;
        For c2 In c1
        Loop
            v_cntr := v_cntr + 1;
            v_day  := lpad(substr(c2.column_value, 1, instr(c2.column_value, '-') - 1), 2, '0');

            v_lop  := substr(c2.column_value, instr(c2.column_value, '-') + 1);

            Insert Into ss_absent_ts_lop (
                empno,
                lop_4_date,
                payslip_yyyymm,
                half_full,
                entry_date
            )
            Values (
                param_empno,
                to_date(param_absent_yyyymm || v_day, 'yyyymmdd'),
                param_payslip_yyyymm,
                v_lop,
                sysdate
            );

        End Loop;

        If v_cntr > 0 Then
            regenerate_list_4_one_emp(
                param_absent_yyyymm,
                param_payslip_yyyymm,
                param_empno,
                param_requester,
                param_success,
                param_message
            );
        Else
            param_success := 'KO';
            param_message := 'Err - Zero rows updated.';
        End If;

    Exception
        When Others Then
            param_success := 'KO';
            param_message := 'Err - ' || sqlcode || ' - ' || sqlerrm;
            Rollback;
    End;

    Procedure regenerate_list_4_one_emp(
        param_absent_yyyymm  Varchar2,
        param_payslip_yyyymm Varchar2,
        param_empno          Varchar2,
        param_requester      Varchar2,
        param_success Out    Varchar2,
        param_message Out    Varchar2
    ) As
    Begin
        check_payslip_month_isopen(
            param_payslip_yyyymm,
            param_success,
            param_message
        );
        If param_success = 'KO' Then
            Return;
        End If;
        generate_list(
            param_absent_yyyymm,
            param_payslip_yyyymm,
            param_empno,
            param_requester,
            param_success,
            param_message
        );
    End;

    Procedure reset_emp_lop(
        param_absent_yyyymm  Varchar2,
        param_payslip_yyyymm Varchar2,
        param_empno          Varchar2,
        param_requester      Varchar2,
        param_success Out    Varchar2,
        param_message Out    Varchar2
    ) As
    Begin
        check_payslip_month_isopen(
            param_payslip_yyyymm,
            param_success,
            param_message
        );
        If param_success = 'KO' Then
            Return;
        End If;
        Delete
            From ss_absent_ts_lop
        Where
            payslip_yyyymm                    = param_payslip_yyyymm
            And to_char(lop_4_date, 'yyyymm') = param_absent_yyyymm
            And empno                         = param_empno;

        Commit;
        regenerate_list_4_one_emp(
            param_absent_yyyymm,
            param_payslip_yyyymm,
            param_empno,
            param_requester,
            param_success,
            param_message
        );
    End;

    Procedure delete_user_lop(
        param_empno          Varchar2,
        param_payslip_yyyymm Varchar2,
        param_absent_yyyymm  Varchar2,
        param_requester      Varchar2,
        param_success Out    Varchar2,
        param_message Out    Varchar2
    ) As
    Begin
        Delete
            From ss_absent_ts_lop
        Where
            empno                             = param_empno
            And payslip_yyyymm                = param_payslip_yyyymm
            And to_char(lop_4_date, 'yyyymm') = param_absent_yyyymm;

        Commit;
        regenerate_list_4_one_emp(
            param_absent_yyyymm,
            param_payslip_yyyymm,
            param_empno,
            param_requester,
            param_success,
            param_message
        );
    Exception
        When Others Then
            param_success := 'KO';
            param_message := 'Err - ' || sqlcode || ' - ' || sqlerrm;
    End;

    Procedure refresh_absent_list(
        param_absent_yyyymm  Varchar2,
        param_payslip_yyyymm Varchar2,
        param_requester      Varchar2,
        param_success Out    Varchar2,
        param_message Out    Varchar2
    ) As

        v_count            Number;
        v_absent_list_date Date;
        Cursor cur_onduty Is
            With
                absent_list As (
                    Select
                        empno
                    From
                        ss_absent_ts_detail
                    Where
                        absent_yyyymm      = param_absent_yyyymm
                        And payslip_yyyymm = param_payslip_yyyymm
                    Union
                    Select
                        empno
                    From
                        ss_absent_ts_lop
                    Where
                        payslip_yyyymm = param_payslip_yyyymm
                )
            Select
            Distinct
                empno
            From
                (
                    Select
                        empno
                    From
                        ss_ondutyapp
                    Where
                        app_date >= trunc(v_absent_list_date)
                        And type In ('OD', 'IO')
                        And nvl(lead_apprl, 0) <> 2
                        And nvl(hod_apprl, 0) <> 2
                        And nvl(hrd_apprl, 0) <> 2
                        And to_char(pdate, 'yyyymm') = param_absent_yyyymm
                        And empno In (
                            Select
                                empno
                            From
                                absent_list
                        )
                    Union
                    Select
                        empno
                    From
                        ss_ondutyapp_deleted
                    Where
                        deleted_on >= trunc(v_absent_list_date)
                        And type In ('OD', 'IO')
                        And to_char(pdate, 'yyyymm') = param_absent_yyyymm
                    Union
                    Select
                        empno
                    From
                        ss_ondutyapp_rejected
                    Where
                        rejected_on >= trunc(v_absent_list_date)
                        And type In ('OD', 'IO')
                        And to_char(pdate, 'yyyymm') = param_absent_yyyymm
                );

        Cursor cur_depu Is
            With
                absent_list As (
                    Select
                        empno
                    From
                        ss_absent_ts_detail
                    Where
                        absent_yyyymm      = param_absent_yyyymm
                        And payslip_yyyymm = param_payslip_yyyymm
                    Union
                    Select
                        empno
                    From
                        ss_absent_ts_lop
                    Where
                        payslip_yyyymm = param_payslip_yyyymm
                )
            Select
            Distinct
                empno
            From
                (
                    Select
                        empno
                    From
                        ss_depu
                    Where
                        (app_date >= trunc(v_absent_list_date)
                            Or chg_date >= trunc(v_absent_list_date))
                        And type In ('TR', 'DP')
                        And nvl(hod_apprl, 0) <> 2
                        And nvl(hrd_apprl, 0) <> 2
                        And (to_char(bdate, 'yyyymm')               = param_absent_yyyymm
                            Or to_char(nvl(edate, bdate), 'yyyymm') = param_absent_yyyymm)
                        And empno In (
                            Select
                                empno
                            From
                                absent_list
                        )
                    Union
                    Select
                        empno
                    From
                        ss_depu_deleted
                    Where
                        deleted_on >= trunc(v_absent_list_date)
                        And type In ('TR', 'DP')
                        And (to_char(bdate, 'yyyymm')               = param_absent_yyyymm
                            Or to_char(nvl(edate, bdate), 'yyyymm') = param_absent_yyyymm)
                    Union
                    Select
                        empno
                    From
                        ss_depu_rejected
                    Where
                        rejected_on >= trunc(v_absent_list_date)
                        And type In ('TR', 'DP')
                        And (to_char(bdate, 'yyyymm')               = param_absent_yyyymm
                            Or to_char(nvl(edate, bdate), 'yyyymm') = param_absent_yyyymm)
                    Union
                    Select
                        empno
                    From
                        ss_depu_hist
                    Where
                        empno In (
                            Select
                                empno
                            From
                                absent_list
                        )
                        And type In ('TR', 'DP')
                        And chg_date >= trunc(v_absent_list_date)
                        And (to_char(bdate, 'yyyymm')               = param_absent_yyyymm
                            Or to_char(nvl(edate, bdate), 'yyyymm') = param_absent_yyyymm)
                );

        Cursor cur_leave Is
            With
                absent_list As (
                    Select
                        empno
                    From
                        ss_absent_ts_detail
                    Where
                        absent_yyyymm      = param_absent_yyyymm
                        And payslip_yyyymm = param_payslip_yyyymm
                    Union
                    Select
                        empno
                    From
                        ss_absent_ts_lop
                    Where
                        payslip_yyyymm = param_payslip_yyyymm
                )
            Select
            Distinct
                empno
            From
                (
                    Select
                        empno
                    From
                        ss_leaveapp
                    Where
                        (app_date >= trunc(v_absent_list_date))
                        And nvl(lead_apprl, 0) <> 2
                        And nvl(hod_apprl, 0) <> 2
                        And nvl(hrd_apprl, 0) <> 2
                        And (to_char(bdate, 'yyyymm')               = param_absent_yyyymm
                            Or to_char(nvl(edate, bdate), 'yyyymm') = param_absent_yyyymm)
                        And empno In (
                            Select
                                empno
                            From
                                absent_list
                        )
                    Union
                    /*
                    Select
                        empno
                    From
                        ss_leave_adj
                    Where
                        (adj_dt >= trunc(v_absent_list_date))
                        And empno In (
                            Select
                                empno
                            From
                                absent_list
                        )
                        And (to_char(bdate, 'yyyymm')               = param_absent_yyyymm
                            Or to_char(nvl(edate, bdate), 'yyyymm') = param_absent_yyyymm)
                    Union
                    */
                    Select
                        empno
                    From
                        ss_leaveapp_deleted
                    Where
                        deleted_on >= trunc(v_absent_list_date)
                        And (to_char(bdate, 'yyyymm')               = param_absent_yyyymm
                            Or to_char(nvl(edate, bdate), 'yyyymm') = param_absent_yyyymm)
                    Union
                    Select
                        empno
                    From
                        ss_leaveapp_rejected
                    Where
                        rejected_on >= trunc(v_absent_list_date)
                        And (to_char(bdate, 'yyyymm')               = param_absent_yyyymm
                            Or to_char(nvl(edate, bdate), 'yyyymm') = param_absent_yyyymm)
                );
        v_sysdate          Date := sysdate;
    Begin
        check_payslip_month_isopen(
            param_payslip_yyyymm,
            param_success,
            param_message
        );
        If param_success = 'KO' Then
            Return;
        End If;
        Begin
            Select
                nvl(refreshed_on, modified_on)
            Into
                v_absent_list_date
            From
                ss_absent_ts_master
            Where
                absent_yyyymm      = param_absent_yyyymm
                And payslip_yyyymm = param_payslip_yyyymm;

        Exception
            When Others Then
                param_success := 'KO';
                param_message := 'Absent list not yet generated for the said period.';
                Return;
        End;

        For c_empno In cur_onduty
        Loop
            Null;
            regenerate_list_4_one_emp(
                param_absent_yyyymm,
                param_payslip_yyyymm,
                c_empno.empno,
                param_requester,
                param_success,
                param_message
            );
        End Loop;

        For c_empno In cur_depu
        Loop
            Null;
            regenerate_list_4_one_emp(
                param_absent_yyyymm,
                param_payslip_yyyymm,
                c_empno.empno,
                param_requester,
                param_success,
                param_message
            );
        End Loop;

        For c_empno In cur_leave
        Loop
            Null;
            regenerate_list_4_one_emp(
                param_absent_yyyymm,
                param_payslip_yyyymm,
                c_empno.empno,
                param_requester,
                param_success,
                param_message
            );
        End Loop;
        Update
            ss_absent_ts_master
        Set
            refreshed_on = v_sysdate
        Where
            absent_yyyymm      = param_absent_yyyymm
            And payslip_yyyymm = param_payslip_yyyymm;

        Commit;
    Exception
        When Others Then
            param_success := 'KO';
            param_message := 'Err - ' || sqlcode || ' - ' || sqlerrm;
    End;

    Function is_emp_absent(
        param_empno In Varchar2,
        param_date  In Date
    ) Return Number As

        v_count           Number;
        c_is_absent       Constant Number := 1;
        c_not_absent      Constant Number := 0;
        c_leave_depu_tour Constant Number := 2;
        v_on_ldt          Number;
        v_ldt_appl        Number;
    Begin
        v_on_ldt   := isleavedeputour(param_date, param_empno);
        If v_on_ldt = 1 Then
            Return c_not_absent;
        End If;
        v_ldt_appl := isldt_appl(param_empno, param_date);
        If v_ldt_appl > 0 Then
            Return c_not_absent;
        End If;
        Select
            Count(*)
        Into
            v_count
        From
            ss_absent_ts_lop
        Where
            empno          = param_empno
            And lop_4_date = param_date;

        If v_count > 0 Then
            Return c_not_absent;
        End If;
        Return c_is_absent;
    End is_emp_absent;

    Procedure reverse_lop_4_emp(
        param_empno          Varchar2,
        param_payslip_yyyymm Varchar2,
        param_lop_val        Varchar2,
        param_requester      Varchar2,
        param_success Out    Varchar2,
        param_message Out    Varchar2
    ) As

        Cursor c1 Is
            Select
                column_value
            From
                Table (ss.csv_to_table(param_lop_val));

        Type typ_tab Is
            Table Of c1%rowtype Index By Binary_Integer;
        v_tab  typ_tab;
        v_day  Varchar2(8);
        v_lop  Varchar2(5);
        v_cntr Number;
        v_date Date;
    Begin
        check_payslip_month_isopen(
            param_payslip_yyyymm,
            param_success,
            param_message
        );
        If param_success = 'KO' Then
            Return;
        End If;
        Begin
            v_date := to_date(param_payslip_yyyymm, 'yyyymm');
        Exception
            When Others Then
                param_success := 'KO';
                param_message := 'Err - ' || sqlcode || ' - ' || sqlerrm;
                Return;
        End;

        param_success := 'KO';
        v_cntr        := 0;
        For c2 In c1
        Loop
            v_cntr := v_cntr + 1;
            v_day  := substr(c2.column_value, 1, instr(c2.column_value, '-') - 1);

            v_lop  := substr(c2.column_value, instr(c2.column_value, '-') + 1);

            Insert Into ss_absent_ts_lop_reverse (
                empno,
                lop_4_date,
                payslip_yyyymm,
                half_full,
                entry_date
            )
            Values (
                param_empno,
                to_date(v_day, 'yyyymmdd'),
                to_char(v_date, 'yyyymm'),
                v_lop,
                sysdate
            );

        End Loop;

        If v_cntr = 0 Then
            param_success := 'KO';
            param_message := 'Err - Zero rows updated.';
        Else
            param_success := 'OK';
        End If;

    Exception
        When Others Then
            param_success := 'KO';
            param_message := 'Err - ' || sqlcode || ' - ' || sqlerrm;
            Rollback;
    End;

    Procedure send_absent_email(
        p_payslip_yyyymm Varchar2,
        p_absent_yyyymm  Varchar2,
        p_success Out    Varchar2,
        p_message Out    Varchar2
    ) As
        Cursor cur_mail_list Is
            Select
                group_id,
                Listagg(user_email, ';') Within
                    Group (Order By
                        empno) email_csv_list
            From
                (
                    Select
                        e.empno,
                        replace(e.email, ',', '.')                       user_email,
                        ceil((Row_Number() Over(Order By e.empno)) / 50) group_id
                    From
                        ss_emplmast e
                    Where
                        e.empno In (
                            Select
                                empno
                            From
                                ss_absent_ts_detail
                            Where
                                absent_yyyymm          = p_absent_yyyymm
                                And payslip_yyyymm     = p_payslip_yyyymm
                                And nvl(no_mail, 'KO') = 'KO'
                                And empno Not In ('04600', '04132')
                        )
                        And email Is Not Null
                    Order By e.empno
                )
            Group By
                group_id;

        v_subject           Varchar2(1000);
        v_msg_body          Varchar2(2000);
        v_mail_csv          Varchar2(2000);
        v_success           Varchar2(100);
        v_message           Varchar2(500);
        v_absent_month_date Date;
        v_absent_month_text Varchar2(30);
    Begin
        Begin
            v_absent_month_date := to_date(p_absent_yyyymm, 'yyyymm');
            v_absent_month_text := regexp_replace(to_char(v_absent_month_date, 'Month-yyyy'), '\s{2,}', ' ');
        Exception
            When Others Then
                p_success := 'KO';
                p_message := 'Err - ' || sqlcode || ' - ' || sqlerrm;
                Return;
        End;
        v_msg_body := replace(c_absent_mail_body, '!@MONTH@!', v_absent_month_text);
        v_subject  := 'SELFSERVICE : ' || replace(c_absent_mail_sub, '!@MONTH@!', v_absent_month_text);

        For email_csv_row In cur_mail_list
        Loop
            v_mail_csv := email_csv_row.email_csv_list;
            send_mail_from_api(
                p_mail_to      => Null,
                p_mail_cc      => 'a.kotian@tecnimont.in;',
                p_mail_bcc     => v_mail_csv,
                p_mail_subject => v_subject,
                p_mail_body    => v_msg_body,
                p_mail_profile => 'SELFSERVICE',
                --(example --> SQSI, OSD, ALHR, etc...)
                p_mail_format  => 'HTML',
                p_success      => v_success,
                p_message      => v_message
            );

        End Loop;
        p_success  := 'OK';
        p_message  := 'Procedure executed successfully.';
    Exception
        When Others Then
            p_success := 'KO';
            p_message := 'Err - ' || sqlcode || ' - ' || sqlerrm;

    End;



End pkg_absent_ts;
/
---------------------------
--Changed PACKAGE BODY
--PKG_ABSENT
---------------------------
CREATE OR REPLACE PACKAGE BODY "SELFSERVICE"."PKG_ABSENT" As

    Function get_emp_absent_update_date(
        param_empno                Varchar2,
        param_period_keyid         Varchar2,
        param_absent_list_gen_date Date
    ) Return Date Is
        v_ret_date Date;
    Begin
        Select
            trunc(modified_on)
        Into
            v_ret_date
        From
            ss_absent_detail
        Where
            empno      = param_empno
            And key_id = param_period_keyid;

        Return (v_ret_date);
    Exception
        When Others Then
            Return (param_absent_list_gen_date);
    End;

    Procedure check_payslip_month_isopen(
        param_payslip_yyyymm Varchar2,
        param_success Out    Varchar2,
        param_message Out    Varchar2
    ) As
        v_open_payslip_yyyymm Varchar2(10);
    Begin
        v_open_payslip_yyyymm := get_payslip_month;
        If v_open_payslip_yyyymm <> param_payslip_yyyymm Then
            param_success := 'KO';
            param_message := 'Err - Payslip month "' || param_payslip_yyyymm || '" is not open in the system';
            Return;
        Else
            param_success := 'OK';
        End If;

    End;

    Procedure generate_list(
        param_absent_yyyymm  Varchar2,
        param_payslip_yyyymm Varchar2,
        param_empno          Varchar2,
        param_requester      Varchar2,
        param_success Out    Varchar2,
        param_message Out    Varchar2
    ) As

        v_key_id      Varchar2(8);
        v_first_date  Date;
        v_last_day    Date;
        --v_empno       varchar2(5);
        v_requester   Varchar2(5);
        v_param_empno Varchar2(10);
    Begin
        /*
            check_payslip_month_isopen(param_payslip_yyyymm,param_success,param_message);
            if param_success = 'KO' then
                return;
            end if;
            */
        If param_absent_yyyymm = '202106' Then
            v_first_date := to_date(param_absent_yyyymm || '07', 'yyyymmdd');
        Else
            v_first_date := to_date(param_absent_yyyymm || '01', 'yyyymmdd');
        End If;

        If param_absent_yyyymm = '202003' Then
            v_last_day := To_Date('20-Mar-2020', 'dd-Mon-yyyy');
        Else
            v_last_day := last_day(v_first_date);
        End If;

        v_key_id      := dbms_random.string('X', 8);
        v_requester   := ss.get_empno(param_requester);
        If param_empno = 'ALL' Then
            v_param_empno := '%';
        Else
            v_param_empno := param_empno || '%';
        End If;

        Delete
            From ss_absent_detail
        Where
            absent_yyyymm      = param_absent_yyyymm
            And payslip_yyyymm = param_payslip_yyyymm
            And empno Like v_param_empno;

        If param_empno = 'ALL' Then
            Delete
                From ss_absent_master
            Where
                absent_yyyymm      = param_absent_yyyymm
                And payslip_yyyymm = param_payslip_yyyymm;

            Insert Into ss_absent_master (
                absent_yyyymm,
                payslip_yyyymm,
                modified_on,
                modified_by,
                key_id
            )
            Values (
                param_absent_yyyymm,
                param_payslip_yyyymm,
                sysdate,
                v_requester,
                v_key_id
            );

        Else
            Select
                key_id
            Into
                v_key_id
            From
                ss_absent_master
            Where
                absent_yyyymm      = param_absent_yyyymm
                And payslip_yyyymm = param_payslip_yyyymm;

        End If;

        Commit;
        Insert Into ss_absent_detail (
            key_id,
            absent_yyyymm,
            payslip_yyyymm,
            empno,
            absent_days,
            cl_bal,
            sl_bal,
            pl_bal,
            co_bal
        )
        Select
            v_key_id,
            param_absent_yyyymm,
            param_payslip_yyyymm,
            empno,
            absent_days,
            closingclbal(
                empno,
                trunc(last_day(to_date(param_payslip_yyyymm, 'yyyymm'))),
                0
            ) cl_bal,
            closingslbal(
                empno,
                trunc(last_day(to_date(param_payslip_yyyymm, 'yyyymm'))),
                0
            ) sl_bal,
            closingplbal(
                empno,
                trunc(last_day(to_date(param_payslip_yyyymm, 'yyyymm'))),
                0
            ) pl_bal,
            closingcobal(
                empno,
                trunc(last_day(to_date(param_payslip_yyyymm, 'yyyymm'))),
                0
            ) co_bal
        From
            (
                Select
                    empno,
                    Listagg(dy, ', ') Within
                        Group (Order By dy) As absent_days
                From
                    (
                        With
                            days_tab As (
                                Select
                                    to_date(param_absent_yyyymm || to_char(days, 'FM00'), 'yyyymmdd') pdate,
                                    days                                                              dy
                                From
                                    ss_days
                                Where
                                    --days <= to_number(to_char(last_day(to_date(param_absent_yyyymm, 'yyyymm')), 'dd'))
                                    days <= to_number(to_char(v_last_day, 'dd'))
                                    And days >= to_number(to_char(v_first_date, 'dd'))
                            )
                        Select
                            a.empno,
                            dy,
                            pkg_absent.is_emp_absent(
                                a.empno, pdate, substr(s_mrk, ((dy - 1) * 2) + 1, 2), a.doj
                            ) is_absent
                        From
                            ss_emplmast a,
                            days_tab    b,
                            ss_muster   c
                        Where
                            mnth         = Trim(Trim(param_absent_yyyymm))
                            And a.empno  = c.empno
                            And a.status = 1
                            And a.parent Not In (
                                Select
                                    parent
                                From
                                    ss_dept_not_4_absent
                            )
                            And emptype In (
                                'R', 'F'
                            )
                            And a.empno Like v_param_empno
                    )
                Where
                    is_absent = 1
                Group By empno
            );

        Commit;
        param_success := 'OK';
    Exception
        When Others Then
            param_success := 'KO';
            param_message := 'Err - ' || sqlcode || ' - ' || sqlerrm;
    End generate_list;

    Procedure generate_nu_list_4_all_emp(
        param_absent_yyyymm  Varchar2,
        param_payslip_yyyymm Varchar2,
        param_requester      Varchar2,
        param_success Out    Varchar2,
        param_message Out    Varchar2
    ) As
    Begin
        check_payslip_month_isopen(
            param_payslip_yyyymm,
            param_success,
            param_message
        );
        If param_success = 'KO' Then
            Return;
        End If;
        Delete
            From ss_absent_lop
        Where
            payslip_yyyymm                    = param_payslip_yyyymm
            And to_char(lop_4_date, 'yyyymm') = param_absent_yyyymm;

        generate_list(
            param_absent_yyyymm,
            param_payslip_yyyymm,
            'ALL',
            param_requester,
            param_success,
            param_message
        );
    End;

    Procedure regenerate_list_4_one_emp(
        param_absent_yyyymm  Varchar2,
        param_payslip_yyyymm Varchar2,
        param_empno          Varchar2,
        param_requester      Varchar2,
        param_success Out    Varchar2,
        param_message Out    Varchar2
    ) As
    Begin
        check_payslip_month_isopen(
            param_payslip_yyyymm,
            param_success,
            param_message
        );
        If param_success = 'KO' Then
            Return;
        End If;
        generate_list(
            param_absent_yyyymm,
            param_payslip_yyyymm,
            param_empno,
            param_requester,
            param_success,
            param_message
        );
    End;

    Procedure reset_emp_lop(
        param_absent_yyyymm  Varchar2,
        param_payslip_yyyymm Varchar2,
        param_empno          Varchar2,
        param_requester      Varchar2,
        param_success Out    Varchar2,
        param_message Out    Varchar2
    ) As
    Begin
        check_payslip_month_isopen(
            param_payslip_yyyymm,
            param_success,
            param_message
        );
        If param_success = 'KO' Then
            Return;
        End If;
        Delete
            From ss_absent_lop
        Where
            payslip_yyyymm                    = param_payslip_yyyymm
            And to_char(lop_4_date, 'yyyymm') = param_absent_yyyymm
            And empno                         = param_empno;

        Commit;
        regenerate_list_4_one_emp(
            param_absent_yyyymm,
            param_payslip_yyyymm,
            param_empno,
            param_requester,
            param_success,
            param_message
        );
    End;

    Function is_emp_absent(
        param_empno      In Varchar2,
        param_date       In Date,
        param_shift_code In Varchar2,
        param_doj        In Date
    ) Return Varchar2 As

        v_holiday         Number;
        v_count           Number;
        c_is_absent       Constant Number := 1;
        c_not_absent      Constant Number := 0;
        c_leave_depu_tour Constant Number := 2;
        v_on_ldt          Number;
        v_ldt_appl        Number;
    Begin
        v_holiday  := get_holiday(param_date);
        If v_holiday > 0 Or nvl(param_shift_code, 'ABCD') In (
                'HH', 'OO'
            )
        Then
            --return -1;
            Return c_not_absent;
        End If;

        --Check DOJ & DOL

        If param_date < nvl(param_doj, param_date) Then
            --return -5;
            Return c_not_absent;
        End If;
        v_on_ldt   := isleavedeputour(param_date, param_empno);
        If v_on_ldt = 1 Then
            --return -2;
            --return c_leave_depu_tour;
            Return c_not_absent;
        End If;
        Select
            Count(empno)
        Into
            v_count
        From
            ss_integratedpunch
        Where
            empno     = Trim(param_empno)
            And pdate = param_date;

        If v_count > 0 Then
            --return -3;
            Return c_not_absent;
        End If;
        v_ldt_appl := isldt_appl(param_empno, param_date);
        If v_ldt_appl > 0 Then
            --return -6;
            Return c_not_absent;
        End If;
        Select
            Count(*)
        Into
            v_count
        From
            ss_absent_lop
        Where
            empno          = param_empno
            And lop_4_date = param_date;

        If v_count > 0 Then
            Return c_not_absent;
        End If;
        --return -4;
        Return c_is_absent;
    End is_emp_absent;

    Procedure set_lop_4_emp(
        param_empno          Varchar2,
        param_absent_yyyymm  Varchar2,
        param_payslip_yyyymm Varchar2,
        param_lop_val        Varchar2,
        param_requester      Varchar2,
        param_success Out    Varchar2,
        param_message Out    Varchar2
    ) As

        Cursor c1 Is
            Select
                column_value
            From
                Table (ss.csv_to_table(param_lop_val));

        Type typ_tab Is
            Table Of c1%rowtype Index By Binary_Integer;
        v_tab  typ_tab;
        v_day  Varchar2(5);
        v_lop  Varchar2(5);
        v_cntr Number;
    Begin
        check_payslip_month_isopen(
            param_payslip_yyyymm,
            param_success,
            param_message
        );
        If param_success = 'KO' Then
            Return;
        End If;
        param_success := 'KO';
        v_cntr        := 0;
        For c2 In c1
        Loop
            v_cntr := v_cntr + 1;
            v_day  := lpad(substr(c2.column_value, 1, instr(c2.column_value, '-') - 1), 2, '0');

            v_lop  := substr(c2.column_value, instr(c2.column_value, '-') + 1);

            Insert Into ss_absent_lop (
                empno,
                lop_4_date,
                payslip_yyyymm,
                half_full,
                entry_date
            )
            Values (
                param_empno,
                to_date(param_absent_yyyymm || v_day, 'yyyymmdd'),
                param_payslip_yyyymm,
                v_lop,
                sysdate
            );

        End Loop;

        If v_cntr > 0 Then
            regenerate_list_4_one_emp(
                param_absent_yyyymm,
                param_payslip_yyyymm,
                param_empno,
                param_requester,
                param_success,
                param_message
            );
        Else
            param_success := 'KO';
            param_message := 'Err - Zero rows updated.';
        End If;

    Exception
        When Others Then
            param_success := 'KO';
            param_message := 'Err - ' || sqlcode || ' - ' || sqlerrm;
            Rollback;
    End;

    Function get_lop(
        param_empno Varchar2,
        param_pdate Date
    ) Return Number Is
        v_lop Number;
    Begin
        Select
            half_full
        Into
            v_lop
        From
            ss_absent_lop
        Where
            empno          = param_empno
            And lop_4_date = param_pdate;

        Return v_lop;
    Exception
        When Others Then
            Return 0;
    End;

    Procedure update_no_mail_list(
        param_absent_yyyymm       Varchar2,
        param_payslip_yyyymm      Varchar2,
        param_emp_list_4_no_mail  Varchar2,
        param_emp_list_4_yes_mail Varchar2,
        param_requester           Varchar2,
        param_success Out         Varchar2,
        param_message Out         Varchar2
    ) As
    Begin
        Null;
        check_payslip_month_isopen(
            param_payslip_yyyymm,
            param_success,
            param_message
        );
        If param_success = 'KO' Then
            Return;
        End If;
        /*
        If Trim(param_emp_list_4_no_mail) Is Null Then
            param_success   := 'KO';
            param_message   := 'Err - Employee List for NO-MAIL is blank.';
            return;
        End If;
        */
        Update
            ss_absent_detail
        Set
            no_mail = Null
        Where
            absent_yyyymm      = param_absent_yyyymm
            And payslip_yyyymm = param_payslip_yyyymm
            And empno In (
                Select
                    column_value empno
                From
                    Table (ss.csv_to_table(param_emp_list_4_yes_mail))
            );

        Commit;
        Update
            ss_absent_detail
        Set
            no_mail = 'OK'
        Where
            absent_yyyymm      = param_absent_yyyymm
            And payslip_yyyymm = param_payslip_yyyymm
            And empno In (
                Select
                    column_value empno
                From
                    Table (ss.csv_to_table(param_emp_list_4_no_mail))
            );

        Commit;
        param_success := 'OK';
        param_message := 'Employee List for NO-MAIL successfully updated';
    Exception
        When Others Then
            param_success := 'KO';
            param_message := 'Err - ' || sqlcode || ' - ' || sqlerrm;
            Rollback;
    End;

    Procedure add_payslip_period(
        param_period      Varchar2,
        param_open        Varchar2,
        param_by_win_uid  Varchar2,
        param_success Out Varchar2,
        param_message Out Varchar2
    ) As
        v_count    Number;
        v_date     Date;
        v_by_empno Varchar2(5);
    Begin
        Begin
            v_date := to_date(param_period, 'Mon-yyyy');
        Exception
            When Others Then
                param_success := 'KO';
                param_message := 'Err - Invalid date format';
                Return;
        End;

        v_by_empno    := pkg_09794.get_empno(param_by_win_uid);
        If v_by_empno Is Null Then
            param_success := 'KO';
            param_message := 'Err - Data Entry by EmpNo not found.';
            Return;
        End If;

        Select
            Count(*)
        Into
            v_count
        From
            ss_absent_payslip_period
        Where
            period = to_char(v_date, 'yyyymm');

        If v_count <> 0 Then
            param_success := 'KO';
            param_message := 'Err - Period already exists.';
            Return;
        End If;

        Insert Into ss_absent_payslip_period (
            period,
            is_open,
            modified_on,
            modified_by
        )
        Values (
            to_char(v_date, 'yyyymm'),
            param_open,
            sysdate,
            v_by_empno
        );

        If param_open = 'OK' Then
            Update
                ss_absent_payslip_period
            Set
                is_open = 'KO'
            Where
                period != to_char(v_date, 'yyyymm')
                And is_open = 'OK';

        End If;

        Commit;
        param_success := 'OK';
        param_message := 'Period successfully added.';
    Exception
        When Others Then
            param_success := 'KO';
            param_message := 'Err - ' || sqlcode || ' - ' || sqlerrm;
    End;

    Procedure edit_payslip_period(
        param_period      Varchar2,
        param_open        Varchar2,
        param_by_win_uid  Varchar2,
        param_success Out Varchar2,
        param_message Out Varchar2
    ) As
        v_count    Number;
        v_date     Date;
        v_by_empno Varchar2(5);
    Begin
        Begin
            v_date := to_date(param_period, 'Mon-yyyy');
        Exception
            When Others Then
                param_success := 'KO';
                param_message := 'Err - Invalid date format';
                Return;
        End;

        v_by_empno    := pkg_09794.get_empno(param_by_win_uid);
        If v_by_empno Is Null Then
            param_success := 'KO';
            param_message := 'Err - Data Entry by EmpNo not found.';
            Return;
        End If;

        Select
            Count(*)
        Into
            v_count
        From
            ss_absent_payslip_period
        Where
            period = to_char(v_date, 'yyyymm');

        If v_count <> 1 Then
            param_success := 'KO';
            param_message := 'Err - Period not found in database.';
            Return;
        End If;

        Update
            ss_absent_payslip_period
        Set
            is_open = param_open
        Where
            period = to_char(v_date, 'yyyymm');

        If param_open = 'OK' Then
            Update
                ss_absent_payslip_period
            Set
                is_open = 'KO'
            Where
                period != to_char(v_date, 'yyyymm')
                And is_open = 'OK';

        End If;

        Commit;
        param_success := 'OK';
        param_message := 'Period successfully updated.';
    Exception
        When Others Then
            param_success := 'KO';
            param_message := 'Err - ' || sqlcode || ' - ' || sqlerrm;
    End;

    Procedure refresh_absent_list(
        param_absent_yyyymm  Varchar2,
        param_payslip_yyyymm Varchar2,
        param_requester      Varchar2,
        param_success Out    Varchar2,
        param_message Out    Varchar2
    ) As

        v_count             Number;
        v_absent_list_date  Date;
        v_absent_list_keyid Varchar2(8);
        Cursor cur_onduty(
            pc_list_keyid Varchar2,
            pc_list_date  Date
        ) Is
            With
                absent_list As (
                    Select
                        empno
                    From
                        ss_absent_detail
                    Where
                        absent_yyyymm      = param_absent_yyyymm
                        And payslip_yyyymm = param_payslip_yyyymm
                    Union
                    Select
                        empno
                    From
                        ss_absent_lop
                    Where
                        payslip_yyyymm = param_payslip_yyyymm
                )
            Select
            Distinct
                empno
            From
                (
                    Select
                        empno
                    From
                        ss_ondutyapp
                    Where
                        app_date >= get_emp_absent_update_date(
                            empno, pc_list_keyid, pc_list_date
                        )
                        And type In ('OD', 'IO')
                        And nvl(lead_apprl, 0) <> 2
                        And nvl(hod_apprl, 0) <> 2
                        And nvl(hrd_apprl, 0) <> 2
                        And to_char(pdate, 'yyyymm') = param_absent_yyyymm
                        And empno In (
                            Select
                                empno
                            From
                                absent_list
                        )
                    Union
                    Select
                        empno
                    From
                        ss_ondutyapp_deleted
                    Where
                        deleted_on >= get_emp_absent_update_date(
                            empno, pc_list_keyid, pc_list_date
                        )
                        And to_char(pdate, 'yyyymm') = param_absent_yyyymm
                        And type In ('OD', 'IO')
                    Union
                    Select
                        empno
                    From
                        ss_ondutyapp_rejected
                    Where
                        rejected_on >= get_emp_absent_update_date(
                            empno, pc_list_keyid, pc_list_date
                        )
                        And to_char(pdate, 'yyyymm') = param_absent_yyyymm
                        And type In ('OD', 'IO')
                );

        Cursor cur_depu(
            pc_list_keyid Varchar2,
            pc_list_date  Date
        ) Is
            With
                absent_list As (
                    Select
                        empno
                    From
                        ss_absent_detail
                    Where
                        absent_yyyymm      = param_absent_yyyymm
                        And payslip_yyyymm = param_payslip_yyyymm
                    Union
                    Select
                        empno
                    From
                        ss_absent_lop
                    Where
                        payslip_yyyymm = param_payslip_yyyymm
                )
            Select
            Distinct
                empno
            From
                (
                    Select
                        empno
                    From
                        ss_depu
                    Where
                        (app_date >= get_emp_absent_update_date(
                                empno, pc_list_keyid, pc_list_date
                            )
                            Or chg_date >= get_emp_absent_update_date(
                                empno, pc_list_keyid, pc_list_date
                            ))
                        And type In ('TR', 'DP')
                        And nvl(hod_apprl, 0) <> 2
                        And nvl(hrd_apprl, 0) <> 2
                        And (to_char(bdate, 'yyyymm')               = param_absent_yyyymm
                            Or to_char(nvl(edate, bdate), 'yyyymm') = param_absent_yyyymm)
                        And empno In (
                            Select
                                empno
                            From
                                absent_list
                        )
                    Union
                    Select
                        empno
                    From
                        ss_depu_deleted
                    Where
                        deleted_on >= get_emp_absent_update_date(
                            empno, pc_list_keyid, pc_list_date
                        )
                        And type In ('TR', 'DP')
                        And (to_char(bdate, 'yyyymm')               = param_absent_yyyymm
                            Or to_char(nvl(edate, bdate), 'yyyymm') = param_absent_yyyymm)
                    Union
                    Select
                        empno
                    From
                        ss_depu_rejected
                    Where
                        rejected_on >= get_emp_absent_update_date(
                            empno, pc_list_keyid, pc_list_date
                        )
                        And type In ('TR', 'DP')
                        And (to_char(bdate, 'yyyymm')               = param_absent_yyyymm
                            Or to_char(nvl(edate, bdate), 'yyyymm') = param_absent_yyyymm)
                    Union
                    Select
                        empno
                    From
                        ss_depu_hist
                    Where
                        empno In (
                            Select
                                empno
                            From
                                absent_list
                        )
                        And type In ('TR', 'DP')
                        And chg_date >= get_emp_absent_update_date(
                            empno, pc_list_keyid, pc_list_date
                        )
                        And (to_char(bdate, 'yyyymm')               = param_absent_yyyymm
                            Or to_char(nvl(edate, bdate), 'yyyymm') = param_absent_yyyymm)
                );

        Cursor cur_leave(
            pc_list_keyid Varchar2,
            pc_list_date  Date
        ) Is
            With
                absent_list As (
                    Select
                        empno
                    From
                        ss_absent_detail
                    Where
                        absent_yyyymm      = param_absent_yyyymm
                        And payslip_yyyymm = param_payslip_yyyymm
                    Union
                    Select
                        empno
                    From
                        ss_absent_lop
                    Where
                        payslip_yyyymm = param_payslip_yyyymm
                )
            Select
            Distinct
                empno
            From
                (
                    Select
                        empno
                    From
                        ss_leaveapp
                    Where
                        (app_date >= get_emp_absent_update_date(
                            empno, pc_list_keyid, pc_list_date
                        ))
                        And nvl(lead_apprl, 0) <> 2
                        And nvl(hod_apprl, 0) <> 2
                        And nvl(hrd_apprl, 0) <> 2
                        And (to_char(bdate, 'yyyymm')               = param_absent_yyyymm
                            Or to_char(nvl(edate, bdate), 'yyyymm') = param_absent_yyyymm)
                        And empno In (
                            Select
                                empno
                            From
                                absent_list
                        )
                    Union
                    Select
                        empno
                    From
                        ss_leaveapp_deleted
                    Where
                        deleted_on >= get_emp_absent_update_date(
                            empno, pc_list_keyid, pc_list_date
                        )
                        And (to_char(bdate, 'yyyymm')               = param_absent_yyyymm
                            Or to_char(nvl(edate, bdate), 'yyyymm') = param_absent_yyyymm)
                    Union
                    Select
                        empno
                    From
                        ss_leaveapp_rejected
                    Where
                        rejected_on >= get_emp_absent_update_date(
                            empno, pc_list_keyid, pc_list_date
                        )
                        And (to_char(bdate, 'yyyymm')               = param_absent_yyyymm
                            Or to_char(nvl(edate, bdate), 'yyyymm') = param_absent_yyyymm)
                );
        v_sysdate           Date := sysdate;
    Begin
        check_payslip_month_isopen(
            param_payslip_yyyymm,
            param_success,
            param_message
        );
        If param_success = 'KO' Then
            Return;
        End If;
        Begin
            Select
                trunc(nvl(refreshed_on, modified_on)),
                key_id
            Into
                v_absent_list_date,
                v_absent_list_keyid
            From
                ss_absent_master
            Where
                absent_yyyymm      = param_absent_yyyymm
                And payslip_yyyymm = param_payslip_yyyymm;

        Exception
            When Others Then
                param_success := 'KO';
                param_message := 'Absent list not yet generated for the said period.';
                Return;
        End;

        For c_empno In cur_onduty(v_absent_list_keyid, v_absent_list_date)
        Loop
            Null;
            regenerate_list_4_one_emp(
                param_absent_yyyymm,
                param_payslip_yyyymm,
                c_empno.empno,
                param_requester,
                param_success,
                param_message
            );
        End Loop;

        For c_empno In cur_depu(v_absent_list_keyid, v_absent_list_date)
        Loop
            Null;
            regenerate_list_4_one_emp(
                param_absent_yyyymm,
                param_payslip_yyyymm,
                c_empno.empno,
                param_requester,
                param_success,
                param_message
            );
        End Loop;

        For c_empno In cur_leave(v_absent_list_keyid, v_absent_list_date)
        Loop
            Null;
            regenerate_list_4_one_emp(
                param_absent_yyyymm,
                param_payslip_yyyymm,
                c_empno.empno,
                param_requester,
                param_success,
                param_message
            );
        End Loop;

        Update
            ss_absent_master
        Set
            refreshed_on = v_sysdate
        Where
            absent_yyyymm      = param_absent_yyyymm
            And payslip_yyyymm = param_payslip_yyyymm;

        Commit;
    Exception
        When Others Then
            param_success := 'KO';
            param_message := 'Err - ' || sqlcode || ' - ' || sqlerrm;
    End;

    Procedure reverse_lop_4_emp(
        param_empno          Varchar2,
        param_payslip_yyyymm Varchar2,
        param_lop_val        Varchar2,
        param_requester      Varchar2,
        param_success Out    Varchar2,
        param_message Out    Varchar2
    ) As

        Cursor c1 Is
            Select
                column_value
            From
                Table (ss.csv_to_table(param_lop_val));

        Type typ_tab Is
            Table Of c1%rowtype Index By Binary_Integer;
        v_tab  typ_tab;
        v_day  Varchar2(8);
        v_lop  Varchar2(5);
        v_cntr Number;
        v_date Date;
    Begin
        check_payslip_month_isopen(
            param_payslip_yyyymm,
            param_success,
            param_message
        );
        If param_success = 'KO' Then
            Return;
        End If;
        Begin
            v_date := to_date(param_payslip_yyyymm, 'yyyymm');
        Exception
            When Others Then
                param_success := 'KO';
                param_message := 'Err - ' || sqlcode || ' - ' || sqlerrm;
                Return;
        End;

        param_success := 'KO';
        v_cntr        := 0;
        For c2 In c1
        Loop
            v_cntr := v_cntr + 1;
            v_day  := substr(c2.column_value, 1, instr(c2.column_value, '-') - 1);

            v_lop  := substr(c2.column_value, instr(c2.column_value, '-') + 1);

            Insert Into ss_absent_lop_reverse (
                empno,
                lop_4_date,
                payslip_yyyymm,
                half_full,
                entry_date
            )
            Values (
                param_empno,
                to_date(v_day, 'yyyymmdd'),
                to_char(v_date, 'yyyymm'),
                v_lop,
                sysdate
            );

        End Loop;

        If v_cntr = 0 Then
            param_success := 'KO';
            param_message := 'Err - Zero rows updated.';
        Else
            param_success := 'OK';
        End If;

    Exception
        When Others Then
            param_success := 'KO';
            param_message := 'Err - ' || sqlcode || ' - ' || sqlerrm;
            Rollback;
    End;

    Function get_payslip_month Return Varchar2 Is
        v_payslip_month_rec ss_absent_payslip_period%rowtype;
        v_ret_val           Varchar2(7);
    Begin
        Select
            *
        Into
            v_payslip_month_rec
        From
            ss_absent_payslip_period
        Where
            is_open = 'OK';
        --v_ret_val := substr(v_payslip_month_rec.period,1,4) || '-' || substr(v_payslip_month_rec.period,5,2);

        Return v_payslip_month_rec.period;
    Exception
        When Others Then
            Return 'ERR';
    End;

    Procedure delete_user_lop(
        param_empno          Varchar2,
        param_payslip_yyyymm Varchar2,
        param_absent_yyyymm  Varchar2,
        param_requester      Varchar2,
        param_success Out    Varchar2,
        param_message Out    Varchar2
    ) As
    Begin
        Delete
            From ss_absent_lop
        Where
            empno                             = param_empno
            And payslip_yyyymm                = param_payslip_yyyymm
            And to_char(lop_4_date, 'yyyymm') = param_absent_yyyymm;

        Commit;
        regenerate_list_4_one_emp(
            param_absent_yyyymm,
            param_payslip_yyyymm,
            param_empno,
            param_requester,
            param_success,
            param_message
        );
    Exception
        When Others Then
            param_success := 'KO';
            param_message := 'Err - ' || sqlcode || ' - ' || sqlerrm;
    End;

    Function get_pending_app_4_month(
        param_yyyymm Varchar2
    ) Return typ_tab_pending_app
        Pipelined
    As

        Cursor cur_pending_apps Is
            Select
                empno                        empno,
                emp_name                     emp_name,
                parent                       parent,
                app_no                       app_no,
                bdate                        bdate,
                edate                        edate,
                leavetype                    leavetype,
                ss.approval_text(hrd_apprl)  hrd_apprl_txt,
                ss.approval_text(hod_apprl)  hod_apprl_txt,
                ss.approval_text(lead_apprl) lead_apprl_txt
            From
                (
                    With
                        emp_list As (
                            Select
                                empno As emp_num,
                                name  As emp_name,
                                parent
                            From
                                ss_emplmast
                            Where
                                status = 1
                                And emptype In (
                                    'R', 'F'
                                )
                        ), dates As (
                            Select
                                to_date(param_yyyymm, 'yyyymm')           As first_day,
                                last_day(to_date(param_yyyymm, 'yyyymm')) As last_day
                            From
                                dual
                        )
                    Select
                        empno,
                        emp_name,
                        parent,
                        app_no,
                        bdate,
                        edate,
                        leavetype,
                        hrd_apprl,
                        hod_apprl,
                        lead_apprl
                    From
                        ss_leaveapp a,
                        emp_list    b,
                        dates       c
                    Where
                        a.empno = b.emp_num
                        And nvl(lead_apprl, ss.pending) In (
                            ss.pending, ss.approved, ss.apprl_none
                        )
                        And nvl(hod_apprl, ss.pending) In (
                            ss.pending, ss.approved
                        )
                        And nvl(hrd_apprl, ss.pending) In (
                            ss.pending
                        )
                        And (bdate Between first_day And last_day
                            Or nvl(bdate, edate) Between first_day And last_day
                            Or first_day Between bdate And nvl(bdate, edate))
                    Union
                    Select
                        empno,
                        emp_name,
                        parent,
                        app_no,
                        pdate,
                        Null,
                        type As od_type,
                        hrd_apprl,
                        hod_apprl,
                        lead_apprl
                    From
                        ss_ondutyapp a,
                        emp_list     b,
                        dates
                    Where
                        a.empno = b.emp_num
                        And type In (
                            'IO', 'OD'
                        )
                        And nvl(lead_apprl, ss.pending) In (
                            ss.pending, ss.approved, ss.apprl_none
                        )
                        And nvl(hod_apprl, ss.pending) In (
                            ss.pending, ss.approved
                        )
                        And nvl(hrd_apprl, ss.pending) In (
                            ss.pending
                        )
                        And (pdate Between first_day And last_day)
                    Union
                    Select
                        empno,
                        emp_name,
                        parent,
                        app_no,
                        bdate,
                        edate,
                        type As depu_type,
                        hrd_apprl,
                        hod_apprl,
                        lead_apprl
                    From
                        ss_depu  a,
                        emp_list b,
                        dates
                    Where
                        a.empno = b.emp_num
                        And type In (
                            'HT', 'VS', 'TR', 'DP'
                        )
                        And nvl(lead_apprl, ss.pending) In (
                            ss.pending, ss.approved, ss.apprl_none
                        )
                        And nvl(hod_apprl, ss.pending) In (
                            ss.pending, ss.approved
                        )
                        And nvl(hrd_apprl, ss.pending) In (
                            ss.pending
                        )
                        And (bdate Between first_day And last_day
                            Or nvl(bdate, edate) Between first_day And last_day
                            Or first_day Between bdate And nvl(bdate, edate))
                /*union
                select
                    empno,
                    emp_name,
                    parent,
                    app_no,
                    bdate,
                    edate,
                    type,
                    hrd_apprl,
                    hod_apprl,
                    lead_apprl
                from
                    ss_depu a,
                    emp_list b,
                    dates
                where
                    a.empno = b.emp_num
                    and type in (
                        'HT',
                        'VS',
                        'TR',
                        'DP'
                    )
                    and nvl(lead_apprl,ss.pending) in (
                        ss.pending,
                        ss.approved,
                        ss.apprl_none
                    )
                    and nvl(hod_apprl,ss.pending) in (
                        ss.pending,
                        ss.approved
                    )
                    and nvl(hrd_apprl,ss.pending) in (
                        ss.pending
                    )
                    and ( bdate between first_day and last_day
                          or nvl(bdate,edate) between first_day and last_day
                          or first_day between bdate and nvl(bdate,edate) )*/
                );

        v_rec      typ_rec_pending_app;
        v_tab      typ_tab_pending_app;
        v_tab_null typ_tab_pending_app;
    Begin
        Open cur_pending_apps;
        Loop
            Fetch cur_pending_apps Bulk Collect Into v_tab Limit 50;
            For i In 1..v_tab.count
            Loop
                Pipe Row (v_tab(i));
            End Loop;

            v_tab := v_tab_null;
            Exit When cur_pending_apps%notfound;
        End Loop;
        --pipe row ( v_rec );

    End;

    Procedure send_absent_email(
        p_payslip_yyyymm Varchar2,
        p_absent_yyyymm  Varchar2,
        p_success Out    Varchar2,
        p_message Out    Varchar2
    ) As
        Cursor cur_mail_list Is
            Select
                group_id,
                Listagg(user_email, ';') Within
                    Group (Order By
                        empno) email_csv_list
            From
                (
                    Select
                        e.empno,
                        replace(e.email, ',', '.')                       user_email,
                        ceil((Row_Number() Over(Order By e.empno)) / 50) group_id
                    From
                        ss_emplmast e
                    Where
                        e.empno In (
                            Select
                                empno
                            From
                                ss_absent_detail
                            Where
                                absent_yyyymm          = p_absent_yyyymm
                                And payslip_yyyymm     = p_payslip_yyyymm
                                And nvl(no_mail, 'KO') = 'KO'
                                And empno Not In ('04600', '04132')
                        )
                        And email Is Not Null
                    Order By e.empno
                )
            Group By
                group_id;

        v_subject           Varchar2(1000);
        v_msg_body          Varchar2(2000);
        v_mail_csv          Varchar2(2000);
        v_success           Varchar2(100);
        v_message           Varchar2(500);
        v_absent_month_date Date;
        v_absent_month_text Varchar2(30);
    Begin
        Begin
            v_absent_month_date := to_date(p_absent_yyyymm, 'yyyymm');
            v_absent_month_text := regexp_replace(to_char(v_absent_month_date, 'Month-yyyy'), '\s{2,}', ' ');
        Exception
            When Others Then
                p_success := 'KO';
                p_message := 'Err - ' || sqlcode || ' - ' || sqlerrm;
                Return;
        End;
        v_msg_body := replace(c_absent_mail_body, '!@MONTH@!', v_absent_month_text);
        v_subject  := 'SELFSERVICE : ' || replace(c_absent_mail_sub, '!@MONTH@!', v_absent_month_text);

        For email_csv_row In cur_mail_list
        Loop
            v_mail_csv := email_csv_row.email_csv_list;
            send_mail_from_api(
                p_mail_to      => Null,
                p_mail_cc      => 'a.kotian@tecnimont.in;',
                p_mail_bcc     => v_mail_csv,
                p_mail_subject => v_subject,
                p_mail_body    => v_msg_body,
                p_mail_profile => 'SELFSERVICE',
                --(example --> SQSI, OSD, ALHR, etc...)
                p_mail_format  => 'HTML',
                p_success      => v_success,
                p_message      => v_message
            );

        End Loop;
        p_success  := 'OK';
        p_message  := 'Procedure executed successfully.';
    Exception
        When Others Then
            p_success := 'KO';
            p_message := 'Err - ' || sqlcode || ' - ' || sqlerrm;

    End;


    Procedure send_hod_approval_pending_mail(
        p_success Out    Varchar2,
        p_message Out    Varchar2
    ) As
        Cursor cur_mail_list Is
            Select
                group_id,
                Listagg(user_email, ';') Within
                    Group (Order By
                        emp_no) email_csv_list
            From
                (
                    Select
                        e.emp_no,
                        replace(e.emp_email, ',', '.')                       user_email,
                        ceil((Row_Number() Over(Order By e.emp_no)) / 50) group_id
                    From
                        table( pending_approvals.list_of_hod_not_approving() ) e
                )
            Group By
                group_id;

        v_subject           Varchar2(1000);
        v_msg_body          Varchar2(2000);
        v_mail_csv          Varchar2(2000);
        v_success           Varchar2(100);
        v_message           Varchar2(500);
        v_absent_month_date Date;
        v_absent_month_text Varchar2(30);
    Begin
        v_msg_body := c_pending_approval_body;
        v_subject  := 'SELFSERVICE : ' || c_pending_approval_sub;

        For email_csv_row In cur_mail_list
        Loop
            v_mail_csv := email_csv_row.email_csv_list;
            send_mail_from_api(
                p_mail_to      => Null,
                p_mail_cc      => 'a.kotian@tecnimont.in;',
                p_mail_bcc     => v_mail_csv,
                p_mail_subject => v_subject,
                p_mail_body    => v_msg_body,
                p_mail_profile => 'SELFSERVICE',
                --(example --> SQSI, OSD, ALHR, etc...)
                p_mail_format  => 'HTML',
                p_success      => v_success,
                p_message      => v_message
            );

        End Loop;
        p_success  := 'OK';
        p_message  := 'Procedure executed successfully.';
    Exception
        When Others Then
            p_success := 'KO';
            p_message := 'Err - ' || sqlcode || ' - ' || sqlerrm;

    End;

    Procedure send_leadapproval_pending_mail(
        p_success Out    Varchar2,
        p_message Out    Varchar2
    ) As
        Cursor cur_mail_list Is
            Select
                group_id,
                Listagg(user_email, ';') Within
                    Group (Order By
                        emp_no) email_csv_list
            From
                (
                    Select
                        e.emp_no,
                        replace(e.emp_email, ',', '.')                       user_email,
                        ceil((Row_Number() Over(Order By e.emp_no)) / 50) group_id
                    From
                        table( pending_approvals.list_of_leads_not_approving() ) e
                )
            Group By
                group_id;

        v_subject           Varchar2(1000);
        v_msg_body          Varchar2(2000);
        v_mail_csv          Varchar2(2000);
        v_success           Varchar2(100);
        v_message           Varchar2(500);
        v_absent_month_date Date;
        v_absent_month_text Varchar2(30);
    Begin
        v_msg_body := c_pending_approval_body;
        v_subject  := 'SELFSERVICE : ' || c_pending_approval_sub;

        For email_csv_row In cur_mail_list
        Loop
            v_mail_csv := email_csv_row.email_csv_list;
            send_mail_from_api(
                p_mail_to      => Null,
                p_mail_cc      => 'a.kotian@tecnimont.in;',
                p_mail_bcc     => v_mail_csv,
                p_mail_subject => v_subject,
                p_mail_body    => v_msg_body,
                p_mail_profile => 'SELFSERVICE',
                --(example --> SQSI, OSD, ALHR, etc...)
                p_mail_format  => 'HTML',
                p_success      => v_success,
                p_message      => v_message
            );

        End Loop;
        p_success  := 'OK';
        p_message  := 'Procedure executed successfully.';
    Exception
        When Others Then
            p_success := 'KO';
            p_message := 'Err - ' || sqlcode || ' - ' || sqlerrm;

    End;



End pkg_absent;
/
---------------------------
--Changed PACKAGE BODY
--IOT_SWP_CONFIG_WEEK
---------------------------
CREATE OR REPLACE PACKAGE BODY "SELFSERVICE"."IOT_SWP_CONFIG_WEEK" As
    c_plan_close_code  Constant Number := 0;
    c_plan_open_code   Constant Number := 1;
    c_past_plan_code   Constant Number := 0;
    c_cur_plan_code    Constant Number := 1;
    c_future_plan_code Constant Number := 2;

    Function fn_is_second_last_day_of_week(p_sysdate Date) Return Boolean As
        v_secondlast_workdate Date;
        v_fri_date            Date;
        Type rec Is Record(
                work_date     Date,
                work_day_desc Varchar2(100),
                rec_num       Number
            );

        Type typ_tab_work_day Is Table Of rec;
        tab_work_day          typ_tab_work_day;
    Begin
        v_fri_date := iot_swp_common.get_friday_date(trunc(p_sysdate));
        Select
            d_date As work_date,
            Case Rownum
                When 1 Then
                    'LAST'
                When 2 Then
                    'SECOND_LAST'
                Else
                    Null
            End    work_day_desc,
            Rownum As rec_num
        Bulk Collect
        Into
            tab_work_day
        From
            (
                Select
                    *
                From
                    ss_days_details
                Where
                    d_date <= v_fri_date
                    And d_date >= trunc(p_sysdate)
                    And d_date Not In
                    (
                        Select
                            trunc(holiday)
                        From
                            ss_holidays
                        Where
                            (holiday <= v_fri_date
                                And holiday >= trunc(p_sysdate))
                    )
                Order By d_date Desc
            )
        Where
            Rownum In(1, 2);
        If tab_work_day.count = 2 Then
            --v_sysdate EQUAL SECOND_LAST working day "THURSDAY"
            If p_sysdate = tab_work_day(2).work_date Then --SECOND_LAST working day
                Return true;
            End If;
        End If;
        Return false;
    Exception
        When Others Then
            Return false;
    End;

    Procedure sp_del_dms_desk_for_sws_users As
        Cursor cur_desk_plan_dept Is
            Select
                *
            From
                swp_include_assign_4_seat_plan;
        c1      Sys_Refcursor;

        --
        Cursor cur_sws Is
            Select
                a.empno,
                a.primary_workspace,
                a.start_date,
                iot_swp_common.get_swp_planned_desk(
                    p_empno => a.empno
                ) swp_desk_id
            From
                swp_primary_workspace a,
                ss_emplmast           e
            Where
                a.empno                 = e.empno
                And e.status            = 1
                And a.primary_workspace = 2
                And trunc(a.start_date) = (
                    Select
                        Max(trunc(start_date))
                    From
                        swp_primary_workspace b
                    Where
                        b.empno = a.empno
                        And b.start_date <= sysdate
                )
                And e.assign In (
                    Select
                        assign
                    From
                        swp_include_assign_4_seat_plan
                );
        Type typ_tab_sws Is Table Of cur_sws%rowtype Index By Binary_Integer;
        tab_sws typ_tab_sws;
    Begin
        Open cur_sws;
        Loop
            Fetch cur_sws Bulk Collect Into tab_sws Limit 50;
            For i In 1..tab_sws.count
            Loop
                iot_swp_dms.sp_remove_desk_user(
                    p_person_id => Null,
                    p_meta_id   => Null,
                    p_empno     => tab_sws(i).empno,
                    p_deskid    => tab_sws(i).swp_desk_id
                );
            End Loop;
            Exit When cur_sws%notfound;
        End Loop;
    End;

    --

    Procedure sp_mail_plan_to_emp
    As
        cur_dept_rows      Sys_Refcursor;
        cur_emp_week_plan  Sys_Refcursor;
        row_config_week    swp_config_weeks%rowtype;
        v_mail_body        Varchar2(4000);
        v_day_row          Varchar2(1000);
        v_emp_mail         Varchar2(100);
        v_msg_type         Varchar2(15);
        v_msg_text         Varchar2(1000);
        v_emp_desk         Varchar2(10);
        Cursor cur_sws_emp_list(cp_monday_date Date,
                                cp_friday_date Date) Is
            Select
                a.empno,
                e.name As employee_name,
                a.primary_workspace,
                a.start_date
            From
                swp_primary_workspace a,
                ss_emplmast           e
            Where
                e.status                = 1
                And a.empno             = e.empno
                And a.primary_workspace = 2
                And emptype In (
                    Select
                        emptype
                    From
                        swp_include_emptype
                )
                And assign Not In(
                    Select
                        assign
                    From
                        swp_exclude_assign
                )
                And trunc(a.start_date) = (
                    Select
                        Max(trunc(start_date))
                    From
                        swp_primary_workspace b
                    Where
                        b.empno = a.empno
                        And b.start_date <= cp_friday_date
                )
                And e.empno Not In(
                    Select
                        empno
                    From
                        swp_exclude_emp
                    Where
                        empno = e.empno
                        And (cp_monday_date Between start_date And end_date
                            Or cp_friday_date Between start_date And end_date)
                )
                And grade <> 'X1';

        Type typ_tab_sws_emp_list Is Table Of cur_sws_emp_list%rowtype;
        tab_sws_emp_list   typ_tab_sws_emp_list;

        Cursor cur_emp_smart_attend_plan(cp_empno      Varchar2,
                                         cp_start_date Date,
                                         cp_end_date   Date) Is
            With
                atnd_days As (
                    Select
                        w.empno,
                        Trim(w.attendance_date) As attendance_date,
                        Trim(w.deskid)          As deskid,
                        1                       As planned,
                        dm.office               As office,
                        dm.floor                As floor,
                        dm.wing                 As wing,
                        dm.bay                  As bay
                    From
                        swp_smart_attendance_plan w,
                        dms.dm_deskmaster         dm
                    Where
                        w.empno      = cp_empno
                        And w.deskid = dm.deskid(+)
                        And attendance_date Between cp_start_date And cp_end_date
                )
            Select
                e.empno                   As empno,
                dd.d_day,
                dd.d_date,
                nvl(atnd_days.planned, 0) As planned,
                atnd_days.deskid          As deskid,
                atnd_days.office          As office,
                atnd_days.floor           As floor,
                atnd_days.wing            As wing,
                atnd_days.bay             As bay
            From
                ss_emplmast     e,
                ss_days_details dd,
                atnd_days
            Where
                e.empno       = Trim(cp_empno)

                And dd.d_date = atnd_days.attendance_date
                And d_date Between cp_start_date And cp_end_date
            Order By
                dd.d_date;
        Type typ_tab_emp_smart_plan Is Table Of cur_emp_smart_attend_plan%rowtype;
        tab_emp_smart_plan typ_tab_emp_smart_plan;
    Begin

        Select
            *
        Into
            row_config_week
        From
            swp_config_weeks
        Where
            planning_flag = 2;

        Open cur_sws_emp_list(row_config_week.start_date, row_config_week.end_date);
        Loop
            Fetch cur_sws_emp_list Bulk Collect Into tab_sws_emp_list Limit 50;
            For i In 1..tab_sws_emp_list.count
            Loop
                Begin
                    Select
                        email
                    Into
                        v_emp_mail
                    From
                        ss_emplmast
                    Where
                        empno      = tab_sws_emp_list(i).empno
                        And status = 1;
                    If v_emp_mail Is Null Then
                        Continue;
                    End If;
                Exception
                    When Others Then
                        Continue;
                End;


                --PRIMARY WORK SPACE
                If tab_sws_emp_list(i).primary_workspace = 1 Then
                    v_mail_body := v_ows_mail_body;
                    v_mail_body := replace(v_mail_body, '!@User@!', tab_sws_emp_list(i).employee_name);
                    v_mail_body := replace(v_mail_body, '!@StartDate@!', to_char(row_config_week.start_date, 'dd-Mon-yyyy'));
                    v_mail_body := replace(v_mail_body, '!@EndDate@!', to_char(row_config_week.end_date, 'dd-Mon-yyyy'));

                    /*
                    v_emp_desk := get_swp_planned_desk(
                            p_empno => emp_row.empno
                    );
                    */
                    --SMART WORK SPACE
                Elsif tab_sws_emp_list(i).primary_workspace = 2 Then
                    If cur_emp_smart_attend_plan%isopen Then
                        Close cur_emp_smart_attend_plan;
                    End If;
                    Open cur_emp_smart_attend_plan(tab_sws_emp_list(i).empno, row_config_week.start_date, row_config_week.
                    end_date);
                    Fetch cur_emp_smart_attend_plan Bulk Collect Into tab_emp_smart_plan Limit 5;
                    For i In 1..tab_emp_smart_plan.count
                    Loop

                        v_day_row := nvl(v_day_row, '') || v_sws_empty_day_row;
                        v_day_row := replace(v_day_row, 'DESKID', tab_emp_smart_plan(i).deskid);
                        v_day_row := replace(v_day_row, 'DATE', tab_emp_smart_plan(i).d_date);
                        v_day_row := replace(v_day_row, 'DAY', tab_emp_smart_plan(i).d_day);
                        v_day_row := replace(v_day_row, 'OFFICE', tab_emp_smart_plan(i).office);
                        v_day_row := replace(v_day_row, 'FLOOR', tab_emp_smart_plan(i).floor);
                        v_day_row := replace(v_day_row, 'WING', tab_emp_smart_plan(i).wing);

                    End Loop;

                    If v_day_row = v_sws_empty_day_row Or v_day_row Is Null Then
                        Continue;
                    End If;
                    v_mail_body := v_sws_mail_body;
                    v_mail_body := replace(v_mail_body, '!@StartDate@!', to_char(row_config_week.start_date, 'dd-Mon-yyyy'));
                    v_mail_body := replace(v_mail_body, '!@EndDate@!', to_char(row_config_week.end_date, 'dd-Mon-yyyy'));
                    v_mail_body := replace(v_mail_body, '!@User@!', tab_sws_emp_list(i).employee_name);
                    v_mail_body := replace(v_mail_body, '!@WEEKLYPLANNING@!', v_day_row);

                End If;
                tcmpl_app_config.pkg_app_mail_queue.sp_add_to_hold_queue(
                    p_person_id    => Null,
                    p_meta_id      => Null,
                    p_mail_to      => v_emp_mail,
                    p_mail_cc      => Null,
                    p_mail_bcc     => Null,
                    p_mail_subject => 'SWP : Attendance schedule for Smart Workspace',
                    p_mail_body1   => v_mail_body,
                    p_mail_body2   => Null,
                    p_mail_type    => 'HTML',
                    p_mail_from    => 'SELFSERVICE',
                    p_message_type => v_msg_type,
                    p_message_text => v_msg_text
                );
                Commit;
                v_day_row   := Null;
                v_mail_body := Null;
                v_msg_type  := Null;
                v_msg_text  := Null;
            End Loop;
            Exit When cur_sws_emp_list%notfound;

        End Loop;

    End;
    --
    Procedure sp_add_new_joinees_to_pws
    As
    Begin
        Insert Into swp_primary_workspace (key_id, empno, primary_workspace, start_date, modified_on, modified_by, active_code,
            assign_code)
        Select
            dbms_random.string('X', 10),
            empno,
            Case
                When dd.assign = Null Then
                    1
                Else
                    2
            End pws,
            greatest(doj, to_date('31-Jan-2022')),
            sysdate,
            'Sys',
            2,
            e.assign
        From
            ss_emplmast                e,
            swp_deputation_departments dd
        Where
            e.status     = 1
            And e.assign = dd.assign(+)
            And emptype In (
                Select
                    emptype
                From
                    swp_include_emptype
            )
            And e.assign Not In (
                Select
                    assign
                From
                    swp_exclude_assign
            )
            And empno Not In (
                Select
                    empno
                From
                    swp_primary_workspace
            );
    End sp_add_new_joinees_to_pws;

    Procedure init_configuration(p_sysdate Date) As
        v_cur_week_mon        Date;
        v_cur_week_fri        Date;
        v_next_week_key_id    Varchar2(8);
        v_current_week_key_id Varchar2(8);
        v_count               Number;
    Begin
        Select
            Count(*)
        Into
            v_count
        From
            swp_config_weeks;
        If v_count > 0 Then
            Return;
        End If;
        v_cur_week_mon        := iot_swp_common.get_monday_date(p_sysdate);
        v_cur_week_fri        := iot_swp_common.get_friday_date(p_sysdate);
        v_current_week_key_id := dbms_random.string('X', 8);
        --Insert New Plan dates
        Insert Into swp_config_weeks(
            key_id,
            start_date,
            end_date,
            planning_flag,
            pws_open,
            ows_open,
            sws_open
        )
        Values(
            v_current_week_key_id,
            v_cur_week_mon,
            v_cur_week_fri,
            c_cur_plan_code,
            c_plan_close_code,
            c_plan_close_code,
            c_plan_close_code
        );

    End;

    --
    Procedure close_planning As
        b_update_planning_flag Boolean := false;
    Begin
        Update
            swp_config_weeks
        Set
            pws_open = c_plan_close_code,
            ows_open = c_plan_close_code,
            sws_open = c_plan_close_code
        Where
            pws_open    = c_plan_open_code
            Or ows_open = c_plan_open_code
            Or sws_open = c_plan_open_code;
        If b_update_planning_flag Then
            Update
                swp_config_weeks
            Set
                planning_flag = c_past_plan_code
            Where
                planning_flag = c_cur_plan_code;

            Update
                swp_config_weeks
            Set
                planning_flag = c_cur_plan_code
            Where
                planning_flag = c_future_plan_code;

        End If;
    End close_planning;
    --

    Procedure do_dms_data_to_plan(p_week_key_id Varchar2) As
    Begin
        Delete
            From dms.dm_usermaster_swp_plan;
        Delete
            From dms.dm_deskallocation_swp_plan;
        Delete
            From dms.dm_desklock_swp_plan;
        Commit;

        Insert Into dms.dm_usermaster_swp_plan(
            fk_week_key_id,
            empno,
            deskid,
            costcode,
            dep_flag
        )
        Select
            p_week_key_id,
            empno,
            deskid,
            costcode,
            dep_flag
        From
            dms.dm_usermaster;

        Insert Into dms.dm_deskallocation_swp_plan(
            fk_week_key_id,
            deskid,
            assetid
        )
        Select
            p_week_key_id,
            deskid,
            assetid
        From
            dms.dm_deskallocation;

        Insert Into dms.dm_desklock_swp_plan(
            fk_week_key_id,
            unqid,
            empno,
            deskid,
            targetdesk,
            blockflag,
            blockreason
        )
        Select
            p_week_key_id,
            unqid,
            empno,
            deskid,
            targetdesk,
            blockflag,
            blockreason
        From
            dms.dm_desklock;
    End;

    Procedure do_dms_snapshot(p_sysdate Date) As

    Begin
        Delete
            From dms.dm_deskallocation_snapshot;

        Insert Into dms.dm_deskallocation_snapshot(
            snapshot_date,
            deskid,
            assetid
        )
        Select
            p_sysdate,
            deskid,
            assetid
        From
            dms.dm_deskallocation;

        Delete
            From dms.dm_usermaster_snapshot;

        Insert Into dms.dm_usermaster_snapshot(
            snapshot_date,
            empno,
            deskid,
            costcode,
            dep_flag
        )
        Select
            p_sysdate,
            empno,
            deskid,
            costcode,
            dep_flag
        From
            dms.dm_usermaster;

        Delete
            From dms.dm_desklock_snapshot;

        Insert Into dms.dm_desklock_snapshot(
            snapshot_date,
            unqid,
            empno,
            deskid,
            targetdesk,
            blockflag,
            blockreason
        )
        Select
            p_sysdate,
            unqid,
            empno,
            deskid,
            targetdesk,
            blockflag,
            blockreason
        From
            dms.dm_desklock;

        Commit;

    End;
    --
    Procedure toggle_plan_future_to_curr(
        p_sysdate Date
    ) As
        rec_config_week swp_config_weeks%rowtype;
        v_sysdate       Date;
    Begin
        v_sysdate := trunc(p_sysdate);

        Select
            *
        Into
            rec_config_week
        From
            swp_config_weeks
        Where
            key_id In (
                Select
                    key_id
                From
                    (
                        Select
                            key_id
                        From
                            swp_config_weeks
                        Order By start_date Desc
                    )
                Where
                    Rownum = 1
            );

        If rec_config_week.start_date != v_sysdate Then
            Return;
        End If;
        --Close Planning
        close_planning;

        --toggle CURRENT to PAST
        Update
            swp_config_weeks
        Set
            planning_flag = c_past_plan_code
        Where
            planning_flag = c_cur_plan_code;

        --toggle FUTURE to CURRENT 
        Update
            swp_config_weeks
        Set
            planning_flag = c_cur_plan_code
        Where
            planning_flag = c_future_plan_code;

        --Toggle WorkSpace planning FUTURE to CURRENT
        Update
            swp_primary_workspace
        Set
            active_code = c_past_plan_code
        Where
            active_code = c_cur_plan_code
            And empno In (
                Select
                    empno
                From
                    swp_primary_workspace
                Where
                    active_code = c_future_plan_code
            );

        Update
            swp_primary_workspace
        Set
            active_code = c_cur_plan_code
        Where
            active_code = c_future_plan_code;

    End toggle_plan_future_to_curr;
    --
    Procedure rollover_n_open_planning(p_sysdate Date) As
        v_next_week_mon    Date;
        v_next_week_fri    Date;
        v_next_week_key_id Varchar2(8);

        rec_config_week    swp_config_weeks%rowtype;
    Begin
        --Close and toggle existing planning
        toggle_plan_future_to_curr(p_sysdate);

        v_next_week_mon    := iot_swp_common.get_monday_date(p_sysdate + 6);
        v_next_week_fri    := iot_swp_common.get_friday_date(p_sysdate + 6);
        v_next_week_key_id := dbms_random.string('X', 8);
        --Insert New Plan dates
        Insert Into swp_config_weeks(
            key_id,
            start_date,
            end_date,
            planning_flag,
            pws_open,
            ows_open,
            sws_open
        )
        Values(
            v_next_week_key_id,
            v_next_week_mon,
            v_next_week_fri,
            c_future_plan_code,
            c_plan_close_code,
            c_plan_close_code,
            c_plan_close_code
        );

        --Get current week key id
        Select
            *
        Into
            rec_config_week
        From
            swp_config_weeks
        Where
            key_id In (
                Select
                    key_id
                From
                    (
                        Select
                            key_id
                        From
                            swp_config_weeks
                        Where
                            key_id <> v_next_week_key_id
                        Order By start_date Desc
                    )
                Where
                    Rownum = 1
            );

        Insert Into swp_smart_attendance_plan(
            key_id,
            ws_key_id,
            empno,
            attendance_date,
            modified_on,
            modified_by,
            deskid,
            week_key_id
        )
        Select
            dbms_random.string('X', 10),
            a.ws_key_id,
            a.empno,
            trunc(a.attendance_date) + 7,
            p_sysdate,
            'Sys',
            a.deskid,
            v_next_week_key_id
        From
            swp_smart_attendance_plan a
        Where
            week_key_id = rec_config_week.key_id;

        --
        --do snapshot of DESK+USER & DESK+ASSET & Also DESKLOCK mapping
        do_dms_snapshot(trunc(p_sysdate));
        ---

        do_dms_data_to_plan(v_next_week_key_id);
    End rollover_n_open_planning;

    --
    Procedure sp_configuration Is
        v_secondlast_workdate Date;
        v_sysdate             Date;
        v_fri_date            Date;
        v_is_second_last_day  Boolean;
        Type rec Is Record(
                work_date     Date,
                work_day_desc Varchar2(100),
                rec_num       Number
            );

        Type typ_tab_work_day Is Table Of rec;
        tab_work_day          typ_tab_work_day;
    Begin
        sp_add_new_joinees_to_pws;
        v_sysdate            := trunc(sysdate);
        v_fri_date           := iot_swp_common.get_friday_date(trunc(v_sysdate));
        --
        init_configuration(v_sysdate);

        v_is_second_last_day := fn_is_second_last_day_of_week(v_sysdate);

        If v_is_second_last_day Then --SECOND_LAST working day (THURSDAY)
            rollover_n_open_planning(v_sysdate);
            --v_sysdate EQUAL LAST working day "FRIDAY"
            --        ElsIf V_SYSDATE = tab_work_day(1).work_date Then --LAST working day
        Elsif v_sysdate = v_fri_date Then
            close_planning;
        Elsif to_char(v_sysdate, 'Dy') = 'Mon' Then
            toggle_plan_future_to_curr(v_sysdate);
        Else
            Null;
            --ToBeDecided
        End If;
    End sp_configuration;

End iot_swp_config_week;
/
---------------------------
--Changed PACKAGE BODY
--IOT_PUNCH_DETAILS
---------------------------
CREATE OR REPLACE PACKAGE BODY "SELFSERVICE"."IOT_PUNCH_DETAILS" As

    Procedure calculate_weekly_cfwd_hrs(
        p_wk_bfwd_dhrs   Number,
        p_wk_dhrs        Number,
        p_lday_lcome_ego Number,
        p_fri_sl_app     Number,
        p_cfwd_dhrs Out  Number,
        p_pn_hrs    Out  Number
    )
    As
        v_wk_negative_delta Number;
    Begin
        v_wk_negative_delta := nvl(p_wk_bfwd_dhrs, 0) + nvl(p_wk_dhrs, 0);
        If v_wk_negative_delta >= 0 Then
            p_pn_hrs    := 0;
            p_cfwd_dhrs := 0;
            Return;
        End If;
        If p_fri_sl_app <> 1 Then
            p_pn_hrs := ceil((v_wk_negative_delta * -1) / 60);
            If p_pn_hrs Between 5 And 8 Then
                p_pn_hrs := 8;
            End If;

            If p_pn_hrs * 60 > v_wk_negative_delta * -1 Then
                p_cfwd_dhrs := 0;
            Else
                p_cfwd_dhrs := v_wk_negative_delta + p_pn_hrs * 60;
            End If;
        Elsif p_fri_sl_app = 1 Then
            If v_wk_negative_delta > p_lday_lcome_ego Then
                p_pn_hrs    := 0;
                p_cfwd_dhrs := v_wk_negative_delta;
            Elsif v_wk_negative_delta < p_lday_lcome_ego Then
                p_pn_hrs := ceil((v_wk_negative_delta + (p_lday_lcome_ego * -1)) * -1 / 60);
                If p_pn_hrs Between 5 And 8 Then
                    p_pn_hrs := 8;
                End If;
                If p_pn_hrs * 60 > v_wk_negative_delta * -1 Then
                    p_cfwd_dhrs := 0;
                Else
                    p_cfwd_dhrs := v_wk_negative_delta + p_pn_hrs * 60;
                End If;
            End If;
        End If;
        p_pn_hrs            := nvl(p_pn_hrs, 0) * 60;
    End;
    /*
        Function fn_punch_details_4_self(
            p_person_id Varchar2,
            p_meta_id   Varchar2,
            p_yyyymm    Varchar2
        ) Return Sys_Refcursor As
            v_start_date             Date;
            v_end_date               Date;
            v_max_punch              Number;
            v_empno                  Varchar2(5);
            v_prev_delta_hrs         Number;
            v_prev_cfwd_lwd_deltahrs Number;
            v_prev_lc_app_cntr       Number;
            c                        Sys_Refcursor;
            e_employee_not_found     Exception;
            Pragma exception_init(e_employee_not_found, -20001);
        Begin
            v_empno      := get_empno_from_meta_id(p_meta_id);
            If v_empno = 'ERRRR' Then
                Raise e_employee_not_found;
                Return Null;
            End If;
            v_end_date   := last_day(to_date(p_yyyymm, 'yyyymm'));
            v_start_date := n_getstartdate(to_char(v_end_date, 'mm'), to_char(v_end_date, 'yyyy'));

            v_max_punch  := n_maxpunch(v_empno, v_start_date, v_end_date);

            --n_cfwd_lwd_deltahrs(v_empno, to_date(p_yyyymm, 'yyyymm'), 0, v_prev_delta_hrs, v_prev_cfwd_lwd_deltahrs, v_prev_lc_app_cntr);

            Open c For
                Select
                    empno,
                    days,
                    wk_of_year,
                    penaltyhrs,
                    mdate,
                    sday,
                    d_date,
                    shiftcode,
                    islod,
                    issunday,
                    islwd,
                    islcapp,
                    issleaveapp,
                    is_absent,
                    slappcntr,

                    ego,
                    wrkhrs,
                    tot_punch_nos,
                    deltahrs,
                    extra_hours,
                    last_day_c_fwd_dhrs,
                    Sum(wrkhrs) Over (Partition By wk_of_year)   As sum_work_hrs,
                    Sum(deltahrs) Over (Partition By wk_of_year) As sum_delta_hrs,
                    0                                            bfwd_delta_hrs,
                    0                                            cfwd_delta_hrs,
                    0                                            penalty_leave_hrs
                From
                    (
                        Select
                            main_main_query.*,
                            n_otperiod(v_empno, d_date, shiftcode, deltahrs) As extra_hours,
                            Case
                                When islwd = 1 Then

                                    lastday_cfwd_dhrs1(
                                        p_deltahrs  => deltahrs,
                                        p_ego       => ego,
                                        p_slapp     => issleaveapp,
                                        p_slappcntr => slappcntr,
                                        p_islwd     => islwd
                                    )
                                Else
                                    0
                            End                                              As last_day_c_fwd_dhrs

                        From
                            (
                                Select
                                    main_query.*, n_deltahrs(v_empno, d_date, shiftcode, penaltyhrs) As deltahrs
                                From
                                    (
                                        Select
                                            v_empno                                                  As empno,
                                            to_char(d_date, 'dd')                                    As days,
                                            wk_of_year,
                                            penaltyleave1(

                                                latecome1(v_empno, d_date),
                                                earlygo1(v_empno, d_date),
                                                islastworkday1(v_empno, d_date),

                                                Sum(islcomeegoapp(v_empno, d_date))
                                                    Over ( Partition By wk_of_year Order By d_date
                                                        Range Between Unbounded Preceding And Current Row),

                                                n_sum_slapp_count(v_empno, d_date),

                                                islcomeegoapp(v_empno, d_date),
                                                issleaveapp(v_empno, d_date)
                                            )                                                        As penaltyhrs,

                                            to_char(d_date, 'dd-Mon-yyyy')                           As mdate,
                                            d_dd                                                     As sday,
                                            d_date,
                                            getshift1(v_empno, d_date)                               As shiftcode,
                                            isleavedeputour(d_date, v_empno)                         As islod,
                                            get_holiday(d_date)                                      As issunday,
                                            islastworkday1(v_empno, d_date)                          As islwd,
                                            lc_appcount(v_empno, d_date)                             As islcapp,
                                            issleaveapp(v_empno, d_date)                             As issleaveapp,

                                            n_sum_slapp_count(v_empno, d_date)                       As slappcntr,

                                            isabsent(v_empno, d_date)                                As is_absent,
                                            earlygo1(v_empno, d_date)                                As ego,
                                            n_workedhrs(v_empno, d_date, getshift1(v_empno, d_date)) As wrkhrs,

                                            v_max_punch                                              tot_punch_nos

                                        From
                                            ss_days_details
                                        Where
                                            d_date Between v_start_date And v_end_date
                                        Order By d_date
                                    ) main_query
                            ) main_main_query
                    );

            Return c;
        End fn_punch_details_4_self;
    */
    Function fn_punch_details_4_self(
        p_person_id Varchar2,
        p_meta_id   Varchar2,
        p_empno     Varchar2 Default Null,
        p_yyyymm    Varchar2,
        p_for_ot    Varchar2 Default 'KO'
    ) Return typ_tab_punch_data
        Pipelined
    Is
        v_prev_delta_hrs               Number;
        v_prev_lwrk_day_cfwd_delta_hrs Number;
        v_prev_lcome_app_cntr          Number;
        tab_punch_data                 typ_tab_punch_data;
        v_start_date                   Date;
        v_end_date                     Date;
        v_max_punch                    Number;
        v_empno                        Varchar2(5);
        e_employee_not_found           Exception;
        v_is_fri_lcome_ego_app         Number;
        c_absent                       Constant Number := 1;
        c_ldt_leave                    Constant Number := 1;
        c_ldt_tour_depu                Constant Number := 2;
        c_ldt_remote_work              Constant Number := 3;
        v_count                        Number;
        Pragma exception_init(e_employee_not_found, -20001);
    Begin
        If Trim(p_empno) Is Null Then
            v_empno := get_empno_from_meta_id(p_meta_id);
            If v_empno = 'ERRRR' Then
                Raise e_employee_not_found;
                Return;
            End If;
            /*Else
                Select
                    Count(*)
                Into
                    v_count
                From
                    ss_emplmast
                Where
                    empno      = p_empno
                    And status = 1;

                If v_count = 0 Then
                    Raise e_employee_not_found;
                    Return;
                Else
                    v_empno := p_empno;
                End If;*/
        Else
            v_empno := p_empno;

        End If;
        If p_for_ot = 'OK' Then
            v_end_date := n_getenddate(substr(p_yyyymm, 5, 2), substr(p_yyyymm, 1, 4));
        Else
            v_end_date := last_day(to_date(p_yyyymm, 'yyyymm'));
        End If;
        v_start_date := n_getstartdate(substr(p_yyyymm, 5, 2), substr(p_yyyymm, 1, 4));

        v_max_punch  := n_maxpunch(v_empno, v_start_date, v_end_date);

        n_cfwd_lwd_deltahrs(
            p_empno       => v_empno,
            p_pdate       => to_date(p_yyyymm, 'yyyymm'),
            p_savetot     => 0,
            p_deltahrs    => v_prev_delta_hrs,
            p_lwddeltahrs => v_prev_lwrk_day_cfwd_delta_hrs,
            p_lcappcntr   => v_prev_lcome_app_cntr
        );

        Open cur_for_punch_data(v_empno, v_start_date, v_end_date);
        Loop
            Fetch cur_for_punch_data Bulk Collect Into tab_punch_data Limit 7;
            For i In 1..tab_punch_data.count
            Loop

                --tab_punch_data(i).str_wrk_hrs              := to_hrs(tab_punch_data(i).wrk_hrs);
                --tab_punch_data(i).str_delta_hrs            := to_hrs(tab_punch_data(i).delta_hrs);
                --tab_punch_data(i).str_extra_hrs            := to_hrs(tab_punch_data(i).extra_hrs);

                If tab_punch_data(i).is_absent = 1 Then
                    tab_punch_data(i).remarks := 'Absent';
                Elsif tab_punch_data(i).penalty_hrs > 0 Then
                    If tab_punch_data(i).day_punch_count = 1 Then
                        tab_punch_data(i).remarks := tab_punch_data(i).penalty_hrs || '_HrsLeaveDedu(MissedPunch)';
                    Else
                        tab_punch_data(i).remarks := tab_punch_data(i).penalty_hrs || '_HrsLeaveDeducted';
                    End If;
                Elsif tab_punch_data(i).is_ldt = c_ldt_leave Then
                    tab_punch_data(i).remarks := 'OnLeave';
                Elsif tab_punch_data(i).is_ldt = c_ldt_tour_depu Then
                    tab_punch_data(i).remarks := 'OnTour-Depu';
                Elsif tab_punch_data(i).is_ldt = c_ldt_remote_work Then
                    tab_punch_data(i).remarks := 'RemoteWork';
                Elsif (tab_punch_data(i).is_sleave_app > 0 And tab_punch_data(i).sl_app_cntr < 3) Then
                    tab_punch_data(i).remarks := 'SLeave(Apprd)';
                Elsif tab_punch_data(i).is_lc_app > 0 Then
                    tab_punch_data(i).remarks := 'LCome(Apprd)';
                Elsif tab_punch_data(i).day_punch_count = 1 Then
                    tab_punch_data(i).remarks := 'MissedPunch';
                End If;
                If tab_punch_data(i).is_lwd = 1 And tab_punch_data(i).is_sleave_app = 1 And tab_punch_data(i).sl_app_cntr < 3
                Then
                    v_is_fri_lcome_ego_app := 1;
                Else
                    v_is_fri_lcome_ego_app := 0;
                End If;

                If i = 7 Then
                    tab_punch_data(i).wk_bfwd_delta_hrs := v_prev_lwrk_day_cfwd_delta_hrs;
                    calculate_weekly_cfwd_hrs(
                        p_wk_bfwd_dhrs   => tab_punch_data(i).wk_bfwd_delta_hrs,
                        p_wk_dhrs        => tab_punch_data(i).wk_sum_delta_hrs,
                        p_lday_lcome_ego => tab_punch_data(i).last_day_cfwd_dhrs,
                        p_fri_sl_app     => v_is_fri_lcome_ego_app,
                        p_cfwd_dhrs      => tab_punch_data(i).wk_cfwd_delta_hrs,
                        p_pn_hrs         => tab_punch_data(i).wk_penalty_leave_hrs
                    );
                    v_prev_lwrk_day_cfwd_delta_hrs      := tab_punch_data(i).wk_cfwd_delta_hrs;
                End If;

                --tab_punch_data(i).str_wk_sum_work_hrs      := to_hrs(tab_punch_data(i).wk_sum_work_hrs);
                --tab_punch_data(i).str_wk_sum_delta_hrs     := to_hrs(tab_punch_data(i).wk_sum_delta_hrs);
                --tab_punch_data(i).str_wk_bfwd_delta_hrs    := to_hrs(tab_punch_data(i).wk_bfwd_delta_hrs);
                --tab_punch_data(i).str_wk_cfwd_delta_hrs    := to_hrs(tab_punch_data(i).wk_cfwd_delta_hrs);
                --tab_punch_data(i).str_wk_penalty_leave_hrs := to_hrs(tab_punch_data(i).wk_penalty_leave_hrs);

                Pipe Row(tab_punch_data(i));
            End Loop;
            tab_punch_data := Null;
            Exit When cur_for_punch_data%notfound;
        End Loop;
        Close cur_for_punch_data;
        Return;
    End fn_punch_details_4_self;

    Function fn_day_punch_list(
        p_person_id Varchar2,
        p_meta_id   Varchar2,
        p_empno     Varchar2,
        p_date      Date
    ) Return typ_tab_day_punch_list
        Pipelined
    Is
        tab_day_punch_list   typ_tab_day_punch_list;
        v_count              Number;

        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);

    Begin

        Select
            Count(*)
        Into
            v_count
        From
            ss_emplmast
        Where
            empno = p_empno;
        If v_count = 0 Then
            Raise e_employee_not_found;
            Return;
        End If;

        Open cur_day_punch_list(p_empno, p_date);
        Loop
            Fetch cur_day_punch_list Bulk Collect Into tab_day_punch_list Limit 50;
            For i In 1..tab_day_punch_list.count
            Loop
                Pipe Row(tab_day_punch_list(i));
            End Loop;
            Exit When cur_day_punch_list%notfound;
        End Loop;
        Close cur_day_punch_list;
        Return;
    End fn_day_punch_list;

    Procedure punch_details_pipe(
        p_person_id Varchar2,
        p_meta_id   Varchar2,
        p_empno     Varchar2 Default Null,
        p_yyyymm    Varchar2,
        p_for_ot    Varchar2 Default 'KO'
    )
    Is
        v_prev_delta_hrs               Number;
        v_prev_lwrk_day_cfwd_delta_hrs Number;
        v_prev_lcome_app_cntr          Number;
        tab_punch_data                 typ_tab_punch_data;
        v_start_date                   Date;
        v_end_date                     Date;
        v_max_punch                    Number;
        v_empno                        Varchar2(5);
        e_employee_not_found           Exception;
        v_is_fri_lcome_ego_app         Number;
        c_absent                       Constant Number := 1;
        c_ldt_leave                    Constant Number := 1;
        c_ldt_tour_depu                Constant Number := 2;
        c_ldt_remote_work              Constant Number := 3;
        v_count                        Number;
        Pragma exception_init(e_employee_not_found, -20001);
    Begin
        If Trim(p_empno) Is Null Then
            v_empno := get_empno_from_meta_id(p_meta_id);
            If v_empno = 'ERRRR' Then
                Raise e_employee_not_found;
                Return;
            End If;
        Else
            Select
                Count(*)
            Into
                v_count
            From
                ss_emplmast
            Where
                empno      = p_empno
                And status = 1;

            If v_count = 0 Then
                Raise e_employee_not_found;
                Return;
            Else
                v_empno := p_empno;
            End If;
        End If;
        If p_for_ot = 'OK' Then
            v_end_date := n_getenddate(substr(p_yyyymm, 5, 2), substr(p_yyyymm, 1, 4));
        Else
            v_end_date := last_day(to_date(p_yyyymm, 'yyyymm'));
        End If;
        v_start_date := n_getstartdate(substr(p_yyyymm, 5, 2), substr(p_yyyymm, 1, 4));

        v_max_punch  := n_maxpunch(v_empno, v_start_date, v_end_date);

        n_cfwd_lwd_deltahrs(
            p_empno       => v_empno,
            p_pdate       => to_date(p_yyyymm, 'yyyymm'),
            p_savetot     => 0,
            p_deltahrs    => v_prev_delta_hrs,
            p_lwddeltahrs => v_prev_lwrk_day_cfwd_delta_hrs,
            p_lcappcntr   => v_prev_lcome_app_cntr
        );

        Open cur_for_punch_data(v_empno, v_start_date, v_end_date);
        Loop
            Fetch cur_for_punch_data Bulk Collect Into tab_punch_data Limit 7;
            For i In 1..tab_punch_data.count
            Loop

                --tab_punch_data(i).str_wrk_hrs              := to_hrs(tab_punch_data(i).wrk_hrs);
                --tab_punch_data(i).str_delta_hrs            := to_hrs(tab_punch_data(i).delta_hrs);
                --tab_punch_data(i).str_extra_hrs            := to_hrs(tab_punch_data(i).extra_hrs);

                If tab_punch_data(i).is_absent = 1 Then
                    tab_punch_data(i).remarks := 'Absent';
                Elsif tab_punch_data(i).penalty_hrs > 0 Then
                    If tab_punch_data(i).day_punch_count = 1 Then
                        tab_punch_data(i).remarks := tab_punch_data(i).penalty_hrs || '-HoursLeaveDeducted(MissedPunch)';
                    Else
                        tab_punch_data(i).remarks := tab_punch_data(i).penalty_hrs || '-HoursLeaveDeducted';
                    End If;
                Elsif tab_punch_data(i).is_ldt = c_ldt_leave Then
                    tab_punch_data(i).remarks := 'OnLeave';
                Elsif tab_punch_data(i).is_ldt = c_ldt_tour_depu Then
                    tab_punch_data(i).remarks := 'OnTour-Depu';
                Elsif tab_punch_data(i).is_ldt = c_ldt_remote_work Then
                    tab_punch_data(i).remarks := 'RemoteWork';
                Elsif tab_punch_data(i).day_punch_count = 1 Then
                    tab_punch_data(i).remarks := 'MissedPunch';
                End If;
                If tab_punch_data(i).is_lwd = 1 And tab_punch_data(i).is_sleave_app = 1 And tab_punch_data(i).sl_app_cntr < 3
                Then
                    v_is_fri_lcome_ego_app := 1;
                Else
                    v_is_fri_lcome_ego_app := 0;
                End If;

                If i = 7 Then
                    tab_punch_data(i).wk_bfwd_delta_hrs := v_prev_lwrk_day_cfwd_delta_hrs;
                    calculate_weekly_cfwd_hrs(
                        p_wk_bfwd_dhrs   => tab_punch_data(i).wk_bfwd_delta_hrs,
                        p_wk_dhrs        => tab_punch_data(i).wk_sum_delta_hrs,
                        p_lday_lcome_ego => tab_punch_data(i).last_day_cfwd_dhrs,
                        p_fri_sl_app     => v_is_fri_lcome_ego_app,
                        p_cfwd_dhrs      => tab_punch_data(i).wk_cfwd_delta_hrs,
                        p_pn_hrs         => tab_punch_data(i).wk_penalty_leave_hrs
                    );
                    v_prev_lwrk_day_cfwd_delta_hrs      := tab_punch_data(i).wk_cfwd_delta_hrs;
                End If;

                --tab_punch_data(i).str_wk_sum_work_hrs      := to_hrs(tab_punch_data(i).wk_sum_work_hrs);
                --tab_punch_data(i).str_wk_sum_delta_hrs     := to_hrs(tab_punch_data(i).wk_sum_delta_hrs);
                --tab_punch_data(i).str_wk_bfwd_delta_hrs    := to_hrs(tab_punch_data(i).wk_bfwd_delta_hrs);
                --tab_punch_data(i).str_wk_cfwd_delta_hrs    := to_hrs(tab_punch_data(i).wk_cfwd_delta_hrs);
                --tab_punch_data(i).str_wk_penalty_leave_hrs := to_hrs(tab_punch_data(i).wk_penalty_leave_hrs);

            End Loop;
            tab_punch_data := Null;
            Exit When cur_for_punch_data%notfound;
        End Loop;
        Close cur_for_punch_data;
        Return;
    End;

End iot_punch_details;
/
