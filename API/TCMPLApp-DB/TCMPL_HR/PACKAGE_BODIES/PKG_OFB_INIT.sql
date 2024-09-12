Create Or Replace Package Body tcmpl_hr.pkg_ofb_init As

    Procedure sp_add_ofb(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_empno            Varchar2,
        p_end_by_date      Date,
        p_relieving_date   Date,
        p_resignation_date Date,
        p_remarks          Varchar2,
        p_address          Varchar2 Default Null,
        p_primary_mobile   Varchar2 Default Null,
        p_alternate_mobile Varchar2 Default Null,
        p_email_id         Varchar2 Default Null,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_by_empno          Varchar2(5);
        v_key_id            Varchar2(8);
        v_exists            Number;
        v_from_costcode     Varchar2(4);
        v_status            Number;
        v_count             Number;
        v_emp_parent        Varchar2(4);
        v_emptype           Varchar2(1);
        c_apprl_cycle_rf    Constant Varchar2(4) := 'T001';
        c_apprl_cycle_c     Constant Varchar2(4) := 'T002';
        c_apprl_cycle_s     Constant Varchar2(4) := 'T003';
        v_apprl_template_id Varchar2(4);
    Begin
        v_by_empno     := get_empno_from_meta_id(p_meta_id);

        If v_by_empno = 'ERRRR' Then
            p_message_type := not_ok;
            p_message_text := 'Invalid employee number';
            Return;
        End If;
        Select
            parent,
            emptype
        Into
            v_emp_parent,
            v_emptype
        From
            vu_emplmast
        Where
            empno = p_empno;
        Select
            Count(*)
        Into
            v_count
        From
            ofb_vu_emp_exits
        Where
            empno = p_empno;
        If v_count > 0 Then
            p_message_type := not_ok;
            p_message_text := 'Err - OffBoarding for employee already exists.';
            Return;
        End If;

        Insert Into ofb_emp_exits (
            empno,
            parent,
            end_by_date,
            relieving_date,
            resignation_date,
            remarks,
            address,
            mobile_primary,
            alternate_number,
            email_id,
            created_by,
            created_on
        )
        Values (
            p_empno,
            v_emp_parent,
            p_end_by_date,
            p_relieving_date,
            p_resignation_date,
            p_remarks,
            p_address,
            p_primary_mobile,
            p_alternate_mobile,
            p_email_id,
            v_by_empno,
            sysdate
        );
        If v_emptype In ('R', 'F') Then
            v_apprl_template_id := c_apprl_cycle_rf;
        Elsif v_emptype = 'C' Then
            v_apprl_template_id := c_apprl_cycle_c;
        Elsif v_emptype = 'S' Then
            v_apprl_template_id := c_apprl_cycle_s;
        Else

            p_message_type := not_ok;
            p_message_text := 'Err - Invalid emptype defined in master.';
            Return;
        End If;
        Insert Into ofb_emp_exit_approvals (
            empno,
            tm_key_id,
            tg_key_id,
            action_id,
            apprl_action_id,
            parent_apprl_action_id,
            apprl_action_step,
            apprl_group_step,
            sort_order
        )
        Select
            p_empno,
            tm_key_id,
            tg_key_id,
            ra.action_id,
            apprl_action_id,
            parent_apprl_id,
            action_step,
            group_step,
            t.sort_order
        From
            ofb_apprl_template_details t,
            ofb_role_actions           ra
        Where
            tm_key_id             = v_apprl_template_id
            And t.apprl_action_id = ra.nu_action_id(+);
        Commit;

        pkg_ofb_mail.send_mail_new_ofb(p_empno);

        tcmpl_app_config.pkg_generate_user_access.sp_gen_access_for_ofb_user(p_empno);
        p_message_type := ok;
        p_message_text := 'Precedure execute successfully.';
    Exception
        When Others Then
            Rollback;
            p_message_type := not_ok;
            p_message_text := 'Err - ' || sqlcode || ' - ' || sqlerrm;
    End;

    Procedure sp_update_ofb(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_empno            Varchar2,
        p_end_by_date      Date,
        p_relieving_date   Date,
        p_resignation_date Date,
        p_remarks          Varchar2,
        p_address          Varchar2 Default Null,
        p_primary_mobile   Varchar2 Default Null,
        p_alternate_mobile Varchar2 Default Null,
        p_email_id         Varchar2 Default Null,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_by_empno Varchar2(5);
    Begin
        v_by_empno     := get_empno_from_meta_id(p_meta_id);
        If v_by_empno = 'ERRRR' Then
            p_message_type := not_ok;
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        Update
            ofb_emp_exits
        Set
            end_by_date = p_end_by_date,
            relieving_date = p_relieving_date,
            resignation_date = p_resignation_date,
            remarks = p_remarks,
            address = p_address,
            mobile_primary = p_primary_mobile,
            alternate_number = p_alternate_mobile,
            email_id = p_email_id,
            modified_by = v_by_empno,
            modified_on = sysdate
        Where
            empno = p_empno;
        p_message_type := ok;
        p_message_text := 'Precedure execute successfully.';
    Exception
        When Others Then
            Rollback;
            p_message_type := not_ok;
            p_message_text := 'Err - ' || sqlcode || ' - ' || sqlerrm;

    End;

    Procedure sp_get_details(
        p_person_id            Varchar2,
        p_meta_id              Varchar2,

        p_empno            In  Varchar2,
        p_end_by_date      Out Date,
        p_relieving_date   Out Date,
        p_resignation_date Out Date,
        p_remarks          Out Varchar2,
        p_address          Out Varchar2,
        p_primary_mobile   Out Varchar2,
        p_alternate_mobile Out Varchar2,
        p_email_id         Out Varchar2,

        p_emp_ofb_exists   Out Varchar2,

        p_message_type     Out Varchar2,
        p_message_text     Out Varchar2
    ) As
        v_by_empno          Varchar2(5);
        v_key_id            Varchar2(8);
        v_exists            Number;
        v_from_costcode     Varchar2(4);
        v_status            Number;
        v_count             Number;
        v_emp_parent        Varchar2(4);
        v_emptype           Varchar2(1);
        c_apprl_cycle_rf    Constant Varchar2(4) := 'T001';
        c_apprl_cycle_c     Constant Varchar2(4) := 'T002';
        c_apprl_cycle_s     Constant Varchar2(4) := 'T003';
        v_apprl_template_id Varchar2(4);
    Begin
        v_by_empno     := get_empno_from_meta_id(p_meta_id);

        If v_by_empno = 'ERRRR' Then
            p_message_type := not_ok;
            p_message_text := 'Invalid employee number';
            Return;
        End If;
        Select
            Count(*)
        Into
            v_count
        From
            ofb_vu_emp_exits
        Where
            empno = p_empno;

        If v_count > 0 Then
            p_emp_ofb_exists := ok;
            Select
                end_by_date,
                relieving_date,
                resignation_date,
                remarks,
                address,
                mobile_primary,
                alternate_number,
                email_id
            Into
                p_end_by_date,
                p_relieving_date,
                p_resignation_date,
                p_remarks,
                p_address,
                p_primary_mobile,
                p_alternate_mobile,
                p_email_id
            From
                ofb_emp_exits
            Where
                empno = p_empno;
        Else
            p_emp_ofb_exists := not_ok;
            Select
                Count(*)
            Into
                v_count
            From
                mis_resigned_emp
            Where
                empno = p_empno;
            If v_count > 0 Then
                Select
                    emp_resign_date,
                    date_of_relieving
                Into
                    p_resignation_date,
                    p_relieving_date
                From
                    mis_resigned_emp
                Where
                    empno = p_empno;
            End If;
        End If;
        p_message_type := ok;
        p_message_text := 'Precedure execute successfully.';
    Exception
        When Others Then
            Rollback;
            p_message_type := not_ok;
            p_message_text := 'Err - ' || sqlcode || ' - ' || sqlerrm;

    End;
End;