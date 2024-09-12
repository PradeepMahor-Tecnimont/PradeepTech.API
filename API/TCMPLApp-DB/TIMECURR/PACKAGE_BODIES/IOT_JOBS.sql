Create Or Replace Package Body "TIMECURR"."IOT_JOBS" As

    Procedure proc_update_pm_js_projmast(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,
        
        p_projno           Varchar2,
        p_role_name        Varchar2,
        p_pm_empno         Varchar2,
        p_js_empno         Varchar2,
        
        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As        
        v_empno  Varchar2(5);
    Begin
        v_empno        := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERROR' Then
            p_message_type := c_not_ok;
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        If p_role_name = 'JS' Then
            Update
                projmast
            Set
                prjmngr = p_pm_empno
            Where
                Substr(projno,1,5) = Trim(p_projno);        
        ElsIf p_role_name = 'PM' Then
            Update
                projmast
            Set
                prjdymngr = p_js_empno
            Where
                Substr(projno,1,5) = Trim(p_projno);
        End If;

        p_message_type := c_ok;
        p_message_text := p_message_type;
    Exception
        When Others Then
            Rollback;
            p_message_type := c_not_ok;
            p_message_text := 'Err - ' || sqlcode || ' - ' || sqlerrm;
    End proc_update_pm_js_projmast;

    Procedure sp_add_job(
        p_person_id         Varchar2,
        p_meta_id           Varchar2,
        p_projno            Varchar2,
        p_revision          Number   Default 0,
        p_form_date         Date,
        p_company           Varchar2,
        p_job_type          Varchar2,
        p_is_consortium     Number   Default 0,
        p_tcmno             Varchar2 Default Null,
        p_plant_progress_no Varchar2,
        p_place             Varchar2,
        p_country           Varchar2,
        p_state             Varchar2 Default Null,
        p_scope_of_work     Varchar2,
        p_plant_type        Varchar2,
        p_business_line     Varchar2,
        p_sub_business_line Varchar2,
        p_client_name       Varchar2,
        p_contract_number   Varchar2,
        p_contract_date     Date     Default Null,
        p_start_date        Date,
        p_rev_close_date    Date     Default Null,
        p_exp_close_date    Date,
        p_actual_close_date Date     Default Null,
        p_initiate_approval Number,
        p_pm_empno          Varchar2 Default Null,
        p_message_type Out  Varchar2,
        p_message_text Out  Varchar2
    ) As
        v_exists     Number        := 0;
        v_empno      Varchar2(5);
        v_status     Varchar2(2)   := 'M1';
        v_short_desc Varchar2(200) := '';
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERROR' Then
            p_message_type := c_not_ok;
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        If length(trim(p_plant_progress_no)) > 0 Then
            v_short_desc := v_short_desc || p_plant_progress_no;
        End If;

        If length(trim(p_place)) > 0 Then
            If length(trim(v_short_desc)) = 0 Then
                v_short_desc := trim(v_short_desc) || p_place;
            Else
                v_short_desc := v_short_desc || ', ' || p_place;
            End If;
        End If;

        If length(trim(p_country)) > 0 Then
            v_short_desc := v_short_desc || ' (' || p_country || ')';
        End If;

        If length(trim(p_scope_of_work)) > 0 Then
            If length(v_short_desc) = 0 Then
                v_short_desc := trim(v_short_desc)
                                || iot_jobs_general.get_scope_of_work_short_code(p_scope_of_work);
            Else
                v_short_desc := v_short_desc
                                || ', '
                                || iot_jobs_general.get_scope_of_work_short_code(p_scope_of_work);
            End If;
        End If;

        Select
            Count(*)
        Into
            v_exists
        From
            jobmaster
        Where
            Trim(projno) = p_projno
            And phase    = '00';

        If v_exists = 0 Then
            Insert Into jobmaster (
                projno,
                phase,
                revision,
                form_date,
                company,
                type_of_job,
                consortium_group,
                tcmno,
                plant_progress_no,
                location,
                country,
                loc,
                scope_of_work,
                plant_type,
                business_line,
                sub_business_line,
                client_name,
                loi_contract_no,
                loi_contract_date,
                job_open_date,
                closing_date_rev1,
                expected_closing_date,
                actual_closing_date,
                job_mode_status,
                short_desc,
                invoicing_grp_company,
                approved_vpdir,
                approved_dirop,
                approved_amfi
            )
            Values (
                p_projno,
                '00',
                p_revision,
                p_form_date,
                p_company,
                p_job_type,
                p_is_consortium,
                p_tcmno,
                upper(p_plant_progress_no),
                upper(p_place),
                p_country,
                p_state,
                p_scope_of_work,
                p_plant_type,
                p_business_line,
                p_sub_business_line,
                p_client_name,
                p_contract_number,
                p_contract_date,
                p_start_date,
                p_exp_close_date,
                p_exp_close_date,
                p_actual_close_date,
                v_status,
                upper(substr(v_short_desc, 1, 35)),
                iot_jobs_general.get_invoicing_grp_name(p_job_type),
                0,
                0,
                0
            );
            p_message_type := c_ok;
            p_message_text := 'Job added successfully';
            iot_jobs_responsible_roles.sp_add_responsible_roles(
                p_person_id    => p_person_id,
                p_meta_id      => p_meta_id,
                p_projno       => p_projno,
                p_erp_pm_empno => p_pm_empno,
                p_message_type => p_message_type,
                p_message_text => p_message_text
            );

            iot_jobs_mail_list.sp_insert_mail_list(
                p_person_id    => p_person_id,
                p_meta_id      => p_meta_id,
                p_projno       => p_projno,
                p_tmagroup     => p_job_type,
                p_message_type => p_message_type,
                p_message_text => p_message_text
            );
        Else
            p_message_type := c_not_ok;
            p_message_text := 'Job already exists';
        End If;
        Commit;
    Exception
        When Others Then
            p_message_type := c_not_ok;
            p_message_text := 'Err - ' || sqlcode || ' - ' || sqlerrm;
    End sp_add_job;

    Procedure sp_edit_job(
        p_person_id         Varchar2,
        p_meta_id           Varchar2,
        p_projno            Varchar2,
        p_revision          Number,
        p_form_date         Date,
        p_company           Varchar2,
        p_job_type          Varchar2,
        p_is_consortium     Number,
        p_tcmno             Varchar2,
        p_plant_progress_no Varchar2 Default Null,
        p_place             Varchar2 Default Null,
        p_country           Varchar2 Default Null,
        p_state             Varchar2 Default Null,
        p_scope_of_work     Varchar2 Default Null,
        p_plant_type        Varchar2,
        p_business_line     Varchar2,
        p_sub_business_line Varchar2,
        p_client_name       Varchar2,
        p_contract_number   Varchar2,
        p_contract_date     Date     Default Null,
        p_start_date        Date,
        p_rev_close_date    Date     Default Null,
        p_exp_close_date    Date,        
        p_initiate_approval Number,
        p_message_type Out  Varchar2,
        p_message_text Out  Varchar2
    ) As
        v_exists     Number        := 0;
        v_empno      Varchar2(5);
        v_status     Varchar2(2)   := 'M1';
        v_short_desc Varchar2(200) := '';
        rec_job      jobmaster%rowtype;
        v_r10_empno job_responsible_roles_defaults.empno%type;
        v_r11_empno job_responsible_roles_defaults.empno%type;
    Begin
        v_empno        := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERROR' Then
            p_message_type := c_not_ok;
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        Select
            *
        Into
            rec_job
        From
            jobmaster
        Where
            Trim(projno) = Trim(p_projno)
            And phase    = '00';

        If length(trim(p_plant_progress_no)) > 0 Then
            v_short_desc := v_short_desc || p_plant_progress_no;
        End If;

        If length(trim(p_place)) > 0 Then
            If length(trim(v_short_desc)) = 0 Then
                v_short_desc := trim(v_short_desc) || p_place;
            Else
                v_short_desc := v_short_desc || ', ' || p_place;
            End If;
        End If;

        If length(trim(p_country)) > 0 Then
            v_short_desc := v_short_desc || ' (' || p_country || ')';
        End If;

        If length(trim(p_scope_of_work)) > 0 Then
            If length(v_short_desc) = 0 Then
                v_short_desc := trim(v_short_desc)
                                || iot_jobs_general.get_scope_of_work_short_code(p_scope_of_work);
            Else
                v_short_desc := v_short_desc
                                || ', '
                                || iot_jobs_general.get_scope_of_work_short_code(p_scope_of_work);
            End If;
        End If;

        If nvl(rec_job.is_legacy, 0) = 1 Then
            v_short_desc := rec_job.short_desc;
        End If;
        
        Select empno Into v_r10_empno From job_responsible_roles_defaults
            Where job_responsible_role_id = 'R10';
            
        Select empno Into v_r11_empno From job_responsible_roles_defaults
            Where job_responsible_role_id = 'R11';   

        If p_revision = 0 Then
            Update
                jobmaster
            Set
                revision = p_revision,
                form_date = p_form_date,
                company = p_company,
                type_of_job = p_job_type,
                consortium_group = p_is_consortium,
                tcmno = p_tcmno,
                plant_progress_no = upper(p_plant_progress_no),
                location = upper(p_place),
                country = p_country,
                loc = p_state,
                scope_of_work = p_scope_of_work,
                plant_type = p_plant_type,
                business_line = p_business_line,
                sub_business_line = p_sub_business_line,
                client_name = p_client_name,
                loi_contract_no = p_contract_number,
                loi_contract_date = p_contract_date,
                job_open_date = p_start_date,
                closing_date_rev1 = p_exp_close_date,
                expected_closing_date = p_exp_close_date,                
                job_mode_status = v_status,
                short_desc = upper(substr(v_short_desc, 1, 35)),
                approved_vpdir = 0,
                approved_dirop = 0,
                approved_amfi = 0,
                appdt_vpdir = Null,
                appdt_dirop = Null,                
                dirop_empno = v_r10_empno,
                appdt_amfi = Null,
                amfi_empno = v_r11_empno
            Where
                Trim(projno) = Trim(p_projno)
                And phase    = '00';
        Else
            Update
                jobmaster
            Set
                revision = p_revision,
                form_date = p_form_date,
                company = p_company,
                type_of_job = p_job_type,
                consortium_group = p_is_consortium,
                tcmno = p_tcmno,
                plant_type = p_plant_type,
                business_line = p_business_line,
                sub_business_line = p_sub_business_line,
                client_name = p_client_name,
                loi_contract_no = p_contract_number,
                loi_contract_date = p_contract_date,
                job_open_date = p_start_date,
                closing_date_rev1 = p_exp_close_date,
                expected_closing_date = p_exp_close_date,                
                job_mode_status = v_status,
                approved_vpdir = 0,
                approved_dirop = 0,
                approved_amfi = 0,
                appdt_vpdir = Null,
                appdt_dirop = Null,                
                dirop_empno = v_r10_empno,
                appdt_amfi = Null,
                amfi_empno = v_r11_empno
            Where
                Trim(projno) = Trim(p_projno)
                And phase    = '00';
        End If;

        iot_jobs_mail_list.sp_modify_mail_list(
            p_person_id    => p_person_id,
            p_meta_id      => p_meta_id,
            p_projno       => p_projno,
            p_tmagroup     => p_job_type,
            p_message_type => p_message_type,
            p_message_text => p_message_text
        );

        p_message_type := c_ok;
        p_message_text := 'Job updated successfully';
        Commit;
    Exception
        When Others Then
            p_message_type := c_not_ok;
            p_message_text := 'Err - ' || sqlcode || ' - ' || sqlerrm;
    End sp_edit_job;

    Procedure sp_revise_job(
        p_person_id         Varchar2,
        p_meta_id           Varchar2,
        p_projno            Varchar2,
        p_revision          Number,
        p_company           Varchar2,
        p_job_type          Varchar2,
        p_is_consortium     Number,
        p_tcmno             Varchar2,
        /*p_plant_progress_no Varchar2,
        p_place             Varchar2,
        p_country           Varchar2,
        p_state             Varchar2,
        p_scope_of_work     Varchar2,*/
        p_plant_type        Varchar2,
        p_business_line     Varchar2,
        p_sub_business_line Varchar2,
        p_client_name       Varchar2,
        p_contract_number   Varchar2,
        p_contract_date     Date Default Null,
        p_start_date        Date,
        p_rev_close_date    Date,
        p_exp_close_date    Date Default Null,
        p_initiate_approval Number,
        p_message_type Out  Varchar2,
        p_message_text Out  Varchar2
    ) As
        v_exists     Number        := 0;
        v_empno      Varchar2(5);
        v_status     Varchar2(2)   := 'M1';
        v_short_desc Varchar2(200) := '';
        rec_job      jobmaster%rowtype;
        v_r10_empno job_responsible_roles_defaults.empno%type;
        v_r11_empno job_responsible_roles_defaults.empno%type;
    Begin
        v_empno        := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERROR' Then
            p_message_type := c_not_ok;
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        Select
            *
        Into
            rec_job
        From
            jobmaster
        Where
            Trim(projno) = Trim(p_projno)
            And phase    = '00';
        /*
                If length(trim(p_plant_progress_no)) > 0 Then
                    v_short_desc := v_short_desc
                                    || p_plant_progress_no;
                End If;

                If length(trim(p_place)) > 0 Then
                    If length(trim(v_short_desc)) = 0 Then
                        v_short_desc := trim(v_short_desc)
                                        || p_place;
                    Else
                        v_short_desc := v_short_desc
                                        || ', '
                                        || p_place;
                    End If;
                End If;

                If length(trim(p_country)) > 0 Then
                    v_short_desc := v_short_desc
                                    || ' ('
                                    || p_country
                                    || ')';
                End If;

                If length(trim(p_scope_of_work)) > 0 Then
                    If length(v_short_desc) = 0 Then
                        v_short_desc := trim(v_short_desc)
                                        || iot_jobs_general.get_scope_of_work_short_code(p_scope_of_work);
                    Else
                        v_short_desc := v_short_desc
                                        || ', '
                                        || iot_jobs_general.get_scope_of_work_short_code(p_scope_of_work);
                    End If;
                End If;
        */
        If nvl(rec_job.is_legacy, 0) = 1 Then
            v_short_desc := rec_job.short_desc;
        End If;

        Select empno Into v_r10_empno From job_responsible_roles_defaults
            Where job_responsible_role_id = 'R10';
            
        Select empno Into v_r11_empno From job_responsible_roles_defaults
            Where job_responsible_role_id = 'R11';     
            
        iot_jobs_approvals.sp_check_timesheet_booking_revise_job( 
            p_person_id             => p_person_id,
            p_meta_id               => p_meta_id,
            
            p_projno                => p_projno,
            p_revise_closing_date   => p_rev_close_date,
            
            p_message_type          => p_message_type,
            p_message_text          => p_message_text
         );
        If p_message_type = not_ok Then
            p_message_type := p_message_type;
            p_message_text := p_message_text;
            Return;
        End If;
        
        Update
            jobmaster
        Set
            revision = p_revision,
            company = p_company,
            type_of_job = p_job_type,
            consortium_group = p_is_consortium,
            tcmno = p_tcmno,
            --plant_progress_no = upper(p_plant_progress_no),
            --location = upper(p_place),
            --country = p_country,
            --loc = p_state,
            --scope_of_work = p_scope_of_work,
            plant_type = p_plant_type,
            business_line = p_business_line,
            sub_business_line = p_sub_business_line,
            client_name = p_client_name,
            loi_contract_no = p_contract_number,
            loi_contract_date = p_contract_date,
            job_open_date = p_start_date,
            closing_date_rev1 = p_rev_close_date,
            expected_closing_date = p_exp_close_date,            
            job_mode_status = v_status,
            /*short_desc = upper(
                substr(
                    v_short_desc,
                    1,
                    35
                )
            ),*/
            approved_vpdir = 0,
            approved_dirop = 0,
            approved_amfi = 0,
            appdt_vpdir = Null,
            appdt_dirop = Null,
            dirop_empno = v_r10_empno,
            appdt_amfi = Null,
            amfi_empno = v_r11_empno
        Where
            Trim(projno) = Trim(p_projno)
            And phase    = '00';

        p_message_type := c_ok;
        p_message_text := 'Job updated successfully';
        Commit;
    Exception
        When Others Then
            p_message_type := c_not_ok;
            p_message_text := 'Err - ' || sqlcode || ' - ' || sqlerrm;
    End sp_revise_job;

    Procedure sp_update_job(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,
        p_projno           Varchar2,
        p_tcmno            Varchar2,
        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_exists Number := 0;
        v_empno  Varchar2(5);
    Begin
        v_empno        := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERROR' Then
            p_message_type := c_not_ok;
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        Update
            jobmaster
        Set
            tcmno = p_tcmno
        Where
            Trim(projno) = Trim(p_projno)
            And phase    = '00';

        p_message_type := c_ok;
        p_message_text := 'Job updated successfully';
        Commit;
    Exception
        When Others Then
            p_message_type := c_not_ok;
            p_message_text := 'Err - ' || sqlcode || ' - ' || sqlerrm;
    End sp_update_job;

    Procedure sp_pm_js_detail(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,
        p_projno           Varchar2,
        p_pm_empno     Out Varchar2,
        p_js_empno     Out Varchar2,
        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
    Begin
        Select
            pm_empno,
            dirvp_empno
        Into
            p_pm_empno,
            p_js_empno
        From
            jobmaster
        Where
            Trim(projno) = Trim(p_projno);

        p_message_type := c_ok;
        p_message_text := 'Procedure executed successfully.';
    Exception
        When Others Then
            p_message_type := c_not_ok;
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
    End sp_pm_js_detail;

    Procedure sp_update_pm_js(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,
        p_projno           Varchar2,
        p_role_name        Varchar2,
        p_pm_empno         Varchar2,
        p_js_empno         Varchar2,
        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_exists Number := 0;
        v_empno  Varchar2(5);
        v_role_name Char(2);
    Begin
        v_empno        := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERROR' Then
            p_message_type := c_not_ok;
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        If p_role_name = 'JS' Then
            Update
                jobmaster
            Set
                pm_empno = p_pm_empno
            Where
                Trim(projno) = Trim(p_projno)
                And phase    = '00';

            Update
                job_responsible_roles
            Set
                empno = p_pm_empno,
                modified_by = v_empno,
                modified_on = sysdate
            Where
                job_responsible_role_id = Trim('R01')
                And projno5             = Trim(p_projno);
                
            v_role_name := 'PM';
        ElsIf p_role_name = 'PM' Then
            Update
                jobmaster j
            Set
                dirvp_empno = p_js_empno
            Where
                Trim(projno) = Trim(p_projno)
                And phase    = '00';

            Update
                job_responsible_roles
            Set
                empno = p_js_empno,
                modified_by = v_empno,
                modified_on = sysdate
            Where
                job_responsible_role_id = Trim('R02')
                And projno5             = Trim(p_projno);
                
            v_role_name := 'JS';
        End If;

        proc_update_pm_js_projmast(
            p_person_id        => p_person_id,
            p_meta_id          => p_meta_id,
            
            p_projno           => p_projno,
            p_role_name        => p_role_name,
            p_pm_empno         => p_pm_empno,
            p_js_empno         => p_js_empno,
            
            p_message_type     => p_message_type,
            p_message_text     => p_message_text
        );
        
        If p_message_type = not_ok then
            Rollback;
            Return;
        end if;

        tcmpl_app_config.pkg_generate_user_access.sp_jobmaster_generate_access;

        p_message_type := c_ok;
        p_message_text := v_role_name || ' updated successfully';
        Commit;
    Exception
        When Others Then
            Rollback;
            p_message_type := c_not_ok;
            p_message_text := 'Err - ' || sqlcode || ' - ' || sqlerrm;
    End sp_update_pm_js;

    Procedure sp_update_notes(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,
        p_projno           Varchar2,
        p_description      Varchar2,
        p_notes            Varchar2,
        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_exists Number := 0;
        v_empno  Varchar2(5);
    Begin
        v_empno        := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERROR' Then
            p_message_type := c_not_ok;
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        Update
            jobmaster
        Set
            description = p_description,
            notes = p_notes
        Where
            Trim(projno) = Trim(p_projno);

        p_message_type := c_ok;
        p_message_text := 'Description and Notes updated successfully';
        Commit;
    End sp_update_notes;

    Procedure sp_notes_detail(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,
        p_projno           Varchar2,
        p_description  Out Varchar2,
        p_notes        Out Varchar2,
        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
    Begin
        Select
            description,
            notes
        Into
            p_description,
            p_notes
        From
            jobmaster
        Where
            Trim(projno) = Trim(p_projno);

        p_message_type := c_ok;
        p_message_text := 'Procedure executed successfully.';
    Exception
        When Others Then
            p_message_type := c_not_ok;
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
    End sp_notes_detail;

    Procedure sp_approver_status_detail(
        p_person_id          Varchar2,
        p_meta_id            Varchar2,
        p_projno             Varchar2,
        p_pm_name        Out Varchar2,
        p_pm_apprl_date  Out Date,
        p_js_name        Out Varchar2,
        p_js_status      Out Varchar2,
        p_js_apprl_date  Out Date,
        p_md_name        Out Varchar2,
        p_md_status      Out Varchar2,
        p_md_apprl_date  Out Date,
        p_afc_name       Out Varchar2,
        p_afc_status     Out Varchar2,
        p_afc_apprl_date Out Date,
        p_message_type   Out Varchar2,
        p_message_text   Out Varchar2
    ) As
    Begin
        Select
            iot_jobs_general.get_employee_name(pm_empno),
            iot_jobs_approvals_qry.get_pm_approval_date(p_projno),
            iot_jobs_general.get_employee_name(dirvp_empno),
            iot_jobs_general.get_status_name(approved_vpdir),
            appdt_vpdir,
            iot_jobs_general.get_employee_name(dirop_empno),
            iot_jobs_general.get_status_name(approved_dirop),
            appdt_dirop,
            iot_jobs_general.get_employee_name(amfi_empno),
            iot_jobs_general.get_status_name(approved_amfi),
            appdt_amfi
        Into
            p_pm_name,
            p_pm_apprl_date,
            p_js_name,
            p_js_status,
            p_js_apprl_date,
            p_md_name,
            p_md_status,
            p_md_apprl_date,
            p_afc_name,
            p_afc_status,
            p_afc_apprl_date
        From
            jobmaster
        Where
            Trim(projno) = Trim(p_projno);

        p_message_type := c_ok;
        p_message_text := 'Procedure executed successfully.';
    Exception
        When Others Then
            p_message_type := c_not_ok;
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
    End sp_approver_status_detail;

    Procedure import_job_budget(
        p_person_id         Varchar2,
        p_meta_id           Varchar2,
        p_projno            Varchar2,
        p_openingmonth      Varchar2,
        p_budget            typ_tab_string,
        p_budget_errors Out typ_tab_string,
        p_message_type  Out Varchar2,
        p_message_text  Out Varchar2
    ) As
        v_projno          tp_xls.projno%Type;
        v_phase           tp_xls.phase%Type;
        v_yymm            tp_xls.yymm%Type;
        v_costcode        tp_xls.costcode%Type;
        v_initbudg        tp_xls.initbudg%Type;
        v_revbudg         tp_xls.revbudg%Type;
        v_sessionid       tp_xls.sessionid%Type;
        v_valid_cntr      Number := 0;
        v_exists_tp_excel Number := 0;
        tab_valid_budget  typ_tab_budget;
        v_rec_budget      rec_budget;
        v_err_num         Number;
        is_error_in_row   Boolean;
        v_msg_text        Varchar2(200);
        v_msg_type        Varchar2(10);
        v_count           Number;
    Begin
        v_err_num := 0;
        Select
            sys.dbms_random.string('X', 10)
        Into
            v_sessionid
        From
            dual;

        For i In 1..p_budget.count
        Loop
            is_error_in_row := false;
            With
                csv As (
                    Select
                        p_budget(i) str
                    From
                        dual
                )
            Select
                Trim(regexp_substr(str, '(.*?)(\~!~|$)', 1, 1, Null, 1)) projno,
                Trim(regexp_substr(str, '(.*?)(\~!~|$)', 1, 2, Null, 1)) phase,
                Trim(regexp_substr(str, '(.*?)(\~!~|$)', 1, 3, Null, 1)) yymm,
                Trim(regexp_substr(str, '(.*?)(\~!~|$)', 1, 4, Null, 1)) costcode,
                Trim(regexp_substr(str, '(.*?)(\~!~|$)', 1, 5, Null, 1)) initbudg,
                Trim(regexp_substr(str, '(.*?)(\~!~|$)', 1, 6, Null, 1)) revbudg
            Into
                v_projno,
                v_phase,
                v_yymm,
                v_costcode,
                v_initbudg,
                v_revbudg
            From
                csv;

            -- Projno
            If trim(p_projno) != trim(v_projno) Then
                v_err_num                  := v_err_num + 1;
                p_budget_errors(v_err_num) := v_err_num
                                              || '~!~'
                                              ||       --ID
                                              ''
                                              || '~!~'
                                              ||              --Section
                                              i
                                              || '~!~'
                                              ||               --XL row number
                                              'Projno'
                                              || '~!~'
                                              ||        --FieldName
                                              '0'
                                              || '~!~'
                                              ||             --ErrorType
                                              'Critical'
                                              || '~!~'
                                              ||      --ErrorTypeString
                                              'Projno does not match';    --Message
                is_error_in_row            := true;
            End If;

            -- Phase
            If v_phase Is Null Then
                v_err_num                  := v_err_num + 1;
                p_budget_errors(v_err_num) := v_err_num
                                              || '~!~'
                                              ||       --ID
                                              ''
                                              || '~!~'
                                              ||              --Section
                                              i
                                              || '~!~'
                                              ||               --XL row number
                                              'Phase'
                                              || '~!~'
                                              ||         --FieldName
                                              '0'
                                              || '~!~'
                                              ||             --ErrorType
                                              'Critical'
                                              || '~!~'
                                              ||      --ErrorTypeString
                                              'Phase can not be blank';   --Message
                is_error_in_row            := true;
            End If;

            -- yymm
            If v_yymm Is Null Then
                v_err_num                  := v_err_num + 1;
                p_budget_errors(v_err_num) := v_err_num
                                              || '~!~'
                                              ||       --ID
                                              ''
                                              || '~!~'
                                              ||              --Section
                                              i
                                              || '~!~'
                                              ||               --XL row number
                                              'yymm'
                                              || '~!~'
                                              ||          --FieldName
                                              '0'
                                              || '~!~'
                                              ||             --ErrorType
                                              'Critical'
                                              || '~!~'
                                              ||      --ErrorTypeString
                                              'yymm can not be blank';    --Message
                is_error_in_row            := true;
            End If;

            -- costcode
            If v_costcode Is Null Then
                v_err_num                  := v_err_num + 1;
                p_budget_errors(v_err_num) := v_err_num
                                              || '~!~'
                                              ||           --ID
                                              ''
                                              || '~!~'
                                              ||                  --Section
                                              i
                                              || '~!~'
                                              ||                   --XL row number
                                              'costcode'
                                              || '~!~'
                                              ||          --FieldName
                                              '0'
                                              || '~!~'
                                              ||                 --ErrorType
                                              'Critical'
                                              || '~!~'
                                              ||          --ErrorTypeString
                                              'costcode can not be blank';    --Message
                is_error_in_row            := true;
            Else
                Select
                    Count(*)
                Into
                    v_count
                From
                    deptphase
                Where
                    costcode      = v_costcode
                    And isprimary = 1;
                If v_count = 0 Then
                    v_err_num                  := v_err_num + 1;
                    p_budget_errors(v_err_num) := v_err_num
                                                  || '~!~'
                                                  ||           --ID
                                                  ''
                                                  || '~!~'
                                                  ||                  --Section
                                                  i
                                                  || '~!~'
                                                  ||                   --XL row number
                                                  'costcode'
                                                  || '~!~'
                                                  ||          --FieldName
                                                  '0'
                                                  || '~!~'
                                                  ||                 --ErrorType
                                                  'Critical'
                                                  || '~!~'
                                                  ||          --ErrorTypeString
                                                  'costcode phase doesnot exists';    --Message
                    is_error_in_row            := true;
                End If;
            End If;

            -- initialbudget
            If regexp_like(v_initbudg, '^[0-9]+$') = false Then
                v_err_num                  := v_err_num + 1;
                p_budget_errors(v_err_num) := v_err_num
                                              || '~!~'
                                              ||                   --ID
                                              ''
                                              || '~!~'
                                              ||                          --Section
                                              i
                                              || '~!~'
                                              ||                           --XL row number
                                              'initialbudget'
                                              || '~!~'
                                              ||             --FieldName
                                              '0'
                                              || '~!~'
                                              ||                         --ErrorType
                                              'Critical'
                                              || '~!~'
                                              ||                  --ErrorTypeString
                                              'Initial budget should be integer';     --Message
                is_error_in_row            := true;
            End If;

            -- newbudget
            If regexp_like(v_revbudg, '^[0-9]+$') = false Then
                v_err_num                  := v_err_num + 1;
                p_budget_errors(v_err_num) := v_err_num
                                              || '~!~'
                                              ||               --ID
                                              ''
                                              || '~!~'
                                              ||                      --Section
                                              i
                                              || '~!~'
                                              ||                       --XL row number
                                              'newbudget'
                                              || '~!~'
                                              ||             --FieldName
                                              '0'
                                              || '~!~'
                                              ||                     --ErrorType
                                              'Critical'
                                              || '~!~'
                                              ||              --ErrorTypeString
                                              'New budget should be integer';     --Message
                is_error_in_row            := true;
            End If;

            If is_error_in_row = false Then
                v_valid_cntr                                 := nvl(v_valid_cntr, 0) + 1;
                tab_valid_budget(v_valid_cntr).projno        := v_projno;
                tab_valid_budget(v_valid_cntr).phase         := v_phase;
                tab_valid_budget(v_valid_cntr).yymm          := v_yymm;
                tab_valid_budget(v_valid_cntr).costcode      := v_costcode;
                tab_valid_budget(v_valid_cntr).initialbudget := v_initbudg;
                tab_valid_budget(v_valid_cntr).newbudget     := v_revbudg;
                --tab_valid_budget(v_valid_cntr).sessionid := v_sessionid;
            End If;
        End Loop;

        If v_err_num != 0 Then
            p_message_type := 'OO';
            p_message_text := 'Not all records were imported.';
            Return;
        End If;

        For i In 1..v_valid_cntr
        Loop
            v_exists_tp_excel := 0;
            Select
                Count(*)
            Into
                v_exists_tp_excel
            From
                tp_xls
            Where
                projno              = tab_valid_budget(i).projno
                And phase           = tab_valid_budget(i).phase
                And yymm            = tab_valid_budget(i).yymm
                And costcode        = tab_valid_budget(i).costcode
                And Trim(sessionid) = Trim(v_sessionid);

            If v_exists_tp_excel = 0 Then
                Insert Into tp_xls (
                    projno,
                    phase,
                    yymm,
                    costcode,
                    initbudg,
                    revbudg,
                    sessionid
                )
                Values (
                    tab_valid_budget(i).projno,
                    tab_valid_budget(i).phase,
                    tab_valid_budget(i).yymm,
                    tab_valid_budget(i).costcode,
                    tab_valid_budget(i).initialbudget,
                    tab_valid_budget(i).newbudget,
                    Trim(v_sessionid)
                );
            Else
                Update
                    tp_xls
                Set
                    initbudg = tab_valid_budget(i).initialbudget,
                    revbudg = tab_valid_budget(i).newbudget
                Where
                    projno              = tab_valid_budget(i).projno
                    And phase           = tab_valid_budget(i).phase
                    And yymm            = tab_valid_budget(i).yymm
                    And costcode        = tab_valid_budget(i).costcode
                    And Trim(sessionid) = Trim(v_sessionid);
            End If;
        End Loop;

        Commit;
        iot_jobs.post_import_processing(
            p_projno,
            v_sessionid,
            p_openingmonth
        );
        If v_err_num != 0 Then
            p_message_type := 'OO';
            p_message_text := 'Not all records were imported.';
        Else
            p_message_type := 'OK';
            p_message_text := 'File imported successfully.';
        End If;
    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := sqlcode || ' - ' || sqlerrm;
    End import_job_budget;

    Procedure post_import_processing(
        p_projno       Varchar2,
        p_sessionid    Varchar2,
        p_openingmonth Varchar2
    ) As
        v_projno           Varchar2(5);
        v_phase            Varchar2(2);
        v_sessionid        Varchar2(10);
        v_openingmonth     Varchar2(6);
        i                  Number;
        vartab             typerevbudg;
        v_costcode         Varchar2(4);
        v_revopen          Number;
        v_revbal           Number;
        v_intial           Number;
        v_revise           Number;
        v_balance_col      Number;
        v_budget_exists    Number;
        v_jobbudget_exists Number;
        v_row              Number := 1;
        v_revision_num     Number;
        Cursor cur_costcode(
            c_projno    Varchar2,
            c_sessionid Varchar2
        ) Is
            Select
            Distinct
                costcode
            From
                tp_xls
            Where
                projno              = Trim(c_projno)
                And Trim(sessionid) = Trim(c_sessionid)
            Order By
                costcode;

        Cursor cur_tp_xls(
            c_projno    Varchar2,
            c_sessionid Varchar2
        ) Is
            Select
                projno,
                costcode,
                yymm,
                nvl(initbudg, 0) initbudg,
                nvl(revbudg, 0)  revbudg,
                phase
            From
                tp_xls
            Where
                projno              = v_projno
                And Trim(sessionid) = Trim(v_sessionid)
                And (initbudg <> 0
                    Or revbudg <> 0);

        Type typ_tp_table Is
            Table Of cur_tp_xls%rowtype;
        tp_table           typ_tp_table;
    Begin
        v_projno       := substr(trim(p_projno) || '     ', 1, 5);
        --v_phase  	    := '';
        v_sessionid    := rpad(trim(p_sessionid), 10, ' ');
        v_openingmonth := substr(trim(p_openingmonth) || '     ', 1, 6);
        v_revopen      := 0;
        v_revbal       := 0;

        /* copy excel data (tp_xls) to job_budgtran  (w.r.t. sessionid) */
        /*Delete
            From job_budgtran
        Where
            projno = v_projno;

        Commit;*/

        /*Insert Into job_budgtran (projno, costcode, yymm, initbudg, revbudg, phase)
        Select
            projno, costcode, yymm, nvl(initbudg, 0) initbudg, nvl(revbudg, 0) revbudg, phase
        From
            tp_xls
        Where
            projno              = v_projno
            And Trim(sessionid) = Trim(v_sessionid)
            And (initbudg <> 0 Or revbudg <> 0);*/

        Open cur_tp_xls(v_projno, v_sessionid);
        Loop
            Fetch cur_tp_xls
                Bulk Collect Into tp_table Limit 50;
            For i In 1..tp_table.count
            Loop
                Select
                    Count(*)
                Into
                    v_budget_exists
                From
                    job_budgtran
                Where
                    projno       = tp_table(i).projno
                    And costcode = tp_table(i).costcode
                    And yymm     = tp_table(i).yymm;

                Select
                    revision
                Into
                    v_revision_num
                From
                    jobmaster
                Where
                    projno = tp_table(i).projno;

                If v_budget_exists = 0 Then
                    If v_revision_num = 0 Then
                        Insert Into job_budgtran (
                            projno,
                            costcode,
                            yymm,
                            initbudg,
                            revbudg,
                            phase
                        )
                        Values (
                            tp_table(i).projno,
                            tp_table(i).costcode,
                            tp_table(i).yymm,
                            nvl(tp_table(i).initbudg, 0),
                            nvl(tp_table(i).revbudg, 0),
                            tp_table(i).phase
                        );
                    Else
                        Insert Into job_budgtran (
                            projno,
                            costcode,
                            yymm,
                            revbudg,
                            phase
                        )
                        Values (
                            tp_table(i).projno,
                            tp_table(i).costcode,
                            tp_table(i).yymm,
                            nvl(tp_table(i).revbudg, 0),
                            tp_table(i).phase
                        );
                    End If;
                Else
                    If v_revision_num = 0 Then
                        Update
                            job_budgtran
                        Set
                            initbudg = nvl(tp_table(i).initbudg, 0),
                            revbudg = nvl(tp_table(i).revbudg, 0)
                        Where
                            projno       = tp_table(i).projno
                            And costcode = tp_table(i).costcode
                            And yymm     = tp_table(i).yymm;
                    Else
                        Update
                            job_budgtran
                        Set
                            revbudg = nvl(tp_table(i).revbudg, 0)
                        Where
                            projno       = tp_table(i).projno
                            And costcode = tp_table(i).costcode
                            And yymm     = tp_table(i).yymm;
                    End If;
                End If;
            End Loop;
            Exit When cur_tp_xls%notfound;
        End Loop;

        /*For b1 In (Select
                        projno, costcode, yymm, nvl(initbudg, 0) initbudg, nvl(revbudg, 0) revbudg, phase
                   From
                        tp_xls
                   Where
                        projno              = v_projno
                        And Trim(sessionid) = Trim(v_sessionid)
                        And (initbudg <> 0 Or revbudg <> 0))
        Loop


        End Loop;*/

        Commit;

        /* copy excel data (tp_xls) to jobbudget  (w.r.t. sessionid) */
        /*Delete
            From jobbudget
        Where
            projno = v_projno;
        Commit;*/

        For c1 In cur_costcode(v_projno, v_sessionid)
        Loop
            /* total intial and revised budget */
            Select
                costcode,
                Sum(nvl(initbudg, 0)),
                Sum(nvl(revbudg, 0))
            Into
                v_costcode,
                v_intial,
                v_revise
            From
                tp_xls
            Where
                projno              = v_projno
                And Trim(sessionid) = Trim(v_sessionid)
                And costcode        = c1.costcode
            Group By
                costcode;

            /* opening balance for revised budget */
            Begin
                Select
                    Sum(nvl(revbudg, 0))
                Into
                    v_revopen
                From
                    tp_xls
                Where
                    projno              = v_projno
                    And Trim(sessionid) = Trim(v_sessionid)
                    And yymm < v_openingmonth
                    And costcode        = c1.costcode;
                --Group By
                --    costcode;
                If v_revopen > 0 Then
                    v_revopen := v_revopen;
                End If;
            Exception
                When no_data_found Then
                    v_revopen := 0;
            End;

            /* balance revised budget	*/
            Begin
                Select
                    Sum(nvl(revbudg, 0))
                Into
                    v_revbal
                From
                    (
                        Select
                            a.*,
                            Rownum rnum
                        From
                            tp_xls a
                        Where
                            projno              = v_projno
                            And Trim(sessionid) = Trim(v_sessionid)
                            And yymm >= v_openingmonth
                            And costcode        = c1.costcode
                        Order By rnum Desc
                    )
                Where
                    rnum >= 13
                Group By
                    costcode;
                If v_revbal > 0 Then
                    v_revbal := v_revbal;
                End If;
            Exception
                When no_data_found Then
                    v_revbal := 0;
            End;

            /* budget for 12 months */
            Select
                revbudg
            Bulk Collect
            Into
                vartab
            From
                (
                    Select
                        *
                    From
                        tp_xls
                    Where
                        yymm >= v_openingmonth
                        And costcode        = c1.costcode
                        And projno          = v_projno
                        And Trim(sessionid) = Trim(v_sessionid)
                    Order By costcode,
                        yymm
                )
            Where
                Rownum < 13;

            v_balance_col := 12 - vartab.count;
            If vartab.count < 12 Then
                vartab.extend(12);
            End If;
            If v_balance_col > 0 Then
                For j In 1..v_balance_col
                Loop
                    vartab(12 - j) := 0;
                End Loop;
            End If;

            --If vartab.count < 12 Then
            --    vartab.extend(12 - vartab.count);
            --End If;

            Select
                phase
            Into
                v_phase
            From
                deptphase
            Where
                costcode      = v_costcode
                And isprimary = 1;

            Select
                Count(*)
            Into
                v_jobbudget_exists
            From
                jobbudget
            Where
                projno       = v_projno
                And phase    = v_phase
                And costcode = v_costcode;

            If v_jobbudget_exists = 0 Then
                Insert Into jobbudget (
                    projno,
                    phase,
                    costgrp,
                    costcode,
                    cc,
                    intialbudget,
                    mnth01,
                    mnth02,
                    mnth03,
                    mnth04,
                    mnth05,
                    mnth06,
                    mnth07,
                    mnth08,
                    mnth09,
                    mnth10,
                    mnth11,
                    mnth12,
                    balance,
                    revisedbudget,
                    openbudg
                )
                Values (
                    v_projno,
                    v_phase,
                    '-',
                    v_costcode,
                    '-',
                    v_intial,
                    nvl(vartab(1), 0),
                    nvl(vartab(2), 0),
                    nvl(vartab(3), 0),
                    nvl(vartab(4), 0),
                    nvl(vartab(5), 0),
                    nvl(vartab(6), 0),
                    nvl(vartab(7), 0),
                    nvl(vartab(8), 0),
                    nvl(vartab(9), 0),
                    nvl(vartab(10), 0),
                    nvl(vartab(11), 0),
                    nvl(vartab(12), 0),
                    v_revbal,
                    v_revise,
                    v_revopen
                );
            Else
                Update
                    jobbudget
                Set
                    intialbudget = v_intial,
                    mnth01 = nvl(vartab(1), 0),
                    mnth02 = nvl(vartab(2), 0),
                    mnth03 = nvl(vartab(3), 0),
                    mnth04 = nvl(vartab(4), 0),
                    mnth05 = nvl(vartab(5), 0),
                    mnth06 = nvl(vartab(6), 0),
                    mnth07 = nvl(vartab(7), 0),
                    mnth08 = nvl(vartab(8), 0),
                    mnth09 = nvl(vartab(9), 0),
                    mnth10 = nvl(vartab(10), 0),
                    mnth11 = nvl(vartab(11), 0),
                    mnth12 = nvl(vartab(12), 0),
                    balance = v_revbal,
                    revisedbudget = v_revise,
                    openbudg = v_revopen
                Where
                    projno       = v_projno
                    And phase    = v_phase
                    And costcode = v_costcode;
            End If;

        End Loop;
        Commit;

        /* delete data from temporary tables (w.r.t. sessionid) */
        Delete
            From tp_xls
        Where
            projno              = v_projno
            And Trim(sessionid) = Trim(v_sessionid);
        Commit;
    End post_import_processing;

End iot_jobs;
/
Grant Execute On "TIMECURR"."IOT_JOBS" To "TCMPL_APP_CONFIG";