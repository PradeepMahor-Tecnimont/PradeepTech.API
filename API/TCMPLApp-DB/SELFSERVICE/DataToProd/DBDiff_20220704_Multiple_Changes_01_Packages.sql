
set define off;
--------------------------------------------------------
--  File created - Monday-July-04-2022   
--------------------------------------------------------
---------------------------
--Changed TRIGGER
--SS_TRIG_DEPU_UPDATE
---------------------------
ALTER TRIGGER "SELFSERVICE"."SS_TRIG_DEPU_UPDATE" DISABLE;
/
---------------------------
--Changed PROCEDURE
--SEND_MAIL_FROM_API
---------------------------
CREATE OR REPLACE PROCEDURE "SELFSERVICE"."SEND_MAIL_FROM_API" (
    p_mail_to      Varchar2,
    p_mail_cc      Varchar2,
    p_mail_bcc     Varchar2,
    p_mail_subject Varchar2,
    p_mail_body    Varchar2,
    p_mail_profile Varchar2,
    p_mail_format  Varchar2 Default Null,
    p_success Out  Varchar2,
    p_message Out  Varchar2
) As
    v_mail_profile Varchar2(20);
    v_mail_format  Varchar2(20);
Begin
    --return;
    If Trim(p_mail_profile) Is Null Then
        v_mail_profile := 'SELFSERVICE';
    Else
        v_mail_profile := p_mail_profile;
    End If;

    If Trim(p_mail_format) Is Null Then
        v_mail_format := 'Text';
    Else
        v_mail_format := p_mail_format;
    End If;

    tcmpl_app_config.pkg_app_mail_queue.sp_add_to_queue(
        p_person_id    => Null,
        p_meta_id      => Null,
        p_mail_to      => p_mail_to,
        p_mail_cc      => p_mail_cc,
        p_mail_bcc     => p_mail_bcc,
        p_mail_subject => p_mail_subject,
        p_mail_body1   => p_mail_body,
        p_mail_body2   => Null,
        p_mail_type    => v_mail_format,
        p_mail_from    => v_mail_profile,
        p_message_type => p_success,
        p_message_text => p_message
    );

    Return;

    commonmasters.pkg_mail.send_api_mail(
        p_mail_to      => p_mail_to,
        p_mail_cc      => p_mail_cc,
        p_mail_bcc     => p_mail_bcc,
        p_mail_subject => p_mail_subject,
        p_mail_body    => p_mail_body,
        p_mail_profile => v_mail_profile,
        p_mail_format  => v_mail_format,
        p_success      => p_success,
        p_message      => p_message
    );
    /*
    Example

    send_mail_from_api (
        p_mail_to        => 'abc.yahoo.com, def.yahoo.com, ghy123.hotmail.com',
        p_mail_cc        => 'abc.yahoo.com, def.yahoo.com, ghy123.hotmail.com',
        p_mail_bcc       => p_mail_bcc,
        p_mail_subject   => 'This is a Subject of Sample mail',
        p_mail_body      => 'This is Body of Sample mail',
        p_mail_profile   => 'TIMESHEET',   (example --> SQSI, OSD, ALHR, etc...)
        p_success        => p_success,
        p_message        => p_message
    );

    */

End send_mail_from_api;
/
---------------------------
--Changed PACKAGE
--SS_MAIL
---------------------------
CREATE OR REPLACE PACKAGE "SELFSERVICE"."SS_MAIL" As
    c_smtp_mail_server Constant Varchar2(60) := 'ticbexhcn1.ticb.comp';
    c_sender_mail_id Constant Varchar2(60) := 'selfservice@tecnimont.in';
    c_web_server Constant Varchar2(60) := 'http://tplapps02.ticb.comp:80';
    c_empno Constant Varchar2(10) := '&EmpNo&';
    c_app_no Constant Varchar2(10) := '&App_No&';
    c_emp_name Constant Varchar2(10) := '&Emp_Name&';
    c_leave_period Constant Varchar2(20) := '&Leave_Period&';
    c_approval_url Constant Varchar2(20) := '!@ApprovalUrl@!';
    c_msg_type_new_leave_app Constant Number := 1;

    --c_leave_app_msg constant varchar2(2000) := ' Test ';

    c_leave_app_msg Constant Varchar2(2000) := 'There is a Leave application of  ' || c_empno || '  -  ' || c_emp_name ||
        '  for ' || c_leave_period || ' Days.' || chr(13) || chr(10) ||
        'For necessary action, please navigate to ' || chr(13) || chr(10) || c_approval_url || ' .'
        || chr(13) || chr(10) ||
        chr(13) || chr(10) || chr(13) || chr(10) ||
        'Note : This is a system generated message.'
        || chr(13) || chr(10)
        || 'Please do not reply to this message';

    c_leave_app_subject Constant Varchar2(1000) := 'Leave application of ' || c_empno || ' - ' || c_emp_name;

    pkg_var_msg Varchar2(1000);
    pkg_var_sub Varchar2(200);

    Procedure send_mail_2_user_nu(
        param_to_mail_id In Varchar2,
        param_subject    In Varchar2,
        param_body       In Varchar2
    );
    Procedure send_mail(
        param_to_mail_id  Varchar2,
        param_subject     Varchar2,
        param_body        Varchar2,
        param_success Out Number,
        param_message Out Varchar2
    );

    Procedure send_msg_new_leave_app(
        param_app_no      Varchar2,
        param_success Out Number,
        param_message Out Varchar2
    );

    Procedure send_test_email_2_user(
        param_to_mail_id In Varchar2
    );

    Procedure send_html_mail(
        param_to_mail_id  Varchar2,
        param_subject     Varchar2,
        param_body        Varchar2,
        param_success Out Number,
        param_message Out Varchar2
    );
    Procedure send_email_2_user_async(
        param_to_mail_id In Varchar2
    );

    c_leave_rejected_body Varchar2(4000) := '
            <p>You leave application has been rejected.</p>
            <p>Following are the details</p>
            <table style="border-collapse: collapse;" border="1">
            <tbody>
            <tr>
            <td>Application Id</td>
            <td><strong>@app_id</strong></td>
            <td><strong>_____</strong></td>
            <td>Date</td>
            <td><strong>@app_date</strong></td>
            </tr>
            <tr>
            <td>Leave Start Date</td>
            <td><strong>@start_date</strong></td>
            <td></td>
            <td>Leave end date</td>
            <td><strong>@end_date</strong></td>
            </tr>
            <tr>
            <td>Leave period</td>
            <td><strong>@leave_period</strong></td>
            <td></td>
            <td>Leave type</td>
            <td><strong>@leave_type</strong></td>
            </tr>
            <tr>
            <td>Lead approval</td>
            <td><strong>@lead_approval</strong></td>
            <td></td>
            <td>Lead remarks</td>
            <td><strong>@lead_remarks</strong></td>
            </tr>
            <tr>
            <td>HoD approval</td>
            <td><strong>@hod_approval</strong></td>
            <td></td>
            <td>HoD remarks</td>
            <td><strong>@hod_remarks</strong></td>
            </tr>
            <tr>
            <td>HR approval</td>
            <td><strong>@hrd_approval</strong></td>
            <td></td>
            <td>HR remarks</td>
            <td><strong>@hrd_remarks</strong></td>
            </tr>
            </tbody>
            </table>
            <p>Note - This is a system generated message.</p>
            <p>Please do not reply to this message</p>    
    ';
    c_onduty_rejected_body Varchar2(4000) := '
        <p>You leave application has been rejected.</p>
        <p>Following are the details</p>
        <table style="border-collapse: collapse;" border="1">
        <tbody>
        <tr>
        <td>Application Id</td>
        <td><strong>@app_id</strong></td>
        <td><strong>_____</strong></td>
        <td>Date</td>
        <td><strong>@app_date</strong></td>
        </tr>
        <tr>
        <td>On duty type</td>
        <td><strong>@type</strong></td>
        <td> </td>
        <td>On duty sub-type</td>
        <td><strong>@sub_type</strong></td>
        </tr>
        <tr>
        <td>Start date</td>
        <td><strong>@start_date</strong></td>
        <td> </td>
        <td>End date</td>
        <td><strong>@end_date</strong></td>
        </tr>
        <tr>
        <td>Start time</td>
        <td><strong>@start_time</strong></td>
        <td> </td>
        <td>End time</td>
        <td><strong>@end_time</strong></td>
        </tr>
        <tr>
        <td>Reason/description</td>
        <td colspan="4"><strong>@reason</strong></td>
        </tr>
        <tr>
        <td>Lead approval</td>
        <td><strong>@lead_approval</strong></td>
        <td> </td>
        <td>Lead remarks</td>
        <td><strong>@lead_remarks</strong></td>
        </tr>
        <tr>
        <td>HoD approval</td>
        <td><strong>@hod_approval</strong></td>
        <td> </td>
        <td>HoD remarks</td>
        <td><strong>@hod_remarks</strong></td>
        </tr>
        <tr>
        <td>HR approval</td>
        <td><strong>@hrd_approval</strong></td>
        <td> </td>
        <td>HR remarks</td>
        <td><strong>@hrd_remarks</strong></td>
        </tr>
        </tbody>
        </table>
        <p>Note - This is a system generated message.</p>
        <p>Please do not reply to this message</p>    ';
    Procedure send_mail_leave_rejected(
        p_app_id Varchar2
    );

    Procedure send_mail_leave_reject_async(
        p_app_id In Varchar2
    );
    Procedure send_mail_onduty_rejected(
        p_onduty_rec ss_ondutyapp_rejected%rowtype,
        p_depu_rec   ss_depu_rejected%rowtype
    );
End ss_mail;
/
---------------------------
--Changed PACKAGE
--IOT_LEAVE
---------------------------
CREATE OR REPLACE PACKAGE "SELFSERVICE"."IOT_LEAVE" As

    Type typ_tab_string Is Table Of Varchar(4000) Index By Binary_Integer;

    Procedure sp_validate_new_leave(
        p_person_id          Varchar2,
        p_meta_id            Varchar2,

        p_leave_type         Varchar2,
        p_start_date         Date,
        p_end_date           Date,
        p_half_day_on        Number,

        p_leave_period   Out Number,
        p_last_reporting Out Varchar2,
        p_resuming       Out Varchar2,
        p_message_type   Out Varchar2,
        p_message_text   Out Varchar2

    );

    Procedure sp_validate_pl_revision(
        p_person_id          Varchar2,
        p_meta_id            Varchar2,

        p_application_id     Varchar2,
        p_leave_type         Varchar2,
        p_start_date         Date,
        p_end_date           Date,
        p_half_day_on        Number,

        p_leave_period   Out Number,
        p_last_reporting Out Varchar2,
        p_resuming       Out Varchar2,
        p_message_type   Out Varchar2,
        p_message_text   Out Varchar2

    );

    Procedure sp_pl_revision_save(
        p_person_id              Varchar2,
        p_meta_id                Varchar2,

        p_application_id         Varchar2,
        p_start_date             Date,
        p_end_date               Date,
        p_half_day_on            Number,
        p_lead_empno             Varchar2,
        p_new_application_id Out Varchar2,
        p_message_type       Out Varchar2,
        p_message_text       Out Varchar2

    );

    Procedure sp_add_leave_application(
        p_person_id              Varchar2,
        p_meta_id                Varchar2,

        p_leave_type             Varchar2,
        p_start_date             Date,
        p_end_date               Date,
        p_half_day_on            Number,
        p_projno                 Varchar2,
        p_care_taker             Varchar2,
        p_reason                 Varchar2,
        p_med_cert_available     Varchar2 Default Null,
        p_contact_address        Varchar2 Default Null,
        p_contact_std            Varchar2 Default Null,
        p_contact_phone          Varchar2 Default Null,
        p_office                 Varchar2,
        p_lead_empno             Varchar2,
        p_discrepancy            Varchar2 Default Null,
        p_med_cert_file_nm       Varchar2 Default Null,

        p_new_application_id Out Varchar2,

        p_message_type       Out Varchar2,
        p_message_text       Out Varchar2

    );

    Procedure sp_leave_details(
        p_person_id              Varchar2,
        p_meta_id                Varchar2,

        p_application_id         Varchar2,

        p_emp_name           Out Varchar2,
        p_leave_type         Out Varchar2,
        p_application_date   Out Varchar2,
        p_start_date         Out Varchar2,
        p_end_date           Out Varchar2,

        p_leave_period       Out Number,
        p_last_reporting     Out Varchar2,
        p_resuming           Out Varchar2,

        p_projno             Out Varchar2,
        p_care_taker         Out Varchar2,
        p_reason             Out Varchar2,
        p_med_cert_available Out Varchar2,
        p_contact_address    Out Varchar2,
        p_contact_std        Out Varchar2,
        p_contact_phone      Out Varchar2,
        p_office             Out Varchar2,
        p_lead_name          Out Varchar2,
        p_discrepancy        Out Varchar2,
        p_med_cert_file_nm   Out Varchar2,

        p_lead_approval      Out Varchar2,
        p_hod_approval       Out Varchar2,
        p_hr_approval        Out Varchar2,

        p_lead_reason        Out Varchar2,
        p_hod_reason         Out Varchar2,
        p_hr_reason          Out Varchar2,

        p_flag_is_adj        Out Varchar2,
        p_flag_can_del       Out Varchar2,

        p_message_type       Out Varchar2,
        p_message_text       Out Varchar2

    );

    Procedure sp_delete_leave_app(
        p_person_id                  Varchar2,
        p_meta_id                    Varchar2,

        p_application_id             Varchar2,

        p_medical_cert_file_name Out Varchar2,
        p_message_type           Out Varchar2,
        p_message_text           Out Varchar2
    );

    Procedure sp_delete_leave_app_force(
        p_person_id                  Varchar2,
        p_meta_id                    Varchar2,

        p_application_id             Varchar2,

        p_medical_cert_file_name Out Varchar2,
        p_message_type           Out Varchar2,
        p_message_text           Out Varchar2
    );

    Procedure sp_leave_balances(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_empno            Varchar2 Default Null,
        p_start_date       Date     Default Null,
        p_end_date         Date     Default Null,

        p_open_cl      Out Varchar2,
        p_open_sl      Out Varchar2,
        p_open_pl      Out Varchar2,
        p_open_ex      Out Varchar2,
        p_open_co      Out Varchar2,
        p_open_oh      Out Varchar2,
        p_open_lv      Out Varchar2,

        p_close_cl     Out Varchar2,
        p_close_sl     Out Varchar2,
        p_close_pl     Out Varchar2,
        p_close_ex     Out Varchar2,
        p_close_co     Out Varchar2,
        p_close_oh     Out Varchar2,
        p_close_lv     Out Varchar2,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    );

    Procedure sp_leave_approval_lead(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_leave_approvals  typ_tab_string,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    );

    Procedure sp_leave_approval_hod(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_leave_approvals  typ_tab_string,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    );

    Procedure sp_leave_approval_hr(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_leave_approvals  typ_tab_string,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    );

    Procedure sp_do_approval_4_ex_lead(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,
        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    );
