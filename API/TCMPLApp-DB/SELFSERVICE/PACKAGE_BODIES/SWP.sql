--------------------------------------------------------
--  DDL for Package Body SWP
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE BODY "SELFSERVICE"."SWP" As

    Procedure check_details (
        param_win_uid           Varchar2,
        param_swp_exists        Out                     Varchar2,
        param_user_can_do_swp   Out                     Varchar2,
        param_is_iphone_user    Out                     Varchar2,
        param_success           Out                     Varchar2,
        param_message           Out                     Varchar2
    ) As
        v_empno   Varchar2(5);
        v_count   Number;
    Begin
        v_empno         := swp_users.get_empno_from_win_uid(param_win_uid);
        If v_empno Is Null Then
            param_success   := 'KO';
            param_message   := 'Err - User not found in DB.';
            return;
        End If;

        --Check user is valid

        Select
            Count(*)
        Into v_count
        From
            ss_emplmast
        Where
            empno = v_empno
            And status = 1
            And emptype In (
                'R',
                'F',
                'S',
                'C'
            );

        If v_count = 0 Then
            param_user_can_do_swp   := 'KO';
            param_success           := 'OK';
            param_message           := 'User not eligible for Smart Work Policy';
            return;
        Else
            param_user_can_do_swp := 'OK';
        End If;

        --Check employee has already already submitted his response.

        Select
            Count(*)
        Into v_count
        From
            swp_emp_response
        Where
            empno = v_empno;

        If v_count > 0 Then
            param_swp_exists := 'OK';
        Else
            param_swp_exists := 'KO';
        End If;

        Select
            Count(*)
        Into v_count
        From
            swp_emp_with_comp_mob
        Where
            empno = v_empno;

        If v_count > 0 Then
            param_is_iphone_user := 'OK';
        Else
            param_is_iphone_user := 'KO';
        End If;

        param_success   := 'OK';
    Exception
        When Others Then
            param_success   := 'KO';
            param_message   := 'Err - ' || Sqlcode || ' - ' || Sqlerrm;
    End check_details;

    Procedure swp_create (
        param_win_uid             Varchar2,
        param_is_accepted         Varchar2,
        param_download_speed      Varchar2,
        param_upload_speed        Varchar2,
        param_monthly_quota       Varchar2,
        param_isp_name            Varchar2,
        param_router_brand        Varchar2,
        param_router_model        Varchar2,
        param_msauth_on_own_mob   Varchar2,
        param_success             Out                       Varchar2,
        param_message             Out                       Varchar2
    ) As
        v_empno Char(5);
    Begin
        v_empno         := swp_users.get_empno_from_win_uid(param_win_uid);
        If v_empno Is Null Then
            param_success   := 'KO';
            param_message   := 'Err - User not found in DB.';
            return;
        End If;

        Insert Into swp_emp_response (
            empno,
            is_accepted,
            emp_entry_date
        ) Values (
            v_empno,
            param_is_accepted,
            Sysdate
        );

        Delete From swp_it_prerequisites
        Where
            empno = v_empno;

        Insert Into swp_it_prerequisites (
            empno,
            download_speed,
            upload_speed,
            monthly_quota,
            isp_name,
            router_brand,
            router_model,
            ms_auth_on_own_mob,
            modified_on
        ) Values (
            v_empno,
            param_download_speed,
            param_upload_speed,
            param_monthly_quota,
            param_isp_name,
            param_router_brand,
            param_router_model,
            param_msauth_on_own_mob,
            Sysdate
        );

        Commit;
        param_success   := 'OK';
    Exception
        When Others Then
            param_success   := 'KO';
            param_message   := 'Err - ' || Sqlcode || ' - ' || Sqlerrm;
    End swp_create;

    Procedure swp_hod_appr (
        p_json              Clob,
        param_hod_win_uid   Varchar2,
        param_success       Out                 Varchar2,
        param_message       Out                 Varchar2
    ) As
        v_empno         swp_emp_response.empno%Type;
        v_is_accepted   swp_emp_response.is_accepted%Type;
        v_hod           Varchar2(5);
    Begin
        v_hod           := swp_users.get_empno_from_win_uid(param_hod_win_uid);
        If v_hod Is Null Then
            param_success   := 'KO';
            param_message   := 'Err - HoD not found in DB.';
            return;
        End If;

        apex_json.parse(p_json);
        For i In 1..apex_json.get_count('data') Loop
            v_empno         := apex_json.get_varchar2(
                'data[%d].EMPNO',
                i
            );
            v_is_accepted   := apex_json.get_varchar2(
                'data[%d].IS_ACCEPTED',
                i
            );
            If v_is_accepted = 'OK' Then
                Update swp_emp_response
                Set
                    hod_apprl = 'OK',
                    hod_apprl_by = v_hod,
                    hod_apprl_date = Sysdate
                Where
                    empno = v_empno;

            Else
                param_success   := 'KO';
                param_message   := 'Err - Policy not accepted';
                return;
            End If;

        End Loop;

        Commit;
        /*For i In 1..apex_json.get_count('data') Loop
            v_empno := apex_json.get_varchar2('data[%d].EMPNO', i);
            send_mail(v_empno, 'HoD', 'Approved');
        End Loop;*/
        param_success   := 'OK';
        param_message   := 'Approved';
    Exception
        When Others Then
            param_success   := 'KO';
            param_message   := 'Err - ' || Sqlcode || ' - ' || Sqlerrm;
    End swp_hod_appr;

    Procedure swp_hod_reject (
        param_empno         Char,
        param_hod_win_uid   Varchar2,
        param_success       Out                 Varchar2,
        param_message       Out                 Varchar2
    ) As
        v_hod        Varchar2(5);
        v_hr_apprl   Varchar2(2);
    Begin
        v_hod := swp_users.get_empno_from_win_uid(param_hod_win_uid);
        If v_hod Is Null Then
            param_success   := 'KO';
            param_message   := 'Err - HoD not found in DB.';
            return;
        End If;

        Select
            hr_apprl
        Into v_hr_apprl
        From
            swp_emp_response
        Where
            empno = param_empno;

        If Nvl(v_hr_apprl, 'KO') = 'OK' Then
            param_success   := 'KO';
            param_message   := 'Err - Smart Working Policy is already approved by HR.';
            return;
        Else
            Update swp_emp_response
            Set
                hod_apprl = 'KO',
                hod_apprl_by = v_hod,
                hod_apprl_date = Sysdate
            Where
                empno = param_empno;

            Commit;
            send_mail(
                param_empno,
                'HoD',
                'Rejected'
            );
            param_success   := 'OK';
            param_message   := 'Rejected by HoD';
        End If;

    Exception
        When Others Then
            param_success   := 'KO';
            param_message   := 'Err - ' || Sqlcode || ' - ' || Sqlerrm;
    End swp_hod_reject;

    Procedure swp_hr_appr (
        p_json             Clob,
        param_hr_win_uid   Varchar2,
        param_success      Out                Varchar2,
        param_message      Out                Varchar2
    ) As

        v_empno         swp_emp_response.empno%Type;
        v_is_accepted   swp_emp_response.is_accepted%Type;
        v_hod_apprl     swp_emp_response.hod_apprl%Type;
        v_hr            Varchar2(5);
    Begin
        v_hr            := swp_users.get_empno_from_win_uid(param_hr_win_uid);
        If v_hr Is Null Then
            param_success   := 'KO';
            param_message   := 'Err - HR not found in DB.';
            return;
        End If;

        apex_json.parse(p_json);
        For i In 1..apex_json.get_count('data') Loop
            v_empno         := apex_json.get_varchar2(
                'data[%d].EMPNO',
                i
            );
            v_is_accepted   := apex_json.get_varchar2(
                'data[%d].IS_ACCEPTED',
                i
            );
            v_hod_apprl     := apex_json.get_varchar2(
                'data[%d].HOD_APPRL',
                i
            );
            If v_is_accepted = 'OK' And v_hod_apprl = 'OK' Then
                Update swp_emp_response
                Set
                    hr_apprl = 'OK',
                    hr_apprl_by = v_hr,
                    hr_apprl_date = Sysdate
                Where
                    empno = v_empno;

            Else
                param_success   := 'KO';
                param_message   := 'Err - Policy not accepted / HoD not approved';
                return;
            End If;

        End Loop;

        Commit;
        /*For i In 1..apex_json.get_count('data') Loop
            v_empno := apex_json.get_varchar2('data[%d].EMPNO', i);
            send_mail(v_empno, 'HR', 'Approved');
        End Loop;*/
        param_success   := 'OK';
        param_message   := 'Approved';
    Exception
        When Others Then
            param_success   := 'KO';
            param_message   := 'Err - ' || Sqlcode || ' - ' || Sqlerrm;
    End swp_hr_appr;

    Procedure swp_hr_reject (
        param_empno        Char,
        param_hr_win_uid   Varchar2,
        param_success      Out                Varchar2,
        param_message      Out                Varchar2
    ) As
        v_hr         Varchar2(5);
        v_hr_apprl   Varchar2(2);
    Begin
        v_hr            := swp_users.get_empno_from_win_uid(param_hr_win_uid);
        If v_hr Is Null Then
            param_success   := 'KO';
            param_message   := 'Err - HR not found in DB.';
            return;
        End If;

        Update swp_emp_response
        Set
            hr_apprl = 'KO',
            hr_apprl_by = v_hr,
            hr_apprl_date = Sysdate
        Where
            empno = param_empno;

        Commit;
        send_mail(
            param_empno,
            'HR',
            'Rejected'
        );
        param_success   := 'OK';
        param_message   := 'Rejected by HR';
    Exception
        When Others Then
            param_success   := 'KO';
            param_message   := 'Err - ' || Sqlcode || ' - ' || Sqlerrm;
    End swp_hr_reject;

    Procedure swp_hr_reset (
        param_empno        Char,
        param_hr_win_uid   Varchar2,
        param_success      Out                Varchar2,
        param_message      Out                Varchar2
    ) As
        v_hr         Varchar2(5);
        v_hr_apprl   Varchar2(2);
    Begin
        v_hr            := swp_users.get_empno_from_win_uid(param_hr_win_uid);
        If v_hr Is Null Then
            param_success   := 'KO';
            param_message   := 'Err - HR not found in DB.';
            return;
        End If;

        Delete From swp_emp_response
        Where
            empno = param_empno;

        Delete From swp_it_prerequisites
        Where
            empno = param_empno;

        Commit;
        param_success   := 'OK';
        param_message   := 'Reset successfully by HR';
    Exception
        When Others Then
            param_success   := 'KO';
            param_message   := 'Err - ' || Sqlcode || ' - ' || Sqlerrm;
    End swp_hr_reset;

    Function mail_body (
        p_name          Varchar2,
        p_appr          Varchar2,
        p_appr_status   Varchar2
    ) Return Varchar2 Is
        v_body Varchar2(4000);
    Begin
        v_body   := 'Dear ' || p_name || ',' || Chr(13) || Chr(10) || Chr(13) || Chr(10);

        If Upper(p_appr) = 'HOD' Then
            v_body := v_body || 'Your application for the Smart Work Policy Agreement has been disapproved by your HOD. Please contact your HOD before re-application.'
            ;
        Else
            v_body := v_body || 'Your application for the Smart Work Policy Agreement has been disapproved by HR as the completion of the mandatory training/s is/are pending from your end. Please complete your pending training/s and contact Ashutosh Rawat / Kausik Das from HR before re-application.'
            ;
        End If;

        v_body   := v_body || Chr(13) || Chr(10) || Chr(13) || Chr(10);

        v_body   := v_body || 'Thanks,' || Chr(13) || Chr(10);

        v_body   := v_body || 'This is an automated TCMPL Mail.';
        Return v_body;
    End mail_body;

    Procedure send_mail (
        p_empno         Char,
        p_appr          Varchar2,
        p_appr_status   Varchar2
    ) As

        v_email           ss_emplmast.email%Type;
        v_name            ss_emplmast.name%Type;
        v_email_body      Varchar2(4000);
        v_email_subject   Varchar2(200);
        v_success         Varchar2(10);
        v_message         Varchar2(1000);
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
            empno = p_empno;

        If Upper(p_appr) = 'HOD' Then
            v_email_subject := 'Smart Work Policy Agreement application disapproved by HOD';
        Else
            v_email_subject := 'Smart Work Policy Agreement application disapproved by HR';
        End If;

        v_email_body := swp.mail_body(
            v_name,
            p_appr,
            p_appr_status
        );
        If v_email Is Not Null Then
            send_mail_from_api(
                p_mail_to        => v_email,
                p_mail_cc        => Null,
                p_mail_bcc       => Null,
                p_mail_subject   => v_email_subject,
                p_mail_body      => v_email_body,
                p_mail_profile   => 'SELFSERVICE',
                p_mail_format    => 'Text',
                p_success        => v_success,
                p_message        => v_message
            );

        /*
            ss_mail.send_mail_2_user_nu(
                param_to_mail_id   => v_email,
                param_subject      => 'Smart Working - ' || p_appr_status,
                param_body         => swp.mail_body(
                    v_name,
                    p_appr,
                    p_appr_status
                )
            );
        */
        End If;

    Exception
        When Others Then
            Null;
    End send_mail;

End swp;


/

  GRANT EXECUTE ON "SELFSERVICE"."SWP" TO "TCMPL_APP_CONFIG";
