Create Or Replace Package Body "TCMPL_HR"."PKG_DG_MID_TRANSFER_COSTCODE_APPROVALS" As

    Procedure sp_add_approval_cycle(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_key_id           Varchar2,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_empno Varchar2(5);
    Begin
        v_empno        := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            p_message_type := not_ok;
            p_message_text := 'Employee not found';
            Return;
        End If;

        Insert Into dg_mid_transfer_costcode_approvals
        Select
        Distinct
            mtc.key_id,
            Null,
            Null,
            Null,
            atd.dg_key_id,
            atd.apprl_action_id,
            atd.action_step,
            atd.sort_order,
            atd.parent_apprl_id,
            Null
        From
            dg_mid_transfer_costcode  mtc,
            dg_apprl_template_details atd,
            dg_apprl_template_master  atm,
            dg_mid_transfer_type      mtt
        Where
            atm.dg_key_id     = atd.dg_key_id
            And atm.dg_key_id = mtt.dg_key_id
            And mtt.value     = mtc.transfer_type_fk
            And mtc.key_id    = Trim(p_key_id);

        p_message_type := ok;
        p_message_text := 'Procedure executed successfully';
    Exception
        When Others Then
            Rollback;
            p_message_type := not_ok;
            p_message_text := 'Err - ' || sqlcode || ' - ' || sqlerrm;
    End;

    Procedure sp_update_approval_cycle(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_key_id           Varchar2,
        p_apprl_action_id  Varchar2,
        p_approval_action  Varchar2,
        p_approval_remarks Varchar2 Default Null,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_empno Varchar2(5);
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            p_message_type := not_ok;
            p_message_text := 'Employee not found';
            Return;
        End If;

        Update
            dg_mid_transfer_costcode_approvals
        Set
            is_approved = p_approval_action,
            remarks = p_approval_remarks,
            modified_on = sysdate,
            modified_by = Trim(v_empno)
        Where
            key_id              = Trim(p_key_id)
            And is_approved Is Null
            And apprl_action_id = p_apprl_action_id;

        If Sql%found Then
            p_message_type := ok;
            p_message_text := 'Procedure executed successfully';
        Else
            p_message_type := not_ok;
            p_message_text := 'Invalid transfer operation';
        End If;
    Exception
        When Others Then
            Rollback;
            p_message_type := not_ok;
            p_message_text := 'Err - ' || sqlcode || ' - ' || sqlerrm;
    End;

    Procedure sp_update_transfer_type(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_key_id           Varchar2,
        p_transfer_type    Number,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_empno       Varchar2(5);
        v_dg_key_id   dg_apprl_template_master.dg_key_id%Type;
        v_dg_key_id_1 dg_apprl_template_master.dg_key_id%Type;
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            p_message_type := not_ok;
            p_message_text := 'Employee not found';
            Return;
        End If;

        Select
            dg_key_id
        Into
            v_dg_key_id
        From
            dg_mid_transfer_type
        Where
            value = p_transfer_type;

        Select
        Distinct dg_key_id
        Into
            v_dg_key_id_1
        From
            dg_mid_transfer_costcode_approvals
        Where
            key_id = Trim(p_key_id);

        If v_dg_key_id <> v_dg_key_id_1 Then
            Update
                dg_mid_transfer_costcode_approvals
            Set
                dg_key_id = v_dg_key_id,
                modified_on = sysdate,
                modified_by = Trim(v_empno)
            Where
                key_id = Trim(p_key_id);

            If Sql%found Then
                p_message_type := ok;
                p_message_text := 'Procedure executed successfully';
            Else
                p_message_type := not_ok;
                p_message_text := 'Invalid transfer operation';
            End If;
        End If;
    Exception
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'Err - ' || sqlcode || ' - ' || sqlerrm;
    End;

    Procedure sp_delete_approval_cycle(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_key_id           Varchar2,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_empno Varchar2(5);
    Begin
        v_empno        := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            p_message_type := not_ok;
            p_message_text := 'Employee not found';
            Return;
        End If;

        Delete
            From dg_mid_transfer_costcode_approvals
        Where
            key_id = Trim(p_key_id);

        p_message_type := ok;
        p_message_text := 'Procedure executed successfully';
    Exception
        When Others Then
            Rollback;
            p_message_type := not_ok;
            p_message_text := 'Err - ' || sqlcode || ' - ' || sqlerrm;
    End;

End pkg_dg_mid_transfer_costcode_approvals;