Create Or Replace Package Body tcmpl_hr.pkg_dg_mail As
    --c_module_id Constant Char(3) := '';
    Procedure prc_get_mail_receipients(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_key_id           Varchar2,
        p_email_stage      Varchar2,

        p_email_to     Out Varchar2,
        p_email_cc     Out Varchar2,
        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_transfer_type_fk dg_mid_transfer_costcode.transfer_type_fk%Type;
        v_by_empno         Varchar2(5);
    Begin
        v_by_empno := get_empno_from_meta_id(p_meta_id);
        If v_by_empno = 'ERRRR' Then
            p_message_type := not_ok;
            p_message_text := 'Invalid employee number';
            Return;
        End If;
        --source
        If p_email_stage = c_costcode_change_initiated Then
            Select
                transfer_type_fk
            Into
                v_transfer_type_fk
            From
                dg_mid_transfer_costcode
            Where
                key_id = Trim(p_key_id);

            If v_transfer_type_fk = 2 Then
                --Payroll
                Select
                    Listagg(email, ';') Within
                        Group (Order By
                            email)
                Into
                    p_email_to
                From
                    (
                        Select
                            e.email
                        From
                            dg_vu_module_user_role_actions dvmura,
                            vu_emplmast                    e
                        Where
                            e.empno              = dvmura.empno
                            And dvmura.action_id = 'A213'
                    );
            Else
                --Target
                Select
                    Listagg(email, ';') Within
                        Group (Order By
                            email)
                Into
                    p_email_to
                From
                    (
                        Select
                            e.email
                        From
                            dg_mid_transfer_costcode       dmtc,
                            dg_vu_module_user_role_actions dvmura,
                            vu_emplmast                    e
                        Where
                            dvmura.costcode      = dmtc.target_costcode
                            And e.empno          = dvmura.empno
                            And dmtc.key_id      = Trim(p_key_id)
                            And dvmura.action_id = 'A247'
                    );
            End If;

            --User
            Select
                e.email
            Into
                p_email_cc
            From
                dg_mid_transfer_costcode dmtc,
                vu_emplmast              e
            Where
                e.empno         = dmtc.emp_no
                And dmtc.key_id = Trim(p_key_id);

            p_message_type := ok;
            p_message_text := 'Success';
            Return;
        End If;

        --Target
        If p_email_stage = c_costcode_approved_by_target_hod Then
            --Payroll
            Select
                Listagg(email, ';') Within
                    Group (Order By
                        email)
            Into
                p_email_to
            From
                (
                    Select
                        e.email
                    From
                        dg_vu_module_user_role_actions dvmura,
                        vu_emplmast                    e
                    Where
                        e.empno              = dvmura.empno
                        And dvmura.action_id = 'A213'
                );

            --User
            Select
                e.email
            Into
                p_email_cc
            From
                dg_mid_transfer_costcode dmtc,
                vu_emplmast              e
            Where
                e.empno         = dmtc.emp_no
                And dmtc.key_id = Trim(p_key_id);

            p_message_type := ok;
            p_message_text := 'Success';
            Return;
        Elsif p_email_stage = c_costcode_rejected_by_target_hod Then
            --Source
            Select
                Listagg(email, ';') Within
                    Group (Order By
                        email)
            Into
                p_email_to
            From
                (
                    Select
                        e.email
                    From
                        dg_mid_transfer_costcode       dmtc,
                        dg_vu_module_user_role_actions dvmura,
                        vu_emplmast                    e
                    Where
                        dvmura.costcode      = dmtc.current_costcode
                        And e.empno          = dvmura.empno
                        And dmtc.key_id      = Trim(p_key_id)
                        And dvmura.action_id = 'A246'
                );

            --User
            Select
                e.email
            Into
                p_email_cc
            From
                dg_mid_transfer_costcode dmtc,
                vu_emplmast              e
            Where
                e.empno         = dmtc.emp_no
                And dmtc.key_id = Trim(p_key_id);

            p_message_type := ok;
            p_message_text := 'Success';
            Return;
        End If;

        --Payroll
        If p_email_stage = c_costcode_approved_by_payroll Then
            Select
                transfer_type_fk
            Into
                v_transfer_type_fk
            From
                dg_mid_transfer_costcode
            Where
                key_id = Trim(p_key_id);

            If v_transfer_type_fk = 0 Then
                --HR
                Select
                    Listagg(email, ';') Within
                        Group (Order By
                            email)
                Into
                    p_email_to
                From
                    (
                        Select
                            e.email
                        From
                            dg_vu_module_user_role_actions dvmura,
                            vu_emplmast                    e
                        Where
                            e.empno              = dvmura.empno
                            And dvmura.action_id = 'A226'
                    );
            Else
                Select
                    Listagg(email, ';') Within
                        Group (Order By
                            email)
                Into
                    p_email_to
                From
                    (
                        Select
                            e.email
                        From
                            dg_vu_module_user_role_actions dvmura,
                            vu_emplmast                    e
                        Where
                            e.empno = dvmura.empno
                            And dvmura.action_id In ('A226', 'A248')

                        Union

                        Select
                            e.email
                        From
                            dg_mid_transfer_costcode       dmtc,
                            dg_vu_module_user_role_actions dvmura,
                            vu_emplmast                    e
                        Where
                            dvmura.costcode      = dmtc.target_costcode
                            And e.empno          = dvmura.empno
                            And dmtc.key_id      = Trim(p_key_id)
                            And dvmura.action_id = 'A247'

                        Union

                        Select
                            e.email
                        From
                            dg_mid_transfer_costcode       dmtc,
                            dg_vu_module_user_role_actions dvmura,
                            vu_emplmast                    e
                        Where
                            dvmura.costcode      = dmtc.current_costcode
                            And e.empno          = dvmura.empno
                            And dmtc.key_id      = Trim(p_key_id)
                            And dvmura.action_id = 'A246'
                    );

            End If;
            --User
            Select
                e.email
            Into
                p_email_cc
            From
                dg_mid_transfer_costcode dmtc,
                vu_emplmast              e
            Where
                e.empno         = dmtc.emp_no
                And dmtc.key_id = Trim(p_key_id);

            p_message_type := ok;
            p_message_text := 'Success';
            Return;
        Elsif p_email_stage = c_costcode_rejected_by_payroll Then
            --Target & source
            Select
                Listagg(email, ';') Within
                    Group (Order By
                        email)
            Into
                p_email_to
            From
                (
                    Select
                        e.email
                    From
                        dg_mid_transfer_costcode       dmtc,
                        dg_vu_module_user_role_actions dvmura,
                        vu_emplmast                    e
                    Where
                        dvmura.costcode      = dmtc.target_costcode
                        And e.empno          = dvmura.empno
                        And dmtc.key_id      = Trim(p_key_id)
                        And dvmura.action_id = 'A247'

                    Union

                    Select
                        e.email
                    From
                        dg_mid_transfer_costcode       dmtc,
                        dg_vu_module_user_role_actions dvmura,
                        vu_emplmast                    e
                    Where
                        dvmura.costcode      = dmtc.current_costcode
                        And e.empno          = dvmura.empno
                        And dmtc.key_id      = Trim(p_key_id)
                        And dvmura.action_id = 'A246'
                );

            --User
            Select
                e.email
            Into
                p_email_cc
            From
                dg_mid_transfer_costcode dmtc,
                vu_emplmast              e
            Where
                e.empno         = dmtc.emp_no
                And dmtc.key_id = Trim(p_key_id);

            p_message_type := ok;
            p_message_text := 'Success';
            Return;
        End If;

        --HR
        If p_email_stage = c_costcode_approved_by_hr Then
            --Payroll, Target & Source
            Select
                Listagg(email, ';') Within
                    Group (Order By
                        email)
            Into
                p_email_to
            From
                (
                    Select
                        e.email
                    From
                        dg_vu_module_user_role_actions dvmura,
                        vu_emplmast                    e
                    Where
                        e.empno = dvmura.empno
                        And dvmura.action_id In ('A213', 'A248')

                    Union

                    Select
                        e.email
                    From
                        dg_mid_transfer_costcode       dmtc,
                        dg_vu_module_user_role_actions dvmura,
                        vu_emplmast                    e
                    Where
                        dvmura.costcode      = dmtc.target_costcode
                        And e.empno          = dvmura.empno
                        And dmtc.key_id      = Trim(p_key_id)
                        And dvmura.action_id = 'A247'

                    Union

                    Select
                        e.email
                    From
                        dg_mid_transfer_costcode       dmtc,
                        dg_vu_module_user_role_actions dvmura,
                        vu_emplmast                    e
                    Where
                        dvmura.costcode      = dmtc.current_costcode
                        And e.empno          = dvmura.empno
                        And dmtc.key_id      = Trim(p_key_id)
                        And dvmura.action_id = 'A246'
                );

            --User
            Select
                e.email
            Into
                p_email_cc
            From
                dg_mid_transfer_costcode dmtc,
                vu_emplmast              e
            Where
                e.empno         = dmtc.emp_no
                And dmtc.key_id = Trim(p_key_id);

            p_message_type := ok;
            p_message_text := 'Success';
            Return;

        Elsif p_email_stage = c_costcode_rejected_by_hr Then

            Select
                Listagg(email, ';') Within
                    Group (Order By
                        email)
            Into
                p_email_to
            From
                (
                    Select
                        e.email
                    From
                        dg_vu_module_user_role_actions dvmura,
                        vu_emplmast                    e
                    Where
                        e.empno              = dvmura.empno
                        And dvmura.action_id = 'A213'

                    Union

                    Select
                        e.email
                    From
                        dg_mid_transfer_costcode       dmtc,
                        dg_vu_module_user_role_actions dvmura,
                        vu_emplmast                    e
                    Where
                        dvmura.costcode      = dmtc.target_costcode
                        And e.empno          = dvmura.empno
                        And dmtc.key_id      = Trim(p_key_id)
                        And dvmura.action_id = 'A247'

                    Union

                    Select
                        e.email
                    From
                        dg_mid_transfer_costcode       dmtc,
                        dg_vu_module_user_role_actions dvmura,
                        vu_emplmast                    e
                    Where
                        dvmura.costcode      = dmtc.current_costcode
                        And e.empno          = dvmura.empno
                        And dmtc.key_id      = Trim(p_key_id)
                        And dvmura.action_id = 'A246'
                );

            --User
            Select
                e.email
            Into
                p_email_cc
            From
                dg_mid_transfer_costcode dmtc,
                vu_emplmast              e
            Where
                e.empno         = dmtc.emp_no
                And dmtc.key_id = Trim(p_key_id);

            p_message_type := ok;
            p_message_text := 'Success';
            Return;
        End If;

        --Extension
        If p_email_stage = c_costcode_extension Then
            --Payroll, HR & Source & HR Sec (R098)
            Select
                Listagg(email, ';') Within
                    Group (Order By
                        email)
            Into
                p_email_to
            From
                (
                    Select
                        e.email
                    From
                        dg_vu_module_user_role_actions dvmura,
                        vu_emplmast                    e
                    Where
                        e.empno = dvmura.empno
                        And dvmura.action_id In ('A213', 'A226', 'A248')

                    Union

                    Select
                        e.email
                    From
                        dg_mid_transfer_costcode       dmtc,
                        dg_vu_module_user_role_actions dvmura,
                        vu_emplmast                    e
                    Where
                        dvmura.costcode      = dmtc.current_costcode
                        And e.empno          = dvmura.empno
                        And dmtc.key_id      = Trim(p_key_id)
                        And dvmura.action_id = 'A246'
                );

            --User
            Select
                e.email
            Into
                p_email_cc
            From
                dg_mid_transfer_costcode dmtc,
                vu_emplmast              e
            Where
                e.empno         = dmtc.emp_no
                And dmtc.key_id = Trim(p_key_id);

            p_message_type := ok;
            p_message_text := 'Success';
            Return;

        End If;

    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
    End;

    Procedure sp_send_reminder_mid_term_pending_hod As

        Cursor cur_mid_term_hod_pending Is
            Select
                group_id,
                Listagg(user_email, ';') Within
                    Group (Order By
                        empno) email_csv_list
            From
                (
                    Select
                        empno,
                        name                                           employee_name,
                        replace(email, ',', '.')                       user_email,
                        ceil((Row_Number() Over(Order By empno)) / 50) group_id
                    From
                        (
                            Select
                                vu_emp.emp_hod                                  empno,
                                email,
                                name,
                                Row_Number() Over(Order By vu_emp.emp_hod Desc) row_number,
                                Count(*) Over()                                 total_row
                            From
                                vu_emplmast vu_emp
                            Where
                                empno In (
                                    Select
                                        a.emp_hod
                                    From
                                        vu_emplmast                       a
                                        Left Outer Join dg_mid_evaluation b
                                        On a.empno = b.empno
                                    Where
                                        a.status                        = 1
                                        And a.emptype                   = 'R'
                                        And nvl(b.hod_approval, not_ok) = not_ok
                                        And
                                        (a.doj >= ((To_Date('2023-07-3', 'yyyy-MM-dd'))) And
                                            add_months(a.doj, 3) <= trunc(sysdate))
                                        And a.grade In (
                                            Select
                                                grade
                                            From
                                                dg_mid_evaluation_grade c
                                        )
                                )
                        )
                    Where
                        empno Not In ('04132', '04600')
                    Order By empno
                )
            Group By
                group_id;
        --

        Type typ_tab_cur_mid_term_hod_pending Is Table Of cur_mid_term_hod_pending%rowtype;
        tab_mid_term_hod_pending typ_tab_cur_mid_term_hod_pending;
        v_count                  Number;
        v_mail_csv               Varchar2(2000);
        v_subject                Varchar2(1000);
        v_msg_body               Varchar2(2000);
        v_success                Varchar2(1000);
        v_message                Varchar2(500);
    Begin

        v_msg_body := '

<p>Dear HOD,</p>

<p>Mid-term Progress Evaluation of Trainee(s) for your department is available / pending in the system.</p>


<p>Please complete it at the earliest.</p>

';
        v_subject  := 'DIGI : Mid-term Progress Evaluation of Trainees';
        For email_csv_row In cur_mid_term_hod_pending
        Loop
            v_mail_csv := email_csv_row.email_csv_list;
            tcmpl_app_config.pkg_app_mail_queue.sp_add_to_queue(
                p_person_id    => Null,
                p_meta_id      => Null,
                p_mail_to      => Null,
                p_mail_cc      => Null,
                p_mail_bcc     => v_mail_csv,
                p_mail_subject => v_subject,
                p_mail_body1   => v_msg_body,
                p_mail_body2   => Null,
                p_mail_type    => 'HTML',
                p_mail_from    => 'DIGI',
                p_message_type => v_success,
                p_message_text => v_message
            );
        End Loop;
    End;

    Procedure sp_costcode_change_email(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,
        p_key_id           Varchar2,
        p_email_stage      Number,
        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_by_empno               Varchar2(5);
        v_count                  Number;
        v_mail_to                Varchar2(2000);
        v_mail_cc                Varchar2(2000);
        v_mail_csv               Varchar2(2000);
        v_subject                Varchar2(1000);
        v_msg_body               Varchar2(9990);
        v_success                Varchar2(1000);
        v_message                Varchar2(500);
        v_transfer_type_val      Varchar2(1000);
        v_transfer_type_text     Varchar2(1000);
        v_emp_no                 Varchar2(1000);
        v_emp_name               Varchar2(1000);
        v_current_costcode_val   Varchar2(1000);
        v_current_costcode_text  Varchar2(1000);
        v_target_costcode_val    Varchar2(1000);
        v_target_costcode_text   Varchar2(1000);
        v_transfer_date          Date;
        v_transfer_end_date      Date;
        v_remarks                Varchar2(1000);
        v_status_val             Varchar2(1000);
        v_status_text            Varchar2(1000);
        v_effective_transfer_dat Date;
        v_desgcode_val           Varchar2(1000);
        v_desgcode_text          Varchar2(1000);
        v_site_code              Varchar2(1000);
        v_job_group_code         Varchar2(1000);
        v_job_group              Varchar2(1000);
        v_jobdiscipline_code     Varchar2(1000);
        v_jobdiscipline          Varchar2(1000);
        v_jobtitle_code          Varchar2(1000);
        v_jobtitle               Varchar2(1000);
        v_modified_on            Date;
        v_modified_by            Varchar2(1000);
        v_target_hod_remarks     Varchar2(1000);
        v_hr_remarks             Varchar2(1000);
        v_hr_hod_remarks         Varchar2(1000);
        v_desgcode_new           Varchar2(1000);
        v_desg_new               Varchar2(1000);
        v_revised_designation    Varchar2(1000);
        v_job_group_code_new     Varchar2(1000);
        v_job_group_new          Varchar2(1000);
        v_jobdiscipline_code_new Varchar2(1000);
        v_jobdiscipline_new      Varchar2(1000);
        v_jobtitle_code_new      Varchar2(1000);
        v_jobtitle_new           Varchar2(1000);
        v_site_name              Varchar2(1000);
        v_site_location          Varchar2(1000);
        v_message_type           Varchar2(2);
        v_message_text           Varchar2(1000);
    Begin
        v_by_empno     := get_empno_from_meta_id(p_meta_id);
        If v_by_empno = 'ERRRR' Then
            --p_message_type := not_ok;
            --p_message_text := 'Invalid employee number';
            tcmpl_app_config.task_scheduler.sp_log_success(p_proc_name => 'sp_costcode_change_email', p_business_name => 'sp_costcode_change_email',
                                                           p_message => 'Invalid employee number');

            Return;
        End If;
        /*
          If commonmasters.pkg_environment.is_development = ok Or commonmasters.pkg_environment.is_staging = ok Then
             --p_message_type := ok;
             --p_message_text := 'Success';
             null;
         Elsif commonmasters.pkg_environment.is_production = ok Then
             --p_message_type := not_ok;
             --p_message_text := 'Error...';
             return;
         End If;
         */

        pkg_dg_mid_transfer_costcode_qry.sp_dg_mid_transfer_costcode_details(
            p_person_id               => p_person_id,
            p_meta_id                 => p_meta_id,
            p_key_id                  => p_key_id,
            p_transfer_type_val       => v_transfer_type_val,
            p_transfer_type_text      => v_transfer_type_text,
            p_emp_no                  => v_emp_no,
            p_emp_name                => v_emp_name,
            p_current_costcode_val    => v_current_costcode_val,
            p_current_costcode_text   => v_current_costcode_text,
            p_target_costcode_val     => v_target_costcode_val,
            p_target_costcode_text    => v_target_costcode_text,
            p_transfer_date           => v_transfer_date,
            p_transfer_end_date       => v_transfer_end_date,
            p_remarks                 => v_remarks,
            p_status_val              => v_status_val,
            p_status_text             => v_status_text,
            p_effective_transfer_date => v_effective_transfer_dat,
            p_desgcode_val            => v_desgcode_val,
            p_desgcode_text           => v_desgcode_text,
            p_site_code               => v_site_code,
            p_job_group_code          => v_job_group_code,
            p_job_group               => v_job_group,
            p_jobdiscipline_code      => v_jobdiscipline_code,
            p_jobdiscipline           => v_jobdiscipline,
            p_jobtitle_code           => v_jobtitle_code,
            p_jobtitle                => v_jobtitle,
            p_modified_on             => v_modified_on,
            p_modified_by             => v_modified_by,
            p_target_hod_remarks      => v_target_hod_remarks,
            p_hr_remarks              => v_hr_remarks,
            p_hr_hod_remarks          => v_hr_hod_remarks,
            p_desgcode_new            => v_desgcode_new,
            p_desg_new                => v_desg_new,
            p_job_group_code_new      => v_job_group_code_new,
            p_job_group_new           => v_job_group_new,
            p_jobdiscipline_code_new  => v_jobdiscipline_code_new,
            p_jobdiscipline_new       => v_jobdiscipline_new,
            p_jobtitle_code_new       => v_jobtitle_code_new,
            p_jobtitle_new            => v_jobtitle_new,
            p_site_name               => v_site_name,
            p_site_location           => v_site_location,
            p_message_type            => v_message_type,
            p_message_text            => v_message_text
        );

        If v_message_type = not_ok Then
            Return;
        End If;
        -- Action taken by Target Hod (Approved / Reject) Step 2
        If p_email_stage = c_costcode_change_initiated Then
            -- CostCode change Request initiated from Source Hod :-  Step 1

            v_mail_csv := '';
            v_subject  := 'DIGI : CostCode Change Request';
            v_msg_body := c_costcode_change_initiated_msg_body;
            v_msg_body := replace(v_msg_body, '[EMPLOYEE]', v_emp_no || ' - ' || v_emp_name);
            v_msg_body := replace(v_msg_body, '[TRANSFERTYPE]', v_transfer_type_text);
            v_msg_body := replace(v_msg_body, '[CURRENTCOSTCODE]', v_current_costcode_val || '-' || v_current_costcode_text);
            v_msg_body := replace(v_msg_body, '[TARGETCOSTCODE]', v_target_costcode_val || '-' || v_target_costcode_text);
            v_msg_body := replace(v_msg_body, '[TRANSFERTRAVELDATE]', to_char(v_transfer_date, 'dd-Mon-yyyy'));
            v_msg_body := replace(v_msg_body, '[REMARKS]', trim(v_remarks));
        End If;
        -- End -- Action taken by Target Hod (Approved / Reject) Step 2

        -- Action taken by payroll (Approved / Reject) Step 3
        If p_email_stage = c_costcode_approved_by_target_hod Then
            -- Approved  Step 2.1

            v_mail_csv := '';
            v_subject  := 'DIGI : CostCode Change Request - costcode Approved by target hod';
            v_msg_body := c_costcode_approved_by_target_hod_msg_body;
            v_msg_body := replace(v_msg_body, '[EMPLOYEE]', v_emp_no || ' - ' || v_emp_name);
            v_msg_body := replace(v_msg_body, '[TRANSFERTYPE]', v_transfer_type_text);
            v_msg_body := replace(v_msg_body, '[CURRENTCOSTCODE]', v_current_costcode_val || '-' || v_current_costcode_text);
            v_msg_body := replace(v_msg_body, '[TARGETCOSTCODE]', v_target_costcode_val || '-' || v_target_costcode_text);
            v_msg_body := replace(v_msg_body, '[TRANSFERTRAVELDATE]', to_char(v_transfer_date, 'dd-Mon-yyyy'));
            v_msg_body := replace(v_msg_body, '[REMARKS]', trim(v_target_hod_remarks));
        End If;

        If p_email_stage = c_costcode_rejected_by_target_hod Then
            -- Reject Step 2.2

            v_mail_csv := '';
            v_subject  := 'DIGI : CostCode Change Request - costcode Rejected by target hod';
            v_msg_body := c_costcode_rejected_by_target_hod_msg_body;
            v_msg_body := replace(v_msg_body, '[EMPLOYEE]', v_emp_no || ' - ' || v_emp_name);
            v_msg_body := replace(v_msg_body, '[TRANSFERTYPE]', v_transfer_type_text);
            v_msg_body := replace(v_msg_body, '[CURRENTCOSTCODE]', v_current_costcode_val || '-' || v_current_costcode_text);
            v_msg_body := replace(v_msg_body, '[TARGETCOSTCODE]', v_target_costcode_val || '-' || v_target_costcode_text);
            v_msg_body := replace(v_msg_body, '[TRANSFERTRAVELDATE]', to_char(v_transfer_date, 'dd-Mon-yyyy'));
            v_msg_body := replace(v_msg_body, '[REMARKS]', trim(v_target_hod_remarks));
        End If;

        -- End Action taken by payroll (Approved / Reject) Step 3

        -- Action taken by payroll (Approved / Reject) Step 3

        If p_email_stage = c_costcode_approved_by_payroll Then
            -- Approved  Step 3.1

            v_mail_csv := '';
            v_subject  := 'DIGI : CostCode Change Request - costcode Approved by payroll';
            v_msg_body := c_costcode_approved_by_payrol_msg_body;
            v_msg_body := replace(v_msg_body, '[EMPLOYEE]', v_emp_no || ' - ' || v_emp_name);
            v_msg_body := replace(v_msg_body, '[TRANSFERTYPE]', v_transfer_type_text);
            v_msg_body := replace(v_msg_body, '[CURRENTCOSTCODE]', v_current_costcode_val || '-' || v_current_costcode_text);
            v_msg_body := replace(v_msg_body, '[TARGETCOSTCODE]', v_target_costcode_val || '-' || v_target_costcode_text);
            v_msg_body := replace(v_msg_body, '[TRANSFERTRAVELDATE]', to_char(v_transfer_date, 'dd-Mon-yyyy'));
            v_msg_body := replace(v_msg_body, '[REMARKS]', trim(v_hr_hod_remarks));
        End If;

        If p_email_stage = c_costcode_rejected_by_payroll Then
            -- Reject Step 3.2
             If v_desg_new Is Not Null Then
                v_revised_designation := v_desg_new || ' - ' || v_desgcode_new;
            End If;

            v_mail_csv := '';
            v_subject  := 'DIGI : CostCode Change Request - costcode Rejected by payroll';
            v_msg_body := c_costcode_approved_by_hr_msg_body;
            v_msg_body := replace(v_msg_body, '[EMPLOYEE]', '(' ||v_emp_no || ') ' || v_emp_name);
            v_msg_body := replace(v_msg_body, '[TRANSFERTYPE]', v_transfer_type_text);
            v_msg_body := replace(v_msg_body, '[CURRENTCOSTCODE]', v_current_costcode_val || '-' || v_current_costcode_text);
            v_msg_body := replace(v_msg_body, '[TARGETCOSTCODE]', v_target_costcode_val || '-' || v_target_costcode_text);
            v_msg_body := replace(v_msg_body, '[TRANSFERTRAVELDATE]', to_char(v_transfer_date, 'dd-Mon-yyyy'));

            If v_desg_new Is Not Null Then
                v_revised_designation := v_desg_new || ' - ' || v_desgcode_new;
                v_msg_body            := replace(v_msg_body, '[REVISEDDESIGNATION]', v_revised_designation);
            Else
                v_msg_body := replace(v_msg_body, 'IS_DISPLAY', 'none');
            End If;

            v_msg_body := replace(v_msg_body, '[REMARKS]', trim(v_hr_remarks));
            
           /*
            v_mail_csv := '';
            v_subject  := 'DIGI : CostCode Change Request - costcode Rejected by payroll';
            v_msg_body := c_costcode_rejected_by_payrol_msg_body;
            v_msg_body := replace(v_msg_body, '[EMPLOYEE]', v_emp_no || ' - ' || v_emp_name);
            v_msg_body := replace(v_msg_body, '[TRANSFERTYPE]', v_transfer_type_text);
            v_msg_body := replace(v_msg_body, '[CURRENTCOSTCODE]', v_current_costcode_val || '-' || v_current_costcode_text);
            v_msg_body := replace(v_msg_body, '[TARGETCOSTCODE]', v_target_costcode_val || '-' || v_target_costcode_text);
            v_msg_body := replace(v_msg_body, '[TRANSFERTRAVELDATE]', to_char(v_transfer_date, 'dd-Mon-yyyy'));
            v_msg_body := replace(v_msg_body, '[REMARKS]', trim(v_hr_hod_remarks));
           */
        End If;

        If p_email_stage = c_costcode_extension Then
            -- Approved with modification Step 3.3

            v_mail_csv := '';
            v_subject  := 'DIGI : CostCode Change Request - Extention';
            v_msg_body := c_costcode_extention_msg_body;
            v_msg_body := replace(v_msg_body, '[EMPLOYEE]', v_emp_no || ' - ' || v_emp_name);
            v_msg_body := replace(v_msg_body, '[TRANSFERTYPE]', v_transfer_type_text);
            v_msg_body := replace(v_msg_body, '[CURRENTCOSTCODE]', v_current_costcode_val || '-' || v_current_costcode_text);
            v_msg_body := replace(v_msg_body, '[TARGETCOSTCODE]', v_target_costcode_val || '-' || v_target_costcode_text);
            v_msg_body := replace(v_msg_body, '[TRANSFERTRAVELDATE]', to_char(v_transfer_date, 'dd-Mon-yyyy'));
            v_msg_body := replace(v_msg_body, '[REMARKS]', trim(v_hr_hod_remarks));
        End If;

        -- End Action taken by payroll (Approved / Reject) Step 3

        -- Action HR (Nitin/Balaji) Step 4

        If p_email_stage = c_costcode_approved_by_hr Then
            -- Approved  Step 4.1
            If v_desg_new Is Not Null Then
                v_revised_designation := v_desg_new || ' - ' || v_desgcode_new;
            End If;

            v_mail_csv := '';
            v_subject  := 'DIGI : Cost Code Change Intimation';
            v_msg_body := c_costcode_approved_by_hr_msg_body;
            v_msg_body := replace(v_msg_body, '[EMPLOYEE]', '(' ||v_emp_no || ') ' || v_emp_name);
            v_msg_body := replace(v_msg_body, '[TRANSFERTYPE]', v_transfer_type_text);
            v_msg_body := replace(v_msg_body, '[CURRENTCOSTCODE]', v_current_costcode_val || '-' || v_current_costcode_text);
            v_msg_body := replace(v_msg_body, '[TARGETCOSTCODE]', v_target_costcode_val || '-' || v_target_costcode_text);
            v_msg_body := replace(v_msg_body, '[TRANSFERTRAVELDATE]', to_char(v_transfer_date, 'dd-Mon-yyyy'));

            If v_desg_new Is Not Null Then
                v_revised_designation := v_desg_new || ' - ' || v_desgcode_new;
                v_msg_body            := replace(v_msg_body, '[REVISEDDESIGNATION]', v_revised_designation);
            Else
                v_msg_body := replace(v_msg_body, 'IS_DISPLAY', 'none');
            End If;

            v_msg_body := replace(v_msg_body, '[REMARKS]', trim(v_hr_remarks));
        End If;

        If p_email_stage = c_costcode_rejected_by_hr Then
            -- Reject Step 4.2

            If v_desg_new Is Not Null Then
                v_revised_designation := v_desg_new || ' - ' || v_desgcode_new;
            End If;

            v_mail_csv := '';
            v_subject  := 'DIGI : Cost Code Change Intimation - Rejected by HR';
            v_msg_body := c_costcode_rejected_by_hr_msg_body;
            v_msg_body := replace(v_msg_body, '[EMPLOYEE]', '(' ||v_emp_no || ') ' || v_emp_name);
            v_msg_body := replace(v_msg_body, '[TRANSFERTYPE]', v_transfer_type_text);
            v_msg_body := replace(v_msg_body, '[CURRENTCOSTCODE]', v_current_costcode_val || '-' || v_current_costcode_text);
            v_msg_body := replace(v_msg_body, '[TARGETCOSTCODE]', v_target_costcode_val || '-' || v_target_costcode_text);
            v_msg_body := replace(v_msg_body, '[TRANSFERTRAVELDATE]', to_char(v_transfer_date, 'dd-Mon-yyyy'));

            If v_desg_new Is Not Null Then
                v_revised_designation := v_desg_new || ' - ' || v_desgcode_new;
                v_msg_body            := replace(v_msg_body, '[REVISEDDESIGNATION]', v_revised_designation);
            Else
                v_msg_body := replace(v_msg_body, 'IS_DISPLAY', 'none');
            End If;

            v_msg_body := replace(v_msg_body, '[REMARKS]', trim(v_hr_remarks));

        /*
         v_mail_csv := '';
                    v_subject  := 'DIGI : CostCode Change Request - costcode Rejected by HR';
                    v_msg_body := c_costcode_rejected_by_hr_msg_body;
                    v_msg_body := replace(v_msg_body, '[EMPLOYEE]', v_emp_no || ' - ' || v_emp_name);
                    v_msg_body := replace(v_msg_body, '[TRANSFERTYPE]', v_transfer_type_text);
                    v_msg_body := replace(v_msg_body, '[CURRENTCOSTCODE]', v_current_costcode_val || '-' || v_current_costcode_text);
                    v_msg_body := replace(v_msg_body, '[TARGETCOSTCODE]', v_target_costcode_val || '-' || v_target_costcode_text);
                    v_msg_body := replace(v_msg_body, '[TRANSFERTRAVELDATE]', to_char(v_transfer_date, 'dd-Mon-yyyy'));
                    v_msg_body := replace(v_msg_body, '[REMARKS]', trim(v_hr_remarks));
        */

        End If;

        -- End Action HR (Nitin/Balaji) Step 4

        --v_mail_csv := '';
        -- Send Mail and Log

         If p_email_stage = c_costcode_approved_by_hr
            or p_email_stage = c_costcode_rejected_by_hr
            or p_email_stage = c_costcode_rejected_by_payroll Then

          pkg_dg_mail.prc_get_mail_receipients(
            p_person_id    => p_person_id,
            p_meta_id      => p_meta_id,
            p_key_id       => p_key_id,
            p_email_stage  => p_email_stage,
            p_email_to     => v_mail_cc,
            p_email_cc     => v_mail_to,
            p_message_type => v_message_type,
            p_message_text => v_message_text
        );
        else

        pkg_dg_mail.prc_get_mail_receipients(
            p_person_id    => p_person_id,
            p_meta_id      => p_meta_id,
            p_key_id       => p_key_id,
            p_email_stage  => p_email_stage,
            p_email_to     => v_mail_to,
            p_email_cc     => v_mail_cc,
            p_message_type => v_message_type,
            p_message_text => v_message_text
        );
        end if;

        If v_message_type = ok Then
            v_msg_body := trim(v_msg_body);
            tcmpl_app_config.pkg_app_mail_queue.sp_add_to_queue(
                p_person_id    => Null,
                p_meta_id      => Null,
                p_mail_to      => v_mail_to,
                p_mail_cc      => v_mail_cc,
                p_mail_bcc     => v_mail_csv,
                p_mail_subject => v_subject,
                p_mail_body1   => v_msg_body,
                p_mail_body2   => Null,
                p_mail_type    => 'HTML',
                p_mail_from    => 'DIGI',
                p_message_type => v_success,
                p_message_text => v_message
            );

        End If;

        Insert Into dg_mail_log (
            mail_to,
            mail_from,
            mail_cc,
            mail_bcc,
            mail_success,
            mail_success_message,
            mail_date
        )
        Values (
            v_mail_to,
            Null,
            v_mail_cc,
            Null,
            v_success,
            v_message,
            sysdate
        );

        Commit;

        p_message_type := ok;
        p_message_text := ok;
    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
    End;

    Procedure sp_send_reminder_annual_evaluation_pending_hod As

        Cursor cur_annual_evaluation_hod_pending Is
            Select
                group_id,
                Listagg(user_email, ';') Within
                    Group (Order By
                        empno) email_csv_list
            From
                (
                    Select
                        empno,
                        name                                           employee_name,
                        replace(email, ',', '.')                       user_email,
                        ceil((Row_Number() Over(Order By empno)) / 50) group_id
                    From
                        (
                            Select
                                vu_emp.emp_hod                                  empno,
                                email,
                                name,
                                Row_Number() Over(Order By vu_emp.emp_hod Desc) row_number,
                                Count(*) Over()                                 total_row
                            From
                                vu_emplmast vu_emp
                            Where
                                empno In (
                                    Select
                                        a.emp_hod
                                    From
                                        vu_emplmast                        a
                                        Left Outer Join dg_annu_evaluation b
                                        On a.empno = b.empno
                                    Where
                                        a.status                        = 1
                                        And a.emptype                   = 'R'
                                        And nvl(b.hod_approval, not_ok) = not_ok
                                        And
                                        (a.doj >= ((To_Date('2023-07-3', 'yyyy-MM-dd'))) And
                                            (add_months(a.doj, 10) + 15) <= trunc(sysdate))
                                        And a.grade In (
                                            Select
                                                grade
                                            From
                                                dg_mid_evaluation_grade c
                                        )
                                )
                        )
                    Where
                        empno Not In ('04132', '04600')
                    Order By empno
                )
            Group By
                group_id;
        --

        Type typ_tab_cur_annual_evaluation_hod_pending Is Table Of cur_annual_evaluation_hod_pending%rowtype;
        tab_annual_evaluation_hod_pending typ_tab_cur_annual_evaluation_hod_pending;
        v_count                           Number;
        v_mail_csv                        Varchar2(2000);
        v_subject                         Varchar2(1000);
        v_msg_body                        Varchar2(2000);
        v_success                         Varchar2(1000);
        v_message                         Varchar2(500);
    Begin

        v_msg_body := '

<p>Dear HOD,</p>

<p>Annual evaluation Progress Evaluation of Trainee(s) for your department is available / pending in the system.</p>


<p>Please complete it at the earliest.</p>

';
        v_subject  := 'DIGI : Annual evaluation Progress Evaluation of Trainees';
        For email_csv_row In cur_annual_evaluation_hod_pending
        Loop
            v_mail_csv := email_csv_row.email_csv_list;
            tcmpl_app_config.pkg_app_mail_queue.sp_add_to_queue(
                p_person_id    => Null,
                p_meta_id      => Null,
                p_mail_to      => Null,
                p_mail_cc      => Null,
                p_mail_bcc     => v_mail_csv,
                p_mail_subject => v_subject,
                p_mail_body1   => v_msg_body,
                p_mail_body2   => Null,
                p_mail_type    => 'HTML',
                p_mail_from    => 'DIGI',
                p_message_type => v_success,
                p_message_text => v_message
            );
        End Loop;
    End;

End pkg_dg_mail;