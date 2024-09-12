Create Or Replace Package Body "TIMECURR"."IOT_JOBS_PROCESS_PROJMAST" As

    Procedure sp_process_projmast(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_projno           Varchar2,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        Cursor cur_phase Is
            Select
                *
            From
                job_proj_phase
            Where
                projno = Trim(p_projno);
        v_projno             projmast.projno%Type;
        v_name               projmast.name%Type;
        v_client             projmast.client%Type;
        v_sdate              projmast.sdate%Type;
        v_exptcdate          projmast.exptcdate%Type;
        v_cdate              projmast.cdate%Type;
        v_costcode           projmast.costcode%Type;
        v_prjmngr            projmast.prjmngr%Type;
        v_prjdymngr          projmast.prjdymngr%Type;
        v_original           projmast.original%Type;
        v_revised            projmast.revised%Type;
        v_projtype           projmast.projtype%Type;
        v_type               projmast.type%Type;
        v_tmagrp             projmast.tmagrp%Type;
        v_abbr               projmast.abbr%Type;
        v_reimb_job          projmast.reimb_job%Type;
        v_tcm_jobs           projmast.tcm_jobs%Type;
        v_tcm_grp            projmast.tcm_grp%Type;
        v_tcmno              projmast.tcmno%Type;
        v_eou_job            projmast.eou_job%Type;
        v_excl_billing       projmast.excl_billing%Type;
        v_excl_delta_billing projmast.excl_delta_billing%Type;
        v_prjoper            projmast.prjoper%Type;
        v_active             projmast.active%Type;
        v_proj_no            projmast.proj_no%Type;
        v_block_booking      projmast.block_booking%Type;
        v_bu                 projmast.bu%Type;
        v_co                 projmast.co%Type;
        v_revcdate           projmast.revcdate%Type;
        v_newcostcode        projmast.newcostcode%Type;
        v_block_ot           projmast.block_ot%Type;
        v_highend            projmast.highend%Type;
        v_revision           jobmaster.revision%Type;
    Begin
        For c1 In cur_phase
        Loop
            Select
                j.projno || c1.phase_select,
                j.short_desc,
                j.client,                
                j.job_open_date,
                j.expected_closing_date,
                j.actual_closing_date,
                j.costcode,
                j.pm_empno,
                j.dirvp_empno,
                0,
                0,
                'E',
                'BO',
                'F',
                e.abbr,
                Case j.invoicing_grp_company
                    When 'SI' Then
                        1
                    Else
                        0
                End,
                Case substr(j.type_of_job, 1, 3)
                    When '602' Then
                        1
                    Else
                        0
                End,
                Null,
                j.tcmno,
                Case
                    When j.invoicing_grp_company        = 'SI'
                        And substr(j.type_of_job, 1, 3) = '602'
                        And c1.phase_select             = '09'
                    Then
                        1
                    Else
                        0
                End,
                j.excl_billing,
                j.excl_delta_billing,
                fn_get_project_operator(
                    p_person_id => p_person_id,
                    p_meta_id   => p_meta_id,
                    p_projno    => j.projno
                ),
                Case 
                    When j.actual_closing_date Is Null Then
                        1
                    Else 
                        0
                End,
                j.projno,
                nvl(c1.block_booking, 0),
                j.type_of_job,
                --j.company,
                'T',
                j.closing_date_rev1,
                c1.tmagrp,
                nvl(c1.block_ot, 0),
                0,
                j.revision
            Into
                v_projno,
                v_name,
                v_client,
                v_sdate,
                v_exptcdate,
                v_cdate,
                v_costcode,
                v_prjmngr,
                v_prjdymngr,
                v_original,
                v_revised,
                v_projtype,
                v_type,
                v_tmagrp,
                v_abbr,
                v_reimb_job,
                v_tcm_jobs,
                v_tcm_grp,
                v_tcmno,
                v_eou_job,
                v_excl_billing,
                v_excl_delta_billing,
                v_prjoper,
                v_active,
                v_proj_no,
                v_block_booking,
                v_bu,
                v_co,
                v_revcdate,
                v_newcostcode,
                v_block_ot,
                v_highend,
                v_revision
            From
                jobmaster j,
                emplmast  e
            Where
                e.empno      = j.pm_empno
                And j.projno = Trim(p_projno);

            sp_update_projmast(
                p_person_id          => p_person_id,
                p_meta_id            => p_meta_id,

                p_projno             => v_projno,
                p_name               => v_name,
                p_client             => v_client,
                p_sdate              => v_sdate,
                p_exptcdate          => v_exptcdate,
                p_cdate              => v_cdate,
                p_costcode           => v_costcode,
                p_prjmngr            => v_prjmngr,
                p_prjdymngr          => v_prjdymngr,
                p_original           => v_original,
                p_revised            => v_revised,
                p_projtype           => v_projtype,
                p_type               => v_type,
                p_tmagrp             => v_tmagrp,
                p_abbr               => v_abbr,
                p_reimb_job          => v_reimb_job,
                p_tcm_jobs           => v_tcm_jobs,
                p_tcm_grp            => v_tcm_grp,
                p_tcmno              => v_tcmno,
                p_eou_job            => v_eou_job,
                p_excl_billing       => v_excl_billing,
                p_excl_delta_billing => v_excl_delta_billing,
                p_prjoper            => v_prjoper,
                p_active             => v_active,
                p_proj_no            => v_proj_no,
                p_block_booking      => v_block_booking,
                p_bu                 => v_bu,
                p_co                 => v_co,
                p_revcdate           => v_revcdate,
                p_newcostcode        => v_newcostcode,
                p_block_ot           => v_block_ot,
                p_highend            => v_highend,

                p_message_type       => p_message_type,
                p_message_text       => p_message_text
            );
        End Loop;
        
        If v_active = 1 Then
            if v_revision = 0 then
                sp_insert_prjcmast(p_projno);
            end if;
            sp_insert_budgtran(p_projno);
        End If;
        
    Exception
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'Err - ' || sqlcode || ' - ' || sqlerrm;
    End;

    Procedure sp_insert_projmast(
        p_person_id          Varchar2,
        p_meta_id            Varchar2,

        p_projno             Varchar2,
        p_name               Varchar2,
        p_client             Varchar2,
        p_sdate              Date,
        p_exptcdate          Date,
        p_cdate              Date     Default Null,
        p_costcode           Varchar2 Default Null,
        p_prjmngr            Varchar2,
        p_prjdymngr          Varchar2,
        p_original           Number,
        p_revised            Number,
        p_projtype           Varchar2,
        p_type               Varchar2,
        p_tmagrp             Varchar2,
        p_abbr               Varchar2,
        p_reimb_job          Number,
        p_tcm_jobs           Number,
        p_tcm_grp            Varchar2 Default Null,
        p_tcmno              Varchar2 Default Null,
        p_eou_job            Number,
        p_excl_billing       Number Default Null,
        p_excl_delta_billing Number Default Null,
        p_prjoper            Varchar2 Default Null,
        p_active             Number,
        p_proj_no            Varchar2,
        p_block_booking      Number,
        p_bu                 Varchar2,
        p_co                 Varchar2,
        p_revcdate           Date     Default Null,
        p_newcostcode        Varchar2 Default Null,
        p_block_ot           Number,
        p_highend            Number,

        p_message_type Out   Varchar2,
        p_message_text Out   Varchar2
    ) As
        v_empno Varchar2(5);
    Begin
        v_empno        := get_empno_from_meta_id(p_meta_id);

        If v_empno = 'ERRRR' Then
            p_message_type := not_ok;
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        Insert Into projmast (
            projno,
            name,
            client,
            sdate,
            exptcdate,
            cdate,
            costcode,
            prjmngr,
            prjdymngr,
            original,
            revised,
            projtype,
            type,
            tmagrp,
            abbr,
            reimb_job,
            tcm_jobs,
            tcm_grp,
            tcmno,
            eou_job,
            excl_billing,
            excl_delta_billing,
            prjoper,
            active,
            proj_no,
            block_booking,
            bu,
            co,
            revcdate,
            newcostcode,
            block_ot,
            highend)
        Values
        (p_projno,
            p_name,
            p_client,
            p_sdate,
            p_exptcdate,
            p_cdate,
            p_costcode,
            p_prjmngr,
            p_prjdymngr,
            p_original,
            p_revised,
            p_projtype,
            p_type,
            p_tmagrp,
            p_abbr,
            p_reimb_job,
            p_tcm_jobs,
            p_tcm_grp,
            p_tcmno,
            p_eou_job,
            p_excl_billing,
            p_excl_delta_billing,
            p_prjoper,
            p_active,
            p_proj_no,
            p_block_booking,
            p_bu,
            p_co,
            p_revcdate,
            p_newcostcode,
            p_block_ot,
            p_highend);

        p_message_type := ok;
        p_message_text := 'Procedure executed successfully.';

    Exception
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'Err - ' || sqlcode || ' - ' || sqlerrm;
    End sp_insert_projmast;

    Procedure sp_update_projmast(
        p_person_id          Varchar2,
        p_meta_id            Varchar2,

        p_projno             Varchar2,
        p_name               Varchar2,
        p_client             Varchar2,
        p_sdate              Date,
        p_exptcdate          Date,
        p_cdate              Date     Default Null,
        p_costcode           Varchar2 Default Null,
        p_prjmngr            Varchar2,
        p_prjdymngr          Varchar2,
        p_original           Number,
        p_revised            Number,
        p_projtype           Varchar2,
        p_type               Varchar2,
        p_tmagrp             Varchar2,
        p_abbr               Varchar2,
        p_reimb_job          Number,
        p_tcm_jobs           Number,
        p_tcm_grp            Varchar2 Default Null,
        p_tcmno              Varchar2 Default Null,
        p_eou_job            Number,
        p_excl_billing       Number Default Null,
        p_excl_delta_billing Number Default Null,
        p_prjoper            Varchar2 Default Null,
        p_active             Number,
        p_proj_no            Varchar2,
        p_block_booking      Number,
        p_bu                 Varchar2,
        p_co                 Varchar2,
        p_revcdate           Date     Default Null,
        p_newcostcode        Varchar2 Default Null,
        p_block_ot           Number,
        p_highend            Number,

        p_message_type Out   Varchar2,
        p_message_text Out   Varchar2
    ) As
        v_empno Varchar2(5);
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);

        If v_empno = 'ERRRR' Then
            p_message_type := not_ok;
            p_message_text := 'Invalid employee number';
            Return;
        End If;
        
        If p_cdate Is Not Null Then
            Update
                projmast
            Set
                active = 0,
                cdate = p_cdate
            Where
                projno = Trim(p_projno);
        Else        
            Update
                projmast
            Set
                name = p_name,
                client = p_client,
                sdate = p_sdate,
                exptcdate = p_exptcdate,
                cdate = p_cdate,
                costcode = p_costcode,
                prjmngr = p_prjmngr,
                prjdymngr = p_prjdymngr,
                active = p_active,
                prjoper = p_prjoper,
                abbr = p_abbr,
                projtype = p_projtype,
                reimb_job = p_reimb_job,
                block_booking = p_block_booking,
                revcdate = p_revcdate,
                newcostcode = p_newcostcode,
                tcm_jobs = p_tcm_jobs,
                block_ot = p_block_ot,
                tcm_grp = p_tcm_grp,
                tcmno = p_tcmno,
                eou_job = p_eou_job,
                excl_billing = p_excl_billing,
                excl_delta_billing = p_excl_delta_billing,
                proj_no = p_proj_no,
                co = p_co,
                highend = p_highend
            Where
                projno = Trim(p_projno);
        End If;

        If Sql%notfound Then
            sp_insert_projmast(
                p_person_id          => p_person_id,
                p_meta_id            => p_meta_id,

                p_projno             => p_projno,
                p_name               => p_name,
                p_client             => p_client,
                p_sdate              => p_sdate,
                p_exptcdate          => p_exptcdate,
                p_cdate              => p_cdate,
                p_costcode           => p_costcode,
                p_prjmngr            => p_prjmngr,
                p_prjdymngr          => p_prjdymngr,
                p_original           => p_original,
                p_revised            => p_revised,
                p_projtype           => p_projtype,
                p_type               => p_type,
                p_tmagrp             => p_tmagrp,
                p_abbr               => p_abbr,
                p_reimb_job          => p_reimb_job,
                p_tcm_jobs           => p_tcm_jobs,
                p_tcm_grp            => p_tcm_grp,
                p_tcmno              => p_tcmno,
                p_eou_job            => p_eou_job,
                p_excl_billing       => p_excl_billing,
                p_excl_delta_billing => p_excl_delta_billing,
                p_prjoper            => p_prjoper,
                p_active             => p_active,
                p_proj_no            => p_proj_no,
                p_block_booking      => p_block_booking,
                p_bu                 => p_bu,
                p_co                 => p_co,
                p_revcdate           => p_revcdate,
                p_newcostcode        => p_newcostcode,
                p_block_ot           => p_block_ot,
                p_highend            => p_highend,

                p_message_type       => p_message_type,
                p_message_text       => p_message_text
            );
        Else
            p_message_type := ok;
            p_message_text := 'Procedure executed successfully.';
        End If;
    Exception
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'Err - ' || sqlcode || ' - ' || sqlerrm;
    End sp_update_projmast;

    Function fn_get_project_operator(
        p_person_id Varchar2,
        p_meta_id   Varchar2,

        p_projno    Varchar2
    ) Return Varchar2 Is
        v_empno Varchar2(5);
    Begin

        Select
            empno
        Into
            v_empno
        From
            job_responsible_roles
        Where
            job_responsible_role_id = 'R03'
            And projno5             = Trim(p_projno);

        Return v_empno;
    Exception
        When Others Then
            Return Null;
    End;

End iot_jobs_process_projmast;
/
Grant Execute On "TIMECURR"."IOT_JOBS_PROCESS_PROJMAST" To "TCMPL_APP_CONFIG";