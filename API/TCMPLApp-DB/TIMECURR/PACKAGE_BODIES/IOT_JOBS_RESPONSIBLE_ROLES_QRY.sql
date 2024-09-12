Create Or Replace Package Body "TIMECURR"."IOT_JOBS_RESPONSIBLE_ROLES_QRY" As

    Function fn_job_responsible_list(
        p_person_id Varchar2,
        p_meta_id   Varchar2,

        p_projno    Varchar2
    ) Return Sys_Refcursor As
        c                    Sys_Refcursor;
        v_empno              Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;

        Open c For
            Select
                jrr.projno5                                                         projno,
                jrrm.job_responsible_role_name                                      responsible_name,
                jrr.empno || ' - ' || iot_jobs_general.get_employee_name(jrr.empno) employee,
                jrrm.job_responsible_role_id                                        job_responsible_role_id
            From
                job_responsible_roles               jrr, emplmast e, job_responsible_roles_mst jrrm
            Where
                jrr.empno                        = e.empno
                And jrrm.job_responsible_role_id = jrr.job_responsible_role_id
                And jrr.projno5                  = Trim(p_projno)

            Union All

            Select
                p_projno                                                              projno,
                jrrm.job_responsible_role_name                                        responsible_name,
                jrrd.empno || ' - ' || iot_jobs_general.get_employee_name(jrrd.empno) employee,
                jrrm.job_responsible_role_id                                          job_responsible_role_id
            From
                job_responsible_roles_defaults                jrrd, emplmast e, job_responsible_roles_mst jrrm
            Where
                jrrd.empno                       = e.empno
                And jrrm.job_responsible_role_id = jrrd.job_responsible_role_id
                And is_default                   = 1

            Order By
                4;

        Return c;
    End fn_job_responsible_list;

    Procedure sp_job_responsible_app_detail(
        p_person_id                        Varchar2,
        p_meta_id                          Varchar2,

        p_projno                           Varchar2,

        p_empno_r01                    Out Varchar2,
        p_empno_name_r01               Out Varchar2,
        p_empno_r02                    Out Varchar2,
        p_empno_r03                    Out Varchar2,
        p_empno_r04                    Out Varchar2,
        p_empno_r05                    Out Varchar2,
        p_empno_r05_required_attribute Out Varchar2,
        p_empno_r06                    Out Varchar2,
        p_empno_r06_required_attribute Out Varchar2,
        p_empno_r07                    Out Varchar2,
        p_empno_r07_required_attribute Out Varchar2,
        p_empno_r08                    Out Varchar2,
        p_empno_r08_required_attribute Out Varchar2,

        p_message_type                 Out Varchar2,
        p_message_text                 Out Varchar2
    ) As
        Cursor c1 Is
            With
                proj_roles As (
                    Select
                        rr.empno,
                        rr.job_responsible_role_id,
                        e.name employee_name
                    From
                        job_responsible_roles rr,
                        emplmast              e
                    Where
                        rr.empno       = e.empno
                        And rr.projno5 = p_projno
                )
            Select
                p_projno projno,
                rm.job_responsible_role_id,
                rm.job_responsible_role_name,
                fn_get_required_attribute(p_person_id               => p_person_id,
                                          p_meta_id                 => p_meta_id,

                                          p_job_responsible_role_id => rm.job_responsible_role_id,
                                          p_type_of_job             => j.type_of_job
                )        required_attribute,
                pr.empno,
                pr.employee_name
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

        p_empno_r01                    := tab_proj_responsibles(1).empno;
        p_empno_name_r01               := tab_proj_responsibles(1).employee_name;

        p_empno_r02                    := tab_proj_responsibles(2).empno;
        p_empno_r03                    := tab_proj_responsibles(3).empno;
        p_empno_r04                    := tab_proj_responsibles(4).empno;
        p_empno_r05                    := tab_proj_responsibles(5).empno;
        p_empno_r05_required_attribute := tab_proj_responsibles(5).required_attribute;
        p_empno_r06                    := tab_proj_responsibles(6).empno;
        p_empno_r06_required_attribute := tab_proj_responsibles(6).required_attribute;
        p_empno_r07                    := tab_proj_responsibles(7).empno;
        p_empno_r07_required_attribute := tab_proj_responsibles(7).required_attribute;
        p_empno_r08                    := tab_proj_responsibles(8).empno;
        p_empno_r08_required_attribute := tab_proj_responsibles(8).required_attribute;

        p_message_type                 := c_ok;
        p_message_text                 := 'Procedure executed successfully.';

    Exception
        When no_data_found Then
            Select
                jrr1.empno,
                jrr1.empno || ' - ' || e.name,
                Null,
                Null,
                Null,
                Null,
                Null,
                Null,
                Null,
                Null,
                Null,
                Null,
                Null
            Into
                p_empno_r01,
                p_empno_name_r01,
                p_empno_r02,
                p_empno_r03,
                p_empno_r04,
                p_empno_r05,
                p_empno_r05_required_attribute,
                p_empno_r06,
                p_empno_r06_required_attribute,
                p_empno_r07,
                p_empno_r07_required_attribute,
                p_empno_r08,
                p_empno_r08_required_attribute
            From
                job_responsible_roles jrr1,
                emplmast              e
            Where
                jrr1.job_responsible_role_id = c_r01
                And jrr1.empno               = e.empno
                And jrr1.projno5             = Trim(p_projno);

            p_message_type := c_ok;
            p_message_text := 'Procedure executed successfully.';
        When Others Then
            p_message_type := c_not_ok;
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
    End sp_job_responsible_app_detail;

    Function fn_get_empno(
        p_person_id               Varchar2,
        p_meta_id                 Varchar2,

        p_job_responsible_role_id Varchar2,
        p_type_of_job             Varchar2
    ) Return Varchar2 Is
        v_empno              Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
        v_hod                costmast.hod%Type;
        v_costcode           costmast.costcode%Type;
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;
        
        --6030
        If p_type_of_job Is Not Null Then
            Begin
                Select
                    costcode
                Into
                    v_costcode
                From
                    job_responsible_type_job_dept
                Where
                    job_responsible_role_id = Trim(p_job_responsible_role_id)
                    And type_of_job Is Not Null
                    And type_of_job         = Trim(p_type_of_job);

                If v_costcode Is Null Then
                    Return Null;
                End If;
            Exception
                When Others Then
                    Return Null;
            End;
        End If;

        Begin
            Select
                hod
            Into
                v_hod
            From
                costmast
            Where
                costcode = v_costcode;
        Exception
            When Others Then
                Select
                    hod
                Into
                    v_hod
                From
                    costmast
                Where
                    costcode = (
                        Select
                            costcode
                        From
                            job_responsible_type_job_dept
                        Where
                            job_responsible_role_id = Trim(p_job_responsible_role_id)
                            And type_of_job Is Null
                    );

        End;
        Return v_hod;

    End fn_get_empno;

    Procedure sp_get_job_responsible_r05_r06(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_projno           Varchar2,

        p_empno_r01    Out Varchar2,
        p_empno_r02    Out Varchar2,
        p_empno_r03    Out Varchar2,
        p_empno_r04    Out Varchar2,
        p_empno_r05    Out Varchar2,
        p_empno_r06    Out Varchar2,
        p_empno_r07    Out Varchar2,
        p_empno_r08    Out Varchar2,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_type_of_job jobmaster.type_of_job%Type;
    Begin
        Select
            type_of_job
        Into
            v_type_of_job
        From
            jobmaster
        Where
            projno = Trim(p_projno);

        Select
            Null,
            Null,
            Null,
            Null,
            iot_jobs_responsible_roles_qry.fn_get_empno(p_person_id               => p_person_id,
                                                        p_meta_id                 => p_meta_id,
                                                        p_job_responsible_role_id => c_r05,
                                                        p_type_of_job             => v_type_of_job),
            iot_jobs_responsible_roles_qry.fn_get_empno(p_person_id               => p_person_id,
                                                        p_meta_id                 => p_meta_id,
                                                        p_job_responsible_role_id => c_r06,
                                                        p_type_of_job             => v_type_of_job),
            Null,
            Null
        Into
            p_empno_r01,
            p_empno_r02,
            p_empno_r03,
            p_empno_r04,
            p_empno_r05,
            p_empno_r06,
            p_empno_r07,
            p_empno_r08
        From
            dual;
        p_message_type := c_ok;
        p_message_text := 'Procedure executed successfully.';

    Exception
        When Others Then
            p_message_type := c_not_ok;
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
    End sp_get_job_responsible_r05_r06;

    Function fn_get_emp_proj_actions(
        p_person_id Varchar2,
        p_meta_id   Varchar2,

        p_projno    Varchar2
    ) Return Sys_Refcursor As
        c                    Sys_Refcursor;
        v_empno              Varchar2(5);
        e_employee_not_found Exception;
        v_job_mode_status    Varchar2(3);
        Pragma exception_init(e_employee_not_found, -20001);
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;

        Select
            job_mode_status
        Into
            v_job_mode_status
        From
            jobmaster
        Where
            projno = p_projno;
        Open c For
            Select
            --mur.empno,
            Distinct
                mur.role_id,
                mra.action_id
            From
                tcmpl_app_config.sec_module_role_actions mra,
                tcmpl_app_config.sec_module_user_roles   mur
            Where
                mur.role_id       = mra.role_id
                And mur.module_id = 'M09'
                --And empno         = v_empno
                And mur.role_id In (
                    Select
                        app_config_role_id
                    From
                        (
                            Select
                                jrr.projno5                  projno,
                                jrrm.job_responsible_role_id job_responsible_role_id,
                                jrrm.app_config_role_id,
                                jrr.empno                    empno
                            From
                                job_responsible_roles     jrr,
                                job_responsible_roles_mst jrrm
                            Where
                                jrrm.job_responsible_role_id = jrr.job_responsible_role_id
                                And jrr.projno5              = Trim(p_projno)
                                And (
                                jrr.empno In (
                                    Select
                                        principal_empno
                                    From
                                        tcmpl_app_config.sec_module_delegate
                                    Where
                                        on_behalf_empno = v_empno
                                    Union
                                    Select
                                        v_empno
                                    From
                                        dual

                                )
                                )
                            Union

                            Select
                                p_projno                     projno,
                                jrrm.job_responsible_role_id job_responsible_role_id,
                                jrrm.app_config_role_id,
                                jrrd.empno                   empno
                            From
                                job_responsible_roles_defaults jrrd,
                                job_responsible_roles_mst      jrrm
                            Where
                                jrrm.job_responsible_role_id = jrrd.job_responsible_role_id
                                And is_default               = 1
                                And (
                                jrrd.empno In (
                                    Select
                                        principal_empno
                                    From
                                        tcmpl_app_config.sec_module_delegate
                                    Where
                                        on_behalf_empno = v_empno

                                    Union
                                    Select
                                        v_empno
                                    From
                                        dual
                                )
                                )
                        )
                )
                And action_id In (
                    Select
                        action_code
                    From
                        job_mode_action_map
                    Where
                        job_mode = v_job_mode_status
                );
        Return c;
    End;

    Function fn_get_required_attribute(
        p_person_id               Varchar2,
        p_meta_id                 Varchar2,

        p_job_responsible_role_id Varchar2,
        p_type_of_job             Varchar2
    ) Return Varchar2 Is
        v_empno              Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
        v_required_attribute Varchar2(5);
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;

        Select
            c_required_true
        Into
            v_required_attribute
        From
            job_responsible_type_job_reqrd
        Where
            job_responsible_role_id = Trim(p_job_responsible_role_id)
            And type_of_job         = Trim(p_type_of_job);

        Return v_required_attribute;

    Exception
        When Others Then
            Return c_required_false;

    End fn_get_required_attribute;

End iot_jobs_responsible_roles_qry;
/

Grant Execute On "TIMECURR"."IOT_JOBS_RESPONSIBLE_ROLES_QRY" To "TCMPL_APP_CONFIG";