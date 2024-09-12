Create Or Replace Package Body "TIMECURR"."IOT_JOBS_VALIDATE_STATUS_QRY" As

    Procedure sp_job_form_validate(
        p_person_id                  Varchar2,
        p_meta_id                    Varchar2,

        p_projno                     Varchar2,

        p_desc_notes_type        Out Varchar2,
        p_desc_notes_text        Out Varchar2,
        p_job_phases_type        Out Varchar2,
        p_job_phases_text        Out Varchar2,
        p_responsible_roles_type Out Varchar2,
        p_responsible_roles_text Out Varchar2,
        p_budget_type            Out Varchar2,
        p_budget_text            Out Varchar2,
        p_erp_phases_type        Out Varchar2,
        p_erp_phases_text        Out Varchar2,

        p_message_type           Out Varchar2,
        p_message_text           Out Varchar2
    ) As

    Begin
        sp_desc_notes_validate(
            p_person_id       => p_person_id,
            p_meta_id         => p_meta_id,

            p_projno          => p_projno,

            p_desc_notes_type => p_desc_notes_type,
            p_desc_notes_text => p_desc_notes_text,

            p_message_type    => p_message_type,
            p_message_text    => p_message_text
        );

        sp_job_phases_validate(
            p_person_id       => p_person_id,
            p_meta_id         => p_meta_id,

            p_projno          => p_projno,

            p_job_phases_type => p_job_phases_type,
            p_job_phases_text => p_job_phases_text,

            p_message_type    => p_message_type,
            p_message_text    => p_message_text
        );

        sp_responsible_roles_validate(
            p_person_id              => p_person_id,
            p_meta_id                => p_meta_id,

            p_projno                 => p_projno,

            p_responsible_roles_type => p_responsible_roles_type,
            p_responsible_roles_text => p_responsible_roles_text,

            p_message_type           => p_message_type,
            p_message_text           => p_message_text
        );

        sp_budget_validate(
            p_person_id    => p_person_id,
            p_meta_id      => p_meta_id,

            p_projno       => p_projno,

            p_budget_type  => p_budget_type,
            p_budget_text  => p_budget_text,

            p_message_type => p_message_type,
            p_message_text => p_message_text
        );

        sp_erp_phases_validate(
            p_person_id       => p_person_id,
            p_meta_id         => p_meta_id,

            p_projno          => p_projno,

            p_erp_phases_type => p_erp_phases_type,
            p_erp_phases_text => p_erp_phases_text,

            p_message_type    => p_message_type,
            p_message_text    => p_message_text
        );

        p_message_type := c_ok;
        p_message_text := 'Procedure executed successfully.';
    Exception
        When Others Then
            p_message_type := c_not_ok;
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
    End sp_job_form_validate;

    Procedure sp_desc_notes_validate(
        p_person_id           Varchar2,
        p_meta_id             Varchar2,

        p_projno              Varchar2,

        p_desc_notes_type Out Varchar2,
        p_desc_notes_text Out Varchar2,

        p_message_type    Out Varchar2,
        p_message_text    Out Varchar2
    ) As
        v_description jobmaster.description%Type;
        v_notes       jobmaster.notes%Type;
    Begin
        Select
            description, notes
        Into
            v_description, v_notes
        From
            jobmaster
        Where
            projno = Trim(p_projno);

        If v_description Is Null And v_notes Is Null Then
            p_desc_notes_type := c_not_ok;
            p_desc_notes_text := 'Description and Notes found blank';
        Elsif v_description Is Null Then
            p_desc_notes_type := c_not_ok;
            p_desc_notes_text := 'Description found blank';
        Elsif v_notes Is Null Then
            p_desc_notes_type := c_not_ok;
            p_desc_notes_text := 'Notes found blank';
        Else
            p_desc_notes_type := c_ok;
            p_desc_notes_text := c_ok;
        End If;

        p_message_type := c_ok;
        p_message_text := 'Procedure executed successfully.';
    Exception
        When Others Then
            p_message_type := c_not_ok;
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
    End;

    Procedure sp_job_phases_validate(
        p_person_id           Varchar2,
        p_meta_id             Varchar2,

        p_projno              Varchar2,

        p_job_phases_type Out Varchar2,
        p_job_phases_text Out Varchar2,

        p_message_type    Out Varchar2,
        p_message_text    Out Varchar2
    ) As
        v_projno job_proj_phase.projno%Type;
    Begin
        Select
            projno
        Into
            v_projno
        From
            job_proj_phase
        Where
            projno     = Trim(p_projno)
            And Rownum = 1;

        p_job_phases_type := c_ok;
        p_job_phases_text := c_ok;
        p_message_type    := c_ok;
        p_message_text    := 'Procedure executed successfully.';
    Exception
        When no_data_found Then
            p_job_phases_type := c_not_ok;
            p_job_phases_text := 'Job phases not defined';
            p_message_type    := c_ok;
            p_message_text    := 'Procedure executed successfully.';

        When Others Then
            p_message_type := c_not_ok;
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
    End;

    Procedure sp_responsible_roles_validate(
        p_person_id                  Varchar2,
        p_meta_id                    Varchar2,

        p_projno                     Varchar2,

        p_responsible_roles_type Out Varchar2,
        p_responsible_roles_text Out Varchar2,

        p_message_type           Out Varchar2,
        p_message_text           Out Varchar2
    ) As
        Cursor c1 Is
            With
                proj_roles As (
                    Select
                        rr.empno,
                        rr.job_responsible_role_id
                    From
                        job_responsible_roles rr
                    Where
                        rr.projno5 = p_projno
                )
            Select
                p_projno projno,
                rm.job_responsible_role_id,
                rm.job_responsible_role_name,
                iot_jobs_responsible_roles_qry.fn_get_required_attribute(p_person_id               => p_person_id,
                                                                         p_meta_id                 => p_meta_id,

                                                                         p_job_responsible_role_id => rm.job_responsible_role_id,
                                                                         p_type_of_job             => j.type_of_job
                )        required_attribute,
                pr.empno
            From
                job_responsible_roles_mst rm,
                proj_roles                pr,
                jobmaster                 j
            Where
                rm.job_responsible_role_id = pr.job_responsible_role_id (+)
                And j.projno               = p_projno
                And
                rm.job_responsible_role_id In (
                    c_r01, c_r02, c_r03, c_r04, c_r05, c_r06, c_r07, c_r08
                )
            Order By
                rm.job_responsible_role_id;
        Type typ_tab_proj_responsibles Is Table Of c1%rowtype;
        tab_proj_responsibles typ_tab_proj_responsibles;
    Begin
        Open c1;
        Fetch c1 Bulk Collect Into tab_proj_responsibles Limit 8;

        If tab_proj_responsibles(1).empno Is Null Then
            p_responsible_roles_type := c_not_ok;
            p_responsible_roles_text := 'ERP Project manager';
        End If;
        If tab_proj_responsibles(2).empno Is Null Then
            p_responsible_roles_type := c_not_ok;
            If p_responsible_roles_text Is Not Null Then
                p_responsible_roles_text := p_responsible_roles_text || ', ';
            End If;
            p_responsible_roles_text := p_responsible_roles_text || 'Job sponsor';
        End If;
        If tab_proj_responsibles(5).empno Is Null And tab_proj_responsibles(5).required_attribute = c_required_true Then
            p_responsible_roles_type := c_not_ok;
            If p_responsible_roles_text Is Not Null Then
                p_responsible_roles_text := p_responsible_roles_text || ', ';
            End If;
            p_responsible_roles_text := p_responsible_roles_text || 'Project control';
        End If;
        If tab_proj_responsibles(6).empno Is Null And tab_proj_responsibles(6).required_attribute = c_required_true Then
            p_responsible_roles_type := c_not_ok;
            If p_responsible_roles_text Is Not Null Then
                p_responsible_roles_text := p_responsible_roles_text || ', ';
            End If;
            p_responsible_roles_text := p_responsible_roles_text || 'Project Engineering';
        End If;
        If tab_proj_responsibles(7).empno Is Null And tab_proj_responsibles(7).required_attribute = c_required_true Then
            p_responsible_roles_type := c_not_ok;
            If p_responsible_roles_text Is Not Null Then
                p_responsible_roles_text := p_responsible_roles_text || ', ';
            End If;
            p_responsible_roles_text := p_responsible_roles_text || 'Project Procurement';
        End If;
        If tab_proj_responsibles(8).empno Is Null And tab_proj_responsibles(8).required_attribute = c_required_true Then
            p_responsible_roles_type := c_not_ok;
            If p_responsible_roles_text Is Not Null Then
                p_responsible_roles_text := p_responsible_roles_text || ', ';
            End If;
            p_responsible_roles_text := p_responsible_roles_text || 'Project Site';
        End If;
        If p_responsible_roles_text Is Not Null Then
            p_responsible_roles_text := p_responsible_roles_text || ' found blank';
        End If;

        If p_responsible_roles_text Is Null Then
            p_responsible_roles_type := c_ok;
            p_responsible_roles_text := c_ok;
        End If;
        p_message_type := c_ok;
        p_message_text := 'Procedure executed successfully.';

    Exception
        When Others Then
            p_message_type := c_not_ok;
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
    End;

    Procedure sp_budget_validate(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_projno           Varchar2,

        p_budget_type  Out Varchar2,
        p_budget_text  Out Varchar2,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_projno job_budgtran.projno%Type;
    Begin
        Select
            projno
        Into
            v_projno
        From
            job_budgtran
        Where
            projno     = Trim(p_projno)
            And Rownum = 1;

        p_budget_type  := c_ok;
        p_budget_text  := c_ok;
        p_message_type := c_ok;
        p_message_text := 'Procedure executed successfully.';
    Exception
        When no_data_found Then
            p_budget_type  := c_not_ok;
            p_budget_text  := 'Budget not defined';
            p_message_type := c_ok;
            p_message_text := 'Procedure executed successfully.';

        When Others Then
            p_message_type := c_not_ok;
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
    End;

    Procedure sp_erp_phases_validate(
        p_person_id           Varchar2,
        p_meta_id             Varchar2,

        p_projno              Varchar2,

        p_erp_phases_type Out Varchar2,
        p_erp_phases_text Out Varchar2,

        p_message_type    Out Varchar2,
        p_message_text    Out Varchar2
    ) As
        v_projno          job_erp_phases_file.job_no%Type;
        v_job_mode_status jobmaster.job_mode_status%Type;
    Begin
        Select
            job_mode_status
        Into
            v_job_mode_status
        From
            jobmaster
        Where
            projno = Trim(p_projno);
        If v_job_mode_status = c_o1 Then
            Select
                jepf.job_no
            Into
                v_projno
            From
                job_erp_phases_file jepf
            Where
                jepf.job_no = Trim(p_projno);
        End If;

        p_erp_phases_type := c_ok;
        p_erp_phases_text := c_ok;
        p_message_type    := c_ok;
        p_message_text    := 'Procedure executed successfully.';
    Exception
        When no_data_found Then
            p_erp_phases_type := c_not_ok;
            p_erp_phases_text := 'ERP Phases not defined';
            p_message_type    := c_ok;
            p_message_text    := 'Procedure executed successfully.';

        When Others Then
            p_message_type := c_not_ok;
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
    End;

End iot_jobs_validate_status_qry;
/

Grant Execute On "TIMECURR"."IOT_JOBS_VALIDATE_STATUS_QRY" To "TCMPL_APP_CONFIG";