End iot_leave;
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
---------------------------
--Changed PACKAGE BODY
--OD
---------------------------
CREATE OR REPLACE PACKAGE BODY "SELFSERVICE"."OD" As

    Procedure add_to_depu(
        p_empno          Varchar2,
        p_depu_type      Varchar2,
        p_bdate          Date,
        p_edate          Date,
        p_entry_by_empno Varchar2,
        p_lead_approver  Varchar2,
        p_user_ip        Varchar2,
        p_reason         Varchar2,
        p_success Out    Varchar2,
        p_message Out    Varchar2
    );

    Procedure set_variables_4_entry_by(
        p_entry_by_empno      Varchar2,
        p_entry_by_hr         Varchar2,
        p_entry_by_hr_4_self  Varchar2,
        p_lead_empno   In Out Varchar2,
        p_lead_apprl   Out    Varchar2,
        p_hod_empno    Out    Varchar2,
        p_hod_apprl    Out    Varchar2,
        p_hod_ip       Out    Varchar2,
        p_hrd_empno    Out    Varchar2,
        p_hrd_apprl    Out    Varchar2,
        p_hrd_ip       In Out Varchar2,
        p_hod_apprl_dt Out    Date,
        p_hrd_apprl_dt Out    Date
    ) As
        v_hr_ip    Varchar2(20);
        v_hr_empno Varchar2(5);
    Begin
        v_hr_ip        := p_hrd_ip;
        p_hod_apprl    := 0;
        p_hrd_apprl    := 0;
        p_lead_apprl   := 0;
        p_hrd_ip       := Null;
        --
        If lower(p_lead_empno) = 'none' Then
            p_lead_apprl := ss.apprl_none;
        End If;
        If nvl(p_entry_by_hr, 'KO') != 'OK' Or nvl(p_entry_by_hr_4_self, 'KO') = 'OK' Then
            Return;
        End If;
        --

        p_lead_empno   := 'None';
        p_lead_apprl   := ss.apprl_none;
        --
        p_hod_empno    := p_entry_by_empno;
        p_hrd_empno    := p_entry_by_empno;
        --
        p_hod_apprl    := ss.approved;
        p_hrd_apprl    := ss.approved;
        --p_lead_apprl   := 0;
        p_hod_ip       := v_hr_ip;
        p_hrd_ip       := v_hr_ip;
        --
        p_hod_apprl_dt := sysdate;
        p_hrd_apprl_dt := sysdate;
    End;

    Procedure nu_app_send_mail(
        param_app_no      Varchar2,
        param_success Out Number,
        param_message Out Varchar2
    ) As

        v_count      Number;
        v_lead_code  Varchar2(5);
        v_lead_apprl Number;
        v_empno      Varchar2(5);
        v_email_id   Varchar2(60);
        vsubject     Varchar2(100);
        vbody        Varchar2(5000);
    Begin
        Select
            Count(*)
        Into
            v_count
        From
            ss_ondutyapp
        Where
            Trim(app_no) = Trim(param_app_no);

        If v_count <> 1 Then
            Return;
        End If;
        Select
            lead_code,
            lead_apprl,
            empno
        Into
            v_lead_code,
            v_lead_apprl,
            v_empno
        From
            ss_ondutyapp
        Where
            Trim(app_no) = Trim(param_app_no);

        If trim(nvl(v_lead_code, ss.lead_none)) = trim(ss.lead_none) Then
            Select
                email
            Into
                v_email_id
            From
                ss_emplmast
            Where
                empno = (
                    Select
                        mngr
                    From
                        ss_emplmast
                    Where
                        empno = v_empno
                );

        Else
            Select
                email
            Into
                v_email_id
            From
                ss_emplmast
            Where
                empno = v_lead_code;

        End If;

        If v_email_id Is Null Then
            param_success := ss.failure;
            param_message := 'Email Id of the approver found blank. Cannot send email.';
            Return;
        End If;
        --v_email_id := 'd.bhavsar@ticb.com';

        vsubject := 'Application of ' || v_empno;
        vbody    := 'There is ' || vsubject || '. Kindly click the following URL to do the needful.';
        vbody    := vbody || '!nuLine!' || ss.application_url || '/SS_OD.asp?App_No=' || param_app_no;

        vbody    := vbody || '!nuLine!' || '!nuLine!' || '!nuLine!' || '!nuLine!' || 'Note : This is a system generated message.';

        ss_mail.send_mail(
            v_email_id,
            vsubject,
            vbody,
            param_success,
            param_message
        );
    End nu_app_send_mail;

    Procedure approve_od(
        param_array_app_no     Varchar2,
        param_array_rem        Varchar2,
        param_array_od_type    Varchar2,
        param_array_apprl_type Varchar2,
        param_approver_profile Number,
        param_approver_code    Varchar2,
        param_approver_ip      Varchar2,
        param_success Out      Varchar2,
        param_message Out      Varchar2
    ) As

        onduty      Constant Number := 2;
        deputation  Constant Number := 3;
        v_count     Number;
        Type type_app Is
            Table Of Varchar2(30) Index By Binary_Integer;
        Type type_rem Is
            Table Of Varchar2(31) Index By Binary_Integer;
        Type type_od Is
            Table Of Varchar2(3) Index By Binary_Integer;
        Type type_apprl Is
            Table Of Varchar2(3) Index By Binary_Integer;
        tab_app     type_app;
        tab_rem     type_rem;
        tab_od      type_od;
        tab_apprl   type_apprl;
        v_rec_count Number;
        sqlpartod   Varchar2(60)    := 'Update SS_OnDutyApp ';
        sqlpartdp   Varchar2(60)    := 'Update SS_Depu ';
        sqlpart2    Varchar2(500);
        strsql      Varchar2(600);
    Begin
        sqlpart2      := ' set ApproverProfile_APPRL = :Approval, ApproverProfile_Code = :Approver_EmpNo, ApproverProfile_APPRL_DT = Sysdate,
                    ApproverProfile_TCP_IP = :User_TCP_IP , ApproverProfileREASON = :Reason where App_No = :paramAppNo';
        If param_approver_profile = user_profile.type_hod Or param_approver_profile = user_profile.type_sec Then
            sqlpart2 := replace(sqlpart2, 'ApproverProfile', 'HOD');
        Elsif param_approver_profile = user_profile.type_hrd Then
            sqlpart2 := replace(sqlpart2, 'ApproverProfile', 'HRD');
        Elsif param_approver_profile = user_profile.type_lead Then
            sqlpart2 := replace(sqlpart2, 'ApproverProfile', 'LEAD');
        End If;

        With
            tab As (
                Select
                    param_array_app_no As txt_app
                From
                    dual
            )
        Select
            regexp_substr(txt_app, '[^,]+', 1, level)
        Bulk Collect
        Into
            tab_app
        From
            tab
        Connect By
            level <= length(regexp_replace(txt_app, '[^,]*'));

        v_rec_count   := Sql%rowcount;
        With
            tab As (
                Select
                    '  ' || param_array_rem As txt_rem
                From
                    dual
            )
        Select
            regexp_substr(txt_rem, '[^,]+', 1, level)
        Bulk Collect
        Into
            tab_rem
        From
            tab
        Connect By
            level <= length(regexp_replace(txt_rem, '[^,]*')) + 1;

        With
            tab As (
                Select
                    param_array_od_type As txt_od
                From
                    dual
            )
        Select
            regexp_substr(txt_od, '[^,]+', 1, level)
        Bulk Collect
        Into
            tab_od
        From
            tab
        Connect By
            level <= length(regexp_replace(txt_od, '[^,]*')) + 1;

        With
            tab As (
                Select
                    param_array_apprl_type As txt_apprl
                From
                    dual
            )
        Select
            regexp_substr(txt_apprl, '[^,]+', 1, level)
        Bulk Collect
        Into
            tab_apprl
        From
            tab
        Connect By
            level <= length(regexp_replace(txt_apprl, '[^,]*')) + 1;

        For indx In 1..tab_app.count
        Loop
            If to_number(tab_od(indx)) = deputation Then
                strsql := sqlpartdp || ' ' || sqlpart2;
            Elsif to_number(tab_od(indx)) = onduty Then
                strsql := sqlpartod || ' ' || sqlpart2;
            End If;

            Execute Immediate strsql
                Using trim(tab_apprl(indx)), param_approver_code, param_approver_ip, trim(tab_rem(indx)), trim(tab_app(indx));

            If tab_od(indx) = onduty Then
                --IF 1=2 Then
                Insert Into ss_onduty value
                (
                    Select
                        empno,
                        hh,
                        mm,
                        pdate,
                        0,
                        dd,
                        mon,
                        yyyy,
                        type,
                        app_no,
                        description,
                        getodhh(app_no, 1),
                        getodmm(app_no, 1),
                        app_date,
                        reason,
                        odtype
                    From
                        ss_ondutyapp
                    Where
                        Trim(app_no)                   = Trim(tab_app(indx))
                        And nvl(hrd_apprl, ss.pending) = ss.approved
                );

                Insert Into ss_onduty value
                (
                    Select
                        empno,
                        hh1,
                        mm1,
                        pdate,
                        0,
                        dd,
                        mon,
                        yyyy,
                        type,
                        app_no,
                        description,
                        getodhh(app_no, 2),
                        getodmm(app_no, 2),
                        app_date,
                        reason,
                        odtype
                    From
                        ss_ondutyapp
                    Where
                        Trim(app_no)                   = Trim(tab_app(indx))
                        And (type                      = 'OD'
                            Or type                    = 'IO')
                        And nvl(hrd_apprl, ss.pending) = ss.approved
                );

                If param_approver_profile = user_profile.type_hrd And to_number(tab_apprl(indx)) = ss.approved Then
                    generate_auto_punch_4od(trim(tab_app(indx)));
                End If;

            End If;

        End Loop;

        Commit;
        param_success := 'SUCCESS';
    Exception
        When Others Then
            param_success := 'FAILURE';
            param_message := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
    End;

    Procedure add_onduty_type_2(
        p_empno         Varchar2,
        p_od_type       Varchar2,
        p_b_yyyymmdd    Varchar2,
        p_e_yyyymmdd    Varchar2,
        p_entry_by      Varchar2,
        p_lead_approver Varchar2,
        p_user_ip       Varchar2,
        p_reason        Varchar2,
        p_success Out   Varchar2,
        p_message Out   Varchar2
    ) As

        v_count         Number;
        v_empno         Varchar2(5);
        v_entry_by      Varchar2(5);
        v_lead_approver Varchar2(5);
        v_od_catg       Number;
        v_bdate         Date;
        v_edate         Date;
    Begin
        --Check Employee Exists
        v_empno    := substr('0000' || p_empno, -5);
        v_entry_by := substr('0000' || p_entry_by, -5);
        v_lead_approver :=
            Case lower(p_lead_approver)
                When 'none' Then
                    'None'
                Else
                    lpad(p_lead_approver, 5, '0')
            End;

        Select
            Count(*)
        Into
            v_count
        From
            ss_emplmast
        Where
            empno = v_empno;

        If v_count = 0 Then
            p_success := 'KO';
            p_message := 'Employee not found in Database.' || v_empno || ' - ' || p_empno;
            Return;
        End If;

        v_bdate    := to_date(p_b_yyyymmdd, 'yyyymmdd');
        v_edate    := to_date(p_e_yyyymmdd, 'yyyymmdd');
        If v_edate < v_bdate Then
            p_success := 'KO';
            p_message := 'Incorrect date range specified';
            Return;
        End If;

        If v_lead_approver != 'None' Then
            Select
                Count(*)
            Into
                v_count
            From
                ss_emplmast
            Where
                empno = v_lead_approver;

            If v_count = 0 Then
                p_success := 'KO';
                p_message := 'Lead approver not found in Database.';
                Return;
            End If;

        End If;

        Select
            tabletag
        Into
            v_od_catg
        From
            ss_ondutymast
        Where
            type = p_od_type;

        If v_od_catg In (- 1, 3) Then
            add_to_depu(
                p_empno          => v_empno,
                p_depu_type      => p_od_type,
                p_bdate          => v_bdate,
                p_edate          => v_edate,
                p_entry_by_empno => v_entry_by,
                p_lead_approver  => v_lead_approver,
                p_user_ip        => p_user_ip,
                p_reason         => p_reason,
                p_success        => p_success,
                p_message        => p_message
            );
        Else
            p_success := 'KO';
            p_message := 'Invalid OnDuty Type.';
            Return;
        End If;

    Exception
        When Others Then
            p_success := 'KO';
            p_message := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
    End;

    Procedure add_to_depu(
        p_empno          Varchar2,
        p_depu_type      Varchar2,
        p_bdate          Date,
        p_edate          Date,
        p_entry_by_empno Varchar2,
        p_lead_approver  Varchar2,
        p_user_ip        Varchar2,
        p_reason         Varchar2,
        p_success Out    Varchar2,
        p_message Out    Varchar2
    ) As

        v_count                 Number;
        v_depu_row              ss_depu%rowtype;
        v_rec_no                Number;
        v_app_no                Varchar2(60);
        v_now                   Date;
        v_is_office_ip          Varchar2(10);
        v_entry_by_user_profile Number;
        v_is_entry_by_hr        Varchar2(2);
        v_is_entry_by_hr_4_self Varchar2(2);
        v_lead_approver         Varchar2(5);
        v_lead_approval         Number;
        v_hod_empno             Varchar2(5);
        v_hod_ip                Varchar2(30);
        v_hod_apprl             Number;
        v_hod_apprl_dt          Date;
        v_hrd_empno             Varchar2(5);
        v_hrd_ip                Varchar2(30);
        v_hrd_apprl             Number;
        v_hrd_apprl_dt          Date;
        v_appl_desc             Varchar2(60);
        v_curr_app_no           Varchar2(60);
    Begin
        v_now                   := sysdate;
        v_lead_approver         := p_lead_approver;
        v_hrd_ip                := p_user_ip;

        Begin
            /*
                Select
                    *
                Into
                    v_depu_row
                From
                    (
                        Select
                            *
                        From
                            ss_depu
                        Where
                            empno                         = p_empno
                            And app_date In (
                                Select
                                    Max(app_date)
                                From
                                    ss_depu
                                Where
                                    empno = p_empno
                            )
                            And to_char(app_date, 'yyyy') = to_char(v_now, 'yyyy')
                        Order By app_no Desc
                    )
                Where
                    Rownum = 1;
*/
            Select
                app_no
            Into
                v_curr_app_no
            From
                (
                    Select
                        app_no, app_date
                    From
                        (
                            Select
                                app_no, app_date
                            From
                                ss_depu
                            Union
                            Select
                                app_no, app_date
                            From
                                ss_depu_rejected
                        )
                    Where
                        app_date Between trunc(sysdate, 'YEAR')
                        And last_day(add_months(trunc(sysdate, 'YEAR'), 11))
                    Order By app_date Desc, app_no Desc
                )
            Where
                Rownum = 1;
            --v_rec_no := to_number(substr(v_depu_row.app_no, instr(v_depu_row.app_no, '/', -1) + 1));
            v_rec_no := to_number(substr(v_curr_app_no, instr(v_curr_app_no, '/', -1) + 1));

        Exception
            When Others Then
                p_message := sqlcode || ' - ' || sqlerrm;
                v_rec_no  := 0;
        End;

        v_rec_no                := v_rec_no + 1;
        /*
        If p_depu_type = 'WF' Then
            v_is_office_ip := self_attendance.valid_office_ip(p_user_ip);
            If v_is_office_ip = 'KO' Then
                p_success   := 'KO';
                p_message   := 'This utility is applicable from selected PC''s in TCMPL Mumbai Office';
                return;
            End If;

        End If;
        */
        v_entry_by_user_profile := user_profile.get_profile(p_entry_by_empno);
        If v_entry_by_user_profile = user_profile.type_hrd Then
            v_is_entry_by_hr := 'OK';
            If p_entry_by_empno = p_empno Then
                v_is_entry_by_hr_4_self := 'OK';
            End If;
        End If;

        If p_depu_type = 'HT' Then --Home Town
            v_appl_desc := 'Punch HomeTown';
        Elsif p_depu_type = 'DP' Then --Deputation
            v_appl_desc := 'Punch Deputation';
        Elsif p_depu_type = 'TR' Then --ON Tour
            v_appl_desc := 'Punch Tour';
        Elsif p_depu_type = 'VS' Then --Visa Problem
            v_appl_desc := 'Punch Visa Problem';
        Elsif p_depu_type = 'RW' Then --Visa Problem
            v_appl_desc := 'Punch Remote Work';
        End If;

        v_appl_desc             := v_appl_desc || ' from ' || to_char(p_bdate, 'dd-Mon-yyyy') || ' To ' || to_char(p_edate,
        'dd-Mon-yyyy');

        set_variables_4_entry_by(
            p_entry_by_empno     => p_entry_by_empno,
            p_entry_by_hr        => v_is_entry_by_hr,
            p_entry_by_hr_4_self => v_is_entry_by_hr_4_self,
            p_lead_empno         => v_lead_approver,
            p_lead_apprl         => v_lead_approval,
            p_hod_empno          => v_hod_empno,
            p_hod_apprl          => v_hod_apprl,
            p_hod_ip             => v_hod_ip,
            p_hrd_empno          => v_hrd_empno,
            p_hrd_apprl          => v_hrd_apprl,
            p_hrd_ip             => v_hrd_ip,
            p_hod_apprl_dt       => v_hod_apprl_dt,
            p_hrd_apprl_dt       => v_hrd_apprl_dt
        );

        v_app_no                := 'DP/' || p_empno || '/' || to_char(v_now, 'yyyymmdd') || '/' || lpad(v_rec_no, 4, '0');

        Insert Into ss_depu (
            empno,
            app_no,
            app_date,
            bdate,
            edate,
            description,
            type,
            reason,
            user_tcp_ip,
            hod_apprl,
            hod_apprl_dt,
            hod_code,
            hod_tcp_ip,
            hrd_apprl,
            hrd_apprl_dt,
            hrd_code,
            hrd_tcp_ip,
            lead_apprl,
            lead_apprl_empno
        )
        Values (
            p_empno,
            v_app_no,
            v_now,
            p_bdate,
            p_edate,
            v_appl_desc,
            p_depu_type,
            p_reason,
            p_user_ip,
            v_hod_apprl,
            v_hod_apprl_dt,
            v_hod_empno,
            v_hod_ip,
            v_hrd_apprl,
            v_hrd_apprl_dt,
            v_hrd_empno,
            v_hrd_ip,
            v_lead_approval,
            v_lead_approver
        );

        p_success               := 'OK';
        p_message               := 'Your application has been saved successfull. Applicaiton Number :- ' || v_app_no;
    Exception
        When Others Then
            p_success := 'KO';
            p_message := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
    End;

    Procedure add_onduty_type_1(
        p_empno         Varchar2,
        p_od_type       Varchar2,
        p_od_sub_type   Varchar2,
        p_pdate         Varchar2,
        p_hh            Number,
        p_mi            Number,
        p_hh1           Number,
        p_mi1           Number,
        p_lead_approver Varchar2,
        p_reason        Varchar2,
        p_entry_by      Varchar2,
        p_user_ip       Varchar2,
        p_success Out   Varchar2,
        p_message Out   Varchar2
    ) As

        v_pdate                 Date;
        v_count                 Number;
        v_empno                 Varchar2(5);
        v_entry_by              Varchar2(5);
        v_od_catg               Number;
        v_onduty_row            ss_vu_ondutyapp%rowtype;
        v_rec_no                Number;
        v_app_no                Varchar2(60);
        v_now                   Date;
        v_is_office_ip          Varchar2(10);
        v_entry_by_user_profile Number;
        v_is_entry_by_hr        Varchar2(2);
        v_is_entry_by_hr_4_self Varchar2(2);
        v_lead_approver         Varchar2(5);
        v_lead_approval         Number;
        v_hod_empno             Varchar2(5);
        v_hod_ip                Varchar2(30);
        v_hod_apprl             Number;
        v_hod_apprl_dt          Date;
        v_hrd_empno             Varchar2(5);
        v_hrd_ip                Varchar2(30);
        v_hrd_apprl             Number;
        v_hrd_apprl_dt          Date;
        v_appl_desc             Varchar2(60);
        v_dd                    Varchar2(2);
        v_mon                   Varchar2(2);
        v_yyyy                  Varchar2(4);
    Begin
        v_pdate                 := to_date(p_pdate, 'yyyymmdd');
        v_dd                    := to_char(v_pdate, 'dd');
        v_mon                   := to_char(v_pdate, 'MM');
        v_yyyy                  := to_char(v_pdate, 'YYYY');
        --Check Employee Exists
        v_empno                 := substr('0000' || trim(p_empno), -5);
        v_entry_by              := substr('0000' || trim(p_entry_by), -5);
        v_lead_approver :=
            Case lower(p_lead_approver)
                When 'none' Then
                    'None'
                Else
                    lpad(p_lead_approver, 5, '0')
            End;

        Select
            Count(*)
        Into
            v_count
        From
            ss_emplmast
        Where
            empno = v_empno;

        If v_count = 0 Then
            p_success := 'KO';
            p_message := 'Employee not found in Database.' || v_empno || ' - ' || p_empno;
            Return;
        End If;

        If v_lead_approver != 'None' Then
            Select
                Count(*)
            Into
                v_count
            From
                ss_emplmast
            Where
                empno = v_lead_approver;

            If v_count = 0 Then
                p_success := 'KO';
                p_message := 'Lead approver not found in Database.';
                Return;
            End If;

        End If;

        p_message               := 'Debug - A1';
        Select
            tabletag
        Into
            v_od_catg
        From
            ss_ondutymast
        Where
            type = p_od_type;

        If v_od_catg != 2 Then
            p_success := 'KO';
            p_message := 'Invalid OnDuty Type.';
            Return;
        End If;

        p_message               := 'Debug - A2';
        --
        --  * * * * * * * * * * * 
        v_now                   := sysdate;
        Begin
            Select
                *
            Into
                v_onduty_row
            From
                (
                    Select
                        *
                    From
                        ss_vu_ondutyapp
                    Where
                        empno                         = v_empno
                        And app_date In (
                            Select
                                Max(app_date)
                            From
                                ss_vu_ondutyapp
                            Where
                                empno = v_empno
                        )
                        And to_char(app_date, 'yyyy') = to_char(sysdate, 'yyyy')
                    Order By app_no Desc
                )
            Where
                Rownum = 1;

            v_rec_no := to_number(substr(v_onduty_row.app_no, instr(v_onduty_row.app_no, '/', -1) + 1));
        --p_message := 'Debug - A3';

        Exception
            When Others Then
                v_rec_no := 0;
        End;

        v_rec_no                := v_rec_no + 1;
        v_app_no                := 'OD/' || v_empno || '/' || to_char(v_now, 'yyyymmdd') || '/' || lpad(v_rec_no, 4, '0');

        Select
            Count(*)
        Into
            v_count
        From
            ss_vu_ondutyapp
        Where
            app_no = v_app_no;

        If v_count <> 0 Then
            p_success := 'KO';
            p_message := 'There was an unexpected error. Please contact SELFSERVICE-ADMINISTRATOR';
            Return;
        End If;

        p_message               := 'Debug - A3';
        v_entry_by_user_profile := user_profile.get_profile(v_entry_by);
        If v_entry_by_user_profile = user_profile.type_hrd Then
            v_is_entry_by_hr := 'OK';
            If v_entry_by = v_empno Then
                v_is_entry_by_hr_4_self := 'OK';
            End If;
            v_hrd_ip         := p_user_ip;
        Else
            v_is_entry_by_hr := 'KO';
        End If;
        --p_message := 'Debug - A4';

        v_appl_desc             := 'Appl for Punch Entry of ' ||
                                   to_char(v_pdate, 'dd-Mon-yyyy') ||
                                   ' Time ' || lpad(p_hh, 2, '00') || ':' || lpad(p_mi, 2, '00');
        If p_hh1 Is Not Null Then
            v_appl_desc := v_appl_desc || ' - ' || lpad(p_hh1, 2, '00') || ':' || lpad(p_mi1, 2, '00');
        End If;
        v_appl_desc             := replace(trim(v_appl_desc), ' - 0:0');
        set_variables_4_entry_by(
            p_entry_by_empno     => v_entry_by,
            p_entry_by_hr        => v_is_entry_by_hr,
            p_entry_by_hr_4_self => v_is_entry_by_hr_4_self,
            p_lead_empno         => v_lead_approver,
            p_lead_apprl         => v_lead_approval,
            p_hod_empno          => v_hod_empno,
            p_hod_apprl          => v_hod_apprl,
            p_hod_ip             => v_hod_ip,
            p_hrd_empno          => v_hrd_empno,
            p_hrd_apprl          => v_hrd_apprl,
            p_hrd_ip             => v_hrd_ip,
            p_hod_apprl_dt       => v_hod_apprl_dt,
            p_hrd_apprl_dt       => v_hrd_apprl_dt
        );
        --p_message := 'Debug - A5 - ' || v_empno || ' - ' || v_pdate || ' - ' || p_hh || ' - ' || p_mi || ' - ' || p_hh1 || ' - ' || p_mi1 || ' - ODSubType - ' || p_od_sub_type ;

        If p_od_type = 'LE' And v_is_entry_by_hr = 'KO' Then
            v_lead_approver := 'None';
            v_lead_approval := 4;
            v_hod_apprl     := 1;
            v_hod_apprl_dt  := v_now;
            v_hod_empno     := v_entry_by;
            v_hod_ip        := p_user_ip;
        End If;

        Insert Into ss_ondutyapp (
            empno,
            app_no,
            app_date,
            hh,
            mm,
            hh1,
            mm1,
            pdate,
            dd,
            mon,
            yyyy,
            type,
            description,
            odtype,
            reason,
            user_tcp_ip,
            hod_apprl,
            hod_apprl_dt,
            hod_tcp_ip,
            hod_code,
            lead_apprl_empno,
            lead_apprl,
            hrd_apprl,
            hrd_tcp_ip,
            hrd_code,
            hrd_apprl_dt
        )
        Values (
            v_empno,
            v_app_no,
            v_now,
            p_hh,
            p_mi,
            p_hh1,
            p_mi1,
            v_pdate,
            v_dd,
            v_mon,
            v_yyyy,
            p_od_type,
            v_appl_desc,
            nvl(p_od_sub_type, 0),
            p_reason,
            p_user_ip,
            v_hod_apprl,
            v_hod_apprl_dt,
            v_hod_ip,
            v_hod_empno,
            v_lead_approver,
            v_lead_approval,
            v_hrd_apprl,
            v_hrd_ip,
            v_hrd_empno,
            v_hrd_apprl_dt
        );

        p_success               := 'OK';
        p_message               := 'Your application has been saved successfull. Applicaiton Number :- ' || v_app_no;
        Commit;
        If v_entry_by_user_profile != user_profile.type_hrd Then
            Return;
        End If;
        Insert Into ss_onduty value
        (
            Select
                empno,
                hh,
                mm,
                pdate,
                0,
                dd,
                mon,
                yyyy,
                type,
                app_no,
                description,
                getodhh(app_no, 1),
                getodmm(app_no, 1),
                app_date,
                reason,
                odtype
            From
                ss_ondutyapp
            Where
                app_no = v_app_no
        );
        --p_message := 'Debug - A7';

        If p_od_type Not In ('IO', 'OD') Then
            Return;
        End If;
        Insert Into ss_onduty value
        (
            Select
                empno,
                hh1,
                mm1,
                pdate,
                0,
                dd,
                mon,
                yyyy,
                type,
                app_no,
                description,
                getodhh(app_no, 2),
                getodmm(app_no, 2),
                app_date,
                reason,
                odtype
            From
                ss_ondutyapp
            Where
                app_no = v_app_no
        );

        p_message               := 'Debug - A8';
        generate_auto_punch_4od(v_app_no);
        --p_message := 'Debug - A9';
        p_success               := 'OK';
        p_message               := 'Your application has been saved successfull. Applicaiton Number :- ' || v_app_no;
    Exception
        When dup_val_on_index Then
            p_success := 'KO';
            p_message := 'Duplicate values found cannot proceed.' || ' - ' || p_message;
        When Others Then
            p_success := 'KO';
            p_message := 'ERR :- ' || sqlcode || ' - ' || sqlerrm || ' - ' || p_message;
        --p_message := p_message || 

    End add_onduty_type_1;

    Procedure transfer_od_2_wfh(
        p_success Out Varchar2,
        p_message Out Varchar2
    ) As

        Cursor cur_od Is
            Select
                empno,
                'RW'                             od_type,
                to_char(pdate, 'yyyymmdd')       bdate,
                to_char(pdate, 'yyyymmdd')       edate,
                empno                            entry_by,
                lead_apprl_empno,
                user_tcp_ip,
                reason,
                app_no,
                to_char(app_date, 'dd-Mon-yyyy') app_date1,
                to_char(pdate, 'dd-Mon-yyyy')    pdate1
            From
                ss_ondutyapp
            Where
                nvl(hod_apprl, 0)     = 1
                And nvl(hrd_apprl, 0) = 0
                And yyyy In (
                    '2021', '2022'
                )
                And type              = 'OD';

        Type typ_tab_od Is
            Table Of cur_od%rowtype;
        tab_od   typ_tab_od;
        v_app_no Varchar2(30);
        v_is_err Varchar2(10) := 'KO';
    Begin
        Open cur_od;
        Loop
            Fetch cur_od Bulk Collect Into tab_od Limit 50;
            For i In 1..tab_od.count
            Loop
                p_success := Null;
                p_message := Null;
                od.add_onduty_type_2(
                    p_empno         => tab_od(i).empno,
                    p_od_type       => tab_od(i).od_type,
                    p_b_yyyymmdd    => tab_od(i).bdate,
                    p_e_yyyymmdd    => tab_od(i).edate,
                    p_entry_by      => tab_od(i).entry_by,
                    p_lead_approver => tab_od(i).lead_apprl_empno,
                    p_user_ip       => tab_od(i).user_tcp_ip,
                    p_reason        => tab_od(i).reason,
                    p_success       => p_success,
                    p_message       => p_message
                );

                If p_success = 'OK' Then
                    Delete
                        From ss_ondutyapp
                    Where
                        Trim(app_no) = Trim(tab_od(i).app_no);

                Else
                    v_is_err := 'OK';
                End If;

            End Loop;

            Exit When cur_od%notfound;
        End Loop;

        Commit;
        Update
            ss_depu
        Set
            lead_code = 'Sys',
            lead_apprl_dt = sysdate,
            lead_apprl = 1
        Where
            type                = 'RW'
            And trunc(app_date) = trunc(sysdate)
            And lead_apprl <> 4;

        Update
            ss_depu
        Set
            hod_apprl = 1,
            hod_code = 'Sys',
            hod_apprl_dt = sysdate,
            hrd_apprl = 1,
            hrd_code = 'Sys',
            hrd_apprl_dt = sysdate
        Where
            type                = 'RW'
            And trunc(app_date) = trunc(sysdate);

        Commit;
        If v_is_err = 'OK' Then
            p_success := 'KO';
            p_message := 'Err - Some OnDuty applicaitons were not transfered to WFH.';
        Else
            p_success := 'OK';
            p_message := 'OnDuty applications successfully transferd to WFH.';
        End If;

    Exception
        When Others Then
            Rollback;
            p_success := 'OK';
            p_message := 'Err - ' || sqlcode || ' - ' || sqlerrm;
    End;

