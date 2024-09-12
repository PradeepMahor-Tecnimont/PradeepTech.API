--------------------------------------------------------
--  DDL for Package Body PKG_VPP_HR
--------------------------------------------------------

Create Or Replace Package Body tcmpl_hr.vpp_hr As

    Procedure sp_vpp_unlock(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_key_id           Varchar2,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_empno Varchar2(5);
    Begin
        v_empno        := tcmpl_app_config.app_users.get_empno_from_meta_id(p_meta_id);

        If v_empno = 'ERRRR' Then
            p_message_type := 'KO';
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        Update
            vpp_voluntary_parent_policy
        Set
            is_lock = 0, modified_on = sysdate, modified_by = v_empno
        Where
            key_id      = Trim(p_key_id)
            And is_lock = 1;

        Commit;

        p_message_type := 'OK';
        p_message_text := 'Procedure executed successfully.';

    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'Err - ' || sqlcode || ' - ' || sqlerrm;

    End sp_vpp_unlock;

    Procedure sp_hr_vpp_detail_delete(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,
        p_key_id           Varchar2,
        p_key_id_detail    Varchar2,
        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_empno Varchar2(5);
        v_count Number;
    Begin
        v_empno        := tcmpl_app_config.app_users.get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            p_message_type := 'KO';
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        Delete
            From vpp_voluntary_parent_policy_d
        Where
            key_id = Trim(p_key_id_detail);

        Select
            Count(key_id)
        Into
            v_count
        From
            vpp_voluntary_parent_policy_d
        Where
            f_key_id = Trim(p_key_id);

        If v_count = 0 Then

            tcmpl_hr.vpp_user.sp_vpp_delete(
                p_person_id    => p_person_id,
                p_meta_id      => p_meta_id,
                p_key_id       => p_key_id,
                p_message_type => p_message_type,
                p_message_text => p_message_text
            );

        End If;
        Commit;
        p_message_type := ok;
        p_message_text := 'Procedure executed successfully.';
    Exception
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'Err - ' || sqlcode || ' - ' || sqlerrm;
    End sp_hr_vpp_detail_delete;

End vpp_hr;
/
Grant Execute On tcmpl_hr.vpp_hr To tcmpl_app_config;
/