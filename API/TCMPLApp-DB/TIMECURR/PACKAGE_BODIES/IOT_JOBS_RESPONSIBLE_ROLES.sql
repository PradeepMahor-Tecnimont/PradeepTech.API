Create Or Replace Package Body "TIMECURR"."IOT_JOBS_RESPONSIBLE_ROLES" As

    Procedure sp_add_responsible_roles(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_projno           Varchar2,
        
        p_erp_pm_empno     Varchar2 Default Null,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_exists         Number      := 0;
        v_empno          Varchar2(5);
        v_type_of_job    jobmaster.type_of_job%Type;
        v_role_empno     Varchar2(5);
        v_modified_empno Varchar2(5) := Null;
        v_date           Date        := Null;
    Begin
        v_empno          := get_empno_from_meta_id(p_meta_id);

        If v_empno = 'ERROR' Then
            p_message_type := c_not_ok;
            p_message_text := 'Invalid employee number';
            Return;
        End If;
        
        --R01
        Insert Into job_responsible_roles
        Select
            p_projno, job_responsible_role_id, nvl(p_erp_pm_empno, v_empno), 0, v_empno, sysdate
        From
            job_responsible_roles_mst
        Where
            job_responsible_role_id = c_r01
            And is_active           = 1;

        Update
            jobmaster
        Set
            pm_empno = nvl(p_erp_pm_empno, v_empno)
        Where
            projno = Trim(p_projno);
        
        --R02 R03 R04 R07 R08
        Insert Into job_responsible_roles
        Select
            p_projno, job_responsible_role_id, Null, 0, Null, Null
        From
            job_responsible_roles_mst
        Where
            job_responsible_role_id Not In (c_r01, c_r05, c_r06)
            And is_active = 1;

        Select
            type_of_job
        Into
            v_type_of_job
        From
            jobmaster
        Where
            projno = Trim(p_projno);
        
        --R05
        v_role_empno     := iot_jobs_responsible_roles_qry.fn_get_empno(p_person_id               => p_person_id,
                                                                        p_meta_id                 => p_meta_id,
                                                                        p_job_responsible_role_id => c_r05,
                                                                        p_type_of_job             => v_type_of_job);

        If v_role_empno Is Not Null Then
            v_date           := sysdate;
            v_modified_empno := v_empno;
        End If;

        Insert Into job_responsible_roles
        Select
            p_projno, job_responsible_role_id, v_role_empno, 0, v_modified_empno, v_date
        From
            job_responsible_roles_mst
        Where
            job_responsible_role_id = c_r05
            And is_active           = 1;
            
        --R06
        v_role_empno     := iot_jobs_responsible_roles_qry.fn_get_empno(p_person_id               => p_person_id,
                                                                        p_meta_id                 => p_meta_id,
                                                                        p_job_responsible_role_id => c_r06,
                                                                        p_type_of_job             => v_type_of_job);

        v_date           := Null;
        v_modified_empno := Null;
        If v_role_empno Is Not Null Then
            v_date           := sysdate;
            v_modified_empno := v_empno;
        End If;

        Insert Into job_responsible_roles
        Select
            p_projno, job_responsible_role_id, v_role_empno, 0, v_modified_empno, v_date
        From
            job_responsible_roles_mst
        Where
            job_responsible_role_id = c_r06
            And is_active           = 1;

        iot_jobs_general.sp_generate_app_config_roles();

        p_message_type := c_ok;
        p_message_text := 'Procedure executed successfully.';

    Exception
        When Others Then
            p_message_type := c_not_ok;
            p_message_text := 'Err - ' || sqlcode || ' - ' || sqlerrm;
    End sp_add_responsible_roles;

    Procedure sp_insert_responsible_roles(
        p_person_id               Varchar2,
        p_meta_id                 Varchar2,

        p_projno                  Varchar2,
        p_job_responsible_role_id Varchar2,
        p_empno                   Varchar2,

        p_message_type Out        Varchar2,
        p_message_text Out        Varchar2
    ) As
        v_empno Varchar2(5);
    Begin
        v_empno        := get_empno_from_meta_id(p_meta_id);

        If v_empno = 'ERROR' Then
            p_message_type := c_not_ok;
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        Insert Into job_responsible_roles(projno5, job_responsible_role_id, empno, has_approved, modified_by, modified_on)
        Values(
            p_projno, p_job_responsible_role_id, p_empno, 0, v_empno, sysdate);

        p_message_type := c_ok;
        p_message_text := 'Procedure executed successfully.';
    Exception
        When Others Then
            p_message_type := c_not_ok;
            p_message_text := 'Err - ' || sqlcode || ' - ' || sqlerrm;
    End;

    Procedure sp_update_responsible_roles(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_projno           Varchar2,

        p_empno_r01        Varchar2 Default Null,
        p_empno_r02        Varchar2 Default Null,
        p_empno_r03        Varchar2 Default Null,
        p_empno_r04        Varchar2 Default Null,
        p_empno_r05        Varchar2 Default Null,
        p_empno_r06        Varchar2 Default Null,
        p_empno_r07        Varchar2 Default Null,
        p_empno_r08        Varchar2 Default Null,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_empno                Varchar2(5);
        v_empno_role           Varchar2(5);
        v_job_responsible_role Varchar2(3);
        v_empno_1              Varchar2(5);
        v_empno_2              Varchar2(5);
        v_empno_3              Varchar2(5);
        v_empno_4              Varchar2(5);
        v_empno_5              Varchar2(5);
        v_empno_6              Varchar2(5);
        v_empno_7              Varchar2(5);
        v_empno_8              Varchar2(5);
        v_empno_9              Varchar2(5);
        v_empno_10             Varchar2(5);
        v_empno_11             Varchar2(5);
    Begin
        v_empno        := get_empno_from_meta_id(p_meta_id);

        If v_empno = 'ERROR' Then
            p_message_type := c_not_ok;
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        Begin
            Select
                nvl(jrr1.empno, '-'),
                nvl(jrr2.empno, '-'),
                nvl(jrr3.empno, '-'),
                nvl(jrr4.empno, '-'),
                nvl(jrr5.empno, '-'),
                nvl(jrr6.empno, '-'),
                nvl(jrr7.empno, '-'),
                nvl(jrr8.empno, '-')
            Into
                v_empno_1,
                v_empno_2,
                v_empno_3,
                v_empno_4,
                v_empno_5,
                v_empno_6,
                v_empno_7,
                v_empno_8
            From
                job_responsible_roles jrr1,
                job_responsible_roles jrr2,
                job_responsible_roles jrr3,
                job_responsible_roles jrr4,
                job_responsible_roles jrr5,
                job_responsible_roles jrr6,
                job_responsible_roles jrr7,
                job_responsible_roles jrr8
            Where
                jrr1.job_responsible_role_id     = c_r01
                And jrr2.job_responsible_role_id = c_r02
                And jrr3.job_responsible_role_id = c_r03
                And jrr4.job_responsible_role_id = c_r04
                And jrr5.job_responsible_role_id = c_r05
                And jrr6.job_responsible_role_id = c_r06
                And jrr7.job_responsible_role_id = c_r07
                And jrr8.job_responsible_role_id = c_r08
                And jrr1.projno5                 = jrr2.projno5
                And jrr1.projno5                 = jrr3.projno5
                And jrr1.projno5                 = jrr4.projno5
                And jrr1.projno5                 = jrr5.projno5
                And jrr1.projno5                 = jrr6.projno5
                And jrr1.projno5                 = jrr7.projno5
                And jrr1.projno5                 = jrr8.projno5
                And jrr1.projno5                 = Trim(p_projno);
        Exception
            When no_data_found Then
                For i In 2..8
                Loop
                    --If i = 1 Then
                    --    v_job_responsible_role := c_r01;
                    --    v_empno_role           := p_empno_r01;
                    --Els
                    If i = 2 Then
                        v_job_responsible_role := c_r02;
                        v_empno_role           := p_empno_r02;
                    Elsif i = 3 Then
                        v_job_responsible_role := c_r03;
                        v_empno_role           := p_empno_r03;
                    Elsif i = 4 Then
                        v_job_responsible_role := c_r04;
                        v_empno_role           := p_empno_r04;
                    Elsif i = 5 Then
                        v_job_responsible_role := c_r05;
                        v_empno_role           := p_empno_r05;
                    Elsif i = 6 Then
                        v_job_responsible_role := c_r06;
                        v_empno_role           := p_empno_r06;
                    Elsif i = 7 Then
                        v_job_responsible_role := c_r07;
                        v_empno_role           := p_empno_r07;
                    Elsif i = 8 Then
                        v_job_responsible_role := c_r08;
                        v_empno_role           := p_empno_r08;
                    End If;

                    sp_insert_responsible_roles(
                        p_person_id               => p_person_id,
                        p_meta_id                 => p_meta_id,

                        p_projno                  => p_projno,
                        p_job_responsible_role_id => v_job_responsible_role,
                        p_empno                   => v_empno_role,

                        p_message_type            => p_message_type,
                        p_message_text            => p_message_text
                    );
                End Loop;

                iot_jobs_general.sp_generate_app_config_roles();

                Commit;

                p_message_type := c_ok;
                p_message_text := 'Procedure executed successfully.';

                Return;

        End;
        
        --responsible users
        For i In 1..8
        Loop
            v_job_responsible_role := Null;
            v_empno_role           := Null;

            If nvl(p_empno_r01, '-') != v_empno_1 And i = 1 Then
                v_job_responsible_role := c_r01;
                v_empno_role           := p_empno_r01;
            End If;
            If nvl(p_empno_r02, '-') != v_empno_2 And i = 2 Then
                v_job_responsible_role := c_r02;
                v_empno_role           := p_empno_r02;
            End If;
            If nvl(p_empno_r03, '-') != v_empno_3 And i = 3 Then
                v_job_responsible_role := c_r03;
                v_empno_role           := p_empno_r03;
            End If;
            If nvl(p_empno_r04, '-') != v_empno_4 And i = 4 Then
                v_job_responsible_role := c_r04;
                v_empno_role           := p_empno_r04;
            End If;
            If nvl(p_empno_r05, '-') != v_empno_5 And i = 5 Then
                v_job_responsible_role := c_r05;
                v_empno_role           := p_empno_r05;
            End If;
            If nvl(p_empno_r06, '-') != v_empno_6 And i = 6 Then
                v_job_responsible_role := c_r06;
                v_empno_role           := p_empno_r06;
            End If;
            If nvl(p_empno_r07, '-') != v_empno_7 And i = 7 Then
                v_job_responsible_role := c_r07;
                v_empno_role           := p_empno_r07;
            End If;
            If nvl(p_empno_r08, '-') != v_empno_8 And i = 8 Then
                v_job_responsible_role := c_r08;
                v_empno_role           := p_empno_r08;
            End If;

            If v_job_responsible_role Is Not Null Then
                sp_update_responsible(
                    p_person_id               => p_person_id,
                    p_meta_id                 => p_meta_id,

                    p_projno                  => p_projno,

                    p_job_responsible_role_id => v_job_responsible_role,
                    p_empno                   => v_empno_role,

                    p_message_type            => p_message_type,
                    p_message_text            => p_message_text);

                If v_job_responsible_role = c_r02 Then
                    Update
                        jobmaster
                    Set
                        dirvp_empno = v_empno_role
                    Where
                        Trim(projno) = Trim(p_projno)
                        And phase    = '00';
                End If;
            End If;
        End Loop;

        iot_jobs_general.sp_generate_app_config_roles();

        Commit;
        p_message_type := c_ok;
        p_message_text := 'Procedure executed successfully.';

    Exception
        When Others Then
            p_message_type := c_not_ok;
            p_message_text := 'Err - ' || sqlcode || ' - ' || sqlerrm;
    End sp_update_responsible_roles;

    Procedure sp_update_responsible(
        p_person_id               Varchar2,
        p_meta_id                 Varchar2,

        p_projno                  Varchar2,

        p_job_responsible_role_id Varchar2,
        p_empno                   Varchar2,

        p_message_type Out        Varchar2,
        p_message_text Out        Varchar2
    ) As
        v_empno Varchar2(5);
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);

        If v_empno = 'ERROR' Then
            p_message_type := c_not_ok;
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        Update
            job_responsible_roles
        Set
            empno = p_empno,
            modified_by = v_empno,
            modified_on = sysdate
        Where
            job_responsible_role_id = Trim(p_job_responsible_role_id)
            And projno5             = Trim(p_projno);

    Exception
        When Others Then
            p_message_type := c_not_ok;
            p_message_text := 'Err - ' || sqlcode || ' - ' || sqlerrm;
    End sp_update_responsible;

End iot_jobs_responsible_roles;
/
Grant Execute On "TIMECURR"."IOT_JOBS_RESPONSIBLE_ROLES" To "TCMPL_APP_CONFIG";