End od;
/
---------------------------
--Changed PACKAGE BODY
--IOT_SWP_COMMON
---------------------------
CREATE OR REPLACE PACKAGE BODY "SELFSERVICE"."IOT_SWP_COMMON" As

    Function fn_get_pws_text(
        p_pws_type_code Number
    ) Return Varchar2 As
        v_ret_val Varchar2(100);
    Begin
        If p_pws_type_code Is Null Or p_pws_type_code = -1 Then
            Return Null;
        End If;
        Select
            type_desc
        Into
            v_ret_val
        From
            swp_primary_workspace_types
        Where
            type_code = p_pws_type_code;
        Return v_ret_val;
    Exception
        When Others Then
            Return Null;
    End;

    Function fn_get_dept_group(
        p_costcode Varchar2
    ) Return Varchar2 As
        v_retval Varchar2(100);
    Begin
        Select
            group_name
        Into
            v_retval
        From
            ss_dept_grouping
        Where
            parent = p_costcode;
        Return v_retval;
    Exception
        When Others Then
            Return Null;
    End;

    Function get_emp_work_area(
        p_person_id Varchar2,
        p_meta_id   Varchar2,
        p_empno     Varchar2
    ) Return Varchar2 As
        v_count  Number;
        v_projno Varchar2(5);
        v_area   Varchar2(60);
    Begin

        Select
            Count(dapm.office || ' - ' || ep.projno || ' - ' || da.area_desc)
        Into
            v_count
        From
            swp_emp_proj_mapping      ep,
            dms.dm_desk_area_proj_map dapm,
            dms.dm_desk_areas         da
        Where
            ep.projno          = dapm.projno
            And dapm.area_code = da.area_key_id
            And ep.empno       = p_empno;

        If (v_count > 0) Then

            Select
                dapm.office || ' - ' || ep.projno || ' - ' || da.area_desc
            Into
                v_area
            From
                swp_emp_proj_mapping      ep,
                dms.dm_desk_area_proj_map dapm,
                dms.dm_desk_areas         da
            Where
                ep.projno          = dapm.projno
                And dapm.area_code = da.area_key_id
                And ep.empno       = p_empno
                And Rownum         = 1;

        Else
            Begin
                Select
                    da.area_desc
                Into
                    v_area
                From
                    dms.dm_desk_area_dept_map dad,
                    dms.dm_desk_areas         da,
                    ss_emplmast               e
                Where
                    dad.area_code = da.area_key_id
                    And e.assign  = dad.assign
                    And e.empno   = p_empno;

            Exception
                When Others Then
                    v_area := Null;
            End;
        End If;

        Return v_area;
    Exception
        When Others Then
            Return Null;
    End get_emp_work_area;

    Function get_emp_work_area_code(
        p_empno Varchar2
    ) Return Varchar2 As
        v_count     Number;
        v_projno    Varchar2(5);
        v_area_code Varchar2(3);
    Begin
        Select
            da.area_key_id
        Into
            v_area_code
        From
            dms.dm_desk_area_dept_map dad,
            dms.dm_desk_areas         da,
            ss_emplmast               e
        Where
            dad.area_code = da.area_key_id
            And e.assign  = dad.assign
            And e.empno   = p_empno;

        Return v_area_code;
    Exception
        When Others Then
            Return Null;
    End get_emp_work_area_code;

    Function get_desk_from_dms(
        p_empno In Varchar2
    ) Return Varchar2 As
        v_retval Varchar(50);
        v_count  Number;
    Begin

        Select
            Count(*)
        Into
            v_count
        From
            dms.dm_usermaster
        Where
            empno = Trim(p_empno)
            And deskid Not Like 'H%';

        If v_count > 0 Then
            Select
                deskid
            Into
                v_retval
            From
                dms.dm_usermaster
            Where
                empno = Trim(p_empno)
                And deskid Not Like 'H%';
            Return v_retval;
        End If;
        --Return v_retval;
        Select
            Count(*)
        Into
            v_count
        From
            swp_temp_desk_allocation
        Where
            empno = p_empno;

        If v_count > 0 Then
            Select
                deskid
            Into
                v_retval
            From
                swp_temp_desk_allocation
            Where
                empno = Trim(p_empno);
            Return '*!-' || v_retval;
        End If;

        Return v_retval;
    Exception
        When Others Then
            Return Null;
    End get_desk_from_dms;

    Function get_swp_planned_desk(
        p_empno In Varchar2
    ) Return Varchar2 As
        v_retval Varchar(50) := 'NA';
    Begin

        Select
        Distinct deskid As desk
        Into
            v_retval
        From
            dms.dm_usermaster_swp_plan dmst
        Where
            dmst.empno = Trim(p_empno)
            And dmst.deskid Not Like 'H%';

        Return v_retval;
    Exception
        When Others Then
            Return Null;
    End get_swp_planned_desk;

    Function get_total_desk(
        p_work_area Varchar2,
        p_office    Varchar2,
        p_floor     Varchar2,
        p_wing      Varchar2
    ) Return Number As
        v_count Number := 0;
    Begin
        Select
            Count(*)
        Into
            v_count
        From
            dms.dm_deskmaster                         mast, dms.dm_desk_areas area
        Where
            mast.work_area       = p_work_area
            And area.area_key_id = mast.work_area
            And mast.office      = Trim(p_office)
            And mast.floor       = Trim(p_floor)
            And (mast.wing       = p_wing Or p_wing Is Null);

        Return v_count;
    End;

    Function get_occupied_desk(
        p_work_area Varchar2,
        p_office    Varchar2,
        p_floor     Varchar2,
        p_wing      Varchar2,
        p_date      Date Default Null
    ) Return Number As
        v_count Number := 0;
    Begin

        Select
            Count(*)
        Into
            v_count
        From
            dms.dm_deskmaster                         mast, dms.dm_desk_areas area
        Where
            mast.work_area        = p_work_area
            And area.area_key_id  = mast.work_area
            And Trim(mast.office) = Trim(p_office)
            And Trim(mast.floor)  = Trim(p_floor)
            And (mast.wing        = p_wing Or p_wing Is Null)
            And mast.deskid
            In (
                (
                    Select
                    Distinct swptbl.deskid
                    From
                        swp_smart_attendance_plan swptbl
                    Where
                        (trunc(attendance_date) = trunc(p_date) Or p_date Is Null)
                    Union
                    Select
                    Distinct c.deskid
                    From
                        dm_vu_emp_desk_map_swp_plan c
                )
            );
        Return v_count;
    End;

    Function get_monday_date(p_date Date) Return Date As
        v_day_num Number;
    Begin
        v_day_num := to_number(to_char(p_date, 'd'));
        If v_day_num <= 2 Then
            Return p_date + (2 - v_day_num);
        Else
            Return p_date - v_day_num + 2;
        End If;

    End;

    Function get_friday_date(p_date Date) Return Date As
        v_day_num Number;
    Begin
        v_day_num := to_char(p_date, 'd');

        Return p_date + (6 - v_day_num);

    End;

    Function is_emp_eligible_for_swp(
        p_empno Varchar2
    ) Return Varchar2
    As
        v_count Number;
    Begin
        Select
            Count(*)
        Into
            v_count
        From
            swp_emp_response
        Where
            empno        = p_empno
            And hr_apprl = 'OK';
        If v_count = 1 Then
            Return 'OK';
        Else
            Return 'KO';
        End If;
    End;

    Function get_default_costcode_hod_sec(
        p_hod_sec_empno Varchar2,
        p_assign_code   Varchar2 Default Null
    ) Return Varchar2
    As
        v_assign        Varchar2(4);
        v_hod_sec_empno Varchar2(5);
    Begin
        Select
            p_hod_sec_empno
        Into
            v_hod_sec_empno
        From
            ss_emplmast
        Where
            status    = 1
            And empno = lpad(p_hod_sec_empno, 5, '0');
        Select
            assign
        Into
            v_assign
        From
            (
                Select
                    assign
                From
                    (
                        Select
                            costcode As assign
                        From
                            ss_costmast
                        Where
                            hod = v_hod_sec_empno
                        Union
                        Select
                            parent As assign
                        From
                            ss_user_dept_rights
                        Where
                            empno = v_hod_sec_empno
                    )
                Where
                    assign = nvl(p_assign_code, assign)
                Order By assign
            )
        Where
            Rownum = 1;
        Return v_assign;
    Exception
        When Others Then
            Return Null;
    End;

    Function get_default_dept4plan_hod_sec(
        p_hod_sec_empno Varchar2,
        p_assign_code   Varchar2 Default Null
    ) Return Varchar2
    As
        v_assign        Varchar2(4);
        v_hod_sec_empno Varchar2(5);
    Begin
        Select
            p_hod_sec_empno
        Into
            v_hod_sec_empno
        From
            ss_emplmast
        Where
            status    = 1
            And empno = lpad(p_hod_sec_empno, 5, '0');
        Select
            assign
        Into
            v_assign
        From
            (
                Select
                    assign
                From
                    (
                        Select
                            parent As assign
                        From
                            ss_user_dept_rights                                   a, swp_include_assign_4_seat_plan b
                        Where
                            empno        = v_hod_sec_empno
                            And a.parent = b.assign
                        Union
                        Select
                            costcode As assign
                        From
                            ss_costmast                                   a, swp_include_assign_4_seat_plan b
                        Where
                            hod            = v_hod_sec_empno
                            And a.costcode = b.assign
                    )
                Where
                    assign = nvl(p_assign_code, assign)
                Order By assign
            )
        Where
            Rownum = 1;
        Return v_assign;
    Exception
        When Others Then
            Return Null;
    End;

    Function get_hod_sec_costcodes_csv(
        p_hod_sec_empno    Varchar2,
        p_assign_codes_csv Varchar2 Default Null
    ) Return Varchar2
    As
        v_assign        Varchar2(4);
        v_hod_sec_empno Varchar2(5);
        v_ret_val       Varchar2(4000);
    Begin
        Select
            p_hod_sec_empno
        Into
            v_hod_sec_empno
        From
            ss_emplmast
        Where
            status    = 1
            And empno = lpad(p_hod_sec_empno, 5, '0');
        If p_assign_codes_csv Is Null Then
            Select
                Listagg(assign, ',') Within
                    Group (Order By
                        assign)
            Into
                v_ret_val
            From
                (
                    Select
                        costcode As assign
                    From
                        ss_costmast
                    Where
                        hod = v_hod_sec_empno
                    Union
                    Select
                        parent As assign
                    From
                        ss_user_dept_rights
                    Where
                        empno = v_hod_sec_empno
                );
        Else
            Select
                Listagg(assign, ',') Within
                    Group (Order By
                        assign)
            Into
                v_ret_val
            From
                (
                    Select
                        costcode As assign
                    From
                        ss_costmast
                    Where
                        hod = v_hod_sec_empno
                    Union
                    Select
                        parent As assign
                    From
                        ss_user_dept_rights
                    Where
                        empno = v_hod_sec_empno
                )
            Where
                assign In (
                    Select
                        regexp_substr(p_assign_codes_csv, '[^,]+', 1, level) value
                    From
                        dual
                    Connect By
                        level <=
                        length(p_assign_codes_csv) - length(replace(p_assign_codes_csv, ',')) + 1
                );

        End If;
        Return v_ret_val;
    Exception
        When Others Then
            Return Null;
    End;

    Function is_emp_laptop_user(
        p_empno Varchar2
    ) Return Number
    As
        v_laptop_count Number;
    Begin
        v_laptop_count := itinv_stk.dist.is_laptop_user(p_empno);
        If v_laptop_count > 0 Then
            Return 1;
        Else
            Return 0;
        End If;
    End;

    Function csv_to_ary_grades(
        p_grades_csv Varchar2 Default Null
    ) Return Sys_Refcursor As
        c Sys_Refcursor;
    Begin
        If p_grades_csv Is Null Then
            Open c For
                Select
                    grade_id grade
                From
                    ss_vu_grades
                Where
                    grade_id <> '-';
        Else
            Open c For
                Select
                    regexp_substr(p_grades_csv, '[^,]+', 1, level) grade
                From
                    dual
                Connect By
                    level <=
                    length(p_grades_csv) - length(replace(p_grades_csv, ',')) + 1;
        End If;
    End;

    Function is_desk_in_general_area(p_deskid Varchar2) Return Boolean

    As
        v_general_area Varchar2(4) := 'A002';
        v_count        Number;
    Begin
        --Check if the desk is General desk.
        Select
            Count(*)
        Into
            v_count
        From
            dms.dm_deskmaster d,
            dms.dm_desk_areas da
        Where
            deskid                = p_deskid
            And d.work_area       = da.area_key_id
            And da.area_catg_code = v_general_area;
        Return v_count = 1;

    End;

    Function fn_get_emp_pws(
        p_empno Varchar2,
        p_date  Date Default Null
    ) Return Number As
        v_emp_pws      Number;
        v_friday_date  Date;
        v_pws_for_date Date;
    Begin
        v_pws_for_date := trunc(nvl(p_date, sysdate));
        Begin
            Select
                a.primary_workspace
            Into
                v_emp_pws
            From
                swp_primary_workspace a
            Where
                a.empno             = p_empno
                And
                trunc(a.start_date) = (
                    Select
                        Max(trunc(start_date))
                    From
                        swp_primary_workspace b
                    Where
                        b.empno = a.empno
                        And b.start_date <= v_pws_for_date
                );
            Return v_emp_pws;
        Exception
            When Others Then
                Return Null;
        End;
    End;

    Function fn_get_emp_pws_planning(
        p_empno Varchar2 Default Null
    ) Return Varchar2 As
        v_emp_pws        Number;
        v_pws_for_date   Date;
        row_config_weeks swp_config_weeks%rowtype;
    Begin
        If p_empno Is Null Then
            Return Null;
        End If;
        Begin
            Select
                *
            Into
                row_config_weeks
            From
                swp_config_weeks
            Where
                planning_flag = 2;
            v_pws_for_date := row_config_weeks.end_date;
        Exception
            When Others Then
                Null;
        End;
        v_emp_pws := fn_get_emp_pws(p_empno, v_pws_for_date);
        v_emp_pws := nvl(v_emp_pws, -1);
        Return fn_get_pws_text(v_emp_pws);
    Exception
        When Others Then
            Return Null;
    End;

    Function fn_can_do_desk_plan_4_emp(p_empno Varchar2) Return Boolean As
        v_count Number;
    Begin

        Select
            Count(*)
        Into
            v_count
        From
            ss_emplmast                    e,
            swp_include_assign_4_seat_plan sp
        Where
            empno        = p_empno
            And e.assign = sp.assign;
        Return v_count > 0;
    End;

    Function fn_can_work_smartly(
        p_empno Varchar2
    ) Return Number As
        v_is_swp_eligible Varchar2(2);
        v_is_dual_monitor Number(1);
        v_is_laptop_user  Number(1);
    Begin

        v_is_laptop_user  := is_emp_laptop_user(p_empno);
        v_is_dual_monitor := is_emp_dualmonitor_user(p_empno);
        v_is_swp_eligible := get_emp_is_eligible_4swp(p_empno);

        If v_is_laptop_user = 1 And v_is_swp_eligible = 'OK' And v_is_dual_monitor = 0 Then
            Return 1;
        Else
            Return 0;
        End If;
    Exception
        When Others Then
            Return Null;
    End;

    Function fn_is_present_4_swp(
        p_empno Varchar2,
        p_date  Date
    ) Return Number
    As
        v_count Number;
    Begin

        --Punch Count
        Select
            Count(*)
        Into
            v_count
        From
            ss_punch
        Where
            empno     = p_empno
            And pdate = p_date;
        If v_count > 0 Then
            Return 1;
        End If;

        --Approved Leave
        Select
            Count(*)
        Into
            v_count
        From
            ss_leaveledg
        Where
            empno           = p_empno
            And bdate <= p_date
            And nvl(edate, bdate) >= p_date
            And (adj_type   = 'LA'
                Or adj_type = 'LC');
        If v_count > 0 Then
            Return 1;
        End If;

        --Forgot Punch
        Select
            Count(*)
        Into
            v_count
        From
            ss_ondutyapp
        Where
            empno     = p_empno
            And pdate = p_date
            And type  = 'IO';
        If v_count > 0 Then
            Return 1;
        End If;

        --OnTour / Deputation / Remote Work
        Select
            Count(*)
        Into
            v_count
        From
            ss_depu
        Where
            empno         = Trim(p_empno)
            And bdate <= p_date
            And nvl(edate, bdate) >= p_date

            And hrd_apprl = 1;

        If v_count > 0 Then
            Return 1;
        End If;

        --Exception
        Select
            Count(*)
        Into
            v_count
        From
            swp_exclude_emp
        Where
            empno         = Trim(p_empno)
            And p_date Between start_date And end_date
            And is_active = 1;
        If v_count > 0 Then
            Return 1;
        End If;
        Return 0;
    End;

    Function get_emp_is_eligible_4swp(
        p_empno Varchar2 Default Null
    ) Return Varchar2 As
    Begin
        If Trim(p_empno) Is Null Then
            Return Null;
        End If;
        Return is_emp_eligible_for_swp(p_empno);
    End;

    Function is_emp_dualmonitor_user(
        p_empno Varchar2 Default Null
    ) Return Number As
        v_count Number;
    Begin
        Select
            Count(da.assetid)
        Into
            v_count
        From
            dms.dm_deskallocation da,
            dms.dm_usermaster     um,
            dms.dm_assetcode      ac
        Where
            um.deskid             = da.deskid
            And um.empno          = p_empno
            And ac.sub_asset_type = 'IT0MO'
            And da.assetid        = ac.barcode
            And um.deskid Not Like 'H%';
        If v_count >= 2 Then
            Return 1;
        Else
            Return 0;

        End If;

        --
        Select
            Count(da.assetid)
        Into
            v_count
        From
            dms.dm_deskallocation da,
            dms.dm_usermaster     um,
            dms.dm_assetcode      ac
        Where
            um.deskid             = da.deskid
            And um.empno          = p_empno
            And ac.sub_asset_type = 'IT0MO'
            And da.assetid        = ac.barcode
            And um.deskid Like 'H%';
        If v_count >= 2 Then
            Return 1;
        Else
            Return 0;

        End If;

    Exception
        When Others Then
            Return 0;
    End;

    Function get_emp_projno_desc(
        p_empno Varchar2
    ) Return Varchar2 As
        v_projno    Varchar2(5);
        v_proj_name ss_projmast.name%Type;
    Begin
        Select
            projno
        Into
            v_projno
        From
            swp_emp_proj_mapping
        Where
            empno = p_empno;
        Select
        Distinct name
        Into
            v_proj_name
        From
            ss_projmast
        Where
            proj_no = v_projno;
        Return v_projno || ' - ' || v_proj_name;
    Exception
        When Others Then
            Return '';
    End;

    Function fn_get_attendance_status(
        p_empno Varchar2,
        p_date  Date
    ) Return Varchar2 As
        v_count             Number;
        v_punch_exists      Boolean;
        row_depu_tour       ss_depu%rowtype;
        row_onduty          ss_ondutyapp%rowtype;
        row_leave           ss_leaveapp%rowtype;
        row_leaveledg       ss_leaveledg%rowtype;
        row_exclude_emp     swp_exclude_emp%rowtype;
        row_absent_lop      ss_absent_lop%rowtype;
        row_absent_ts_lop   ss_absent_ts_lop%rowtype;
        v_default_return    Varchar2(15);
        e_general_exception Exception;
        Pragma exception_init(e_general_exception, -20002);
    Begin
        v_default_return := 'Absent';
        Select
            Count(*)
        Into
            v_count
        From
            ss_holidays
        Where
            holiday = trunc(p_date);
        If v_count > 0 Then
            v_default_return := '';

        End If;
        Select
            Count(*)
        Into
            v_count
        From
            ss_integratedpunch

        Where
            empno     = p_empno
            And pdate = p_date
            And mach <> 'WFH0';

        If v_count > 0 Then
            Return 'Present';
        End If;

        --Check Exception
        Begin
            Select
                *
            Into
                row_exclude_emp
            From
                swp_exclude_emp
            Where
                p_date Between start_date And end_date
                And empno = p_empno;

        Exception
            When Others Then
                Null;
        End;

        --Check Leave app
        Begin
            Declare
                v_leave_desc Varchar2(100);
            Begin
                Select
                    Count(*)
                Into
                    v_count
                From
                    ss_leaveapp
                Where
                    empno = p_empno
                    And p_date Between bdate And nvl(edate, bdate);
                If v_count > 0 Then
                    v_leave_desc := 'Leave applied';
                Else
                    Raise e_general_exception;
                End If;
                Select
                    *
                Into
                    row_leave
                From
                    ss_leaveapp
                Where
                    empno = p_empno
                    And p_date Between bdate And nvl(edate, bdate);

                If row_leave.hrd_apprl = 1 Then
                    v_leave_desc := 'Leave';
                Else
                    v_leave_desc := 'Leave applied';
                End If;
                If nvl(row_exclude_emp.is_active, 0) = 1 Then
                    Return v_leave_desc || ' + Exception';
                Else
                    Return v_leave_desc;
                End If;

            Exception
                When Others Then
                    Null;
            End;

            -- Check Loss of pay PUNCH DETAILS...
            Begin
                Select
                    *
                Into
                    row_absent_lop
                From
                    ss_absent_lop
                Where
                    empno          = p_empno
                    And lop_4_date = p_date;

                Return 'LWP-PunchDetails';
            Exception
                When Others Then
                    Null;
            End;

            -- Check Loss of pay TIMESHEET...
            Begin
                Select
                    *
                Into
                    row_absent_ts_lop
                From
                    ss_absent_ts_lop
                Where
                    empno          = p_empno
                    And lop_4_date = p_date;

                Return 'LWP-Timesheet';
            Exception
                When Others Then
                    Null;
            End;

            --Check Leave LEDG for Leave Claim & Smart Work Leave deduction
            Declare
                v_leave_desc Varchar2(100);
            Begin
                Select
                    *
                Into
                    row_leaveledg
                From
                    ss_leaveledg
                Where
                    empno     = p_empno
                    And p_date Between bdate And nvl(edate, bdate)
                    And adj_type In ('LC', 'SW')
                    And db_cr = 'D';
                If row_leaveledg.adj_type = 'SW' Then
                    v_leave_desc := 'SWP-Leave';
                Else
                    v_leave_desc := 'Leave';
                End If;
                If nvl(row_exclude_emp.is_active, 0) = 1 Then
                    Return v_leave_desc || ' + Exception';
                Else
                    Return v_leave_desc;
                End If;
            Exception
                When Others Then
                    Null;
            End;

            --Check deputation / tour / remote work
            Begin
                Select
                    Count(*)
                Into
                    v_count
                From
                    ss_depu
                Where
                    type In ('TR', 'DP', 'RW')
                    And empno = p_empno
                    And p_date Between bdate And edate;

                If v_count > 1 Then
                    Return 'Tour-Deputation-err';
                End If;

                Select
                    *
                Into
                    row_depu_tour
                From
                    ss_depu
                Where
                    type In ('TR', 'DP', 'RW')
                    And empno = p_empno
                    And p_date Between bdate And edate;

                If row_depu_tour.hrd_apprl = 1 Then
                    If row_depu_tour.type = 'RW' Then
                        Return 'Smart Work Applied';
                    End If;
                    Return 'Tour-Deputation';
                Else
                    Return 'Tour-Deputation applied';
                End If;
            Exception
                When Others Then
                    Null;
            End;
            --Check Missed / In-Out punch onduty
            Begin
                Select
                    *
                Into
                    row_onduty
                From
                    ss_ondutyapp
                Where
                    type In (
                        'IO', 'OD'
                    )
                    And empno = p_empno
                    And pdate = trunc(p_date);
                If row_onduty.hrd_apprl = 1 Then
                    Return 'Onduty MP/IO';
                Else
                    Return 'Onduty MP/IO applied';

                End If;
            Exception
                When Others Then
                    Null;
            End;

            If row_exclude_emp.is_active = 1 Then
                Return 'Exception';
            End If;

            Return v_default_return;
        Exception
            When Others Then
                Return 'ERR';
        End;
    End;

    Function fn_get_attendance_status(
        p_empno Varchar2,
        p_date  Date,
        p_pws   Number
    ) Return Varchar2 As
        v_count          Number;
        v_ret_val        Varchar2(100);
        v_fri_date       Date;
        v_swp_start_date Date;
    Begin
        If p_empno Is Null Or p_date Is Null Or p_pws Is Null Then
            Return Null;
        End If;
        v_swp_start_date := to_date('18-Apr-2022');
        Select
            Count(*)
        Into
            v_count
        From
            ss_holidays
        Where
            holiday = trunc(p_date);
        If v_count > 0 Then
            --Return '';
            Null;
        End If;
        v_ret_val        := fn_get_attendance_status(
                                p_empno => p_empno,
                                p_date  => p_date
                            );
        If p_pws Not In (2, 3) Then --Office workspace
            Return v_ret_val;
        End If;
        If p_pws = 3 Then -- Deputation workspace
            If v_ret_val = 'Absent' Then
                Return 'OnSite';
            Else
                Return v_ret_val;
            End If;
        End If;

        v_fri_date       := get_friday_date(sysdate);

        --Smart workspace
        If trunc(p_date) <= v_fri_date And trunc(p_date) >= v_swp_start_date Then
            Select
                Count(*)
            Into
                v_count
            From
                swp_smart_attendance_plan
            Where
                empno               = p_empno
                And attendance_date = p_date;
            If v_count = 0 Then
                If v_ret_val = 'Present' Then
                    Return 'OutOfTurn Present';
                Elsif v_ret_val = 'Absent' Then
                    Return 'Smartly Present';
                End If;
            End If;
        End If;
        Return v_ret_val;
    End;

    Function fn_is_attendance_required(
        p_empno Varchar2,
        p_date  Date,
        p_pws   Number
    ) Return Varchar2 As
        v_count   Number;
        v_ret_val Varchar2(100);
    Begin
        If p_pws = 1 Then
            Return 'Yes';
        End If;
        If p_pws = 3 Then
            Return 'No';
        End If;
        If p_pws = 2 Then
            Select
                Count(*)
            Into
                v_count
            From
                swp_smart_attendance_plan
            Where
                empno               = p_empno
                And attendance_date = p_date;
            If v_count > 0 Then
                Return 'Yes';
            Else
                Return 'No';
            End If;
        End If;
        Return '--';
    End;
    --

    Function fn_get_prev_work_date(
        p_prev_date Date Default Null
    ) Return Date
    As
        v_prev_date Date;
        v_count     Number;
    Begin
        v_prev_date := trunc(nvl(p_prev_date, sysdate));
        Select
            Count(*)
        Into
            v_count
        From
            ss_holidays
        Where
            holiday = v_prev_date;
        If v_count = 0 Then
            Return v_prev_date;
        Else
            Return fn_get_prev_work_date(v_prev_date - 1);
        End If;

    End;

    Procedure sp_get_emp_workspace_details(
        p_person_id             Varchar2,
        p_meta_id               Varchar2,
        p_empno                 Varchar2,
        p_current_pws       Out Number,
        p_planning_pws      Out Number,
        p_current_pws_text  Out Varchar2,
        p_planning_pws_text Out Varchar2,
        p_curr_desk_id      Out Varchar2,
        p_curr_office       Out Varchar2,
        p_curr_floor        Out Varchar2,
        p_curr_wing         Out Varchar2,
        p_curr_bay          Out Varchar2,
        p_plan_desk_id      Out Varchar2,
        p_plan_office       Out Varchar2,
        p_plan_floor        Out Varchar2,
        p_plan_wing         Out Varchar2,
        p_plan_bay          Out Varchar2,
        p_message_type      Out Varchar2,
        p_message_text      Out Varchar2
    ) As
        v_current_pws     Number;
        v_planning_pws    Number;
        v_plan_start_date Date;
        v_plan_end_date   Date;
        v_curr_start_date Date;
        v_curr_end_date   Date;
        v_planning_exists Varchar2(2);
        v_pws_open        Varchar2(2);
        v_sws_open        Varchar2(2);
        v_ows_open        Varchar2(2);
        v_msg_type        Varchar2(10);
        v_msg_text        Varchar2(1000);
        v_emp_pws         Number;
        v_friday_date     Date;
    Begin
        get_planning_week_details(
            p_person_id       => p_person_id,
            p_meta_id         => p_meta_id,
            p_plan_start_date => v_plan_start_date,
            p_plan_end_date   => v_plan_end_date,
            p_curr_start_date => v_curr_start_date,
            p_curr_end_date   => v_curr_end_date,
            p_planning_exists => v_planning_exists,
            p_pws_open        => v_pws_open,
            p_sws_open        => v_sws_open,
            p_ows_open        => v_ows_open,
            p_message_type    => v_msg_type,
            p_message_text    => v_msg_text

        );

        p_current_pws       := fn_get_emp_pws(
                                   p_empno => p_empno,
                                   p_date  => trunc(sysdate)
                               );
        If v_plan_end_date Is Not Null Then
            p_planning_pws := fn_get_emp_pws(
                                  p_empno => p_empno,
                                  p_date  => v_plan_end_date
                              );
        End If;
        p_current_pws_text  := fn_get_pws_text(p_current_pws);
        p_planning_pws_text := fn_get_pws_text(p_planning_pws);
        If p_current_pws = 1 Then --Office
            Begin
                p_curr_desk_id := get_desk_from_dms(p_empno);
                Select
                    dm.office,
                    dm.floor,
                    dm.wing,
                    dm.bay
                Into
                    p_curr_office,
                    p_curr_floor,
                    p_curr_wing,
                    p_curr_bay
                From
                    dms.dm_deskmaster dm
                Where
                    dm.deskid = p_curr_desk_id;
            Exception
                When Others Then
                    Null;
            End;
        End If;

        If p_planning_pws = 1 Then --Office
            Begin
                p_plan_desk_id := get_desk_from_dms(p_empno);
                Select
                    dm.office,
                    dm.floor,
                    dm.wing,
                    dm.bay
                Into
                    p_plan_office,
                    p_plan_floor,
                    p_plan_wing,
                    p_plan_bay
                From
                    dms.dm_deskmaster dm
                Where
                    dm.deskid = p_plan_desk_id;
            Exception
                When Others Then
                    Null;
            End;
            /*
        Elsif p_planning_pws = 2 Then --SMART
            p_plan_sws := iot_swp_smart_workspace_qry.fn_emp_week_attend_planning(
                              p_person_id => p_person_id,
                              p_meta_id   => p_meta_id,
                              p_empno     => p_empno,
                              p_date      => v_plan_start_date
                          );
*/
        End If;
    End;

    Procedure sp_emp_office_workspace(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_empno            Varchar2,

        p_office       Out Varchar2,
        p_floor        Out Varchar2,
        p_wing         Out Varchar2,
        p_desk         Out Varchar2,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2

    ) As
        v_count              Number;
        v_empno              Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);

    Begin

        v_empno        := get_empno_from_meta_id(p_meta_id);

        If v_empno = 'ERRRR' Then
            Raise e_employee_not_found;
        End If;

        Select
        Distinct
            'P_Office' As p_office,
            'P_Floor'  As p_floor,
            'P_Desk'   As p_desk,
            'P_Wing'   As p_wing
        Into
            p_office,
            p_floor,
            p_wing,
            p_desk
        From
            dual;

        p_message_type := 'OK';
        p_message_text := 'Procedure executed successfully.';
    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
    End sp_emp_office_workspace;

    Procedure sp_primary_workspace(
        p_person_id                   Varchar2,
        p_meta_id                     Varchar2,
        p_empno                       Varchar2 Default Null,

        p_current_workspace_text  Out Varchar2,
        p_current_workspace_val   Out Varchar2,
        p_current_workspace_date  Out Varchar2,

        p_planning_workspace_text Out Varchar2,
        p_planning_workspace_val  Out Varchar2,
        p_planning_workspace_date Out Varchar2,

        p_message_type            Out Varchar2,
        p_message_text            Out Varchar2

    ) As
        v_count              Number;
        v_empno              Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);

    Begin

        If p_empno Is Not Null Then
            v_empno := p_empno;
        Else
            v_empno := get_empno_from_meta_id(p_meta_id);
        End If;

        If v_empno = 'ERRRR' Then
            Raise e_employee_not_found;
        End If;
        Begin
            Select
            Distinct
                a.primary_workspace As p_primary_workspace_val,
                b.type_desc         As p_primary_workspace_text,
                a.start_date        As p_primary_workspace_date
            Into
                p_current_workspace_val,
                p_current_workspace_text,
                p_current_workspace_date
            From
                swp_primary_workspace       a,
                swp_primary_workspace_types b
            Where
                a.primary_workspace = b.type_code
                And a.empno         = v_empno
                And a.active_code   = 1;
        Exception
            When Others Then
                p_current_workspace_text := 'NA';
        End;

        Begin
            Select
            Distinct
                a.primary_workspace As p_primary_workspace_val,
                b.type_desc         As p_primary_workspace_text,
                a.start_date        As p_primary_workspace_date
            Into
                p_planning_workspace_val,
                p_planning_workspace_text,
                p_planning_workspace_date
            From
                swp_primary_workspace       a,
                swp_primary_workspace_types b
            Where
                a.primary_workspace = b.type_code
                And a.empno         = v_empno
                And a.active_code   = 2;
        Exception
            When Others Then
                p_planning_workspace_text := 'NA';
        End;
        p_message_type := 'OK';
        p_message_text := 'Procedure executed successfully.';
    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
    End sp_primary_workspace;

    Procedure get_planning_week_details(
        p_person_id           Varchar2,
        p_meta_id             Varchar2,
        p_plan_start_date Out Date,
        p_plan_end_date   Out Date,
        p_curr_start_date Out Date,
        p_curr_end_date   Out Date,
        p_planning_exists Out Varchar2,
        p_pws_open        Out Varchar2,
        p_sws_open        Out Varchar2,
        p_ows_open        Out Varchar2,
        p_message_type    Out Varchar2,
        p_message_text    Out Varchar2

    ) As
        v_count         Number;
        v_rec_plan_week swp_config_weeks%rowtype;
        v_rec_curr_week swp_config_weeks%rowtype;
    Begin
        Select
            Count(*)
        Into
            v_count
        From
            swp_config_weeks
        Where
            planning_flag = 2;
        If v_count = 0 Then
            p_pws_open        := 'KO';
            p_sws_open        := 'KO';
            p_ows_open        := 'KO';
            p_planning_exists := 'KO';
        Else
            Select
                *
            Into
                v_rec_plan_week
            From
                swp_config_weeks
            Where
                planning_flag = 2;

            p_plan_start_date := v_rec_plan_week.start_date;
            p_plan_end_date   := v_rec_plan_week.end_date;
            p_planning_exists := 'OK';
            p_pws_open        := Case
                                     When nvl(v_rec_plan_week.pws_open, 0) = 1 Then
                                         'OK'
                                     Else
                                         'KO'
                                 End;
            p_sws_open        := Case
                                     When nvl(v_rec_plan_week.sws_open, 0) = 1 Then
                                         'OK'
                                     Else
                                         'KO'
                                 End;
            p_ows_open        := Case
                                     When nvl(v_rec_plan_week.ows_open, 0) = 1 Then
                                         'OK'
                                     Else
                                         'KO'
                                 End;
        End If;
        Select
            *
        Into
            v_rec_curr_week
        From
            (
                Select
                    *
                From
                    swp_config_weeks
                Where
                    planning_flag <> 2
                Order By start_date Desc
            )
        Where
            Rownum = 1;

        p_curr_start_date := v_rec_curr_week.start_date;
        p_curr_end_date   := v_rec_curr_week.end_date;

        p_message_type    := 'OK';
        p_message_text    := 'Procedure executed successfully.';
    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
    End get_planning_week_details;

