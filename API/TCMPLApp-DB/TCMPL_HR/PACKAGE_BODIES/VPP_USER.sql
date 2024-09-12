Create Or Replace Package Body tcmpl_hr.vpp_user As

    Procedure sp_vpp_add(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,
        p_empno            Varchar2,
        p_name             Varchar2,
        p_relation_id      Varchar2,
        p_dob              Date,
        p_gender           Varchar2,
        p_insured_sum_id   Varchar2,
        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_empno     Varchar2(5);
        v_key_id    Varchar2(8);
        v_count     Number;
        v_config_id Varchar2(8);
    Begin
        v_empno        := tcmpl_app_config.app_users.get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            p_message_type := 'KO';
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        Begin
            Select
                key_id
            Into
                v_key_id
            From
                vpp_voluntary_parent_policy
            Where
                empno = Trim(p_empno);

            sp_vpp_detail_add(
                p_person_id    => p_person_id,
                p_meta_id      => p_meta_id,
                p_key_id       => v_key_id,
                p_name         => p_name,
                p_relation_id  => p_relation_id,
                p_dob          => p_dob,
                p_gender       => p_gender,
                p_message_type => p_message_type,
                p_message_text => p_message_text
            );

            Commit;
        Exception
            When no_data_found Then
                Select
                    Count(key_id)
                Into
                    v_count
                From
                    vpp_config
                Where
                    is_initiate_config = 1
                    And is_draft       = 0;

                If v_count = 0 Then
                    p_message_type := 'KO';
                    p_message_text := 'Invalid request. Configuration not found';
                    Return;
                End If;

                Select
                    key_id
                Into
                    v_config_id
                From
                    vpp_config
                Where
                    is_initiate_config = 1
                    And is_draft       = 0;

                v_key_id := dbms_random.string('X', 8);
                Insert Into vpp_voluntary_parent_policy (
                    key_id,
                    empno,
                    insured_sum_id,
                    modified_on,
                    modified_by,
                    config_key_id
                )
                Values (
                    v_key_id,
                    Trim(p_empno),
                    Trim(p_insured_sum_id),
                    sysdate,
                    v_empno,
                    v_config_id
                );

                sp_vpp_detail_add(
                    p_person_id    => p_person_id,
                    p_meta_id      => p_meta_id,
                    p_key_id       => v_key_id,
                    p_name         => p_name,
                    p_relation_id  => p_relation_id,
                    p_dob          => p_dob,
                    p_gender       => p_gender,
                    p_message_type => p_message_type,
                    p_message_text => p_message_text
                );

        End;

        p_message_type := c_ok;
        p_message_text := 'Procedure executed successfully.';
    End sp_vpp_add;

    Procedure sp_vpp_update(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,
        p_key_id           Varchar2,
        p_insured_sum_id   Varchar2,
        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_empno               Varchar2(5);
        v_count               Number;
        v_config_id           Varchar2(8);
        v_old_insured_sum_id  Varchar2(8);
        v_new_insured_sum_amt Number;
        v_old_insured_sum_amt Number;
    Begin
        v_empno        := tcmpl_app_config.app_users.get_empno_from_meta_id(p_meta_id);

        If v_empno = 'ERRRR' Then
            p_message_type := 'KO';
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        Select
            Count(key_id)
        Into
            v_count
        From
            vpp_config
        Where
            is_initiate_config = 1
            And is_draft       = 0;

        If v_count = 0 Then
            p_message_type := 'KO';
            p_message_text := 'Invalid request. Configuration not found';
            Return;
        End If;

        Select
            new_insured_sum_amt,
            old_insured_sum_amt
        Into
            v_new_insured_sum_amt,
            v_old_insured_sum_amt
        From
            (
                Select
                    (
                        Select
                            nvl(insured_sum_amt, 0)
                        From
                            vpp_insured_sum_master
                        Where
                            insured_sum_id = Trim(p_insured_sum_id)
                    ) As new_insured_sum_amt,
                    (
                        Select
                            nvl(insured_sum_amt, 0)
                        From
                            vpp_insured_sum_master
                        Where
                            insured_sum_id = a.old_insured_sum_id
                    ) As old_insured_sum_amt
                From
                    vpp_voluntary_parent_policy a
                Where
                    key_id = Trim(p_key_id)
            );

        If v_new_insured_sum_amt < v_old_insured_sum_amt Then
            Select
                old_insured_sum_id
            Into
                v_old_insured_sum_id
            From
                vpp_voluntary_parent_policy
            Where
                key_id = Trim(p_key_id);

            p_message_type := 'KO';

            If v_old_insured_sum_id = 'I02' Then
                p_message_text := 'You can increase the Sum Insured limit, cannot decrease it';
                Return;
            End If;

            If v_old_insured_sum_id = 'I03' Then
                p_message_text := 'You cannot decrease the Sum Insured limit ';
                Return;
            End If;

        End If;

        Select
            key_id
        Into
            v_config_id
        From
            vpp_config
        Where
            is_initiate_config = 1
            And is_draft       = 0;

        Update
            vpp_voluntary_parent_policy
        Set
            insured_sum_id = Trim(p_insured_sum_id),
            config_key_id = v_config_id
        Where
            key_id      = Trim(p_key_id)
            And is_lock = 0;
        Commit;
        p_message_type := c_ok;
        p_message_text := 'Procedure executed successfully.';
    Exception
        When Others Then
            p_message_type := c_not_ok;
            p_message_text := 'Err - ' || sqlcode || ' - ' || sqlerrm;
    End sp_vpp_update;

    Procedure sp_vpp_delete(
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

        Delete
            From vpp_voluntary_parent_policy
        Where
            key_id = Trim(p_key_id);

        Commit;
        p_message_type := c_ok;
        p_message_text := 'Procedure executed successfully.';
    Exception
        When Others Then
            p_message_type := c_not_ok;
            p_message_text := 'Err - ' || sqlcode || ' - ' || sqlerrm;
    End sp_vpp_delete;

    Procedure sp_vpp_detail_add(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,
        p_key_id           Varchar2,
        p_name             Varchar2,
        p_relation_id      Varchar2,
        p_dob              Date,
        p_gender           Varchar2,
        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_empno     Varchar2(5);
        v_count     Number;
        v_config_id Varchar2(8);
    Begin
        v_empno        := tcmpl_app_config.app_users.get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            p_message_type := 'KO';
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        Insert Into vpp_voluntary_parent_policy_d (
            key_id,
            name,
            relation_id,
            dob,
            gender,
            modified_on,
            modified_by,
            f_key_id
        )
        Values (
            dbms_random.string('X', 8),
            Trim(p_name),
            Trim(p_relation_id),
            p_dob,
            Trim(p_gender),
            sysdate,
            v_empno,
            p_key_id
        );

        Commit;
        p_message_type := c_ok;
        p_message_text := 'Procedure executed successfully.';
    End sp_vpp_detail_add;

    Procedure sp_vpp_detail_delete(
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

        v_count        := vpp_hr_qry.fn_is_parent_delete_allowed(p_key_id_detail);

        If v_count = 1 Then
            p_message_type := not_ok;
            p_message_text := 'Delete not allowed, please contact HR';
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

            sp_vpp_delete(
                p_person_id    => p_person_id,
                p_meta_id      => p_meta_id,
                p_key_id       => p_key_id,
                p_message_type => p_message_type,
                p_message_text => p_message_text
            );

        End If;
        Commit;
        p_message_type := c_ok;
        p_message_text := 'Procedure executed successfully.';
    Exception
        When Others Then
            p_message_type := c_not_ok;
            p_message_text := 'Err - ' || sqlcode || ' - ' || sqlerrm;
    End sp_vpp_detail_delete;

    Procedure sp_vpp_lock(
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
            is_lock = 1,
            modified_on = sysdate,
            modified_by = v_empno
        Where
            key_id = Trim(p_key_id);

        Commit;
        p_message_type := c_ok;
        p_message_text := 'Procedure executed successfully.';
    Exception
        When Others Then
            p_message_type := c_not_ok;
            p_message_text := 'Err - ' || sqlcode || ' - ' || sqlerrm;
    End sp_vpp_lock;

End vpp_user;
/
Grant Execute On tcmpl_hr.vpp_user To tcmpl_app_config;
/