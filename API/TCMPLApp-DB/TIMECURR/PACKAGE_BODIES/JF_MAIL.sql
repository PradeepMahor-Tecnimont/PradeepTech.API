--------------------------------------------------------
--  DDL for Package Body JF_MAIL
--------------------------------------------------------

Create Or Replace Package Body timecurr.jf_mail As

    Procedure proc_mail_job_form(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_projno           Varchar2,
        p_phase            Varchar2,
        p_stage            Varchar2,
        p_mailto           Varchar2,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_mail_csv       Varchar2(2000);
        v_subject        Varchar2(1000);
        v_msg_body       Varchar2(2000);
        v_success        Varchar2(1000);
        v_message        Varchar2(500);
        v_empno          Varchar2(5);

        v_short_desc     jobmaster.short_desc%Type;
        v_comp_desc      Varchar2(100);
        v_form_mode_desc Varchar2(100);
        v_revision       jobmaster.revision%Type;
        v_form_date      jobmaster.form_date%Type;
        v_description    jobmaster.description%Type;
        v_dirvp_empno    jobmaster.dirvp_empno%Type;
        v_dirop_empno    jobmaster.dirop_empno%Type;
        v_amfi_empno     jobmaster.amfi_empno%Type;
        v_amfi_user      jobmaster.amfi_user%Type;
        v_pm_email       emplmast.email%Type;
        v_pm_name        emplmast.name%Type;

        v_flag           Number(1) := 0;

    Begin
        v_empno        := get_empno_from_meta_id(p_meta_id);

        Select
            jm.short_desc,
            Case jm.co
                When 'T' Then
                    'Tecnimont Pvt. Ltd'
                When 'E' Then
                    'Engineering and Designs Tecnimont ICB  Pvt. Ltd'
            End comp_desc,
            Case jm.form_mode
                When 'M' Then
                    'Modification of Existing Job'
                When 'C' Then
                    'Closing of Existing Job'
                Else
                    'Creation of New Job'
            End form_mode,
            jm.revision,
            jm.form_date,
            jm.description,
            jm.dirvp_empno,
            jm.dirop_empno,
            jm.amfi_empno,
            jm.amfi_user,
            e.email,
            e.name
        Into
            v_short_desc,
            v_comp_desc,
            v_form_mode_desc,
            v_revision,
            v_form_date,
            v_description,
            v_dirvp_empno,
            v_dirop_empno,
            v_amfi_empno,
            v_amfi_user,
            v_pm_email,
            v_pm_name
        From
            jobmaster              jm, emplmast e
        Where
            jm.pm_empno   = e.empno
            And jm.projno = p_projno
            And jm.phase  = p_phase;

        If p_mailto Is Not Null And v_short_desc Is Not Null Then

            v_subject  := get_mail_subject(p_stage, p_mailto, v_pm_email);

            v_msg_body := get_mail_body(p_projno,
                                        p_phase,
                                        v_pm_name,
                                        v_pm_email,
                                        p_mailto,
                                        v_form_date,
                                        v_form_mode_desc,
                                        v_short_desc,
                                        v_comp_desc,
                                        v_description,
                                        p_stage);

            tcmpl_app_config.pkg_app_mail_queue.sp_add_to_queue(
                p_person_id    => Null,
                p_meta_id      => Null,
                p_mail_to      => p_mailto,
                p_mail_cc      => Null,
                p_mail_bcc     => Null,
                p_mail_subject => v_subject,
                p_mail_body1   => v_msg_body,
                p_mail_body2   => Null,
                p_mail_type    => 'Text',
                p_mail_from    => c_mail_from,
                p_message_type => v_success,
                p_message_text => v_message
            );
            v_flag     := 1;
            
        End If;

        If v_pm_email Is Not Null And p_stage <> '1' Then

            v_subject  := get_mail_subject(p_stage, p_mailto, v_pm_email);

            v_msg_body := get_mail_body(p_projno,
                                        p_phase,
                                        v_pm_name,
                                        v_pm_email,
                                        p_mailto,
                                        v_form_date,
                                        v_form_mode_desc,
                                        v_short_desc,
                                        v_comp_desc,
                                        v_description,
                                        p_stage);

            tcmpl_app_config.pkg_app_mail_queue.sp_add_to_queue(
                p_person_id    => Null,
                p_meta_id      => Null,
                p_mail_to      => v_pm_email,
                p_mail_cc      => Null,
                p_mail_bcc     => Null,
                p_mail_subject => v_subject,
                p_mail_body1   => v_msg_body,
                p_mail_body2   => Null,
                p_mail_type    => 'Text',
                p_mail_from    => c_mail_from,
                p_message_type => v_success,
                p_message_text => v_message
            );
            v_flag     := 1;
            
        End If;

        p_message_type := c_ok;
        If v_flag = 1 Then
            p_message_text := 'Procedure executed successfully.';
            
        Else
            p_message_text := 'Nothing to execute.';
            
        End If;

    Exception
        When Others Then
            p_message_type := c_not_ok;
            p_message_text := 'Err - ' || sqlcode || ' - ' || sqlerrm;
    End proc_mail_job_form;

    Function get_mail_subject(p_stage    Varchar2,
                              p_email    Varchar2,
                              p_pm_email Varchar2) Return Varchar2 Is
        v_subject Varchar2(1000);
    Begin
        If p_email Is Not Null Then
            Case p_stage
                When '3' Then
                    v_subject := 'Job Form Pending for Financial Information Updation';

                When '5' Then
                    v_subject := 'Job Form: Acknowledgment Receipt (Final AFC Approval)';

                Else
                    v_subject := 'Job Form Pending for your Approval';

            End Case;
        Elsif p_pm_email Is Not Null Then
            Case p_stage
                When '2' Then
                    v_subject := 'Job Form: Acknowledgment Receipt (Job Incharge Approval)';

                When '3' Then
                    v_subject := 'Job Form: Acknowledgment Receipt (MD Approval)';

                When '4' Then
                    v_subject := 'Job Form: Acknowledgment Receipt (AFC Info Updation)';

                When '5' Then
                    v_subject := 'Job Form: Acknowledgment Receipt (Final AFC Approval)';

            End Case;

        End If;
        Return v_subject;
    End get_mail_subject;

    Function get_mail_body(p_projno      Varchar2,
                           p_phase       Varchar2,
                           p_pm_name     Varchar2,
                           p_pm_email    Varchar2,
                           p_email       Varchar2,
                           p_form_date   Varchar2,
                           p_purpose     Varchar2,
                           p_short_desc  Varchar2,
                           p_comp_desc   Varchar2,
                           p_description Varchar2,
                           p_stage       Varchar2) Return Varchar2 Is
        v_msg_body Varchar2(4000);
    Begin

        If p_email Is Not Null Then
            v_msg_body := 'Dear Sir,' || chr(10) || chr(13) || chr(10) || chr(13);
            v_msg_body := v_msg_body || 'This is to inform you that job form has been created by ' || chr(10) || chr(13);
            v_msg_body := v_msg_body || p_pm_name || ' on ' || p_form_date || ' for ' || p_purpose || ' and ' || chr(10) ||
                          chr(13);
            Case p_stage
                When '1' Then
                    v_msg_body := v_msg_body || 'Waiting for Job Incharge Approval.';
                When '2' Then
                    v_msg_body := v_msg_body || 'Waiting for MD''s approval.';
                When '3' Then
                    v_msg_body := v_msg_body || 'Waiting for AFC Information Updation.';
                When '4' Then
                    v_msg_body := v_msg_body || 'Waiting for Final Approval from AFC.';
                When '5' Then
                    v_msg_body := v_msg_body || 'Final Approval completed from AFC.';
            End Case;
        Elsif p_pm_email Is Not Null Then
            v_msg_body := 'Dear Sir,' || chr(10) || chr(13) || chr(10) || chr(13);
            v_msg_body := v_msg_body || 'The job form, which has been created by you ' || chr(10) || chr(13);
            v_msg_body := v_msg_body || 'on ' || p_form_date || ' for ' || p_purpose || ' and ' || chr(10) || chr(13);
            Case p_stage
                When '2' Then
                    v_msg_body := v_msg_body || 'now it is approved by Job Incharge and Waiting for MD''s Approval';

                When '3' Then
                    v_msg_body := v_msg_body || 'now it is approved by MD and Waiting for AFC Information Updation.';

                When '4' Then
                    v_msg_body := v_msg_body || 'now FAS Information has been updated and waiting for Final Approval from AFC';

                When '5' Then
                    v_msg_body := v_msg_body || 'now it has been approved by AFC.';

            End Case;
        End If;

        v_msg_body := v_msg_body || chr(10) || chr(13) || chr(10) || chr(13);
        v_msg_body := v_msg_body || 'Job Info as follows' || chr(10) || chr(13) || chr(10) || chr(13);
        v_msg_body := v_msg_body || 'Job No      : ' || p_projno || chr(10) || chr(13) || ' ' || p_phase;
        v_msg_body := v_msg_body || 'Job Name    : ' || p_short_desc || chr(10) || chr(13);
        v_msg_body := v_msg_body || 'Job Company : ' || p_comp_desc || chr(10) || chr(13);
        v_msg_body := v_msg_body || 'Description : ' || p_description || chr(10) || chr(13) || chr(10) || chr(13);
        v_msg_body := v_msg_body || chr(10) || chr(13) || chr(10) || chr(13);
        v_msg_body := v_msg_body || 'Thanks.';

        Return v_msg_body;
    End get_mail_body;
	
    --	Grant execute on jf_mail to tcmpl_app_config;

End jf_mail;