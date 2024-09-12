--------------------------------------------------------
--  DDL for Package Body IOT_JOBS_MAIL
--------------------------------------------------------

Create Or Replace Package Body "TIMECURR"."IOT_JOBS_MAIL" As
     
    Procedure sp_process_mail_for_queue(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_projno           Varchar2,
        p_process_name     Varchar2,
        p_subject          Varchar2,
        p_phase            Varchar2,
        p_short_desc       Varchar2,
        p_comp_desc        Varchar2,
        p_form_mode_desc   Varchar2,
        p_revision         Varchar2,
        p_form_date        Date,
        p_description      Varchar2,
        p_pm_email         Varchar2,
        p_pm_name          Varchar2,
        p_js_email         Varchar2,
        p_cmd_email        Varchar2,
        p_afc_email        Varchar2,
        p_dist_list_email  Varchar2,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    );

    Procedure sp_get_job_attributes(
        p_person_id           Varchar2,
        p_meta_id             Varchar2,

        p_projno              Varchar2,
        p_phase           Out Varchar2,
        p_short_desc      Out Varchar2,
        p_comp_desc       Out Varchar2,
        p_form_mode_desc  Out Varchar2,
        p_revision        Out Number,
        p_form_date       Out Date,
        p_description     Out Varchar2,
        p_pm_email        Out Varchar2,
        p_pm_name         Out Varchar2,
        p_js_email        Out Varchar2,
        p_cmd_email       Out Varchar2,
        p_afc_email       Out Varchar2,
        p_dist_list_email Out Varchar2,
        p_process_name        Varchar2,

        p_message_type    Out Varchar2,
        p_message_text    Out Varchar2
    );

    Function fn_get_mail_body(p_projno       Varchar2,
                              p_phase        Varchar2,
                              p_pm_name      Varchar2,
                              p_form_date    Varchar2,
                              p_purpose      Varchar2,
                              p_short_desc   Varchar2,
                              p_comp_desc    Varchar2,
                              p_description  Varchar2,
                              p_process_name Varchar2) Return Varchar2;

    Procedure send_mail_on_erp_pm_approval(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_projno           Varchar2,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_empno           Varchar2(5);
        v_phase           jobmaster.phase%Type;
        v_short_desc      jobmaster.short_desc%Type;
        v_comp_desc       Varchar2(100);
        v_form_mode_desc  Varchar2(100);
        v_revision        jobmaster.revision%Type;
        v_form_date       jobmaster.form_date%Type;
        v_description     jobmaster.description%Type;
        v_pm_email        emplmast.email%Type;
        v_pm_name         emplmast.name%Type;
        v_js_email        emplmast.email%Type;
        v_cmd_email       emplmast.email%Type;
        v_afc_email       Varchar2(201);
        v_dist_list_email Varchar2(4000);
    Begin
        If v_empno = 'ERRRR' Then
            p_message_type := c_not_ok;
            p_message_text := 'Not authorized';
            Return;
        End If;

        sp_get_job_attributes(
            p_person_id       => p_person_id,
            p_meta_id         => p_meta_id,

            p_projno          => p_projno,
            p_phase           => v_phase,
            p_short_desc      => v_short_desc,
            p_comp_desc       => v_comp_desc,
            p_form_mode_desc  => v_form_mode_desc,
            p_revision        => v_revision,
            p_form_date       => v_form_date,
            p_description     => v_description,
            p_pm_email        => v_pm_email,
            p_pm_name         => v_pm_name,
            p_js_email        => v_js_email,
            p_cmd_email       => v_cmd_email,
            p_afc_email       => v_afc_email,
            p_dist_list_email => v_dist_list_email,
            p_process_name    => c_send_mail_on_erp_pm_approval,

            p_message_type    => p_message_type,
            p_message_text    => p_message_text
        );

        If v_js_email Is Not Null Then
            --For Job sponsor's approval
            sp_process_mail_for_queue(
                p_person_id       => p_person_id,
                p_meta_id         => p_meta_id,

                p_projno          => p_projno,
                p_process_name    => c_send_mail_on_erp_pm_approval,
                p_subject         => c_to_approve_subject,
                p_phase           => v_phase,
                p_short_desc      => v_short_desc,
                p_comp_desc       => v_comp_desc,
                p_form_mode_desc  => v_form_mode_desc,
                p_revision        => v_revision,
                p_form_date       => v_form_date,
                p_description     => v_description,
                p_pm_email        => v_pm_email,
                p_pm_name         => v_pm_name,
                p_js_email        => v_js_email,
                p_cmd_email       => v_cmd_email,
                p_afc_email       => v_afc_email,
                p_dist_list_email => v_dist_list_email,

                p_message_type    => p_message_type,
                p_message_text    => p_message_text
            );
        End If;
    Exception
        When Others Then
            p_message_type := c_not_ok;
            p_message_text := 'Err - ' || sqlcode || ' - ' || sqlerrm;
    End send_mail_on_erp_pm_approval;

    Procedure send_mail_on_js_approval(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_projno           Varchar2,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_empno           Varchar2(5);
        v_phase           jobmaster.phase%Type;
        v_short_desc      jobmaster.short_desc%Type;
        v_comp_desc       Varchar2(100);
        v_form_mode_desc  Varchar2(100);
        v_revision        jobmaster.revision%Type;
        v_form_date       jobmaster.form_date%Type;
        v_description     jobmaster.description%Type;
        v_pm_email        emplmast.email%Type;
        v_pm_name         emplmast.name%Type;
        v_js_email        emplmast.email%Type;
        v_cmd_email       emplmast.email%Type;
        v_afc_email       Varchar2(201);
        v_dist_list_email Varchar2(4000);
    Begin
        If v_empno = 'ERRRR' Then
            p_message_type := c_not_ok;
            p_message_text := 'Not authorized';
            Return;
        End If;

        sp_get_job_attributes(
            p_person_id       => p_person_id,
            p_meta_id         => p_meta_id,

            p_projno          => p_projno,
            p_phase           => v_phase,
            p_short_desc      => v_short_desc,
            p_comp_desc       => v_comp_desc,
            p_form_mode_desc  => v_form_mode_desc,
            p_revision        => v_revision,
            p_form_date       => v_form_date,
            p_description     => v_description,
            p_pm_email        => v_pm_email,
            p_pm_name         => v_pm_name,
            p_js_email        => v_js_email,
            p_cmd_email       => v_cmd_email,
            p_afc_email       => v_afc_email,
            p_dist_list_email => v_dist_list_email,
            p_process_name    => c_send_mail_on_js_approval,

            p_message_type    => p_message_type,
            p_message_text    => p_message_text
        );

        --For MD's approval
        sp_process_mail_for_queue(
            p_person_id       => p_person_id,
            p_meta_id         => p_meta_id,

            p_projno          => p_projno,
            p_process_name    => c_send_mail_on_js_approval,
            p_subject         => c_to_approve_subject,
            p_phase           => v_phase,
            p_short_desc      => v_short_desc,
            p_comp_desc       => v_comp_desc,
            p_form_mode_desc  => v_form_mode_desc,
            p_revision        => v_revision,
            p_form_date       => v_form_date,
            p_description     => v_description,
            p_pm_email        => v_pm_email,
            p_pm_name         => v_pm_name,
            p_js_email        => v_js_email,
            p_cmd_email       => v_cmd_email,
            p_afc_email       => v_afc_email,
            p_dist_list_email => v_dist_list_email,

            p_message_type    => p_message_type,
            p_message_text    => p_message_text
        );

        --For PM's info
        sp_process_mail_for_queue(
            p_person_id       => p_person_id,
            p_meta_id         => p_meta_id,

            p_projno          => p_projno,
            p_process_name    => c_approved_by_js_subject,
            p_subject         => c_approved_by_js_subject,
            p_phase           => v_phase,
            p_short_desc      => v_short_desc,
            p_comp_desc       => v_comp_desc,
            p_form_mode_desc  => v_form_mode_desc,
            p_revision        => v_revision,
            p_form_date       => v_form_date,
            p_description     => v_description,
            p_pm_email        => v_pm_email,
            p_pm_name         => v_pm_name,
            p_js_email        => v_js_email,
            p_cmd_email       => v_cmd_email,
            p_afc_email       => v_afc_email,
            p_dist_list_email => v_dist_list_email,

            p_message_type    => p_message_type,
            p_message_text    => p_message_text
        );

    Exception
        When Others Then
            p_message_type := c_not_ok;
            p_message_text := 'Err - ' || sqlcode || ' - ' || sqlerrm;
    End send_mail_on_js_approval;
    
    Procedure send_mail_on_js_review(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_projno           Varchar2,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_empno           Varchar2(5);
        v_phase           jobmaster.phase%Type;
        v_short_desc      jobmaster.short_desc%Type;
        v_comp_desc       Varchar2(100);
        v_form_mode_desc  Varchar2(100);
        v_revision        jobmaster.revision%Type;
        v_form_date       jobmaster.form_date%Type;
        v_description     jobmaster.description%Type;
        v_pm_email        emplmast.email%Type;
        v_pm_name         emplmast.name%Type;
        v_js_email        emplmast.email%Type;
        v_cmd_email       emplmast.email%Type;
        v_afc_email       Varchar2(201);
        v_dist_list_email Varchar2(4000);
    Begin
        If v_empno = 'ERRRR' Then
            p_message_type := c_not_ok;
            p_message_text := 'Not authorized';
            Return;
        End If;

        sp_get_job_attributes(
            p_person_id       => p_person_id,
            p_meta_id         => p_meta_id,

            p_projno          => p_projno,
            p_phase           => v_phase,
            p_short_desc      => v_short_desc,
            p_comp_desc       => v_comp_desc,
            p_form_mode_desc  => v_form_mode_desc,
            p_revision        => v_revision,
            p_form_date       => v_form_date,
            p_description     => v_description,
            p_pm_email        => v_pm_email,
            p_pm_name         => v_pm_name,
            p_js_email        => v_js_email,
            p_cmd_email       => v_cmd_email,
            p_afc_email       => v_afc_email,
            p_dist_list_email => v_dist_list_email,
            p_process_name    => c_send_mail_on_js_review,

            p_message_type    => p_message_type,
            p_message_text    => p_message_text
        );

        --For PM's info
        sp_process_mail_for_queue(
            p_person_id       => p_person_id,
            p_meta_id         => p_meta_id,

            p_projno          => p_projno,
            p_process_name    => c_review_by_js_subject,
            p_subject         => c_review_by_js_subject,
            p_phase           => v_phase,
            p_short_desc      => v_short_desc,
            p_comp_desc       => v_comp_desc,
            p_form_mode_desc  => v_form_mode_desc,
            p_revision        => v_revision,
            p_form_date       => v_form_date,
            p_description     => v_description,
            p_pm_email        => v_pm_email,
            p_pm_name         => v_pm_name,
            p_js_email        => v_js_email,
            p_cmd_email       => null,
            p_afc_email       => null,
            p_dist_list_email => null,

            p_message_type    => p_message_type,
            p_message_text    => p_message_text
        );

    Exception
        When Others Then
            p_message_type := c_not_ok;
            p_message_text := 'Err - ' || sqlcode || ' - ' || sqlerrm;
    End send_mail_on_js_review;
    
    Procedure send_mail_on_cmd_approval(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_projno           Varchar2,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_empno           Varchar2(5);
        v_phase           jobmaster.phase%Type;
        v_short_desc      jobmaster.short_desc%Type;
        v_comp_desc       Varchar2(100);
        v_form_mode_desc  Varchar2(100);
        v_revision        jobmaster.revision%Type;
        v_form_date       jobmaster.form_date%Type;
        v_description     jobmaster.description%Type;
        v_pm_email        emplmast.email%Type;
        v_pm_name         emplmast.name%Type;
        v_js_email        emplmast.email%Type;
        v_cmd_email       emplmast.email%Type;
        v_afc_email       Varchar2(201);
        v_dist_list_email Varchar2(4000);
    Begin
        If v_empno = 'ERRRR' Then
            p_message_type := c_not_ok;
            p_message_text := 'Not authorized';
            Return;
        End If;

        sp_get_job_attributes(
            p_person_id       => p_person_id,
            p_meta_id         => p_meta_id,

            p_projno          => p_projno,
            p_phase           => v_phase,
            p_short_desc      => v_short_desc,
            p_comp_desc       => v_comp_desc,
            p_form_mode_desc  => v_form_mode_desc,
            p_revision        => v_revision,
            p_form_date       => v_form_date,
            p_description     => v_description,
            p_pm_email        => v_pm_email,
            p_pm_name         => v_pm_name,
            p_js_email        => v_js_email,
            p_cmd_email       => v_cmd_email,
            p_afc_email       => v_afc_email,
            p_dist_list_email => v_dist_list_email,
            p_process_name    => c_send_mail_on_cmd_approval,

            p_message_type    => p_message_type,
            p_message_text    => p_message_text
        );

        --For AFC's approval
        sp_process_mail_for_queue(
            p_person_id       => p_person_id,
            p_meta_id         => p_meta_id,

            p_projno          => p_projno,
            p_process_name    => c_send_mail_on_cmd_approval,
            p_subject         => c_to_approve_subject,
            p_phase           => v_phase,
            p_short_desc      => v_short_desc,
            p_comp_desc       => v_comp_desc,
            p_form_mode_desc  => v_form_mode_desc,
            p_revision        => v_revision,
            p_form_date       => v_form_date,
            p_description     => v_description,
            p_pm_email        => v_pm_email,
            p_pm_name         => v_pm_name,
            p_js_email        => v_js_email,
            p_cmd_email       => v_cmd_email,
            p_afc_email       => v_afc_email,
            p_dist_list_email => v_dist_list_email,

            p_message_type    => p_message_type,
            p_message_text    => p_message_text
        );

        --For PM's info
        sp_process_mail_for_queue(
            p_person_id       => p_person_id,
            p_meta_id         => p_meta_id,

            p_projno          => p_projno,
            p_process_name    => c_approved_by_cmd_subject,
            p_subject         => c_approved_by_cmd_subject,
            p_phase           => v_phase,
            p_short_desc      => v_short_desc,
            p_comp_desc       => v_comp_desc,
            p_form_mode_desc  => v_form_mode_desc,
            p_revision        => v_revision,
            p_form_date       => v_form_date,
            p_description     => v_description,
            p_pm_email        => v_pm_email,
            p_pm_name         => v_pm_name,
            p_js_email        => v_js_email,
            p_cmd_email       => v_cmd_email,
            p_afc_email       => v_afc_email,
            p_dist_list_email => v_dist_list_email,

            p_message_type    => p_message_type,
            p_message_text    => p_message_text
        );

    Exception
        When Others Then
            p_message_type := c_not_ok;
            p_message_text := 'Err - ' || sqlcode || ' - ' || sqlerrm;
    End send_mail_on_cmd_approval;

    Procedure send_mail_on_afc_approval(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_projno           Varchar2,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_empno           Varchar2(5);
        v_phase           jobmaster.phase%Type;
        v_short_desc      jobmaster.short_desc%Type;
        v_comp_desc       Varchar2(100);
        v_form_mode_desc  Varchar2(100);
        v_revision        jobmaster.revision%Type;
        v_form_date       jobmaster.form_date%Type;
        v_description     jobmaster.description%Type;
        v_pm_email        emplmast.email%Type;
        v_pm_name         emplmast.name%Type;
        v_js_email        emplmast.email%Type;
        v_cmd_email       emplmast.email%Type;
        v_afc_email       Varchar2(201);
        v_dist_list_email Varchar2(4000);
    Begin
        If v_empno = 'ERRRR' Then
            p_message_type := c_not_ok;
            p_message_text := 'Not authorized';
            Return;
        End If;

        sp_get_job_attributes(
            p_person_id       => p_person_id,
            p_meta_id         => p_meta_id,

            p_projno          => p_projno,
            p_phase           => v_phase,
            p_short_desc      => v_short_desc,
            p_comp_desc       => v_comp_desc,
            p_form_mode_desc  => v_form_mode_desc,
            p_revision        => v_revision,
            p_form_date       => v_form_date,
            p_description     => v_description,
            p_pm_email        => v_pm_email,
            p_pm_name         => v_pm_name,
            p_js_email        => v_js_email,
            p_cmd_email       => v_cmd_email,
            p_afc_email       => v_afc_email,
            p_dist_list_email => v_dist_list_email,
            p_process_name    => c_send_mail_on_afc_approval,

            p_message_type    => p_message_type,
            p_message_text    => p_message_text
        );

        --For PM's info
        sp_process_mail_for_queue(
            p_person_id       => p_person_id,
            p_meta_id         => p_meta_id,

            p_projno          => p_projno,
            p_process_name    => c_approved_by_afc_subject,
            p_subject         => c_approved_by_afc_subject,
            p_phase           => v_phase,
            p_short_desc      => v_short_desc,
            p_comp_desc       => v_comp_desc,
            p_form_mode_desc  => v_form_mode_desc,
            p_revision        => v_revision,
            p_form_date       => v_form_date,
            p_description     => v_description,
            p_pm_email        => v_pm_email,
            p_pm_name         => v_pm_name,
            p_js_email        => v_js_email,
            p_cmd_email       => v_cmd_email,
            p_afc_email       => v_afc_email,
            p_dist_list_email => v_dist_list_email,

            p_message_type    => p_message_type,
            p_message_text    => p_message_text
        );

        --For Distribution list's info
        sp_process_mail_for_queue(
            p_person_id       => p_person_id,
            p_meta_id         => p_meta_id,

            p_projno          => p_projno,
            p_process_name    => c_send_mail_on_afc_approval,
            p_subject         => c_approved_by_afc_subject,
            p_phase           => v_phase,
            p_short_desc      => v_short_desc,
            p_comp_desc       => v_comp_desc,
            p_form_mode_desc  => v_form_mode_desc,
            p_revision        => v_revision,
            p_form_date       => v_form_date,
            p_description     => v_description,
            p_pm_email        => v_pm_email,
            p_pm_name         => v_pm_name,
            p_js_email        => v_js_email,
            p_cmd_email       => v_cmd_email,
            p_afc_email       => v_afc_email,
            p_dist_list_email => v_dist_list_email,

            p_message_type    => p_message_type,
            p_message_text    => p_message_text
        );

    Exception
        When Others Then
            p_message_type := c_not_ok;
            p_message_text := 'Err - ' || sqlcode || ' - ' || sqlerrm;
    End send_mail_on_afc_approval;

    Procedure sp_process_mail_for_queue(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_projno           Varchar2,
        p_process_name     Varchar2,
        p_subject          Varchar2,
        p_phase            Varchar2,
        p_short_desc       Varchar2,
        p_comp_desc        Varchar2,
        p_form_mode_desc   Varchar2,
        p_revision         Varchar2,
        p_form_date        Date,
        p_description      Varchar2,
        p_pm_email         Varchar2,
        p_pm_name          Varchar2,
        p_js_email         Varchar2,
        p_cmd_email        Varchar2,
        p_afc_email        Varchar2,
        p_dist_list_email  Varchar2,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_subject  Varchar2(1000);
        v_msg_body Varchar2(2000);
        v_success  Varchar2(1000);
        v_message  Varchar2(500);
        v_empno    Varchar2(5);
        v_mail_to  Varchar2(4000);
    Begin
        If v_empno = 'ERRRR' Then
            p_message_type := c_not_ok;
            p_message_text := 'Not authorized';
            Return;
        End If;

        v_subject      := 'JOB FORM : ' || p_form_mode_desc || ' : Job - ' || p_projno || ' - ' || p_subject;

        v_msg_body     := fn_get_mail_body(p_projno,
                                           p_phase,
                                           p_pm_name,
                                           p_form_date,
                                           p_form_mode_desc,
                                           p_short_desc,
                                           p_comp_desc,
                                           p_description,
                                           p_process_name);

        If p_process_name = c_send_mail_on_erp_pm_approval Then
            v_mail_to := p_js_email;
        Elsif p_process_name = c_send_mail_on_js_approval Then
            v_mail_to := p_cmd_email;
        Elsif p_process_name = c_send_mail_on_js_review Then
            v_mail_to := p_pm_email;
        Elsif p_process_name = c_send_mail_on_cmd_approval Then
            v_mail_to := p_afc_email;
        Elsif p_process_name = c_send_mail_on_afc_approval Then
            v_mail_to := p_dist_list_email;
        Elsif p_process_name In (c_approved_by_js_subject, c_review_by_js_subject, c_approved_by_cmd_subject, c_approved_by_afc_subject) Then
            v_mail_to := p_pm_email;
        End If;

        tcmpl_app_config.pkg_app_mail_queue.sp_add_to_queue(
            p_person_id    => Null,
            p_meta_id      => Null,
            p_mail_to      => v_mail_to,
            p_mail_cc      => Null,
            p_mail_bcc     => Null,
            p_mail_subject => v_subject,
            p_mail_body1   => v_msg_body,
            p_mail_body2   => Null,
            p_mail_type    => 'HTML',
            p_mail_from    => c_mail_from,
            p_message_type => v_success,
            p_message_text => v_message
        );

        p_message_type := c_ok;
        p_message_text := 'Procedure executed successfully.';

    Exception
        When Others Then
            p_message_type := c_not_ok;
            p_message_text := 'Err - ' || sqlcode || ' - ' || sqlerrm;
    End sp_process_mail_for_queue;

    Procedure sp_get_job_attributes(
        p_person_id           Varchar2,
        p_meta_id             Varchar2,

        p_projno              Varchar2,
        p_phase           Out Varchar2,
        p_short_desc      Out Varchar2,
        p_comp_desc       Out Varchar2,
        p_form_mode_desc  Out Varchar2,
        p_revision        Out Number,
        p_form_date       Out Date,
        p_description     Out Varchar2,
        p_pm_email        Out Varchar2,
        p_pm_name         Out Varchar2,
        p_js_email        Out Varchar2,
        p_cmd_email       Out Varchar2,
        p_afc_email       Out Varchar2,
        p_dist_list_email Out Varchar2,
        p_process_name        Varchar2,

        p_message_type    Out Varchar2,
        p_message_text    Out Varchar2
    ) As
        v_empno             Varchar2(5);
        v_js_empno          Varchar2(5);
        v_job_mode_status   jobmaster.job_mode_status%Type;
        v_dist_list_email   Varchar2(1000);
    Begin
        v_empno        := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            p_message_type := c_not_ok;
            p_message_text := 'Not authorized';
            Return;
        End If;

        Select
            jm.phase,
            jm.short_desc,
            Case jm.co
                When 'T' Then
                    'Tecnimont Pvt. Ltd'
                When 'E' Then
                    'Engineering and Designs Tecnimont ICB  Pvt. Ltd'
            End comp_desc,
            Case
                When jm.job_mode_status In ('C2','C3','CC') Then
                    'Closing of Existing Job'
                When jm.revision = 0 Then
                    'Creation of New Job'
                Else
                    'Modification of Existing Job'
            End form_mode,
            jm.revision,
            jm.form_date,
            jm.description,
            jm.dirvp_empno,
            e.email,
            e.name,
            jm.job_mode_status
        Into
            p_phase,
            p_short_desc,
            p_comp_desc,
            p_form_mode_desc,
            p_revision,
            p_form_date,
            p_description,
            v_js_empno,
            p_pm_email,
            p_pm_name,
            v_job_mode_status
        From
            jobmaster jm,
            emplmast  e
        Where
            jm.pm_empno   = e.empno
            And jm.projno = Trim(p_projno);

        If p_process_name = c_send_mail_on_erp_pm_approval And v_js_empno Is Not Null Then
            Select
                email
            Into
                p_js_email
            From
                emplmast
            Where
                empno = Trim(v_js_empno);
        End If;

        If p_process_name = c_send_mail_on_js_approval Then
            Select
                Listagg(email, ';') Within
                    Group (Order By
                        email)
            Into
                p_cmd_email
            From
                (
                    Select
                        e.email email
                    From
                        emplmast                       e,
                        job_responsible_roles_defaults jrrd
                    Where
                        e.empno                     = jrrd.empno
                        And job_responsible_role_id = c_r10
                );
        End If;
        
        If p_process_name = c_send_mail_on_js_review Then
            Select
                Listagg(email, ';') Within
                    Group (Order By
                        email)
            Into
                p_pm_email
            From
                (
                    Select
                        e.email email
                    From
                        emplmast            e,
                        jobmaster           jm
                    Where
                        e.empno             = jm.pm_empno
                        And jm.projno       = p_projno
                );
        End If;

        If p_process_name = c_send_mail_on_cmd_approval Then
            Select
                Listagg(email, ';') Within
                    Group (Order By
                        email)
            Into
                p_afc_email
            From
                (
                    Select
                        e.email email
                    From
                        emplmast                       e,
                        job_responsible_roles_defaults jrrd
                    Where
                        e.empno                     = jrrd.empno
                        And job_responsible_role_id = c_r11
                );
        End If;

        If p_process_name = c_send_mail_on_afc_approval Then
            Select
                Listagg(email, ';') Within
                    Group (Order By
                        email)
            Into
                p_dist_list_email
            From
                (
                    Select
                        e.email email
                    From
                        emplmast              e,
                        job_responsible_roles jrr
                    Where
                        e.empno     = jrr.empno
                        And projno5 = Trim(p_projno)
                    Union
                    Select
                        e.email email
                    From
                        emplmast                       e,
                        job_responsible_roles_defaults jrrd
                    Where
                        e.empno = jrrd.empno
                    Union

                    Select
                        e.email email
                    From
                        emplmast                e,
                        costmast                c,
                        job_mail_list_costcodes jmlc
                    Where
                        e.empno         = c.hod
                        And e.assign    = c.costcode
                        And c.costcode  = jmlc.costcode
                        And jmlc.projno = Trim(p_projno)
                );
            
            --To notify AFC to manage job in SAP             
            Begin
                Select
                    Listagg(e.email, ';') Within
                        Group (Order By
                            e.email)
                Into
                    v_dist_list_email
                From
                    emplmast                e,
                    job_responsible_notify  jrn
                Where
                    jrn.empno         = e.empno
                    And jrn.job_responsible_role_id = c_r13
                    And jrn.isactive = 1;
                    
                If v_dist_list_email Is Not Null Then
                    p_dist_list_email := p_dist_list_email || ';' || v_dist_list_email;
                End If;
            
            Exception
                When Others Then
                    Null;
            End;
            
        End If;

        p_message_type := c_ok;
        p_message_text := 'Procedure executed successfully.';

    Exception
        When Others Then
            p_message_type := c_not_ok;
            p_message_text := 'Err - ' || sqlcode || ' - ' || sqlerrm;
    End sp_get_job_attributes;

    Function fn_get_mail_body(p_projno       Varchar2,
                              p_phase        Varchar2,
                              p_pm_name      Varchar2,
                              p_form_date    Varchar2,
                              p_purpose      Varchar2,
                              p_short_desc   Varchar2,
                              p_comp_desc    Varchar2,
                              p_description  Varchar2,
                              p_process_name Varchar2) Return Varchar2 Is
        v_msg_body Varchar2(4000);
    Begin

        If p_process_name In (c_send_mail_on_erp_pm_approval, c_send_mail_on_js_approval, c_send_mail_on_cmd_approval, c_send_mail_on_afc_approval) Then
            v_msg_body := '<p>Dear Sir,</p><br />';
            v_msg_body := v_msg_body || '<p>This is to inform you that job form has been created by ' || p_pm_name;
            If p_purpose = 'Creation of New Job' Then
                v_msg_body := v_msg_body || ' on ' || p_form_date;
            End If;
            v_msg_body := v_msg_body || ' for ' || p_purpose || ' and ';
            Case p_process_name
                When c_send_mail_on_erp_pm_approval Then
                    v_msg_body := v_msg_body || 'Waiting for Job Incharge Approval.';
                When c_send_mail_on_js_approval Then
                    v_msg_body := v_msg_body || 'Waiting for MD''s approval.';
                When c_send_mail_on_cmd_approval Then
                    v_msg_body := v_msg_body || 'Waiting for Final Approval from AFC.';
                When c_send_mail_on_afc_approval Then
                    v_msg_body := v_msg_body || 'Final Approval completed from AFC.';
            End Case;
            v_msg_body := v_msg_body || '</p>';

        Elsif p_process_name In (c_approved_by_js_subject, c_approved_by_cmd_subject, c_approved_by_afc_subject) Then
            v_msg_body := '<p>Dear Sir,</p><br />';
            v_msg_body := v_msg_body || '<p>The job form, which has been created by you';
            If p_purpose = 'Creation of New Job' Then
                v_msg_body := v_msg_body || ' on ' || p_form_date;
            End If;
            v_msg_body := v_msg_body || ' for ' || p_purpose || ' and ';
            Case p_process_name
                When c_approved_by_js_subject Then
                    v_msg_body := v_msg_body || 'now it is approved by Job Incharge and Waiting for MD''s Approval';
                When c_approved_by_cmd_subject Then
                    v_msg_body := v_msg_body || 'now it is approved by MD and Waiting for AFC''s Approval';
                When c_approved_by_afc_subject Then
                    v_msg_body := v_msg_body || 'now it has been approved by AFC.';
            End Case;
            v_msg_body := v_msg_body || '</p>';
            
        Elsif p_process_name In (c_review_by_js_subject) Then
            v_msg_body := '<p>Dear '|| p_pm_name ||',</p><br />';
            v_msg_body := v_msg_body || '<p>The job form, which has been created by you';
            If p_purpose = 'Creation of New Job' Then
                v_msg_body := v_msg_body || ' on ' || p_form_date;
            End If;
            v_msg_body := v_msg_body || ' is reverted back for your review.';  
            
            v_msg_body := v_msg_body || '</p>';
            
        End If;

        v_msg_body := v_msg_body || '<br /><p>Job Info as follows</p>';
        v_msg_body := v_msg_body || '<table style="border-collapse: collapse;width:75%; max-width:500px;" border="0"><tbody>';
        v_msg_body := v_msg_body || '<tr><td>Job No      : </td><td>' || p_projno || ' [ Phase : ' || p_phase || ' ]</td></tr>';
        v_msg_body := v_msg_body || '<tr><td>Job Name    : </td><td>' || p_short_desc ||' </td></tr>';
        v_msg_body := v_msg_body || '<tr><td>Job Company : </td><td>' || p_comp_desc ||' </td></tr>';
        v_msg_body := v_msg_body || '<tr><td>Description : </td><td>' || p_description ||' </td></tr></tbody></table><br /><br />';
        v_msg_body := v_msg_body || '<p>Thanks. <br /><br />This is an auto-generated mail. Please do not reply to this mail.</p>';

        Return v_msg_body;
    End fn_get_mail_body;

End iot_jobs_mail;
/
Grant Execute On "TIMECURR"."IOT_JOBS_MAIL" To "TCMPL_APP_CONFIG";