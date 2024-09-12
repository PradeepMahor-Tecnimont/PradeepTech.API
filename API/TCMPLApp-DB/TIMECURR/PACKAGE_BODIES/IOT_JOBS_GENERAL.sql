Create Or Replace Package Body "TIMECURR"."IOT_JOBS_GENERAL" As

    Function get_employee_name(
        p_empno Varchar2
    ) Return Varchar2 As
        v_name Varchar2(35);
    Begin
        Select
            name
        Into
            v_name
        From
            emplmast
        Where
            Trim(empno) = Trim(p_empno);

        Return v_name;
    Exception
        When Others Then
            Return Null;
    End get_employee_name;

    Function get_status_name(
        p_status Varchar2
    ) Return Varchar2 As
        v_status_name Varchar2(10);
    Begin
        If p_status = '1' Then
            v_status_name := 'Approved';
        Elsif p_status = '0' Then
            v_status_name := 'Pending';
        Else
            v_status_name := '';
        End If;

        Return v_status_name;
    End get_status_name;

    Function get_job_status_name(
        p_code Varchar2
    ) Return Varchar2 As
        v_status_name Varchar2(100);
    Begin
        Select
            status_desc
        Into
            v_status_name
        From
            job_mode_status_mast
        Where
            status_code = p_code;

        Return v_status_name;
    End get_job_status_name;

    Function get_company_name(
        p_company Varchar2
    ) Return Varchar2 As
        v_name Varchar2(40);
    Begin
        Select
            description
        Into
            v_name
        From
            job_co_master
        Where
            Trim(code) = Trim(p_company);

        Return v_name;
    Exception
        When Others Then
            Return Null;
    End get_company_name;

    Function get_country_name(
        p_country Varchar2
    ) Return Varchar2 As
        v_name Varchar2(40);
    Begin
        Select
            country_name
        Into
            v_name
        From
            country_master
        Where
            Trim(country_code) = Trim(p_country);

        Return v_name;
    Exception
        When Others Then
            Return Null;
    End get_country_name;

    Function get_state_name(
        p_loc Varchar2
    ) Return Varchar2 As
        v_name Varchar2(40);
    Begin
        Select
            name
        Into
            v_name
        From
            job_loc
        Where
            Trim(loc) = Trim(p_loc);

        Return v_name;
    Exception
        When Others Then
            Return Null;
    End get_state_name;

    Function get_business_line_name(
        p_code Varchar2
    ) Return Varchar2 As
        v_description Varchar2(100);
    Begin
        Select
            description || ' [ ' || short_description || ' ]'
        Into
            v_description
        From
            business_line
        Where
            Trim(code) = Trim(p_code);

        Return v_description;
    Exception
        When Others Then
            Return Null;
    End get_business_line_name;

    Function get_sub_business_line_name(
        p_code Varchar2
    ) Return Varchar2 As
        v_description Varchar2(100);
    Begin
        Select
            description || ' [ ' || short_description || ' ]'
        Into
            v_description
        From
            sub_business_line
        Where
            Trim(code) = Trim(p_code);

        Return v_description;
    Exception
        When Others Then
            Return Null;
    End get_sub_business_line_name;

    Function get_scope_of_work_name(
        p_code Varchar2
    ) Return Varchar2 As
        v_description Varchar2(100);
    Begin
        Select
            description || ' [ ' || short_description || ' ]'
        Into
            v_description
        From
            scope_of_work
        Where
            Trim(code) = Trim(p_code);

        Return v_description;
    Exception
        When Others Then
            Return Null;
    End get_scope_of_work_name;

    Function get_scope_of_work_short_code(
        p_code Varchar2
    ) Return Varchar2 As
        v_short_desc Varchar2(20);
    Begin
        Select
            short_description
        Into
            v_short_desc
        From
            scope_of_work
        Where
            Trim(code) = Trim(p_code);

        Return v_short_desc;
    Exception
        When Others Then
            Return Null;
    End get_scope_of_work_short_code;

    Function get_plant_type_name(
        p_code Varchar2
    ) Return Varchar2 As
        v_description Varchar2(100);
    Begin
        Select
            description || ' [ ' || short_description || ' ]'
        Into
            v_description
        From
            plant_type
        Where
            Trim(code) = Trim(p_code);

        Return v_description;
    Exception
        When Others Then
            Return Null;
    End get_plant_type_name;

    Function get_job_type_name(
        p_jobtype Varchar2
    ) Return Varchar2 As
        v_name Varchar2(100);
    Begin
        Select
            tmagroupdesc || ' [ ' || tmagroup || ' ]'
        Into
            v_name
        From
            job_tmagroup
        Where
            Trim(tmagroup) = Trim(p_jobtype);

        Return v_name;
    Exception
        When Others Then
            Return Null;
    End get_job_type_name;

    Function get_proj_displayed_as(
        p_projno Varchar2
    ) Return Varchar2 As
        v_name              Varchar2(100);
        v_plant_progress_no Varchar2(100);
        v_location          Varchar2(30);
        v_country           Varchar2(3);
        v_scope_of_work     Varchar2(15);
    Begin
        Select
            plant_progress_no, location, country, scope_of_work
        Into
            v_plant_progress_no, v_location, v_country, v_scope_of_work
        From
            jobmaster
        Where
            projno = p_projno;

        If length(v_plant_progress_no) <> 0 Then
            v_name := v_name || v_plant_progress_no;
        End If;

        If length(v_location) <> 0 Then
            If length(v_name) = 0 Then
                v_name := v_name || v_location;
            Else
                v_name := v_name || ', ' || v_location;
            End If;
        End If;

        If length(v_country) <> 0 Then
            v_name := v_name || ' (' || v_country || ')';
        End If;

        If length(v_scope_of_work) <> 0 Then
            If length(v_name) = 0 Then
                v_name := v_name || v_scope_of_work;
            Else
                v_name := v_name || ', ' || v_scope_of_work;
            End If;
        End If;

        Return v_name;
    Exception
        When Others Then
            Return Null;
    End get_proj_displayed_as;

    Function get_tmagrp_desc(
        p_tmagrp Varchar2
    ) Return Varchar2 As
        v_name job_tmagroup.tmagroupdesc%Type;
    Begin
        Select
            tmagroupdesc
        Into
            v_name
        From
            job_tmagroup
        Where
            tmagroup = p_tmagrp;
            
        Return v_name || ' [ ' || p_tmagrp || ' ]';
        
    Exception
        When Others Then
            Return Null;
    End get_tmagrp_desc;

    Function get_invoicing_grp_name(
        p_tmagrp Varchar2
    ) Return Varchar2 As
        v_code Varchar2(2);
    Begin
        Select
            invoicing_grp
        Into
            v_code
        From
            job_tmagroup
        Where
            tmagroup = p_tmagrp;
        Return v_code;
    Exception
        When Others Then
            Return Null;
    End get_invoicing_grp_name;

    Function get_invoicing_grp_name2(
        p_code Varchar2
    ) Return Varchar2 As
        v_name Varchar2(40);
    Begin
        Select
            description || ' [ ' || code || ' ]'
        Into
            v_name
        From
            invoicing_grp_company
        Where
            code = p_code;
        Return v_name;
    Exception
        When Others Then
            Return Null;
    End get_invoicing_grp_name2;

    Function get_contract_name(
        p_contract Varchar2
    ) Return Varchar2 As
        v_descr Varchar2(35);
    Begin
        Select
            descr || ' [ ' || contract_type || ' ]'
        Into
            v_descr
        From
            job_contract
        Where
            Trim(contract_type) = Trim(p_contract);
        Return v_descr;
    Exception
        When Others Then
            Return Null;
    End get_contract_name;

    Procedure sp_generate_app_config_roles As
    Begin
        tcmpl_app_config.pkg_generate_user_access.sp_jobmaster_generate_access;
        tcmpl_app_config.task_scheduler.sp_log_success(
            p_proc_name     => 'tcmpl_app.config.sp_jobmaster_generate_access',
            p_business_name => 'Generate JOB Master Roles'
        );
    Exception
        When Others Then
            tcmpl_app_config.task_scheduler.sp_log_failure(
                p_proc_name     => 'tcmpl_app.config.sp_jobmaster_generate_access',
                p_business_name => 'Generate JOB Master Roles',
                p_message       => 'Err - ' || sqlcode || ' - ' || sqlerrm
            );

    End;

    Function derive_job_mode_status(
        p_projno Varchar2
    ) Return Varchar2 As
        v_status            Varchar2(2);
        v_approved_vpdir    Number;
        v_approved_dirop    Number;
        v_approved_amfi     Number;
        v_timesheet         Number := 0;
        v_is_active         Number;
        v_closing_date_rev1 jobmaster.closing_date_rev1%Type;
    Begin
    
        -- approval status flags
        Select
            approved_vpdir,
            approved_dirop,
            approved_amfi,
            trunc(nvl(closing_date_rev1, sysdate))
        Into
            v_approved_vpdir,
            v_approved_dirop,
            v_approved_amfi,
            v_closing_date_rev1
        From
            jobmaster
        Where
            projno = p_projno;
       
        -- timesheet booking
        If v_closing_date_rev1 < trunc(sysdate) Then
            v_timesheet := 1;
        End If;
        
        -- is project closed
        Select
            iot_jobs_qry.fn_get_proj_status(p_projno)
        Into
            v_is_active
        From
            dual;               
        
        -- extract job_mode_status

        If v_is_active = 0 Then
            v_status := 'CC';
            Return v_status;
        End If;

        If v_approved_vpdir Is Null Then
            v_status := 'M1';
            Return v_status;
        End If;

        If v_approved_vpdir = 0 Then
            v_status := 'M2';
            Return v_status;
        End If;

        If v_approved_vpdir = 1 And (v_approved_dirop = 0 Or v_approved_amfi = 0) Then
            v_status := 'M3';
            Return v_status;
        End If;

        If v_approved_vpdir = 1 And v_approved_dirop = 1 And v_approved_amfi = 1 Then
            If v_timesheet = 1 Then
                v_status := 'O2';
            Else
                v_status := 'O1';
            End If;
            Return v_status;
        End If;

        Return v_status;
    Exception
        When Others Then
            Return Null;
    End derive_job_mode_status;

    Procedure sp_client_create(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_client_name      Varchar2,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_empno  Varchar2(5);
        v_client clntmast.client%Type;
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);

        If v_empno = 'ERRRR' Then
            p_message_type := not_ok;
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        Begin
            Select
                client
            Into
                v_client
            From
                clntmast
            Where
                upper(name) = upper(Trim(p_client_name));

            p_message_type := not_ok;
            p_message_text := 'Client already existing.';
            Return;

        Exception
            When no_data_found Then
                Select
                    to_char(Max(To_Number(substr(client, 2))))
                Into
                    v_client
                From
                    clntmast
                Where
                    upper(name) Like substr(upper(Trim(p_client_name)), 1, 1) || '%'
                    And client != substr(upper(Trim(p_client_name)), 1, 1) || '99999';

                If v_client Is Null Then
                    v_client := substr(upper(trim(p_client_name)), 1, 1) || '00001';
                Else
                    v_client := substr(upper(trim(p_client_name)), 1, 1) || lpad(to_char(To_Number(v_client) + 1), 5, '0');
                End If;

                Insert Into clntmast
                (
                    client,
                    name
                )
                Values
                (
                    v_client,
                    Trim(p_client_name)
                );
                Commit;
                p_message_type := ok;
                p_message_text := 'Procedure executed successfully.';
        End;
    Exception
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;

    End sp_client_create;

End iot_jobs_general;
/
Grant Execute On "TIMECURR"."IOT_JOBS_GENERAL" To "TCMPL_APP_CONFIG";