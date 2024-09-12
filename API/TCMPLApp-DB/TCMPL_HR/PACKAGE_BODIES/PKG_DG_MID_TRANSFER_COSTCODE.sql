Create Or Replace Package Body "TCMPL_HR"."PKG_DG_MID_TRANSFER_COSTCODE" As

    Procedure sp_add_dg_mid_transfer_costcode(
        p_person_id         Varchar2,
        p_meta_id           Varchar2,

        p_transfer_type     Number,
        p_emp_no            Varchar2,
        p_current_costcode  Varchar2,
        p_target_costcode   Varchar2,
        p_transfer_date     Date,
        p_transfer_end_date Date     Default Null,
        p_remarks           Varchar2,
        p_status            Number,
        p_site_code         Varchar2 Default Null,

        p_message_type Out  Varchar2,
        p_message_text Out  Varchar2
    ) As
        v_exists       Number;
        v_empno        Varchar2(5);
        v_flag         Number      := 0;
        v_keyid        Varchar2(8);
        v_user_tcp_ip  Varchar2(5) := 'NA';
        v_message_type Number      := 0;
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            p_message_type := not_ok;
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        If trunc(sysdate) - trunc(p_transfer_date) > 30 Then
            p_message_type := not_ok;
            p_message_text := 'Error...Transfer date cannot be more than 30 days before !!!';
            Return;
        End If;

        If p_transfer_type = 1 Then
            If p_transfer_end_date Is Null Then
                p_message_type := not_ok;
                p_message_text := 'Error...Transfer end date cannot be found !!!';
                Return;
            End If;

            If p_site_code Is Null Then
                p_message_type := not_ok;
                p_message_text := 'Error...Site code found blank !!!';
                Return;
            End If;

            If trunc(p_transfer_end_date) <= trunc(p_transfer_date) Then
                p_message_type := not_ok;
                p_message_text := 'Error...Invalid Transfer date / Transfer end date !!!';
                Return;
            End If;

        End If;

        v_keyid := dbms_random.string('X', 8);
        Select
            Count(key_id)
        Into
            v_exists
        From
            dg_mid_transfer_costcode
        Where
            Trim(upper(emp_no))  = Trim(upper(p_emp_no))
            And transfer_type_fk = p_transfer_type
            And status           = p_status;

        If v_exists = 0 Then
            Insert Into dg_mid_transfer_costcode (
                key_id,
                transfer_type_fk,
                emp_no,
                current_costcode,
                target_costcode,
                transfer_date,
                transfer_end_date,
                remarks,
                status,
                effective_transfer_date,
                desgcode,
                modified_on,
                modified_by,
                flag,
                site_code
            )
            Values (
                v_keyid,
                p_transfer_type,
                Trim(p_emp_no),
                Trim(p_current_costcode),
                Trim(p_target_costcode),
                p_transfer_date,
                p_transfer_end_date,
                Trim(p_remarks),
                p_status,
                Null,
                Null,
                sysdate,
                v_empno,
                v_flag,
                p_site_code
            );

            If p_status = 0 Then
                pkg_dg_mid_transfer_costcode_approvals.sp_add_approval_cycle(
                    p_person_id    => p_person_id,
                    p_meta_id      => p_meta_id,

                    p_key_id       => v_keyid,

                    p_message_type => p_message_type,
                    p_message_text => p_message_text
                );

                If p_message_type = not_ok Then
                    Rollback;
                    p_message_type := not_ok;
                    p_message_text := 'Error while approving.';
                    Return;
                End If;
            
                pkg_dg_mail.sp_costcode_change_email(
                    p_person_id    => p_person_id,
                    p_meta_id      => p_meta_id,
                    
                    p_key_id       => v_keyid,
                    p_email_stage  => c_costcode_change_initiated,                               
    
                    p_message_type => p_message_type,
                    p_message_text => p_message_text
                );   

                If p_message_type = not_ok Then
                    p_message_type := not_ok;
                    p_message_text := 'Costcode transfer added successfully..but error occured while mailing...';
                    Return;
                End If;
            End If;    
            
            p_message_type := ok;
            p_message_text := 'Costcode transfer added successfully..';
        Else
            p_message_type := not_ok;
            p_message_text := 'Costcode transfer already exists !!!';
        End If;

    Exception
        When Others Then
            Rollback;
            p_message_type := not_ok;
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
    End sp_add_dg_mid_transfer_costcode;

    Procedure sp_update_dg_mid_transfer_costcode(
        p_person_id         Varchar2,
        p_meta_id           Varchar2,

        p_key_id            Varchar2,
        p_transfer_type     Number,
        p_emp_no            Varchar2,
        p_current_costcode  Varchar2,
        p_target_costcode   Varchar2,
        p_transfer_date     Date,
        p_transfer_end_date Date     Default Null,
        p_remarks           Varchar2,
        p_status            Number,
        p_site_code         Varchar2 Default Null,

        p_message_type Out  Varchar2,
        p_message_text Out  Varchar2
    ) As
        v_exists       Number;
        v_empno        Varchar2(5);
        v_user_tcp_ip  Varchar2(5) := 'NA';
        v_message_type Number      := 0;
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            p_message_type := not_ok;
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        If p_transfer_type = 1 Then
            If p_transfer_end_date Is Null Then
                p_message_type := not_ok;
                p_message_text := 'Error...Transfer end date cannot be found !!!';
                Return;
            End If;

            If p_site_code Is Null Then
                p_message_type := not_ok;
                p_message_text := 'Error...Site code found blank !!!';
                Return;
            End If;

            If trunc(p_transfer_end_date) <= trunc(p_transfer_date) Then
                p_message_type := not_ok;
                p_message_text := 'Error...Invalid Transfer date / Transfer end date !!!';
                Return;
            End If;

        End If;

        Select
            Count(key_id)
        Into
            v_exists
        From
            dg_mid_transfer_costcode
        Where
            key_id = p_key_id;

        If v_exists = 1 Then
            Update
                dg_mid_transfer_costcode
            Set
                transfer_type_fk = p_transfer_type,
                current_costcode = Trim(p_current_costcode),
                target_costcode = Trim(p_target_costcode),
                transfer_date = p_transfer_date,
                transfer_end_date = p_transfer_end_date,
                remarks = Trim(p_remarks),
                status = p_status,
                modified_on = sysdate,
                modified_by = v_empno,
                site_code = p_site_code
            Where
                key_id     = p_key_id
                And status = c_save_as_draft;

            If p_status = 0 Then
                pkg_dg_mid_transfer_costcode_approvals.sp_add_approval_cycle(
                    p_person_id    => p_person_id,
                    p_meta_id      => p_meta_id,

                    p_key_id       => p_key_id,

                    p_message_type => p_message_type,
                    p_message_text => p_message_text
                );

                If p_message_type = not_ok Then
                    Rollback;
                    p_message_type := not_ok;
                    p_message_text := 'Error while approving.';
                    Return;
                End If;
            
                pkg_dg_mail.sp_costcode_change_email(
                    p_person_id    => p_person_id,
                    p_meta_id      => p_meta_id,
                    
                    p_key_id       => p_key_id,
                    p_email_stage  => c_costcode_change_initiated,                               
    
                    p_message_type => p_message_type,
                    p_message_text => p_message_text
                );   

                If p_message_type = not_ok Then
                    p_message_type := not_ok;
                    p_message_text := 'Costcode transfer added successfully..but error occured while mailing...';
                    Return;
                End If;
            End If;   

            Commit;
            p_message_type := ok;
            p_message_text := 'Costcode transfer updated successfully.';
        Else
            p_message_type := not_ok;
            p_message_text := 'No matching Costcode transfer exists !!!';
        End If;
    Exception
        When dup_val_on_index Then
            Rollback;
            p_message_type := not_ok;
            p_message_text := 'Costcode transfer already exists !!!';
        When Others Then
            Rollback;
            p_message_type := not_ok;
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
    End sp_update_dg_mid_transfer_costcode;

    Procedure sp_delete_dg_mid_transfer_costcode(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_key_id           Varchar2,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_empno        Varchar2(5);
        v_is_used      Number;
        v_user_tcp_ip  Varchar2(5) := 'NA';
        v_message_type Number      := 0;
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            p_message_type := not_ok;
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        Select
            Count(key_id)
        Into
            v_is_used
        From
            dg_mid_transfer_costcode
        Where
            key_id = p_key_id
            And status != c_pending;

        If v_is_used > 0 Then
            p_message_type := not_ok;
            p_message_text := 'Record cannot be delete, this record already used !!!';
            Return;
        End If;

        Delete
            From dg_mid_transfer_costcode
        Where
            key_id     = p_key_id
            And status = c_pending;

        pkg_dg_mid_transfer_costcode_approvals.sp_delete_approval_cycle(
            p_person_id    => p_person_id,
            p_meta_id      => p_meta_id,

            p_key_id       => p_key_id,

            p_message_type => p_message_type,
            p_message_text => p_message_text
        );

        If p_message_type = ok Then
            Commit;
            p_message_type := ok;
            p_message_text := 'Record deleted successfully.';
        Else
            Rollback;
            p_message_type := not_ok;
            p_message_text := 'Error in Costcode transfer deletion..';
        End If;

    Exception
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
    End sp_delete_dg_mid_transfer_costcode;

    Procedure sp_hod_approval_transfer_costcode(
        p_person_id         Varchar2,
        p_meta_id           Varchar2,

        p_key_id            Varchar2,
        p_apprl_action_id   Varchar2,
        p_approval_action   Varchar2,
        p_status            Number,
        p_target_costcode   Varchar2 Default Null,
        p_approval_remarks  Varchar2 Default Null,
        p_transfer_date     Date     Default Null,
        p_transfer_end_date Date     Default Null,
        p_site_code         Varchar2 Default Null,

        p_message_type Out  Varchar2,
        p_message_text Out  Varchar2
    ) As
        v_empno            Varchar2(5);
        v_is_used          Number;
        v_exists           Number      := 0;
        v_user_tcp_ip      Varchar2(5) := 'NA';
        v_message_type     Number      := 0;
        v_transfer_type_fk dg_mid_transfer_costcode.transfer_type_fk%Type;
        v_status           dg_mid_transfer_costcode.status%Type;
        v_transfer_date    dg_mid_transfer_costcode.transfer_date%Type;
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            p_message_type := not_ok;
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        If pkg_dg_mid_transfer_costcode_qry.fn_is_approval_due(
                p_key_id,
                p_apprl_action_id
            ) = not_ok
        Then
            p_message_type := not_ok;
            p_message_text := 'Not authorized to approve !!!.';
            Return;
        End If;

        Begin
            Select
                transfer_type_fk, status, transfer_date
            Into
                v_transfer_type_fk, v_status, v_transfer_date
            From
                dg_mid_transfer_costcode
            Where
                key_id = p_key_id;
            If c_pending = v_status Then
                v_exists := 1;
            End If;
        Exception
            When Others Then
                v_exists := 0;
        End;

        If v_exists = 1 Then
            If v_transfer_type_fk = 1 Then
                If p_transfer_end_date Is Not Null Then
                    If trunc(p_transfer_end_date) <= trunc(v_transfer_date) Then
                        p_message_type := not_ok;
                        p_message_text := 'Error...Invalid Transfer date / Transfer end date !!!';
                        Return;
                    End If;
                Else
                    p_message_type := not_ok;
                    p_message_text := 'Error...Transfer end date cannot be blank !!!';
                    Return;
                End If;

                If p_site_code Is Null Then
                    p_message_type := not_ok;
                    p_message_text := 'Error...Site code found blank !!!';
                    Return;
                End If;

                Update
                    dg_mid_transfer_costcode
                Set
                    status = p_status,
                    target_costcode = Nvl(p_target_costcode, target_costcode),
                    transfer_date = Nvl(p_transfer_date, transfer_date),
                    transfer_end_date = p_transfer_end_date,
                    site_code = p_site_code,
                    modified_on = sysdate,
                    modified_by = v_empno
                Where
                    key_id     = p_key_id
                    And status = c_pending;
            Else
                Update
                    dg_mid_transfer_costcode
                Set
                    status = p_status,
                    modified_on = sysdate,
                    modified_by = v_empno
                Where
                    key_id     = p_key_id
                    And status = c_pending;
            End If;

            pkg_dg_mid_transfer_costcode_approvals.sp_update_approval_cycle(
                p_person_id        => p_person_id,
                p_meta_id          => p_meta_id,

                p_key_id           => p_key_id,
                p_apprl_action_id  => p_apprl_action_id,
                p_approval_action  => p_approval_action,
                p_approval_remarks => p_approval_remarks,

                p_message_type     => p_message_type,
                p_message_text     => p_message_text
            );

            If p_message_type = not_ok Then
                Rollback;
                p_message_type := not_ok;
                p_message_text := 'Error while approving.';
                Return;
            End If;       
            
            Commit;
                
            pkg_dg_mail.sp_costcode_change_email(
                p_person_id     => p_person_id,
                p_meta_id       => p_meta_id,
                
                p_key_id        => p_key_id,
                p_email_stage   => Case p_approval_action
                                    When ok Then c_costcode_approved_by_target_hod
                                    Else c_costcode_rejected_by_target_hod
                                    End,                               

                p_message_type => p_message_type,
                p_message_text => p_message_text
            );   
            
            If p_message_type = not_ok Then
                p_message_type := not_ok;
                p_message_text := 'Success..but error occured while mailing...';
                Return;
            End If;
            
            p_message_type := ok;
            p_message_text := 'Procedure executed successfully.';

        Else
            p_message_type := not_ok;
            p_message_text := 'No matching Costcode transfer exists !!!';
        End If;

    Exception
        When dup_val_on_index Then
            Rollback;
            p_message_type := not_ok;
            p_message_text := 'Costcode transfer already exists !!!';
        When Others Then
            Rollback;
            p_message_type := not_ok;
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
    End sp_hod_approval_transfer_costcode;

    Procedure sp_hr_approval_transfer_costcode(
        p_person_id               Varchar2,
        p_meta_id                 Varchar2,

        p_key_id                  Varchar2,
        p_status                  Number,
        p_target_costcode         Varchar2,
        p_effective_transfer_date Date,
        p_desgcode                Varchar2 Default Null,
        p_apprl_action_id         Varchar2,
        p_approval_action         Varchar2,
        p_site_code               Varchar2 Default Null,
        p_approval_remarks        Varchar2 Default Null,
        p_transfer_end_date       Date     Default Null,
        p_job_group_code          Varchar2 Default Null,
        p_jobdiscipline_code      Varchar2 Default Null,
        p_jobtitle_code           Varchar2 Default Null,

        p_message_type Out        Varchar2,
        p_message_text Out        Varchar2
    ) As
        v_empno            Varchar2(5);
        v_is_used          Number;
        v_exists           Number;
        v_user_tcp_ip      Varchar2(5) := 'NA';
        v_message_type     Number      := 0;
        v_emp_no           Varchar2(5);
        v_description      dg_mid_transfer_type.description%Type;
        v_transfer_type_fk dg_mid_transfer_costcode.transfer_type_fk%Type;
        v_status           dg_mid_transfer_costcode.status%Type;
        v_transfer_date    dg_mid_transfer_costcode.transfer_date%Type;
        v_desgcode         dg_mid_transfer_costcode.desgcode%Type;                
        v_job_group_code   dg_mid_transfer_costcode.job_group_code%Type;                     
        v_jobdiscipline_code dg_mid_transfer_costcode.jobdiscipline_code%Type;                        
        v_jobtitle_code      dg_mid_transfer_costcode.jobtitle_code%Type;   
        v_email_stage        Number;
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            p_message_type := not_ok;
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        If pkg_dg_mid_transfer_costcode_qry.fn_is_approval_due(
                p_key_id,
                p_apprl_action_id
            ) = not_ok
        Then
            p_message_type := not_ok;
            p_message_text := 'Not authorized to approve !!!.';
            Return;
        End If;

        If p_status = 1 Then
            If trunc(sysdate) - trunc(p_effective_transfer_date) > 30 Then
                p_message_type := not_ok;
                p_message_text := 'Error...Effective transfer date cannot be more than 30 days before !!!';
                Return;
            End If;
        End If;

        Begin
            Select
                transfer_type_fk, status, transfer_date
            Into
                v_transfer_type_fk, v_status, v_transfer_date
            From
                dg_mid_transfer_costcode
            Where
                key_id = p_key_id;
            If c_pending = v_status Then
                v_exists := 1;
            End If;
        Exception
            When Others Then
                v_exists := 0;
        End;

        If v_exists = 1 Then
            If v_transfer_type_fk = 1 Then
                If p_transfer_end_date Is Not Null Then
                    If trunc(p_transfer_end_date) <= trunc(v_transfer_date) Then
                        p_message_type := not_ok;
                        p_message_text := 'Error...Invalid Transfer date / Transfer end date !!!';
                        Return;
                    End If;
                Else
                    p_message_type := not_ok;
                    p_message_text := 'Error...Transfer end date cannot be blank !!!';
                    Return;
                End If;

                If p_site_code Is Null Then
                    p_message_type := not_ok;
                    p_message_text := 'Error...Site code found blank !!!';
                    Return;
                End If;

                Update
                    dg_mid_transfer_costcode
                Set
                    target_costcode = Trim(p_target_costcode),
                    effective_transfer_date = p_effective_transfer_date,
                    status = Case                                 
                                 When p_status = 1 
                                     And p_apprl_action_id = c_apprl_action_id_hr
                                     And trunc(p_effective_transfer_date) <= trunc(sysdate)
                                 Then
                                     c_approved
                                 When p_status = 1
                                     And p_apprl_action_id = c_apprl_action_id_hr
                                     And trunc(p_effective_transfer_date) > trunc(sysdate)
                                 Then
                                     c_pending_time_bound
                                 When p_status = -1 Then
                                     c_rejected                                 
                             End,
                    site_code = p_site_code,
                    transfer_end_date = p_transfer_end_date,
                    modified_on = sysdate,
                    modified_by = v_empno
                Where
                    key_id     = p_key_id
                    And status = c_pending;
            Elsif v_transfer_type_fk = 2 Then
                Update
                    dg_mid_transfer_costcode
                Set
                    target_costcode = Trim(p_target_costcode),
                    effective_transfer_date = p_effective_transfer_date,
                    status = Case                                 
                                 When p_status = 1
                                     And p_apprl_action_id = c_apprl_action_id_hr
                                     And trunc(p_effective_transfer_date) <= trunc(sysdate)
                                 Then
                                     c_approved
                                 When p_status = 1
                                     And p_apprl_action_id = c_apprl_action_id_hr
                                     And trunc(p_effective_transfer_date) > trunc(sysdate)
                                 Then
                                     c_pending_time_bound
                                 When p_status = -1 Then
                                     c_rejected
                             End,
                    modified_on = sysdate,
                    modified_by = v_empno
                Where
                    key_id     = p_key_id
                    And status = c_pending;
            Else
                If p_job_group_code Is Null Or p_jobdiscipline_code Is Null Or p_jobtitle_code Is Null Then
                    p_message_type := not_ok;
                    p_message_text := 'Error...Job group / Job discipline / Job title found blank !!!';
                    Return;
                End If;
                
                If p_apprl_action_id = c_apprl_action_id_hr Then
                    Update
                        dg_mid_transfer_costcode
                    Set
                        target_costcode = Trim(p_target_costcode),
                        effective_transfer_date = p_effective_transfer_date,
                        --desgcode = Trim(p_desgcode),
                        status = Case
                                     When p_status = 0 Then
                                        c_pending                                    
                                     When p_status = 1
                                         And p_apprl_action_id = c_apprl_action_id_hr_hod
                                         And trunc(p_effective_transfer_date) <= trunc(sysdate)
                                     Then
                                         c_approved
                                     When p_status = 1
                                         And p_apprl_action_id = c_apprl_action_id_hr_hod
                                         And trunc(p_effective_transfer_date) > trunc(sysdate)
                                     Then
                                         c_pending_time_bound
                                     When p_status = -1 Then
                                         c_rejected
                                 End,
                        --job_group_code = p_job_group_code,
                        --jobdiscipline_code = p_jobdiscipline_code,
                        --jobtitle_code = p_jobtitle_code,
                        modified_on = sysdate,
                        modified_by = v_empno
                    Where
                        key_id     = p_key_id
                        And status = c_pending;                
                        
                    Select                        
                        e.desgcode,                        
                        e.jobgroup,                        
                        e.jobdiscipline,                        
                        e.jobtitle_code
                    Into                        
                        v_desgcode,                        
                        v_job_group_code,                        
                        v_jobdiscipline_code,                        
                        v_jobtitle_code                        
                    From
                        dg_mid_transfer_costcode mtc,
                        vu_emplmast              e
                    Where
                        mtc.emp_no     = e.empno
                        And mtc.key_id = p_key_id;
                        
                    Update
                        dg_mid_transfer_costcode
                    Set                        
                        desgcode = Trim(v_desgcode),                        
                        job_group_code = v_job_group_code,
                        jobdiscipline_code = v_jobdiscipline_code,
                        jobtitle_code = v_jobtitle_code
                    Where
                        key_id     = p_key_id
                        And status = c_pending;       
                Else
                    Update
                        dg_mid_transfer_costcode
                    Set
                        target_costcode = Trim(p_target_costcode),
                        effective_transfer_date = p_effective_transfer_date,
                        --desgcode = Trim(p_desgcode),
                        status = Case
                                     When p_status = 0 Then
                                        c_pending                                    
                                     When p_status = 1
                                         And p_apprl_action_id = c_apprl_action_id_hr_hod
                                         And trunc(p_effective_transfer_date) <= trunc(sysdate)
                                     Then
                                         c_approved
                                     When p_status = 1
                                         And p_apprl_action_id = c_apprl_action_id_hr_hod
                                         And trunc(p_effective_transfer_date) > trunc(sysdate)
                                     Then
                                         c_pending_time_bound
                                     When p_status = -1 Then
                                         c_rejected
                                 End,
                        --job_group_code = p_job_group_code,
                        --jobdiscipline_code = p_jobdiscipline_code,
                        --jobtitle_code = p_jobtitle_code,
                        modified_on = sysdate,
                        modified_by = v_empno
                    Where
                        key_id     = p_key_id
                        And status = c_pending;
                End If;
            End If;

            pkg_dg_mid_transfer_costcode_approvals.sp_update_approval_cycle(
                p_person_id        => p_person_id,
                p_meta_id          => p_meta_id,

                p_key_id           => p_key_id,
                p_apprl_action_id  => p_apprl_action_id,
                p_approval_action  => p_approval_action,
                p_approval_remarks => p_approval_remarks,

                p_message_type     => p_message_type,
                p_message_text     => p_message_text
            );

            If p_message_type = ok Then
                If p_approval_action = ok Then
                    If v_transfer_type_fk = 0 And p_apprl_action_id = c_apprl_action_id_hr Then
                        sp_add_dg_mid_transfer_costcode_perm_payoll(
                            p_person_id          => p_person_id,
                            p_meta_id            => p_meta_id,

                            p_key_id             => p_key_id,
                            
                            p_desgcode           => p_desgcode,
                            p_job_group_code     => p_job_group_code,
                            p_jobdiscipline_code => p_jobdiscipline_code,
                            p_jobtitle_code      => p_jobtitle_code,
                    
                            p_message_type       => p_message_type,
                            p_message_text       => p_message_text);                        
                        
                        If p_message_type = not_ok Then                        
                            p_message_type := not_ok;
                            p_message_text := 'Error while approving.';
                            Return;
                        End If;
                    End If;
                    
                    If p_apprl_action_id = c_apprl_action_id_hr_hod Or ( (v_transfer_type_fk = 1 Or v_transfer_type_fk = 2) And p_apprl_action_id = c_apprl_action_id_hr) Then
                        If trunc(p_effective_transfer_date) <= trunc(sysdate) Then
                            pkg_dg_mid_transfer_costcode_approvals.sp_update_approval_cycle(
                                p_person_id        => p_person_id,
                                p_meta_id          => p_meta_id,
    
                                p_key_id           => p_key_id,
                                p_apprl_action_id  => c_job_schedule_action_id,
                                p_approval_action  => p_approval_action,
                                p_approval_remarks => p_approval_remarks,
    
                                p_message_type     => p_message_type,
                                p_message_text     => p_message_text
                            );
    
                            Select
                                mtc.emp_no, mtt.description
                            Into
                                v_emp_no, v_description
                            From
                                dg_mid_transfer_costcode mtc,
                                dg_mid_transfer_type     mtt
                            Where
                                mtc.transfer_type_fk = mtt.value
                                And key_id           = Trim(p_key_id);
    
                            timecurr.hr_pkg_costmast_main.sp_dg_empl_costcode_update(
                                p_person_id          => p_person_id,
                                p_meta_id            => p_meta_id,
    
                                p_empno              => v_emp_no,
                                p_transfer_type      => v_description,
                                p_costcode           => p_target_costcode,
                                p_desgcode           => p_desgcode,
                                p_job_group_code     => p_job_group_code,
                                p_jobdiscipline_code => p_jobdiscipline_code,
                                p_jobtitle_code      => p_jobtitle_code,
    
                                p_message_type       => p_message_type,
                                p_message_text       => p_message_text);
                        End If;
                    End If;
                End If;
                If p_message_type = ok Then
                    Commit;
                    If p_apprl_action_id = c_apprl_action_id_hr Then
                        If p_approval_action = ok Then
                            v_email_stage := c_costcode_approved_by_payroll;
                        Else
                            v_email_stage := c_costcode_rejected_by_payroll;
                        End If;
                    ElsIf p_apprl_action_id = c_apprl_action_id_hr_hod Then
                        If p_approval_action = ok Then
                            v_email_stage := c_costcode_approved_by_hr;
                        Else
                            v_email_stage := c_costcode_rejected_by_hr;
                        End If;
                    End If;
                    
                    pkg_dg_mail.sp_costcode_change_email(
                        p_person_id     => p_person_id,
                        p_meta_id       => p_meta_id,
                        
                        p_key_id        => p_key_id,
                        p_email_stage   => v_email_stage,                               

                        p_message_type => p_message_type,
                        p_message_text => p_message_text
                    );   
                    
                    If p_message_type = not_ok Then
                        p_message_type := not_ok;
                        p_message_text := 'Success..but error occured while mailing...';
                        Return;
                    End If;                                
                    
                    p_message_type := ok;
                    p_message_text := 'Procedure executed successfully.';
                Else
                    Rollback;
                    p_message_type := not_ok;
                    p_message_text := 'Error while approving.';
                End If;
            End If;
        Else
            p_message_type := not_ok;
            p_message_text := 'No matching Costcode transfer exists !!!';
        End If;

    Exception
        When dup_val_on_index Then
            Rollback;
            p_message_type := not_ok;
            p_message_text := 'Costcode transfer already exists !!!';
        When Others Then
            Rollback;
            p_message_type := not_ok;
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
    End sp_hr_approval_transfer_costcode;

    Procedure sp_return_dg_mid_transfer_costcode(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_transfer_type    Number,
        p_key_id           Varchar2,
        p_emp_no           Varchar2,
        p_current_costcode Varchar2,
        p_target_costcode  Varchar2,
        p_transfer_date    Date,
        p_remarks          Varchar2,
        p_status           Number,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_exists       Number;
        v_empno        Varchar2(5);
        v_keyid        Varchar2(8);
        v_user_tcp_ip  Varchar2(5) := 'NA';
        v_message_type Number      := 0;
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            p_message_type := not_ok;
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        If trunc(p_transfer_date) - trunc(sysdate) > 30 Then
            p_message_type := not_ok;
            p_message_text := 'Error...Effective transfer date is more than 30 days back !!!';
            Return;
        End If;

        v_keyid := dbms_random.string('X', 8);
        Select
            Count(key_id)
        Into
            v_exists
        From
            dg_mid_transfer_costcode
        Where
            Trim(upper(emp_no))  = Trim(upper(p_emp_no))
            And transfer_type_fk = p_transfer_type            
            And status           = p_status
            And key_id = Trim(p_key_id);

        If v_exists = 0 Then
            Insert Into dg_mid_transfer_costcode (
                key_id,
                transfer_type_fk,
                emp_no,
                current_costcode,
                target_costcode,
                transfer_date,
                remarks,
                status,
                effective_transfer_date,
                desgcode,
                modified_on,
                modified_by
            )
            Values (
                v_keyid,
                p_transfer_type,
                Trim(p_emp_no),
                Trim(p_current_costcode),
                Trim(p_target_costcode),
                p_transfer_date,
                Trim(p_remarks),
                p_status,
                Null,
                Null,
                sysdate,
                v_empno
            );
            Update
                dg_mid_transfer_costcode
            Set
                flag = 1
            Where
                key_id = p_key_id;

            pkg_dg_mid_transfer_costcode_approvals.sp_add_approval_cycle(
                p_person_id    => p_person_id,
                p_meta_id      => p_meta_id,

                p_key_id       => v_keyid,

                p_message_type => p_message_type,
                p_message_text => p_message_text
            );

            If p_message_type = ok Then
                Commit;
                
                pkg_dg_mail.sp_costcode_change_email(
                    p_person_id     => p_person_id,
                    p_meta_id       => p_meta_id,
                    
                    p_key_id        => v_keyid,
                    p_email_stage   => c_costcode_change_initiated,                               

                    p_message_type => p_message_type,
                    p_message_text => p_message_text
                );   
                
                If p_message_type = not_ok Then
                    p_message_type := not_ok;
                    p_message_text := 'Costcode transfer added successfully..but error occured while mailing...';
                    Return;
                End If;                                                                   
                
                p_message_type := ok;
                p_message_text := 'Costcode transfer added successfully..';
            Else
                Rollback;
                p_message_type := not_ok;
                p_message_text := 'Error in Costcode transfer..';
            End If;
        Else
            p_message_type := not_ok;
            p_message_text := 'Costcode transfer already exists !!!';
        End If;

    Exception
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
    End sp_return_dg_mid_transfer_costcode;

    Procedure sp_hr_approval_return_transfer_costcode(
        p_person_id               Varchar2,
        p_meta_id                 Varchar2,

        p_key_id                  Varchar2,
        p_status                  Number,
        p_effective_transfer_date Date,
        p_apprl_action_id         Varchar2,
        p_approval_action         Varchar2,

        p_message_type Out        Varchar2,
        p_message_text Out        Varchar2
    ) As
        v_empno        Varchar2(5);
        v_is_used      Number;
        v_exists       Number;
        v_user_tcp_ip  Varchar2(5) := 'NA';
        v_message_type Number      := 0;
        v_emp_no       Varchar2(5);
        v_description  dg_mid_transfer_type.description%Type;
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            p_message_type := not_ok;
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        If pkg_dg_mid_transfer_costcode_qry.fn_is_approval_due(
                p_key_id,
                p_apprl_action_id
            ) = not_ok
        Then
            p_message_type := not_ok;
            p_message_text := 'Not authorized to approve !!!.';
            Return;
        End If;

        If trunc(sysdate) - trunc(p_effective_transfer_date) > 30 Then
            p_message_type := not_ok;
            p_message_text := 'Error...Effective transfer date cannot be more than 30 days before !!!';
            Return;
        End If;

        Select
            Count(key_id)
        Into
            v_exists
        From
            dg_mid_transfer_costcode
        Where
            key_id     = p_key_id
            And status = c_pending;

        If v_exists = 1 Then
            Update
                dg_mid_transfer_costcode
            Set
                effective_transfer_date = p_effective_transfer_date,
                status = Case
                             When p_status = 1
                                 And trunc(p_effective_transfer_date) <= trunc(sysdate)
                             Then
                                 c_approved
                             When p_status = 1
                                 And trunc(p_effective_transfer_date) > trunc(sysdate)
                             Then
                                 c_pending_time_bound
                             When p_status = -1 Then
                                 c_rejected
                         End
            Where
                key_id     = p_key_id
                And status = c_pending;

            pkg_dg_mid_transfer_costcode_approvals.sp_update_approval_cycle(
                p_person_id       => p_person_id,
                p_meta_id         => p_meta_id,

                p_key_id          => p_key_id,
                p_apprl_action_id => p_apprl_action_id,
                p_approval_action => p_approval_action,

                p_message_type    => p_message_type,
                p_message_text    => p_message_text
            );
            If p_message_type = ok Then
                If p_approval_action = ok Then
                    If trunc(p_effective_transfer_date) <= trunc(sysdate) Then
                        pkg_dg_mid_transfer_costcode_approvals.sp_update_approval_cycle(
                            p_person_id       => p_person_id,
                            p_meta_id         => p_meta_id,

                            p_key_id          => p_key_id,
                            p_apprl_action_id => c_job_schedule_action_id,
                            p_approval_action => p_approval_action,

                            p_message_type    => p_message_type,
                            p_message_text    => p_message_text
                        );

                        Select
                            mtc.emp_no, mtt.description
                        Into
                            v_emp_no, v_description
                        From
                            dg_mid_transfer_costcode                           mtc, dg_mid_transfer_type mtt
                        Where
                            mtc.transfer_type_fk = mtt.value
                            And key_id           = Trim(p_key_id);

                        timecurr.hr_pkg_costmast_main.sp_dg_empl_costcode_update(
                            p_person_id          => p_person_id,
                            p_meta_id            => p_meta_id,

                            p_empno              => v_emp_no,
                            p_transfer_type      => v_description,
                            p_costcode           => Null,
                            p_desgcode           => Null,
                            p_job_group_code     => Null,
                            p_jobdiscipline_code => Null,
                            p_jobtitle_code      => Null,

                            p_message_type       => p_message_type,
                            p_message_text       => p_message_text);
                    End If;
                End If;
                If p_message_type = ok Then
                    Commit;
                    p_message_type := ok;
                    p_message_text := 'Procedure executed successfully.';
                Else
                    Rollback;
                    p_message_type := not_ok;
                    p_message_text := 'Error while approving.';
                End If;
            End If;

        Else
            p_message_type := not_ok;
            p_message_text := 'No matching Costcode transfer exists !!!';
        End If;

    Exception
        When dup_val_on_index Then
            Rollback;
            p_message_type := not_ok;
            p_message_text := 'Costcode transfer already exists !!!';
        When Others Then
            Rollback;
            p_message_type := not_ok;
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
    End sp_hr_approval_return_transfer_costcode;

    Procedure sp_hod_temporary_transfer_post_approval(
        p_person_id         Varchar2,
        p_meta_id           Varchar2,

        p_key_id            Varchar2,
        p_approval_remarks  Varchar2 Default Null,
        p_transfer_end_date Date,

        p_message_type Out  Varchar2,
        p_message_text Out  Varchar2
    ) As
        v_empno            Varchar2(5);
        v_is_used          Number;
        v_exists           Number      := 0;
        v_user_tcp_ip      Varchar2(5) := 'NA';
        v_message_type     Number      := 0;
        v_transfer_type_fk dg_mid_transfer_costcode.transfer_type_fk%Type;
        v_status           dg_mid_transfer_costcode.status%Type;
        v_transfer_date    dg_mid_transfer_costcode.transfer_date%Type;
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            p_message_type := not_ok;
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        Begin
            Select
                transfer_type_fk, status, transfer_date
            Into
                v_transfer_type_fk, v_status, v_transfer_date
            From
                dg_mid_transfer_costcode
            Where
                key_id = p_key_id;
            If c_approved = v_status Then
                v_exists := 1;
            End If;
        Exception
            When Others Then
                v_exists := 0;
        End;

        If v_exists = 1 Then
            If v_transfer_type_fk = 1 Then                
                If trunc(p_transfer_end_date) <= trunc(v_transfer_date) Then
                    p_message_type := not_ok;
                    p_message_text := 'Error...Invalid Transfer end date !!!';
                    Return;
                End If;
                
                Update
                    dg_mid_transfer_costcode
                Set
                    transfer_end_date = p_transfer_end_date,
                    modified_on = sysdate,
                    modified_by = v_empno
                Where
                    key_id     = p_key_id
                    And status = c_approved;

                Insert Into dg_mid_transfer_costcode_post_approvals_log (
                    key_id,
                    transfer_end_date,
                    remarks,
                    modified_on,
                    modified_by
                )
                Values (
                    p_key_id,
                    p_transfer_end_date,
                    p_approval_remarks,
                    sysdate,
                    v_empno
                );
                
                pkg_dg_mail.sp_costcode_change_email(
                    p_person_id    => p_person_id,
                    p_meta_id      => p_meta_id,
                    
                    p_key_id       => p_key_id,
                    p_email_stage  => c_costcode_extention,                               

                    p_message_type => p_message_type,
                    p_message_text => p_message_text
                );   
                
                If p_message_type = not_ok Then
                    p_message_type := not_ok;
                    p_message_text := 'Success..but error occured while mailing...';
                    Return;
                End If;                

            Else
                p_message_type := not_ok;
                p_message_text := 'Error...Invalid transfer type !!!';
                Return;
            End If;

            Commit;
            p_message_type := ok;
            p_message_text := 'Procedure executed successfully.';

        Else
            p_message_type := not_ok;
            p_message_text := 'No matching Costcode transfer exists !!!';
        End If;

    Exception
        When dup_val_on_index Then
            Rollback;
            p_message_type := not_ok;
            p_message_text := 'Costcode transfer already exists !!!';
        When Others Then
            Rollback;
            p_message_type := not_ok;
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
    End sp_hod_temporary_transfer_post_approval;

    Procedure sp_add_dg_mid_transfer_costcode_perm_payoll(
        p_person_id               Varchar2,
        p_meta_id                 Varchar2,

        p_key_id                  Varchar2,        
        
        p_desgcode                Varchar2,
        p_job_group_code          Varchar2,
        p_jobdiscipline_code      Varchar2,
        p_jobtitle_code           Varchar2,

        p_message_type Out        Varchar2,
        p_message_text Out        Varchar2
    ) As
        v_empno            Varchar2(5);                      
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            p_message_type := not_ok;
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        Insert Into dg_mid_transfer_costcode_perm_payroll
            Select * from dg_mid_transfer_costcode
            Where key_id = trim(p_key_id);

        Update dg_mid_transfer_costcode_perm_payroll
            Set desgcode = Trim(p_desgcode),
                job_group_code = Trim(p_job_group_code),
                jobdiscipline_code = Trim(p_jobdiscipline_code),
                jobtitle_code = Trim(p_jobtitle_code),
                modified_on = sysdate,
                modified_by = v_empno
        Where key_id = trim(p_key_id);
        
        p_message_type := ok;
        p_message_text := 'Procedure executed successfully.';

    Exception
        When dup_val_on_index Then
            Rollback;
            p_message_type := not_ok;
            p_message_text := 'Costcode transfer already exists !!!';
        When Others Then
            Rollback;
            p_message_type := not_ok;
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
    End sp_add_dg_mid_transfer_costcode_perm_payoll;

End pkg_dg_mid_transfer_costcode;