Create Or Replace Package Body "TCMPL_HR"."PKG_DG_TRANSFER_COSTCODE_JOB_SCHEDULER" As

    Procedure sp_job_schedule_approval_cycle As
        Cursor cur_dg_costcode Is
            Select
                key_id,
                transfer_type_fk,
                emp_no,
                pkg_dg_mid_transfer_costcode_qry.fun_get_transfer_type_desc(transfer_type_fk) transfer_type_desc
            From
                dg_mid_transfer_costcode
            Where
                status                             = 3
                And trunc(effective_transfer_date) = trunc(sysdate);

        v_message_type          Varchar2(2);
        v_message_text          Varchar2(4000);
        v_emp_no                Varchar2(5);
        v_description           dg_mid_transfer_type.description%Type;
        v_target_costcode       dg_mid_transfer_costcode.target_costcode%Type;
        v_desgcode              Char(6);
        v_job_group_code        dg_mid_transfer_costcode_perm_payroll.job_group_code%Type;
        v_jobdiscipline_code    dg_mid_transfer_costcode_perm_payroll.jobdiscipline_code%Type;    
        v_jobtitle_code         dg_mid_transfer_costcode_perm_payroll.jobtitle_code%Type;
    Begin

        For c1 In cur_dg_costcode
        Loop
            Begin
                --Update costcode transfer approvals table
                Update
                    dg_mid_transfer_costcode_approvals
                Set
                    is_approved = ok,
                    modified_on = sysdate,
                    modified_by = 'SYS',
                    remarks = 'By Job scheduler'
                Where
                    apprl_action_id = c_job_schedule_action_id
                    And key_id      = c1.key_id;
                
                --Update costcode transfer table
                Update
                    dg_mid_transfer_costcode
                Set
                    status = 1
                Where
                    status                             = 3
                    And trunc(effective_transfer_date) = trunc(sysdate)
                    And key_id                         = c1.key_id;
            
                --update emp details
                If c1.transfer_type_fk = 0 Then
                    Select
                        mtcpp.emp_no, mtt.description, mtcpp.target_costcode, mtcpp.desgcode, mtcpp.job_group_code, mtcpp.jobdiscipline_code, mtcpp.jobtitle_code
                    Into
                        v_emp_no, v_description, v_target_costcode, v_desgcode, v_job_group_code, v_jobdiscipline_code, v_jobtitle_code
                    From
                        dg_mid_transfer_costcode_perm_payroll mtcpp,
                        dg_mid_transfer_type     mtt
                    Where
                        mtcpp.transfer_type_fk = mtt.value
                        And key_id           = c1.key_id;
                Else
                    Select
                        mtc.emp_no, mtt.description, mtc.target_costcode, mtc.desgcode
                    Into
                        v_emp_no, v_description, v_target_costcode, v_desgcode
                    From
                        dg_mid_transfer_costcode mtc,
                        dg_mid_transfer_type     mtt
                    Where
                        mtc.transfer_type_fk = mtt.value
                        And key_id           = c1.key_id;
                End If;
                
                timecurr.hr_pkg_costmast_main.sp_dg_empl_costcode_update(
                    p_person_id             => Null,
                    p_meta_id               => Null,

                    p_empno                 => v_emp_no,
                    p_transfer_type         => v_description,
                    p_costcode              => v_target_costcode,
                    p_desgcode              => v_desgcode,
                    p_job_group_code        => v_job_group_code,
                    p_jobdiscipline_code    => v_jobdiscipline_code,
                    p_jobtitle_code         => v_jobtitle_code,                                      

                    p_message_type          => v_message_type,
                    p_message_text          => v_message_text);               

            Exception
                When Others Then
                    Rollback;                    
            End;
        End Loop;       

    Exception
        When Others Then
            Rollback;           
    End;

End pkg_dg_transfer_costcode_job_scheduler;