End iot_swp_common;
/
---------------------------
--Changed PACKAGE BODY
--IOT_ONDUTY
---------------------------
CREATE OR REPLACE PACKAGE BODY "SELFSERVICE"."IOT_ONDUTY" As
    c_onduty     Constant Varchar2(2) := 'OD';
    c_deputation Constant Varchar2(2) := 'DP';
    c_yes        Constant Varchar2(2) := 'OK';
    c_no         Constant Varchar2(2) := 'KO';

    Procedure sp_delete_onduty_app(
        p_application_id Varchar2,
        p_tab_from       Varchar2,
        p_force_del      Varchar2
    ) As
        v_count      Number;
        v_self_empno Varchar2(5);

        v_tab_from   Varchar2(2);
    Begin

        del_od_app(
            p_app_no    => p_application_id,
            p_tab_from  => p_tab_from,
            p_force_del => p_force_del
        );

    Exception
        When Others Then
            Null;
    End;

    Procedure sp_process_disapproved_app(
        p_person_id      Varchar2,
        p_meta_id        Varchar2,
        p_application_id Varchar2,
        p_tab_from       Varchar2
    ) As
        v_msg_type        Varchar2(15);
        v_msg_text        Varchar2(1000);
        v_onduty_rejected ss_ondutyapp_rejected%rowtype;
        v_depu_rejected   ss_depu_rejected%rowtype;
        v_onduty          ss_ondutyapp%rowtype;
        v_depu            ss_depu%rowtype;
    Begin

        If p_tab_from = c_onduty Then

            Insert Into ss_ondutyapp_rejected (
                empno,
                hh,
                mm,
                pdate,
                dd,
                mon,
                yyyy,
                type,
                app_no,
                description,
                hod_apprl,
                hod_apprl_dt,
                hod_code,
                hrd_apprl,
                hrd_apprl_dt,
                hrd_code,
                app_date,
                hh1,
                mm1,
                reason,
                user_tcp_ip,
                hod_tcp_ip,
                hrd_tcp_ip,
                hodreason,
                hrdreason,
                odtype,
                lead_apprl,
                lead_code,
                lead_apprl_dt,
                lead_tcp_ip,
                lead_reason,
                lead_apprl_empno,
                rejected_on
            )
            Select
                empno,
                hh,
                mm,
                pdate,
                dd,
                mon,
                yyyy,
                type,
                app_no,
                description,
                hod_apprl,
                hod_apprl_dt,
                hod_code,
                hrd_apprl,
                hrd_apprl_dt,
                hrd_code,
                app_date,
                hh1,
                mm1,
                reason,
                user_tcp_ip,
                hod_tcp_ip,
                hrd_tcp_ip,
                hodreason,
                hrdreason,
                odtype,
                lead_apprl,
                lead_code,
                lead_apprl_dt,
                lead_tcp_ip,
                lead_reason,
                lead_apprl_empno,
                sysdate
            From
                ss_ondutyapp
            Where
                app_no = p_application_id;

        Elsif p_tab_from = c_deputation Then
            Insert Into ss_depu_rejected (
                empno,
                app_no,
                bdate,
                edate,
                description,
                type,
                hod_apprl,
                hod_apprl_dt,
                hod_code,
                hrd_apprl,
                hrd_apprl_dt,
                hrd_code,
                app_date,
                reason,
                user_tcp_ip,
                hod_tcp_ip,
                hrd_tcp_ip,
                hodreason,
                hrdreason,
                chg_no,
                chg_date,
                lead_apprl,
                lead_apprl_dt,
                lead_code,
                lead_tcp_ip,
                lead_reason,
                lead_apprl_empno,
                chg_by,
                site_code,
                rejected_on
            )
            Select
                empno,
                app_no,
                bdate,
                edate,
                description,
                type,
                hod_apprl,
                hod_apprl_dt,
                hod_code,
                hrd_apprl,
                hrd_apprl_dt,
                hrd_code,
                app_date,
                reason,
                user_tcp_ip,
                hod_tcp_ip,
                hrd_tcp_ip,
                hodreason,
                hrdreason,
                chg_no,
                chg_date,
                lead_apprl,
                lead_apprl_dt,
                lead_code,
                lead_tcp_ip,
                lead_reason,
                lead_apprl_empno,
                chg_by,
                site_code,
                sysdate
            From
                ss_depu
            Where
                app_no = p_application_id;

        Else
            Return;
        End If;
        sp_delete_onduty_app(
            p_application_id => p_application_id,
            p_tab_from       => p_tab_from,
            p_force_del      => c_no
        );

        Begin
            If p_tab_from = c_onduty Then
                Select
                    *
                Into
                    v_onduty_rejected
                From
                    ss_ondutyapp_rejected
                Where
                    app_no = p_application_id;
            Elsif p_tab_from = c_deputation Then
                Select
                    *
                Into
                    v_depu_rejected
                From
                    ss_depu_rejected
                Where
                    app_no = p_application_id;
            Else
                Return;
            End If;
            ---
            ss_mail.send_mail_onduty_rejected(
                p_onduty_rec => v_onduty_rejected,
                p_depu_rec   => v_depu_rejected
            );
        Exception
            When Others Then
                Return;
        End;

    End;

    Procedure sp_onduty_details(
        p_application_id      Varchar2,

        p_emp_name        Out Varchar2,

        p_onduty_type     Out Varchar2,
        p_onduty_sub_type Out Varchar2,
        p_start_date      Out Varchar2,
        p_end_date        Out Varchar2,

        p_hh1             Out Varchar2,
        p_mi1             Out Varchar2,
        p_hh2             Out Varchar2,
        p_mi2             Out Varchar2,

        p_reason          Out Varchar2,
        p_lead_name       Out Varchar2,
        p_lead_approval   Out Varchar2,
        p_hod_approval    Out Varchar2,
        p_hr_approval     Out Varchar2,

        p_message_type    Out Varchar2,
        p_message_text    Out Varchar2
    ) As

        v_onduty_app ss_vu_ondutyapp%rowtype;
        v_depu       ss_vu_depu%rowtype;
        v_empno      Varchar2(5);
        v_count      Number;

    Begin
        Select
            Count(*)
        Into
            v_count
        From
            ss_vu_ondutyapp
        Where
            Trim(app_no) = Trim(p_application_id);
        If v_count = 1 Then
            Select
                *
            Into
                v_onduty_app
            From
                ss_vu_ondutyapp
            Where
                Trim(app_no) = Trim(p_application_id);
        Else
            Select
                Count(*)
            Into
                v_count
            From
                ss_vu_depu
            Where
                Trim(app_no) = Trim(p_application_id);

            If v_count = 1 Then
                Select
                    *
                Into
                    v_depu
                From
                    ss_vu_depu
                Where
                    Trim(app_no) = Trim(p_application_id);
            End If;
        End If;
        If v_count = 0 Then
            p_message_type := 'KO';
            p_message_text := 'Err - Invalid application id';
            Return;
        End If;
        If v_onduty_app.empno Is Not Null Then
            Select
                description
            Into
                p_onduty_type
            From
                ss_ondutymast
            Where
                type = v_onduty_app.type;
            p_onduty_type   := v_onduty_app.type || ' - ' || p_onduty_type;
            If nvl(v_onduty_app.odtype, 0) <> 0 Then
                Select
                    description
                Into
                    p_onduty_sub_type
                From
                    ss_onduty_sub_type
                Where
                    od_sub_type = v_onduty_app.odtype;
                p_onduty_sub_type := v_onduty_app.odtype || ' - ' || p_onduty_sub_type;
            End If;

            p_emp_name      := get_emp_name(v_onduty_app.empno);
            p_start_date    := v_onduty_app.pdate;
            p_hh1           := lpad(v_onduty_app.hh, 2, '0');
            p_mi1           := lpad(v_onduty_app.mm, 2, '0');
            p_hh2           := lpad(v_onduty_app.hh1, 2, '0');
            p_mi2           := lpad(v_onduty_app.mm1, 2, '0');
            p_reason        := v_onduty_app.reason;

            p_lead_name     := get_emp_name(v_onduty_app.lead_apprl_empno);
            p_lead_approval := v_onduty_app.lead_apprldesc;
            p_hod_approval  := v_onduty_app.hod_apprldesc;
            p_hr_approval   := v_onduty_app.hrd_apprldesc;

        Elsif v_depu.empno Is Not Null Then

            Select
                description
            Into
                p_onduty_type
            From
                ss_ondutymast
            Where
                type = v_depu.type;
            p_onduty_type   := v_depu.type || ' - ' || p_onduty_type;

            p_emp_name      := get_emp_name(v_depu.empno);

            p_onduty_type   := v_depu.type || ' - ' || p_onduty_type;
            p_start_date    := v_depu.bdate;
            p_end_date      := v_depu.edate;
            p_reason        := v_depu.reason;

            Select
                description
            Into
                p_onduty_type
            From
                ss_ondutymast
            Where
                type = v_depu.type;
            p_onduty_type   := v_depu.type || ' - ' || p_onduty_type;

            p_emp_name      := get_emp_name(v_depu.empno);
            p_lead_name     := get_emp_name(v_depu.lead_apprl_empno);

            p_lead_approval := v_depu.lead_apprldesc;
            p_hod_approval  := v_depu.hod_apprldesc;
            p_hr_approval   := v_depu.hrd_apprldesc;

        End If;

        p_message_type := 'OK';

    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'Err - ' || sqlcode || ' - ' || sqlerrm;
    End;

    Procedure sp_add_punch_entry(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_empno            Varchar2,
        p_hh1              Varchar2,
        p_mi1              Varchar2,
        p_hh2              Varchar2 Default Null,
        p_mi2              Varchar2 Default Null,
        p_date             Date,
        p_type             Varchar2,
        p_sub_type         Varchar2 Default Null,
        p_lead_approver    Varchar2,
        p_reason           Varchar2,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_entry_by_empno Varchar2(5);
        v_count          Number;
        v_lead_approval  Number := 0;
        v_hod_approval   Number := 0;
        v_desc           Varchar2(60);
    Begin
        v_entry_by_empno := get_empno_from_meta_id(p_meta_id);
        If v_entry_by_empno = 'ERRRR' Then
            p_message_type := 'KO';
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        od.add_onduty_type_1(
            p_empno         => p_empno,
            p_od_type       => p_type,
            p_od_sub_type   => nvl(Trim(p_sub_type), 0),
            p_pdate         => to_char(p_date, 'yyyymmdd'),
            p_hh            => to_number(Trim(p_hh1)),
            p_mi            => to_number(Trim(p_mi1)),
            p_hh1           => to_number(Trim(p_hh2)),
            p_mi1           => to_number(Trim(p_mi2)),
            p_lead_approver => p_lead_approver,
            p_reason        => p_reason,
            p_entry_by      => v_entry_by_empno,
            p_user_ip       => Null,
            p_success       => p_message_type,
            p_message       => p_message_text
        );

    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'Err - ' || sqlcode || ' - ' || sqlerrm;
    End sp_add_punch_entry;

    Procedure sp_add_depu_tour(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_empno            Varchar2,
        p_start_date       Date,
        p_end_date         Date,
        p_type             Varchar2,
        p_lead_approver    Varchar2,
        p_reason           Varchar2,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_entry_by_empno Varchar2(5);
        v_count          Number;

    Begin
        v_entry_by_empno := get_empno_from_meta_id(p_meta_id);
        If v_entry_by_empno = 'ERRRR' Then
            p_message_type := 'KO';
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        od.add_onduty_type_2(
            p_empno         => p_empno,
            p_od_type       => p_type,
            p_b_yyyymmdd    => to_char(p_start_date, 'yyyymmdd'),
            p_e_yyyymmdd    => to_char(p_end_date, 'yyyymmdd'),
            p_entry_by      => v_entry_by_empno,
            p_lead_approver => p_lead_approver,
            p_user_ip       => Null,
            p_reason        => p_reason,
            p_success       => p_message_type,
            p_message       => p_message_text
        );
    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'Err - ' || sqlcode || ' - ' || sqlerrm;

    End sp_add_depu_tour;

    Procedure sp_extend_depu(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_application_id   Varchar2,
        p_end_date         Date,
        p_reason           Varchar2,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_entry_by_empno Varchar2(5);
        v_count          Number;
        rec_depu         ss_depu%rowtype;
    Begin
        Select
            *
        Into
            rec_depu
        From
            ss_depu
        Where
            Trim(app_no) = Trim(p_application_id);
        If rec_depu.edate > p_end_date Then
            p_message_type := 'KO';
            p_message_text := 'Extension end date should be greater than existing end date.';
            Return;
        End If;
        sp_add_depu_tour(
            p_person_id     => p_person_id,
            p_meta_id       => p_meta_id,

            p_empno         => rec_depu.empno,
            p_start_date    => rec_depu.edate + 1,
            p_end_date      => p_end_date,
            p_type          => rec_depu.type,
            p_lead_approver => 'None',
            p_reason        => p_reason,

            p_message_type  => p_message_type,
            p_message_text  => p_message_text
        );
    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'Err - ' || sqlcode || ' - ' || sqlerrm;

    End;

    --
    Procedure sp_delete_od_app_4_self(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_application_id   Varchar2,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_count    Number;
        v_empno    Varchar2(5);
        v_tab_from Varchar2(2);
    Begin
        v_count        := 0;
        v_empno        := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            p_message_type := 'KO';
            p_message_text := 'Invalid employee number';
            Return;
        End If;
        Select
            Count(*)
        Into
            v_count
        From
            ss_ondutyapp
        Where
            Trim(app_no) = Trim(p_application_id)
            And empno    = v_empno;
        If v_count = 1 Then
            v_tab_from := 'OD';
        Else
            Select
                Count(*)
            Into
                v_count
            From
                ss_depu
            Where
                Trim(app_no) = Trim(p_application_id)
                And empno    = v_empno;
            If v_count = 1 Then
                v_tab_from := 'DP';
            End If;
        End If;
        If v_count = 0 Then
            p_message_type := 'KO';
            p_message_text := 'Err - Invalid application id';
            Return;
        End If;
        sp_delete_onduty_app(
            p_application_id => p_application_id,
            p_tab_from       => v_tab_from,
            p_force_del      => c_no
        );
        p_message_type := 'OK';
        p_message_text := 'Procedure executed successfully.';

    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'Err - ' || sqlcode || ' - ' || sqlerrm;

    End sp_delete_od_app_4_self;

    Procedure sp_delete_od_app_force(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_application_id   Varchar2,
        p_empno            Varchar2,
        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_count      Number;
        v_self_empno Varchar2(5);

        v_tab_from   Varchar2(2);
    Begin
        v_count        := 0;
        v_self_empno   := get_empno_from_meta_id(p_meta_id);
        If v_self_empno = 'ERRRR' Then
            p_message_type := 'KO';
            p_message_text := 'Invalid employee number';
            Return;
        End If;
        Select
            Count(*)
        Into
            v_count
        From
            ss_vu_ondutyapp
        Where
            Trim(app_no) = Trim(p_application_id)
            And empno    = p_empno;
        If v_count = 1 Then
            v_tab_from := c_onduty;
        Else
            Select
                Count(*)
            Into
                v_count
            From
                ss_vu_depu
            Where
                Trim(app_no) = Trim(p_application_id)
                And empno    = p_empno;
            If v_count = 1 Then
                v_tab_from := c_deputation;
            End If;
        End If;
        If v_count = 0 Then
            p_message_type := 'KO';
            p_message_text := 'Err - Invalid application id';
            Return;
        End If;
        sp_delete_onduty_app(
            p_application_id => p_application_id,
            p_tab_from       => v_tab_from,
            p_force_del      => c_yes
        );
        p_message_type := 'OK';
        p_message_text := 'Procedure executed successfully.';

    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'Err - ' || sqlcode || ' - ' || sqlerrm;

    End sp_delete_od_app_force;

    Procedure sp_onduty_application_details(
        p_person_id           Varchar2,
        p_meta_id             Varchar2,

        p_application_id      Varchar2,

        p_emp_name        Out Varchar2,

        p_onduty_type     Out Varchar2,
        p_onduty_sub_type Out Varchar2,
        p_start_date      Out Varchar2,
        p_end_date        Out Varchar2,

        p_hh1             Out Varchar2,
        p_mi1             Out Varchar2,
        p_hh2             Out Varchar2,
        p_mi2             Out Varchar2,

        p_reason          Out Varchar2,

        p_lead_name       Out Varchar2,
        p_lead_approval   Out Varchar2,
        p_hod_approval    Out Varchar2,
        p_hr_approval     Out Varchar2,

        p_message_type    Out Varchar2,
        p_message_text    Out Varchar2
    ) As
        v_count    Number;
        v_empno    Varchar2(5);
        v_tab_from Varchar2(2);
    Begin
        v_count := 0;
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            p_message_type := 'KO';
            p_message_text := 'Invalid employee number';
            Return;
        End If;
        sp_onduty_details(
            p_application_id  => p_application_id,

            p_emp_name        => p_emp_name,

            p_onduty_type     => p_onduty_type,
            p_onduty_sub_type => p_onduty_sub_type,
            p_start_date      => p_start_date,
            p_end_date        => p_end_date,

            p_hh1             => p_hh1,
            p_mi1             => p_mi1,
            p_hh2             => p_hh2,
            p_mi2             => p_mi2,

            p_reason          => p_reason,

            p_lead_name       => p_lead_name,
            p_lead_approval   => p_lead_approval,
            p_hod_approval    => p_hod_approval,
            p_hr_approval     => p_hr_approval,

            p_message_type    => p_message_type,
            p_message_text    => p_message_text

        );
    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'Err - ' || sqlcode || ' - ' || sqlerrm;
    End;

    Procedure sp_onduty_approval(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_onduty_approvals typ_tab_string,
        p_approver_profile Number,
        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_app_no         Varchar2(70);
        v_approval       Number;
        v_remarks        Varchar2(70);
        v_count          Number;
        v_rec_count      Number;
        sqlpartod        Varchar2(60) := 'Update SS_OnDutyApp ';
        sqlpartdp        Varchar2(60) := 'Update SS_Depu ';
        sqlpart2         Varchar2(500);
        strsql           Varchar2(600);
        v_odappstat_rec  ss_odappstat%rowtype;
        v_approver_empno Varchar2(5);
        v_user_tcp_ip    Varchar2(30);
        v_msg_type       Varchar2(10);
        v_msg_text       Varchar2(1000);
    Begin

        v_approver_empno := get_empno_from_meta_id(p_meta_id);
        If v_approver_empno = 'ERRRR' Then
            p_message_type := 'KO';
            p_message_text := 'Invalid employee number';
            Return;
        End If;
        sqlpart2         := ' set ApproverProfile_APPRL = :Approval, ApproverProfile_Code = :Approver_EmpNo, ApproverProfile_APPRL_DT = Sysdate,
                    ApproverProfile_TCP_IP = :User_TCP_IP , ApproverProfileREASON = :Reason where App_No = :paramAppNo';
        If p_approver_profile = user_profile.type_hod Or p_approver_profile = user_profile.type_sec Then
            sqlpart2 := replace(sqlpart2, 'ApproverProfile', 'HOD');
        Elsif p_approver_profile = user_profile.type_hrd Then
            sqlpart2 := replace(sqlpart2, 'ApproverProfile', 'HRD');
        Elsif p_approver_profile = user_profile.type_lead Then
            sqlpart2 := replace(sqlpart2, 'ApproverProfile', 'LEAD');
        End If;

        For i In 1..p_onduty_approvals.count
        Loop

            With
                csv As (
                    Select
                        p_onduty_approvals(i) str
                    From
                        dual
                )
            Select
                Trim(regexp_substr(str, '[^~!~]+', 1, 1))            app_no,
                to_number(Trim(regexp_substr(str, '[^~!~]+', 1, 2))) approval,
                Trim(regexp_substr(str, '[^~!~]+', 1, 3))            remarks
            Into
                v_app_no, v_approval, v_remarks
            From
                csv;

            Select
                *
            Into
                v_odappstat_rec
            From
                ss_odappstat
            Where
                Trim(app_no) = Trim(v_app_no);

            If (v_odappstat_rec.fromtab) = c_deputation Then
                strsql := sqlpartdp || ' ' || sqlpart2;
            Elsif (v_odappstat_rec.fromtab) = c_onduty Then
                strsql := sqlpartod || ' ' || sqlpart2;
            End If;
            /*
            p_message_type := 'OK';
            p_message_text := 'Debug 1 - ' || p_onduty_approvals(i);
            Return;
            */
            strsql := replace(strsql, 'LEADREASON', 'LEAD_REASON');
            Execute Immediate strsql
                Using v_approval, v_approver_empno, v_user_tcp_ip, v_remarks, trim(v_app_no);
            Commit;
            If v_odappstat_rec.fromtab = c_onduty And p_approver_profile = user_profile.type_hrd And v_approval = ss.approved
            Then
                Insert Into ss_onduty value
                (
                    Select
                        empno,
                        hh,
                        mm,
                        pdate,
                        0,
                        dd,
                        mon,
                        yyyy,
                        type,
                        app_no,
                        description,
                        getodhh(app_no, 1),
                        getodmm(app_no, 1),
                        app_date,
                        reason,
                        odtype
                    From
                        ss_ondutyapp
                    Where
                        Trim(app_no)                   = Trim(v_app_no)
                        And nvl(hrd_apprl, ss.pending) = ss.approved
                );

                Insert Into ss_onduty value
                (
                    Select
                        empno,
                        hh1,
                        mm1,
                        pdate,
                        0,
                        dd,
                        mon,
                        yyyy,
                        type,
                        app_no,
                        description,
                        getodhh(app_no, 2),
                        getodmm(app_no, 2),
                        app_date,
                        reason,
                        odtype
                    From
                        ss_ondutyapp
                    Where
                        Trim(app_no)                   = Trim(v_app_no)
                        And (type                      = 'OD'
                            Or type                    = 'IO')
                        And nvl(hrd_apprl, ss.pending) = ss.approved
                );

                If p_approver_profile = user_profile.type_hrd And v_approval = ss.approved Then
                    generate_auto_punch_4od(v_app_no);
                End If;
            Elsif v_approval = ss.disapproved Then

                sp_process_disapproved_app(
                    p_person_id      => p_person_id,
                    p_meta_id        => p_meta_id,

                    p_application_id => Trim(v_app_no),
                    p_tab_from       => v_odappstat_rec.fromtab
                );

            End If;

        End Loop;

        Commit;
        p_message_type   := 'OK';
        p_message_text   := 'Procedure executed successfully.';
    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
    End;

    Procedure sp_onduty_approval_lead(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_onduty_approvals typ_tab_string,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    )
    As
    Begin
        sp_onduty_approval(
            p_person_id        => p_person_id,
            p_meta_id          => p_meta_id,

            p_onduty_approvals => p_onduty_approvals,
            p_approver_profile => user_profile.type_lead,
            p_message_type     => p_message_type,
            p_message_text     => p_message_text
        );
    End;

    Procedure sp_onduty_approval_hod(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_onduty_approvals typ_tab_string,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    )
    As
    Begin
        sp_onduty_approval(
            p_person_id        => p_person_id,
            p_meta_id          => p_meta_id,

            p_onduty_approvals => p_onduty_approvals,
            p_approver_profile => user_profile.type_hod,
            p_message_type     => p_message_type,
            p_message_text     => p_message_text
        );
    End;

    Procedure sp_onduty_approval_hr(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_onduty_approvals typ_tab_string,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    )
    As
    Begin
        sp_onduty_approval(
            p_person_id        => p_person_id,
            p_meta_id          => p_meta_id,

            p_onduty_approvals => p_onduty_approvals,
            p_approver_profile => user_profile.type_hrd,
            p_message_type     => p_message_type,
            p_message_text     => p_message_text
        );
    End;

    Procedure sp_check_emp_onduty_swp(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_empno            Varchar2,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_entry_by_empno Varchar2(5);
        v_count          Number;

    Begin
        p_message_type   := 'KO';
        p_message_text   := 'Employee not in swp onduty ';
        v_entry_by_empno := get_empno_from_meta_id(p_meta_id);
        If v_entry_by_empno = 'ERRRR' Then
            p_message_type := 'KO';
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        Select
            Count(*)
        Into
            v_count
        From
            ss_emp_for_onduty_swp
        Where
            empno = p_empno;

        If v_count > 0 Then
            p_message_type := 'OK';
            p_message_text := 'Employee is in swp onduty ';
            Return;
        End If;

    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'Err - ' || sqlcode || ' - ' || sqlerrm;
    End sp_check_emp_onduty_swp;

End iot_onduty;
/
---------------------------
--Changed PACKAGE BODY
--IOT_LEAVE
---------------------------
CREATE OR REPLACE PACKAGE BODY "SELFSERVICE"."IOT_LEAVE" As

    Procedure sp_process_disapproved_app(
        p_person_id      Varchar2,
        p_meta_id        Varchar2,
        p_application_id Varchar2
    ) As
        v_medical_cert_file Varchar2(100);
        v_msg_type          Varchar2(15);
        v_msg_text          Varchar2(1000);
    Begin
        Insert Into ss_leaveapp_rejected (
            app_no,
            empno,
            app_date,
            rep_to,
            projno,
            caretaker,
            leaveperiod,
            leavetype,
            bdate,
            edate,
            reason,
            mcert,
            work_ldate,
            resm_date,
            contact_add,
            contact_phn,
            contact_std,
            last_hrs,
            last_mn,
            resm_hrs,
            resm_mn,
            dataentryby,
            office,
            hod_apprl,
            hod_apprl_dt,
            hod_code,
            hrd_apprl,
            hrd_apprl_dt,
            hrd_code,
            discrepancy,
            user_tcp_ip,
            hod_tcp_ip,
            hrd_tcp_ip,
            hodreason,
            hrdreason,
            hd_date,
            hd_part,
            lead_apprl,
            lead_apprl_dt,
            lead_code,
            lead_tcp_ip,
            lead_apprl_empno,
            lead_reason,
            rejected_on,
            is_covid_sick_leave,
            med_cert_file_name
        )
        Select
            app_no,
            empno,
            app_date,
            rep_to,
            projno,
            caretaker,
            leaveperiod,
            leavetype,
            bdate,
            edate,
            reason,
            mcert,
            work_ldate,
            resm_date,
            contact_add,
            contact_phn,
            contact_std,
            last_hrs,
            last_mn,
            resm_hrs,
            resm_mn,
            dataentryby,
            office,
            hod_apprl,
            hod_apprl_dt,
            hod_code,
            hrd_apprl,
            hrd_apprl_dt,
            hrd_code,
            discrepancy,
            user_tcp_ip,
            hod_tcp_ip,
            hrd_tcp_ip,
            hodreason,
            hrdreason,
            hd_date,
            hd_part,
            lead_apprl,
            lead_apprl_dt,
            lead_code,
            lead_tcp_ip,
            lead_apprl_empno,
            lead_reason,
            sysdate,
            is_covid_sick_leave,
            med_cert_file_name
        From
            ss_leaveapp
        Where
            Trim(app_no) = p_application_id;
        Commit;
        sp_delete_leave_app(
            p_person_id              => p_person_id,
            p_meta_id                => p_meta_id,

            p_application_id         => Trim(p_application_id),

            p_medical_cert_file_name => v_medical_cert_file,
            p_message_type           => v_msg_type,
            p_message_text           => v_msg_text
        );

        ss_mail.send_mail_leave_reject_async(
            p_app_id => p_application_id
        );

    End;

    Procedure get_leave_balance_all(
        p_empno            Varchar2,
        p_pdate            Date Default Null,
        p_open_close_flag  Number,

        p_cl           Out Varchar2,
        p_sl           Out Varchar2,
        p_pl           Out Varchar2,
        p_ex           Out Varchar2,
        p_co           Out Varchar2,
        p_oh           Out Varchar2,
        p_lv           Out Varchar2,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    )
    As

        v_cl  Number;
        v_sl  Number;
        v_pl  Number;
        v_ex  Number;
        v_co  Number;
        v_oh  Number;
        v_lv  Number;
        v_tot Number;
    Begin
        get_leave_balance(
            param_empno       => p_empno,
            param_date        => p_pdate,
            param_open_close  => p_open_close_flag,
            param_leave_type  => 'LV',
            param_leave_count => v_lv
        );

        openbal(
            v_empno       => p_empno,
            v_opbaldtfrom => p_pdate,
            v_openbal     => p_open_close_flag,
            v_cl          => v_cl,
            v_pl          => v_pl,
            v_sl          => v_sl,
            v_ex          => v_ex,
            v_co          => v_co,
            v_oh          => v_oh,
            v_tot         => v_tot
        );

        p_cl := to_days(v_cl);
        p_pl := to_days(v_pl);
        p_sl := to_days(v_sl);
        p_ex := to_days(v_ex);
        p_co := to_days(v_co);
        p_oh := to_days(v_oh);
        p_lv := to_days(v_lv);

        p_cl := nvl(trim(p_cl), '0.0');
        p_pl := nvl(trim(p_pl), '0.0');
        p_sl := nvl(trim(p_sl), '0.0');
        p_ex := nvl(trim(p_ex), '0.0');
        p_co := nvl(trim(p_co), '0.0');
        p_oh := nvl(trim(p_oh), '0.0');
        p_lv := nvl(trim(p_lv), '0.0');

    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'Err - ' || sqlcode || ' - ' || sqlerrm;
    End;

    Procedure get_leave_details_from_app(
        p_application_id         Varchar2,

        p_emp_name           Out Varchar2,
        p_leave_type         Out Varchar2,
        p_application_date   Out Varchar2,
        p_start_date         Out Varchar2,
        p_end_date           Out Varchar2,

        p_leave_period       Out Number,
        p_last_reporting     Out Varchar2,
        p_resuming           Out Varchar2,

        p_projno             Out Varchar2,
        p_care_taker         Out Varchar2,
        p_reason             Out Varchar2,
        p_med_cert_available Out Varchar2,
        p_contact_address    Out Varchar2,
        p_contact_std        Out Varchar2,
        p_contact_phone      Out Varchar2,
        p_office             Out Varchar2,
        p_lead_name          Out Varchar2,
        p_discrepancy        Out Varchar2,
        p_med_cert_file_nm   Out Varchar2,

        p_lead_approval      Out Varchar2,
        p_hod_approval       Out Varchar2,
        p_hr_approval        Out Varchar2,

        p_lead_reason        Out Varchar2,
        p_hod_reason         Out Varchar2,
        p_hr_reason          Out Varchar2,

        p_flag_can_del       Out Varchar2,

        p_message_type       Out Varchar2,
        p_message_text       Out Varchar2

    ) As
        v_leave_app ss_vu_leaveapp%rowtype;
    Begin
        Select
            *
        Into
            v_leave_app
        From
            ss_vu_leaveapp
        Where
            Trim(app_no) = Trim(p_application_id);
        p_emp_name           := get_emp_name(v_leave_app.empno);
        p_leave_type         := v_leave_app.leavetype;
        p_application_date   := to_char(v_leave_app.app_date, 'dd-Mon-yyyy');
        p_start_date         := to_char(v_leave_app.bdate, 'dd-Mon-yyyy');
        p_end_date           := to_char(v_leave_app.edate, 'dd-Mon-yyyy');

        p_leave_period       := to_days(v_leave_app.leaveperiod);
        p_last_reporting     := to_char(v_leave_app.work_ldate, 'dd-Mon-yyyy');
        p_resuming           := to_char(v_leave_app.resm_date, 'dd-Mon-yyyy');

        p_projno             := v_leave_app.projno;
        p_care_taker         := v_leave_app.caretaker;
        p_reason             := v_leave_app.reason;
        p_med_cert_available := v_leave_app.mcert;
        p_contact_address    := v_leave_app.contact_add;
        p_contact_std        := v_leave_app.contact_std;
        p_contact_phone      := v_leave_app.contact_phn;
        p_office             := v_leave_app.office;
        p_lead_name          := get_emp_name(v_leave_app.lead_code);
        p_discrepancy        := v_leave_app.discrepancy;
        p_med_cert_file_nm   := v_leave_app.med_cert_file_name;

        If nvl(v_leave_app.lead_apprl, 0) != 0 Or nvl(v_leave_app.hod_apprl, 0) != 0 Or nvl(v_leave_app.hrd_apprl, 0) != 0
        Then
            p_flag_can_del := 'KO';
        Else
            p_flag_can_del := 'OK';
        End If;

        p_lead_approval      := ss.approval_text(v_leave_app.lead_apprl);
        p_hod_approval       := Case
                                    When v_leave_app.lead_apprl = ss.disapproved Then
                                        '-'
                                    Else
                                        ss.approval_text(v_leave_app.hod_apprl)
                                End;
        p_hr_approval        := Case
                                    When v_leave_app.hod_apprl = ss.disapproved Then
                                        '-'
                                    Else
                                        ss.approval_text(v_leave_app.hrd_apprl)
                                End;
        p_lead_reason        := v_leave_app.lead_reason;
        p_hod_reason         := v_leave_app.hodreason;
        p_hr_reason          := v_leave_app.hrdreason;

        p_message_text       := 'OK';

    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'Err - ' || sqlcode || ' - ' || sqlerrm;
    End;

    Procedure get_leave_details_from_adj(
        p_application_id       Varchar2,

        p_emp_name         Out Varchar2,
        p_leave_type       Out Varchar2,
        p_application_date Out Varchar2,
        p_start_date       Out Varchar2,
        p_end_date         Out Varchar2,

        p_leave_period     Out Number,
        p_med_cert_file_nm Out Varchar2,

        p_reason           Out Varchar2,

        p_lead_approval    Out Varchar2,
        p_hod_approval     Out Varchar2,
        p_hr_approval      Out Varchar2,

        p_message_type     Out Varchar2,
        p_message_text     Out Varchar2
    ) As
        v_leave_adj ss_leave_adj%rowtype;
    Begin
        Select
            *
        Into
            v_leave_adj
        From
            ss_leave_adj
        Where
            adj_no = p_application_id;
        p_emp_name         := get_emp_name(v_leave_adj.empno);
        p_leave_type       := v_leave_adj.leavetype;
        p_application_date := to_char(v_leave_adj.adj_dt, 'dd-Mon-yyyy');
        p_start_date       := to_char(v_leave_adj.bdate, 'dd-Mon-yyyy');
        p_end_date         := to_char(v_leave_adj.edate, 'dd-Mon-yyyy');
        p_med_cert_file_nm := v_leave_adj.med_cert_file_name;

        p_leave_period     := to_days(v_leave_adj.leaveperiod);
        p_reason           := v_leave_adj.description;
        p_message_text     := 'OK';

    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'Err - ' || sqlcode || ' - ' || sqlerrm;
    End;

    Procedure sp_validate_new_leave(
        p_person_id          Varchar2,
        p_meta_id            Varchar2,

        p_leave_type         Varchar2,
        p_start_date         Date,
        p_end_date           Date,
        p_half_day_on        Number,

        p_leave_period   Out Number,
        p_last_reporting Out Varchar2,
        p_resuming       Out Varchar2,
        p_message_type   Out Varchar2,
        p_message_text   Out Varchar2

    ) As
        v_empno        Varchar2(5);
        v_message_type Varchar2(2);
        v_count        Number;
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            p_message_type := 'KO';
            p_message_text := 'Invalid employee by person id';
            Return;
        End If;
        Select
            Count(*)
        Into
            v_count
        From
            ss_emplmast
        Where
            empno = v_empno;
        If v_count = 0 Then
            p_message_type := 'KO';
            p_message_text := 'Invalid employee number';
            Return;
        End If;
        leave.validate_leave(
            param_empno          => v_empno,
            param_leave_type     => p_leave_type,
            param_bdate          => trunc(p_start_date),
            param_edate          => trunc(p_end_date),
            param_half_day_on    => p_half_day_on,
            param_app_no         => Null,
            param_leave_period   => p_leave_period,
            param_last_reporting => p_last_reporting,
            param_resuming       => p_resuming,
            param_msg_type       => v_message_type,
            param_msg            => p_message_text
        );
        If v_message_type = ss.failure Then
            p_message_type := 'KO';
        Else
            p_message_type := 'OK';
        End If;
    Exception
        When Others Then
            p_message_type := ss.failure;
            p_message_text := 'Err - ' || sqlcode || ' - ' || sqlerrm;
    End sp_validate_new_leave;

    Procedure sp_validate_pl_revision(
        p_person_id          Varchar2,
        p_meta_id            Varchar2,

        p_application_id     Varchar2,
        p_leave_type         Varchar2,
        p_start_date         Date,
        p_end_date           Date,
        p_half_day_on        Number,

        p_leave_period   Out Number,
        p_last_reporting Out Varchar2,
        p_resuming       Out Varchar2,
        p_message_type   Out Varchar2,
        p_message_text   Out Varchar2

    ) As
        v_empno        Varchar2(5);
        v_message_type Varchar2(2);
        v_count        Number;
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            p_message_type := 'KO';
            p_message_text := 'Invalid employee by metaid';
            Return;
        End If;

        leave.validate_leave(
            param_empno          => v_empno,
            param_leave_type     => p_leave_type,
            param_bdate          => trunc(p_start_date),
            param_edate          => trunc(p_end_date),
            param_half_day_on    => p_half_day_on,
            param_app_no         => p_application_id,
            param_leave_period   => p_leave_period,
            param_last_reporting => p_last_reporting,
            param_resuming       => p_resuming,
            param_msg_type       => v_message_type,
            param_msg            => p_message_text
        );
        If v_message_type = ss.failure Then
            p_message_type := 'KO';
        Else
            p_message_type := 'OK';
        End If;
    Exception
        When Others Then
            p_message_type := ss.failure;
            p_message_text := 'Err - ' || sqlcode || ' - ' || sqlerrm;
    End sp_validate_pl_revision;

    Procedure sp_add_leave_application(
        p_person_id              Varchar2,
        p_meta_id                Varchar2,

        p_leave_type             Varchar2,
        p_start_date             Date,
        p_end_date               Date,
        p_half_day_on            Number,
        p_projno                 Varchar2,
        p_care_taker             Varchar2,
        p_reason                 Varchar2,
        p_med_cert_available     Varchar2 Default Null,
        p_contact_address        Varchar2 Default Null,
        p_contact_std            Varchar2 Default Null,
        p_contact_phone          Varchar2 Default Null,
        p_office                 Varchar2,
        p_lead_empno             Varchar2,
        p_discrepancy            Varchar2 Default Null,
        p_med_cert_file_nm       Varchar2 Default Null,

        p_new_application_id Out Varchar2,

        p_message_type       Out Varchar2,
        p_message_text       Out Varchar2

    ) As

        v_empno        Varchar2(5);
        v_message_type Varchar2(2);
        v_count        Number;
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            p_message_type := 'KO';
            p_message_text := 'Invalid employee by person id';
            Return;
        End If;
        Select
            Count(*)
        Into
            v_count
        From
            ss_emplmast
        Where
            empno = v_empno;
        If v_count = 0 Then
            p_message_type := 'KO';
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        leave.add_leave_app(
            param_empno            => v_empno,
            param_leave_type       => p_leave_type,
            param_bdate            => p_start_date,
            param_edate            => p_end_date,
            param_half_day_on      => p_half_day_on,
            param_projno           => p_projno,
            param_caretaker        => p_care_taker,
            param_reason           => p_reason,
            param_cert             => p_med_cert_available,
            param_contact_add      => p_contact_address,
            param_contact_std      => p_contact_std,
            param_contact_phn      => p_contact_phone,
            param_office           => p_office,
            param_dataentryby      => v_empno,
            param_lead_empno       => p_lead_empno,
            param_discrepancy      => p_discrepancy,
            param_med_cert_file_nm => p_med_cert_file_nm,
            param_tcp_ip           => Null,
            param_nu_app_no        => p_new_application_id,
            param_msg_type         => v_message_type,
            param_msg              => p_message_text
        );

        If v_message_type = ss.failure Then
            p_message_type := 'KO';
        Else
            p_message_type := 'OK';
        End If;

    End;

    Procedure sp_pl_revision_save(
        p_person_id              Varchar2,
        p_meta_id                Varchar2,

        p_application_id         Varchar2,
        p_start_date             Date,
        p_end_date               Date,
        p_half_day_on            Number,
        p_lead_empno             Varchar2,
        p_new_application_id Out Varchar2,
        p_message_type       Out Varchar2,
        p_message_text       Out Varchar2

    ) As

        v_empno        Varchar2(5);
        v_message_type Varchar2(2);
        v_count        Number;
    Begin
        --v_message_type := '1234';
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            p_message_type := 'KO';
            p_message_text := 'Invalid employee by person id';
            Return;
        End If;

        leave.save_pl_revision(
            param_empno       => v_empno,
            param_app_no      => p_application_id,
            param_bdate       => p_start_date,
            param_edate       => p_end_date,
            param_half_day_on => p_half_day_on,
            param_dataentryby => v_empno,
            param_lead_empno  => p_lead_empno,
            param_discrepancy => Null,
            param_tcp_ip      => Null,
            param_nu_app_no   => p_new_application_id,
            param_msg_type    => v_message_type,
            param_msg         => p_message_text
        );

        If v_message_type = ss.failure Then
            p_message_type := 'KO';
        Else
            p_message_type := 'OK';
        End If;

    End;

    Procedure sp_leave_details(
        p_person_id              Varchar2,
        p_meta_id                Varchar2,

        p_application_id         Varchar2,

        p_emp_name           Out Varchar2,
        p_leave_type         Out Varchar2,
        p_application_date   Out Varchar2,
        p_start_date         Out Varchar2,
        p_end_date           Out Varchar2,

        p_leave_period       Out Number,
        p_last_reporting     Out Varchar2,
        p_resuming           Out Varchar2,

        p_projno             Out Varchar2,
        p_care_taker         Out Varchar2,
        p_reason             Out Varchar2,
        p_med_cert_available Out Varchar2,
        p_contact_address    Out Varchar2,
        p_contact_std        Out Varchar2,
        p_contact_phone      Out Varchar2,
        p_office             Out Varchar2,
        p_lead_name          Out Varchar2,
        p_discrepancy        Out Varchar2,
        p_med_cert_file_nm   Out Varchar2,

        p_lead_approval      Out Varchar2,
        p_hod_approval       Out Varchar2,
        p_hr_approval        Out Varchar2,

        p_lead_reason        Out Varchar2,
        p_hod_reason         Out Varchar2,
        p_hr_reason          Out Varchar2,

        p_flag_is_adj        Out Varchar2,
        p_flag_can_del       Out Varchar2,

        p_message_type       Out Varchar2,
        p_message_text       Out Varchar2

    ) As
        v_count Number;
    Begin

        Select
            Count(*)
        Into
            v_count
        From
            ss_vu_leaveapp
        Where
            Trim(app_no) = Trim(p_application_id);
        If v_count = 1 Then
            get_leave_details_from_app(
                p_application_id     => p_application_id,

                p_emp_name           => p_emp_name,
                p_leave_type         => p_leave_type,
                p_application_date   => p_application_date,
                p_start_date         => p_start_date,
                p_end_date           => p_end_date,

                p_leave_period       => p_leave_period,
                p_last_reporting     => p_last_reporting,
                p_resuming           => p_resuming,

                p_projno             => p_projno,
                p_care_taker         => p_care_taker,
                p_reason             => p_reason,
                p_med_cert_available => p_med_cert_available,
                p_contact_address    => p_contact_address,
                p_contact_std        => p_contact_std,
                p_contact_phone      => p_contact_phone,
                p_office             => p_office,
                p_lead_name          => p_lead_name,
                p_discrepancy        => p_discrepancy,
                p_med_cert_file_nm   => p_med_cert_file_nm,

                p_lead_approval      => p_lead_approval,
                p_hod_approval       => p_hod_approval,
                p_hr_approval        => p_hr_approval,

                p_lead_reason        => p_lead_reason,
                p_hod_reason         => p_hod_reason,
                p_hr_reason          => p_hr_reason,

                p_flag_can_del       => p_flag_can_del,

                p_message_type       => p_message_type,
                p_message_text       => p_message_text
            );
            p_flag_is_adj := 'KO';
        Else
            get_leave_details_from_adj(
                p_application_id   => p_application_id,

                p_emp_name         => p_emp_name,
                p_leave_type       => p_leave_type,
                p_application_date => p_application_date,
                p_start_date       => p_start_date,
                p_end_date         => p_end_date,

                p_leave_period     => p_leave_period,
                p_med_cert_file_nm => p_med_cert_file_nm,

                p_reason           => p_reason,

                p_lead_approval    => p_lead_approval,
                p_hod_approval     => p_hod_approval,
                p_hr_approval      => p_hr_approval,

                p_message_type     => p_message_type,
                p_message_text     => p_message_text
            );
            p_flag_is_adj  := 'OK';
            p_flag_can_del := 'KO';
        End If;
    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'Err - ' || sqlcode || ' - ' || sqlerrm;
    End;

    Procedure sp_delete_leave_app(
        p_person_id                  Varchar2,
        p_meta_id                    Varchar2,

        p_application_id             Varchar2,

        p_medical_cert_file_name Out Varchar2,
        p_message_type           Out Varchar2,
        p_message_text           Out Varchar2
    ) As
        v_count      Number;
        v_empno      Varchar2(5);
        rec_leaveapp ss_leaveapp%rowtype;
    Begin
        v_empno        := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            p_message_type := 'KO';
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        Select
            Count(*)
        Into
            v_count
        From
            ss_leaveapp
        Where
            Trim(app_no) = Trim(p_application_id);
        If v_count = 0 Then
            p_message_type := 'KO';
            p_message_text := 'Invalid application id';
            Return;
        End If;
        Select
            med_cert_file_name
        Into
            p_medical_cert_file_name
        From
            ss_leaveapp
        Where
            Trim(app_no) = Trim(p_application_id);

        deleteleave(trim(p_application_id));

        p_message_type := 'OK';
        p_message_text := 'Application deleted successfully.';
    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'Err - ' || sqlcode || ' - ' || sqlerrm;
    End;

    Procedure sp_delete_leave_app_force(
        p_person_id                  Varchar2,
        p_meta_id                    Varchar2,

        p_application_id             Varchar2,

        p_medical_cert_file_name Out Varchar2,
        p_message_type           Out Varchar2,
        p_message_text           Out Varchar2
    ) As
        v_count      Number;
        v_empno      Varchar2(5);
        rec_leaveapp ss_leaveapp%rowtype;
    Begin
        v_empno        := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            p_message_type := 'KO';
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        Select
            Count(*)
        Into
            v_count
        From
            ss_vu_leaveapp
        Where
            Trim(app_no) = Trim(p_application_id);
        If v_count = 1 Then
            Select
                med_cert_file_name
            Into
                p_medical_cert_file_name
            From
                ss_vu_leaveapp
            Where
                Trim(app_no) = Trim(p_application_id);
        End If;
        If v_count = 0 Then
            Select
                Count(*)
            Into
                v_count
            From
                ss_leave_adj
            Where
                adj_no = Trim(p_application_id);
            If v_count = 1 Then
                Select
                    med_cert_file_name
                Into
                    p_medical_cert_file_name
                From
                    ss_leave_adj
                Where
                    Trim(adj_no) = Trim(p_application_id);
            End If;
        End If;

        deleteleave(
            appnum      => p_application_id,
            p_force_del => 'OK'
        );

        p_message_type := 'OK';
        p_message_text := 'Application deleted successfully.';
    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'Err - ' || sqlcode || ' - ' || sqlerrm;
    End sp_delete_leave_app_force;

    Procedure sp_leave_balances(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_empno            Varchar2 Default Null,
        p_start_date       Date     Default Null,
        p_end_date         Date     Default Null,

        p_open_cl      Out Varchar2,
        p_open_sl      Out Varchar2,
        p_open_pl      Out Varchar2,
        p_open_ex      Out Varchar2,
        p_open_co      Out Varchar2,
        p_open_oh      Out Varchar2,
        p_open_lv      Out Varchar2,

        p_close_cl     Out Varchar2,
        p_close_sl     Out Varchar2,
        p_close_pl     Out Varchar2,
        p_close_ex     Out Varchar2,
        p_close_co     Out Varchar2,
        p_close_oh     Out Varchar2,
        p_close_lv     Out Varchar2,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_empno        Varchar2(5);
        v_message_type Varchar2(2);
        v_count        Number;
    Begin
        If p_empno Is Null Then
            v_empno := get_empno_from_meta_id(p_meta_id);
            If v_empno = 'ERRRR' Then
                p_message_type := 'KO';
                p_message_text := 'Invalid employee by person id';
                Return;
            End If;
        Else
            v_empno := p_empno;
        End If;
        /*
        Select
            Count(*)
        Into
            v_count
        From
            ss_emplmast
        Where
            empno = p_empno;
        If v_count = 0 Then
            p_message_type := 'KO';
            p_message_text := 'Invalid employee number';
            Return;
        End If;
        */
        get_leave_balance_all(
            p_empno           => v_empno,
            p_pdate           => p_start_date,
            p_open_close_flag => ss.opening_bal,

            p_cl              => p_open_cl,
            p_sl              => p_open_sl,
            p_pl              => p_open_pl,
            p_ex              => p_open_ex,
            p_co              => p_open_co,
            p_oh              => p_open_oh,
            p_lv              => p_open_lv,

            p_message_type    => p_message_type,
            p_message_text    => p_message_text
        );

        If p_message_type = 'KO' Then
            Return;
        End If;

        get_leave_balance_all(
            p_empno           => v_empno,
            p_pdate           => p_end_date,
            p_open_close_flag => ss.closing_bal,

            p_cl              => p_close_cl,
            p_sl              => p_close_sl,
            p_pl              => p_close_pl,
            p_ex              => p_close_ex,
            p_co              => p_close_co,
            p_oh              => p_close_oh,
            p_lv              => p_close_lv,

            p_message_type    => p_message_type,
            p_message_text    => p_message_text
        );

    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'Err - ' || sqlcode || ' - ' || sqlerrm;

    End;

    Procedure sp_leave_approval(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_leave_approvals  typ_tab_string,
        p_approver_profile Number,
        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_app_no            Varchar2(70);
        v_approval          Number;
        v_remarks           Varchar2(70);
        v_count             Number;
        v_rec_count         Number;
        sqlpart1            Varchar2(60) := 'Update SS_leaveapp ';
        sqlpart2            Varchar2(500);
        strsql              Varchar2(600);
        v_odappstat_rec     ss_odappstat%rowtype;
        v_approver_empno    Varchar2(5);
        v_user_tcp_ip       Varchar2(30);
        v_msg_type          Varchar2(20);
        v_msg_text          Varchar2(1000);
        v_medical_cert_file Varchar2(200);
    Begin

        v_approver_empno := get_empno_from_meta_id(p_meta_id);
        If v_approver_empno = 'ERRRR' Then
            p_message_type := 'KO';
            p_message_text := 'Invalid employee number';
            Return;
        End If;
        sqlpart2         := ' set ApproverProfile_APPRL = :Approval, ApproverProfile_Code = :Approver_EmpNo, ApproverProfile_APPRL_DT = Sysdate,
                    ApproverProfile_TCP_IP = :User_TCP_IP , ApproverProfileREASON = :Reason where App_No = :paramAppNo';
        If p_approver_profile = user_profile.type_hod Or p_approver_profile = user_profile.type_sec Then
            sqlpart2 := replace(sqlpart2, 'ApproverProfile', 'HOD');
        Elsif p_approver_profile = user_profile.type_hrd Then
            sqlpart2 := replace(sqlpart2, 'ApproverProfile', 'HRD');
        Elsif p_approver_profile = user_profile.type_lead Then
            sqlpart2 := replace(sqlpart2, 'ApproverProfile', 'LEAD');
        End If;

        For i In 1..p_leave_approvals.count
        Loop

            With
                csv As (
                    Select
                        p_leave_approvals(i) str
                    From
                        dual
                )
            Select
                Trim(regexp_substr(str, '[^~!~]+', 1, 1))            app_no,
                to_number(Trim(regexp_substr(str, '[^~!~]+', 1, 2))) approval,
                Trim(regexp_substr(str, '[^~!~]+', 1, 3))            remarks
            Into
                v_app_no, v_approval, v_remarks
            From
                csv;

            /*
            p_message_type := 'OK';
            p_message_text := 'Debug 1 - ' || p_leave_approvals(i);
            Return;
            */
            strsql := sqlpart1 || ' ' || sqlpart2;
            strsql := replace(strsql, 'LEADREASON', 'LEAD_REASON');
            Execute Immediate strsql
                Using v_approval, v_approver_empno, v_user_tcp_ip, v_remarks, trim(v_app_no);
            Commit;
            If p_approver_profile = user_profile.type_hrd And v_approval = ss.approved Then
                leave.post_leave_apprl(v_app_no, v_msg_type, v_msg_text);
                /*
                If v_msg_type = ss.success Then
                    generate_auto_punch_4od(v_app_no);
                End If;
                */
            Elsif v_approval = ss.disapproved Then

                sp_process_disapproved_app(
                    p_person_id      => p_person_id,
                    p_meta_id        => p_meta_id,

                    p_application_id => Trim(v_app_no)
                );

            End If;

        End Loop;

        Commit;
        p_message_type   := 'OK';
        p_message_text   := 'Procedure executed successfully.';
    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
    End;

    Procedure sp_leave_approval_lead(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_leave_approvals  typ_tab_string,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    )
    As
    Begin
        sp_leave_approval(
            p_person_id        => p_person_id,
            p_meta_id          => p_meta_id,

            p_leave_approvals  => p_leave_approvals,
            p_approver_profile => user_profile.type_lead,
            p_message_type     => p_message_type,
            p_message_text     => p_message_text
        );
    End;

    Procedure sp_leave_approval_hod(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_leave_approvals  typ_tab_string,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    )
    As
    Begin
        sp_leave_approval(
            p_person_id        => p_person_id,
            p_meta_id          => p_meta_id,

            p_leave_approvals  => p_leave_approvals,
            p_approver_profile => user_profile.type_hod,
            p_message_type     => p_message_type,
            p_message_text     => p_message_text
        );
    End sp_leave_approval_hod;

    Procedure sp_leave_approval_hr(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_leave_approvals  typ_tab_string,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    )
    As
    Begin
        sp_leave_approval(
            p_person_id        => p_person_id,
            p_meta_id          => p_meta_id,

            p_leave_approvals  => p_leave_approvals,
            p_approver_profile => user_profile.type_hrd,
            p_message_type     => p_message_type,
            p_message_text     => p_message_text
        );
    End sp_leave_approval_hr;

    Procedure sp_do_approval_4_ex_lead(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,
        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_jan_2022       Date         := To_Date('1-Jan-2022', 'dd-Mon-yyyy');
        Cursor cur_pending_leave Is
            Select
                app_no,
                app_date,
                la.empno,
                lead_apprl_empno,
                lead_apprl,
                e.status
            From
                ss_leaveapp la,
                ss_emplmast e
            Where
                nvl(lead_apprl, 0) In (0)
                And la.lead_apprl_empno = e.empno
                And e.status            = 0
                And app_date >= v_jan_2022;
        v_sys_apprl      Varchar2(5)  := 'Sys';
        v_apprl_remarks  Varchar2(30) := 'Auto apprl as lead resigned';
        v_approver_empno Varchar2(5);
    Begin
        v_approver_empno := get_empno_from_meta_id(p_meta_id);
        If v_approver_empno = 'ERRRR' Then
            p_message_type := 'KO';
            p_message_text := 'Invalid employee number';
            Return;
        End If;
        For row_pending_leave In cur_pending_leave
        Loop
            Update
                ss_leaveapp
            Set
                lead_apprl = 1, lead_code = 'Sys', lead_apprl_dt = sysdate, lead_reason = v_apprl_remarks,
                hod_apprl = 1, hod_code = 'Sys', hod_apprl_dt = sysdate, hodreason = v_apprl_remarks
                where app_no = row_pending_leave.app_no;
        End Loop;
        p_message_type   := 'OK';
        p_message_text   := 'Procedure execute successfully';
    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;

    End sp_do_approval_4_ex_lead;

End iot_leave;
/
