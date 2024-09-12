--------------------------------------------------------
--  DDL for Package Body IOT_JOBS_APPROVALS
--------------------------------------------------------

Create Or Replace Package Body timecurr.iot_jobs_approvals As
    
    Procedure prc_check_timesheet_booking_close_job( 
        p_person_id             Varchar2,
        p_meta_id               Varchar2,
        
        p_projno                Varchar2,
        p_actual_closing_date   Date,
        
        p_message_type          Out Varchar2,
        p_message_text          Out Varchar2
        ) AS
        v_empno                 Varchar2(5);
        v_count                 Number;
    begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERROR' Then
            p_message_type := c_not_ok;
            p_message_text := 'Invalid employee number';
            Return;
        End If;               
        
        Select 
            Count(yymm) 
        Into 
            v_count 
        From 
            time_daily
        Where 
            to_number(yymm) >= to_number(to_char(p_actual_closing_date, 'YYYYMM'))
            And Substr(projno,1,5) = p_projno;            
        If v_count  = 0 Then
            p_message_type := ok;
            p_message_text := ok;
        Else
            p_message_type := not_ok;
            p_message_text := 'Cannot close job as manhours booked in Timesheet. Please select any date in future month';
            Return;
        End If;
        
        Select 
            Count(yymm) 
        Into 
            v_count 
        From 
            time_ot
        Where 
            to_number(yymm) >= to_number(to_char(p_actual_closing_date, 'YYYYMM'))
            And Substr(projno,1,5) = p_projno;            
        If v_count  = 0 Then
            p_message_type := ok;
            p_message_text := ok;
        Else
            p_message_type := not_ok;
            p_message_text := 'Cannot close job as manhours booked in Timesheet. Please select any date in future month';
            Return;
        End If;
        
        Select 
            Count(yymm) 
        Into 
            v_count 
        From 
            timetran
        Where 
            to_number(yymm) >= to_number(to_char(p_actual_closing_date, 'YYYYMM'))
            And Substr(projno,1,5) = p_projno;            
        If v_count  = 0 Then
            p_message_type := ok;
            p_message_text := ok;
        Else
            p_message_type := not_ok;
            p_message_text := 'Cannot close job as manhours booked in Timesheet. Please select any date in future month';
            Return;
        End If;
        
         Select 
            Count(yymm) 
        Into 
            v_count 
        From 
            ts_osc_mhrs_master omm, ts_osc_mhrs_detail omd
        Where 
            omm.oscm_id = omd.oscm_id
            And to_number(omm.yymm) >= to_number(to_char(p_actual_closing_date, 'YYYYMM'))
            And Substr(omd.projno,1,5) = p_projno;
        If v_count  = 0 Then
            p_message_type := ok;
            p_message_text := ok;
        Else
            p_message_type := not_ok;
            p_message_text := 'Cannot close job as manhours booked in OSC. Please select any date in future month';
            Return;
        End If;
    end;
    
    Procedure sp_check_timesheet_booking_revise_job( 
        p_person_id             Varchar2,
        p_meta_id               Varchar2,
        
        p_projno                Varchar2,
        p_revise_closing_date   Date,
        
        p_message_type          Out Varchar2,
        p_message_text          Out Varchar2
   ) AS
        v_empno                 Varchar2(5);
        v_count                 Number;
    begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERROR' Then
            p_message_type := c_not_ok;
            p_message_text := 'Invalid employee number';
            Return;
        End If;                             
        
        Select 
            Count(yymm) 
        Into 
            v_count 
        From 
            time_daily
        Where 
            to_number(yymm) > to_number(to_char(add_months(p_revise_closing_date,1), 'YYYYMM'))
            And Substr(projno,1,5) = p_projno;            
        If v_count  = 0 Then
            p_message_type := ok;
            p_message_text := ok;
        Else
            p_message_type := not_ok;
            p_message_text := 'Cannot revise job as manhours booked in Timesheet. Please select any date in future month';
            Return;
        End If;
        
        Select 
            Count(yymm) 
        Into 
            v_count 
        From 
            time_ot
        Where 
            to_number(yymm) > to_number(to_char(add_months(p_revise_closing_date,1), 'YYYYMM'))
            And Substr(projno,1,5) = p_projno;            
        If v_count  = 0 Then
            p_message_type := ok;
            p_message_text := ok;
        Else
            p_message_type := not_ok;
            p_message_text := 'Cannot revise job as manhours booked in Timesheet. Please select any date in future month';
            Return;
        End If;
        
        Select 
            Count(yymm) 
        Into 
            v_count 
        From 
            timetran
        Where 
            to_number(yymm) > to_number(to_char(add_months(p_revise_closing_date,1), 'YYYYMM'))
            And Substr(projno,1,5) = p_projno;            
        If v_count  = 0 Then
            p_message_type := ok;
            p_message_text := ok;
        Else
            p_message_type := not_ok;
            p_message_text := 'Cannot revise job as manhours booked in Timesheet. Please select any date in future month';
            Return;
        End If;
        
         Select 
            Count(yymm) 
        Into 
            v_count 
        From 
            ts_osc_mhrs_master omm, ts_osc_mhrs_detail omd
        Where 
            omm.oscm_id = omd.oscm_id
            And to_number(omm.yymm) > to_number(to_char(add_months(p_revise_closing_date,1), 'YYYYMM'))
            And Substr(omd.projno,1,5) = p_projno;
        If v_count  = 0 Then
            p_message_type := ok;
            p_message_text := ok;
        Else
            p_message_type := not_ok;
            p_message_text := 'Cannot revise job as manhours booked in OSC. Please select any date in future month';
            Return;
        End If;
    end;       
    
    Procedure cmd_approval(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,
        p_projno           Varchar2,
        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_empno Varchar2(5);
        v_count Number;
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);

        If v_empno = 'ERROR' Then
            p_message_type := c_not_ok;
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        Select
            Count(*)
        Into
            v_count
        From
            jobmaster
        Where
            projno                     = p_projno
            And approved_vpdir         = 1
            And nvl(approved_dirop, 0) = 0;
        If v_count = 0 Then
            p_message_type := c_not_ok;
            p_message_text := 'Err - Job cannot be found for approval.';
            Return;
        End If;

        job_approvals_logs(
            p_person_id               => p_person_id,
            p_meta_id                 => p_meta_id,
            p_projno                  => p_projno,
            p_job_responsible_role_id => c_r10,
            p_message_type            => p_message_type,
            p_message_text            => p_message_text
        );

        If p_message_type = ok Then
            Update
                jobmaster
            Set
                approved_dirop = 1,
                approved_amfi = 0,
                dirop_empno = iot_jobs_approvals_qry.get_principal_empno_4_approval(p_projno, c_r10),
                appdt_dirop = sysdate                
            Where
                projno = p_projno;

            iot_jobs_mail.send_mail_on_cmd_approval(
                p_person_id    => p_person_id,
                p_meta_id      => p_meta_id,
                p_projno       => p_projno,
                p_message_type => p_message_type,
                p_message_text => p_message_text
            );

            p_message_type := c_ok;
            p_message_text := 'Approval intimation send to AFC';

            Commit;
        Else
            p_message_type := not_ok;
            p_message_text := 'Approval process failed !!!';
        End If;
    Exception
        When Others Then
            p_message_type := c_not_ok;
            p_message_text := 'Err - ' || sqlcode || ' - ' || sqlerrm;
    End;

    Procedure afc_approval(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,
        
        p_projno           Varchar2,
        p_client           Varchar2 Default Null,
        p_project_type     Varchar2 Default Null,
        p_invoice_to_grp   Varchar2 Default Null,
        
        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_empno Varchar2(5);
        v_count Number;
        v_actual_closing_date jobmaster.actual_closing_date%type;
        v_closing_date_rev1   jobmaster.closing_date_rev1%type;
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);

        If v_empno = 'ERROR' Then
            p_message_type := c_not_ok;
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        Select
            Count(*)
        Into
            v_count
        From
            jobmaster
        Where
            projno                     = p_projno
            And approved_vpdir         = 1
            And nvl(approved_dirop, 0) = 1
            And nvl(approved_amfi, 0)  = 0;

        If v_count = 0 Then
            p_message_type := c_not_ok;
            p_message_text := 'Err - Job cannot be found for approval.';
            Return;
        End If;

        job_approvals_logs(
            p_person_id               => p_person_id,
            p_meta_id                 => p_meta_id,
            p_projno                  => p_projno,
            p_job_responsible_role_id => c_r11,
            p_message_type            => p_message_type,
            p_message_text            => p_message_text
        );

        If p_message_type = ok Then
            Select 
                actual_closing_date, closing_date_rev1
            Into 
                v_actual_closing_date, v_closing_date_rev1 
            From 
                jobmaster
            Where
                projno = p_projno;
            If v_actual_closing_date Is Null Then
                Update
                    jobmaster
                Set
                    client = p_client,
                    contract_type = p_project_type,
                    invoicing_grp_company = p_invoice_to_grp,
                    approved_amfi = 1,
                    amfi_empno = iot_jobs_approvals_qry.get_principal_empno_4_approval(p_projno, c_r11),
                    appdt_amfi = sysdate,
                    job_mode_status = iot_jobs_mode_status.fn_approved_and_open
                Where
                    projno = p_projno;
                    
                If v_closing_date_rev1 Is Not Null Then
                    If trunc(sysdate, 'mm') >  trunc(v_closing_date_rev1, 'mm') then
                        Update
                            jobmaster
                        Set                                               
                            job_mode_status = iot_jobs_mode_status.fn_ts_booking_blocked
                        Where
                            projno = p_projno;
                    End if;
                End If;   
            Else
                Update
                    jobmaster
                Set                    
                    approved_amfi = 1,
                    amfi_empno = iot_jobs_approvals_qry.get_principal_empno_4_approval(p_projno, c_r11),
                    appdt_amfi = sysdate,
                    job_mode_status = iot_jobs_mode_status.fn_closed
                Where
                    projno = p_projno;                                                                        
            End If;

            iot_jobs_mail.send_mail_on_afc_approval(
                p_person_id    => p_person_id,
                p_meta_id      => p_meta_id,
                p_projno       => p_projno,
                p_message_type => p_message_type,
                p_message_text => p_message_text
            );

            iot_jobs_process_projmast.sp_process_projmast(
                p_person_id    => p_person_id,
                p_meta_id      => p_meta_id,
                p_projno       => p_projno,
                p_message_type => p_message_type,
                p_message_text => p_message_text
            );

            p_message_type := c_ok;
            p_message_text := 'Approval successfully done !!';

            Commit;
        Else
            p_message_type := not_ok;
            p_message_text := 'Approval process failed !!!';
        End If;
    Exception
        When Others Then
            p_message_type := c_not_ok;
            p_message_text := 'Err - ' || sqlcode || ' - ' || sqlerrm;
    End;

    Procedure js_approval(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,
        p_projno           Varchar2,
        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_empno Varchar2(5);
        v_count Number;
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);

        If v_empno = 'ERROR' Then
            p_message_type := c_not_ok;
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        Select
            Count(*)
        Into
            v_count
        From
            jobmaster
        Where
            projno              = p_projno
            And job_mode_status In (iot_jobs_mode_status.fn_approvals_pending_all, iot_jobs_mode_status.fn_closure_approvals_pending_all);

        If v_count = 0 Then
            p_message_type := c_not_ok;
            p_message_text := 'Err - Job cannot be found for approval.';
            Return;
        End If;

        job_approvals_logs(
            p_person_id               => p_person_id,
            p_meta_id                 => p_meta_id,
            p_projno                  => p_projno,
            p_job_responsible_role_id => c_r02,
            p_message_type            => p_message_type,
            p_message_text            => p_message_text
        );

        If p_message_type = ok Then
            Update
                jobmaster
            Set
                approved_vpdir = 1,
                approved_dirop = 0,
                dirvp_empno = iot_jobs_approvals_qry.get_principal_empno_4_approval(p_projno, c_r02),
                appdt_vpdir = sysdate,
                job_mode_status = Case  
                                  When actual_closing_date Is Null Then 
                                    iot_jobs_mode_status.fn_approvals_pending_partial
                                  Else 
                                    iot_jobs_mode_status.fn_closure_approvals_pending_partial
                                  End
            Where
                projno = p_projno;

            iot_jobs_mail.send_mail_on_js_approval(
                p_person_id    => p_person_id,
                p_meta_id      => p_meta_id,
                p_projno       => p_projno,
                p_message_type => p_message_type,
                p_message_text => p_message_text
            );

            p_message_type := c_ok;
            p_message_text := 'Approval intimation send to CMD';

            Commit;
        Else
            p_message_type := not_ok;
            p_message_text := 'Approval process failed !!!';
        End If;
    Exception
        When Others Then
            p_message_type := c_not_ok;
            p_message_text := 'Err - ' || sqlcode || ' - ' || sqlerrm;
    End;

    Procedure js_send_back_for_review(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,
        p_projno           Varchar2,
        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_empno Varchar2(5);
        v_count Number;
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);

        If v_empno = 'ERROR' Then
            p_message_type := c_not_ok;
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        Select
            Count(*)
        Into
            v_count
        From
            jobmaster
        Where
            projno              = p_projno
            And job_mode_status = iot_jobs_mode_status.fn_approvals_pending_all;

        If v_count = 0 Then
            p_message_type := c_not_ok;
            p_message_text := 'Err - Job cannot be found.';
            Return;
        End If;

        job_approvals_logs(
            p_person_id               => p_person_id,
            p_meta_id                 => p_meta_id,
            p_projno                  => p_projno,
            p_job_responsible_role_id => c_r02,
            p_message_type            => p_message_type,
            p_message_text            => p_message_text
        );

        If p_message_type = ok Then
            Update
                jobmaster
            Set
                approved_vpdir = 0,
                dirvp_empno = iot_jobs_approvals_qry.get_principal_empno_4_approval(p_projno, c_r02),
                appdt_vpdir = null,
                job_mode_status = iot_jobs_mode_status.fn_under_revision
            Where
                projno = p_projno;

            iot_jobs_mail.send_mail_on_js_review(
                p_person_id    => p_person_id,
                p_meta_id      => p_meta_id,
                p_projno       => p_projno,
                p_message_type => p_message_type,
                p_message_text => p_message_text
            );

            p_message_type := c_ok;
            p_message_text := 'Review intimation send to PM';

            Commit;
        Else
            p_message_type := not_ok;
            p_message_text := 'Review intimation process failed !!!';
        End If;
    Exception
        When Others Then
            p_message_type := c_not_ok;
            p_message_text := 'Err - ' || sqlcode || ' - ' || sqlerrm;
    End;

    Procedure job_approval_initiation(
        p_person_id             Varchar2,
        p_meta_id               Varchar2,
        
        p_projno                Varchar2,
        p_actual_close_date     Date     Default Null,
        p_notes                 Varchar2 Default Null,
        
        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_empno                  Varchar2(5);
        v_count                  Number;
        v_desc_notes_type        Varchar2(2);
        v_desc_notes_text        Varchar2(50);
        v_job_phases_type        Varchar2(2);
        v_job_phases_text        Varchar2(50);
        v_responsible_roles_type Varchar2(2);
        v_responsible_roles_text Varchar2(50);
        v_budget_type            Varchar2(2);
        v_budget_text            Varchar2(50);
        v_erp_phases_type        Varchar2(2);
        v_erp_phases_text        Varchar2(50);
        v_closing_date_rev1      jobmaster.closing_date_rev1%type;
        v_message_type           Varchar2(2);
        v_message_text           Varchar2(50);
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERROR' Then
            p_message_type := c_not_ok;
            p_message_text := 'Invalid employee number';
            Return;
        End If;
        
        If p_actual_close_date Is Not Null Then        
             prc_check_timesheet_booking_close_job( 
                p_person_id             => p_person_id,
                p_meta_id               => p_meta_id,
                
                p_projno                => p_projno,
                p_actual_closing_date   => p_actual_close_date,
                
                p_message_type          => p_message_type,
                p_message_text          => p_message_text
             );
            If p_message_type = not_ok Then
                p_message_type := p_message_type;
                p_message_text := p_message_text;
                Return;
            End If;
            
            sp_check_projections_booking( 
                p_person_id             => p_person_id,
                p_meta_id               => p_meta_id,
                
                p_projno                => p_projno,
                p_actual_close_date     => p_actual_close_date,
                
                p_message_type          => p_message_type,
                p_message_text          => p_message_text
             );
            If p_message_type = not_ok Then
                Update 
                    prjcmast
                Set 
                    hours = 0
                Where 
                    hours != 0
                    And to_number(yymm) >= to_number(to_char(p_actual_close_date, 'YYYYMM'))
                    And Substr(projno,1,5) = p_projno;
            End If;
        Else
            Select
                Count(*)
            Into
                v_count
            From
                jobmaster
            Where
                projno              = p_projno
                And job_mode_status = iot_jobs_mode_status.fn_under_revision;
    
            If v_count = 0 Then
                p_message_type := c_not_ok;
                p_message_text := 'Err - Job cannot be found for approval.';
                Return;
            End If;
    
            -- validation
    
            iot_jobs_validate_status_qry.sp_job_form_validate(
                p_person_id              => p_person_id,
                p_meta_id                => p_meta_id,
                p_projno                 => p_projno,
                p_desc_notes_type        => v_desc_notes_type,
                p_desc_notes_text        => v_desc_notes_text,
                p_job_phases_type        => v_job_phases_type,
                p_job_phases_text        => v_job_phases_text,
                p_responsible_roles_type => v_responsible_roles_type,
                p_responsible_roles_text => v_responsible_roles_text,
                p_budget_type            => v_budget_type,
                p_budget_text            => v_budget_text,
                p_erp_phases_type        => v_erp_phases_type,
                p_erp_phases_text        => v_erp_phases_text,
                p_message_type           => v_message_type,
                p_message_text           => v_message_text
            );
            
            Select closing_date_rev1 Into v_closing_date_rev1 From jobmaster
                where projno = trim(p_projno);
            
            /*if v_closing_date_rev1 is not null then
                sp_check_timesheet_booking_revise_job( 
                    p_person_id             => p_person_id,
                    p_meta_id               => p_meta_id,
                    
                    p_projno                => p_projno,
                    p_revise_closing_date   => v_closing_date_rev1,
                    
                    p_message_type          => p_message_type,
                    p_message_text          => p_message_text
                 );
                If p_message_type = not_ok Then
                    p_message_type := p_message_type;
                    p_message_text := p_message_text;
                    Return;
                End If;
            end if;*/
        End If;
        
        If p_actual_close_date Is Not Null Or (v_desc_notes_type = 'OK' And v_job_phases_type = 'OK' And v_responsible_roles_type = 'OK' And v_budget_type = 'OK') Then
            job_approvals_logs(
                p_person_id               => p_person_id,
                p_meta_id                 => p_meta_id,
                p_projno                  => p_projno,
                p_job_responsible_role_id => c_r01,
                p_message_type            => p_message_type,
                p_message_text            => p_message_text
            );
            If p_message_type = ok Then
                If p_actual_close_date Is Not Null Then
                    Update
                        jobmaster
                    Set
                        actual_closing_date = p_actual_close_date,
                        notes = p_notes,
                        job_mode_status = iot_jobs_mode_status.fn_closure_approvals_pending_all,
                        approved_vpdir = 0,
                        approved_dirop = 0,
                        approved_amfi = 0
                    Where
                        projno = p_projno;
                Else 
                    Update
                        jobmaster
                    Set
                        job_mode_status = iot_jobs_mode_status.fn_approvals_pending_all,
                        approved_vpdir = 0
                    Where
                        projno = p_projno;
                End If;
                
                Commit;

                iot_jobs_mail.send_mail_on_erp_pm_approval(
                    p_person_id    => p_person_id,
                    p_meta_id      => p_meta_id,
                    p_projno       => p_projno,
                    p_message_type => p_message_type,
                    p_message_text => p_message_text
                );

                p_message_type := c_ok;
                p_message_text := 'Approval intimation send to job sponsor.';
            Else
                p_message_type := not_ok;
                p_message_text := 'Approval process failed !!!';
            End If;
        Else
            p_message_type := c_not_ok;
            p_message_text := 'Incomplete job form, could not send for approval';
        End If;

    Exception
        When Others Then
            p_message_type := c_not_ok;
            p_message_text := 'Err - ' || sqlcode || ' - ' || sqlerrm;
    End;

    Procedure job_approvals_logs(
        p_person_id               Varchar2,
        p_meta_id                 Varchar2,

        p_projno                  Varchar2,
        p_job_responsible_role_id Varchar2,

        p_message_type Out        Varchar2,
        p_message_text Out        Varchar2
    ) As
        v_empno           Varchar2(5);
        v_principal_empno Varchar2(5);
    Begin
        v_empno           := get_empno_from_meta_id(p_meta_id);

        If v_empno = 'ERRRR' Then
            p_message_type := c_not_ok;
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        v_principal_empno := iot_jobs_approvals_qry.get_principal_empno_4_approval(p_projno, p_job_responsible_role_id);
        If v_principal_empno Is Null Then
            p_message_type := not_ok;
            p_message_text := 'Principal employee not defined.';
            Return;
        End If;

        Insert Into job_approvals_log
        Select
            projno, revision, sysdate, p_job_responsible_role_id, v_principal_empno, v_empno
        From
            jobmaster
        Where
            projno = Trim(p_projno);
        p_message_type    := ok;
        p_message_text    := 'Procedure executed successfully.';

    Exception
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;

    End job_approvals_logs;

    Procedure sp_check_projections_booking( 
        p_person_id             Varchar2,
        p_meta_id               Varchar2,
        
        p_projno                Varchar2,
        p_actual_close_date     Date,
        
        p_message_type          Out Varchar2,
        p_message_text          Out Varchar2
        ) AS
        v_empno                 Varchar2(5);
        v_count                 Number;
    begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERROR' Then
            p_message_type := c_not_ok;
            p_message_text := 'Invalid employee number';
            Return;
        End If;
        
        Select 
            Count(yymm) 
        Into 
            v_count 
        From 
            prjcmast
        Where 
            hours != 0
            And to_number(yymm) >= to_number(to_char(p_actual_close_date, 'YYYYMM'))
            And Substr(projno,1,5) = p_projno;
            
        If v_count = 0 Then
            p_message_type := ok;
            p_message_text := ok;
        Else
            p_message_type := not_ok;
            p_message_text := 'Manhours have been forecasted in Projections on or after Actual closing date.';            
        End If;
    end;


End;
/
Grant Execute On "TIMECURR"."IOT_JOBS_APPROVALS" To "TCMPL_APP_CONFIG";