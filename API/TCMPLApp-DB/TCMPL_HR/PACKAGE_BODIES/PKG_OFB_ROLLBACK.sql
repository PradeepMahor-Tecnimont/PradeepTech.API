Create Or Replace Package Body tcmpl_hr.pkg_ofb_rollback As

    Procedure sp_ofb_rollback(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,
        p_empno            Varchar2,
        p_remarks          Varchar2,
        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_empno  Varchar2(5);
        v_exists Number;
    Begin
        v_empno        := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            p_message_type := 'KO';
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        Select
            Count(*)
        Into
            v_exists
        From
            ofb_rollback
        Where
            empno      = p_empno
            And status = 0;

        If v_exists > 0 Then
            p_message_type := not_ok;
            p_message_text := 'Error - record already exists..';
            Return;
        End If;

        Insert Into ofb_rollback (
            empno,
            status,
            remarks,
            requested_by,
            requested_on,
            approved_by,
            approved_on
        )
        Values (
            p_empno,
            0,
            p_remarks,
            v_empno,
            sysdate,
            Null,
            Null
        );

        Commit;
        p_message_type := 'OK';
        p_message_text := 'Procedure executed successfully.';
    Exception
        When Others Then
            p_message_type := not_ok;
            p_message_text := sqlcode || ' - ' || sqlerrm;
    End sp_ofb_rollback;

    Procedure sp_ofb_rollback_approve(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,
        p_empno            Varchar2,
        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_empno  Varchar2(5);
        v_exists Number;
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            p_message_type := 'KO';
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        Select
            Count(*)
        Into
            v_exists
        From
            ofb_rollback
        Where
            empno      = p_empno
            And status = 0;

        If v_exists = 0 Then
            p_message_type := not_ok;
            p_message_text := 'Error - record not exists..';
            Return;
        End If;

        Update
            ofb_rollback
        Set
            status = 1,
            approved_by = v_empno,
            approved_on = sysdate
        Where
            empno      = p_empno
            And status = 0;

        If (Sql%rowcount > 0) Then
            Delete
                From ofb_emp_exit_approvals
            Where
                empno = p_empno;
            Delete
                From ofb_emp_exits
            Where
                empno = p_empno;

            If (Sql%rowcount > 0) Then
                p_message_type := ok;
                p_message_text := 'Procedure executed successfully.';
            Else
                Rollback;
                p_message_type := not_ok;
                p_message_text := 'Error - Procedure not executed..';
            End If;
        Else
            Rollback;
            p_message_type := not_ok;
            p_message_text := 'Error - Procedure not executed..';
        End If;

        Commit;
    --p_message_type := 'OK';
    --p_message_text := 'Procedure executed successfully.';
    Exception
        When Others Then
            p_message_type := not_ok;
            p_message_text := sqlcode || ' - ' || sqlerrm;
    End sp_ofb_rollback_approve;

    Procedure sp_ofb_rollback_delete(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,
        p_empno            Varchar2,
        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_empno  Varchar2(5);
        v_exists Number;
    Begin
        v_empno        := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            p_message_type := 'KO';
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        Select
            Count(*)
        Into
            v_exists
        From
            ofb_rollback
        Where
            empno      = p_empno
            And status = 0;

        If v_exists = 0 Then
            p_message_type := not_ok;
            p_message_text := 'Error - record not exists..';
            Return;
        End If;

        Delete
            From ofb_rollback
        Where
            empno      = p_empno
            And status = 0;

        p_message_type := ok;
        p_message_text := 'Procedure executed successfully.';
    Exception
        When Others Then
            p_message_type := not_ok;
            p_message_text := sqlcode || ' - ' || sqlerrm;
    End sp_ofb_rollback_delete;

    Procedure sp_get_rollback_details(
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
            v_exists
        From
            ofb_rollback
        Where
            empno      = p_empno
            And status = 0;
			
        If v_exists > 0 Then
            p_message_type := not_ok;
            p_message_text := 'Error - Rollback already exists..';
            Return;
        Else
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
        End If;

        p_message_type := ok;
        p_message_text := 'Precedure execute successfully.';

    Exception
        When Others Then
            Rollback;
            p_message_type := not_ok;
            p_message_text := 'Err - ' || sqlcode || ' - ' || sqlerrm;

    End sp_get_rollback_details;
End pkg_ofb_rollback;