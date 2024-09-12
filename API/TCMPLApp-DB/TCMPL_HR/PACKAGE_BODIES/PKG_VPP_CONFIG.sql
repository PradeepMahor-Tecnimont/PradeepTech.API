Create Or Replace Package Body tcmpl_hr.pkg_vpp_config As

    Procedure sp_add_vpp_config(
        p_person_id            Varchar2,
        p_meta_id              Varchar2,
        p_end_date             Date,
        p_is_display_premium   Number,
        p_is_draft             Number,
        p_is_applicable_to_all Number,
        p_emp_joining_date     Date Default Null,
        p_json_obj             Blob Default Null,
        p_message_type Out     Varchar2,
        p_message_text Out     Varchar2
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

        sp_validate_vpp_config(
            p_person_id            => p_person_id,
            p_meta_id              => p_meta_id,
            p_key_id               => Null,
            p_validate_for_action  => 'ADD',
            p_start_date           => Null,
            p_end_date             => p_end_date,
            p_is_display_premium   => p_is_display_premium,
            p_is_draft             => p_is_draft,
            p_is_applicable_to_all => p_is_applicable_to_all,
            p_emp_joining_date     => p_emp_joining_date,
            p_is_initiate_config   => 0,
            p_json_obj             => p_json_obj,
            p_message_type         => p_message_type,
            p_message_text         => p_message_text
        );

        If p_message_type = not_ok Then
            Return;
        End If;
        v_keyid := dbms_random.string('X', 8);
        Insert Into vpp_config (
            key_id,
            start_date,
            end_date,
            is_display_premium,
            is_draft,
            emp_joining_date,
            is_initiate_config,
            is_applicable_to_all,
            created_by,
            created_on,
            modified_on
        )
        Values (
            v_keyid,
            Null,
            p_end_date,
            p_is_display_premium,
            p_is_draft,
            p_emp_joining_date,
            0,
            p_is_applicable_to_all,
            v_empno,
            sysdate,
            sysdate
        );

        If (Sql%rowcount > 0) Then
            Commit;

            p_message_type := ok;
            p_message_text := 'Configuration added successfully..';
            
            /*If p_is_applicable_to_all = 1 Then                 
                        sp_applicable_to_all_process(
                                                    p_person_id => p_person_id,
                                                    p_meta_id => p_meta_id,
                                                    p_key_id => v_keyid,
                                                    p_message_type => p_message_type,
                                                    p_message_text => p_message_text
                        );               
                End If;*/

        End If;

    Exception
        When Others Then
            Rollback;
            p_message_type := not_ok;
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
    End sp_add_vpp_config;

    Procedure sp_update_vpp_config(
        p_person_id            Varchar2,
        p_meta_id              Varchar2,
        p_key_id               Varchar2,
        p_end_date             Date,
        p_is_display_premium   Number,
        p_is_draft             Number,
        p_is_applicable_to_all Number,
        p_emp_joining_date     Date Default Null,
        p_json_obj             Blob Default Null,
        p_message_type Out     Varchar2,
        p_message_text Out     Varchar2
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

        Select
            Count(*)
        Into
            v_exists
        From
            vpp_config
        Where
            key_id = p_key_id;

        If v_exists = 1 Then
            If p_is_draft = 1 Then
                Update
                    vpp_config
                Set
                    end_date = p_end_date,
                    is_display_premium = p_is_display_premium,
                    is_applicable_to_all = p_is_applicable_to_all,
                    emp_joining_date = p_emp_joining_date,
                    modified_by = v_empno,
                    modified_on = sysdate
                Where
                    key_id = p_key_id;
                If (Sql%rowcount > 0) Then
                    Commit;
                    p_message_type := ok;
                    p_message_text := 'Configuration updated successfully.';
                End If;
                Return;
            End If;

            Update
                vpp_config
            Set
                end_date = p_end_date,
                is_display_premium = p_is_display_premium,
                is_draft = p_is_draft,
                emp_joining_date = p_emp_joining_date,
                is_applicable_to_all = p_is_applicable_to_all,
                modified_by = v_empno,
                modified_on = sysdate
            Where
                key_id = p_key_id
                And p_end_date >= sysdate;

            If (Sql%rowcount > 0) Then
                Commit;
                p_message_type := ok;
                p_message_text := 'Configuration updated successfully.';
            Else
                p_message_type := not_ok;
                p_message_text := 'Process execution failed!! Please check end date';
            End If;
        Else
            p_message_type := not_ok;
            p_message_text := 'No matching Configuration exists !!!';
        End If;

    Exception
        When dup_val_on_index Then
            p_message_type := not_ok;
            p_message_text := 'Configuration already exists !!!';
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
    End sp_update_vpp_config;

    Procedure sp_delete_vpp_config(
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
        v_empno        := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            p_message_type := not_ok;
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        /* Select
             Count(*)
         Into
             v_is_used
         From
             tblName
         Where
             keyId = p_keyId;

         If v_is_used > 0 Then
             p_message_type := not_ok;
             p_message_text := 'Record cannot be delete, this record already used !!!';
             Return;
         End If;
         */

        Delete
            From vpp_config
        Where
            key_id = p_key_id;

        Commit;
        p_message_type := ok;
        p_message_text := 'Record deleted successfully.';
    Exception
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
    End sp_delete_vpp_config;

    Procedure import_vpp_premium(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,
        p_config_key_id    Varchar2,
        p_json             Blob,
        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_exists        Number;
        v_empno         Varchar2(5);
        v_err_num       Number;
        v_xl_row_number Number := 0;
        is_error_in_row Boolean;
        v_count         Number;
        Cursor cur_json Is
            Select
                jt.*
            From
                Json_Table (p_json Format Json, '$[*]'
                    Columns (
                        insured_sum_id Varchar2 (3) Path '$.InsuredSumId',
                        persons        Number       Path '$.Persons',
                        premium        Number       Path '$.Premium',
                        lacs           Varchar2 (3) Path '$.Lacs',
                        gst_amt        Number       Path '$.GstAmt',
                        total_premium  Number       Path '$.TotalPremium'
                    )
                )
                As jt;

    Begin
        v_empno   := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            p_message_type := not_ok;
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        If p_config_key_id Is Null Then
            v_err_num       := v_err_num + 1;
            is_error_in_row := True;
            Return;
        End If;

        v_err_num := 0;
        For c1 In cur_json
        Loop
            is_error_in_row := False;
            v_xl_row_number := v_xl_row_number + 1;
            If c1.insured_sum_id Is Null Then
                v_err_num       := v_err_num + 1;
                is_error_in_row := True;
            End If;

            If c1.persons Is Null Then
                v_err_num       := v_err_num + 1;
                is_error_in_row := True;
            End If;

            If c1.premium Is Null Then
                v_err_num       := v_err_num + 1;
                is_error_in_row := True;
            End If;

            If c1.lacs Is Null Then
                v_err_num       := v_err_num + 1;
                is_error_in_row := True;
            End If;

            If c1.gst_amt Is Null Then
                v_err_num       := v_err_num + 1;
                is_error_in_row := True;
            End If;

            If c1.total_premium Is Null Then
                v_err_num       := v_err_num + 1;
                is_error_in_row := True;
            End If;

            If is_error_in_row = false Then
                Insert Into vpp_premium_master (
                    insured_sum_id,
                    persons,
                    premium,
                    lacs,
                    gst_amt,
                    total_premium,
                    config_key_id,
                    modified_on,
                    key_id
                )
                Values (
                    c1.insured_sum_id,
                    c1.persons,
                    c1.premium,
                    c1.lacs,
                    c1.gst_amt,
                    c1.total_premium,
                    p_config_key_id,
                    sysdate,
                    dbms_random.string('X', 10)
                );

            End If;
        End Loop;

        If v_err_num != 0 Then
            p_message_type := not_ok;
            p_message_text := 'Not all records were imported.';
        Else
            p_message_type := ok;
            p_message_text := 'File imported successfully.';
        End If;

        /*
            p_movemast_errors := tcmpl_app_config.pkg_process_excel_import_errors.fn_read_error_list(
                                                                                                        p_person_id => p_person_id,
                                                                                                        p_meta_id => p_meta_id
                                     );*/

        Commit;
    Exception
        When Others Then
            p_message_type := not_ok;
            p_message_text := sqlcode || ' - ' || sqlerrm;
    End import_vpp_premium;

    Procedure sp_initiate_config_process(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,
        p_key_id           Varchar2,
        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As

        v_empno        Varchar2(5);
        v_count        Varchar2(5);
        v_is_used      Number;
        v_user_tcp_ip  Varchar2(5) := 'NA';
        v_message_type Number      := 0;
    Begin
        v_empno        := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            p_message_type := not_ok;
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        Select
            Count(*)
        Into
            v_count
        From
            vpp_config
        Where
            key_id = p_key_id;

        If v_count = 0 Then
            p_message_type := not_ok;
            p_message_text := 'Process execution failed!!';
            Return;
        End If;

        Select
            Count(*)
        Into
            v_count
        From
            vpp_config
        Where
            trunc(start_date) < trunc(sysdate)
            And is_initiate_config = 0
            And is_draft           = 1;

        If v_count != 0 Then
            p_message_type := not_ok;
            p_message_text := 'Error :- Todays date record already exists.!!';
            Return;
        End If;

        Select
            Count(*)
        Into
            v_count
        From
            vpp_config
        Where
            sysdate Between start_date And end_date
            And is_initiate_config = 1
            And is_draft           = 0;

        If v_count != 0 Then
            p_message_type := not_ok;
            p_message_text := 'Error :- Todays date record already exists.!!';
            Return;
        End If;

        Select
            Count(*)
        Into
            v_count
        From
            vpp_config
        Where
            is_initiate_config = 1;

        If v_count != 0 Then
            p_message_type := not_ok;
            p_message_text := 'Process failed : Please De-Active previous config and try again';
            Return;
        End If;

        Select
            Count(*)
        Into
            v_count
        From
            vpp_premium_master
        Where
            config_key_id = p_key_id;

        /*
         If v_count = 0 Then
                p_message_type := not_ok;
                p_message_text := 'Process failed : Premium data set not found..';
                Return;
            End If;
            */

        Select
            Count(*)
        Into
            v_count
        From
            vpp_config
        Where
            start_date Is Null
            And key_id = p_key_id;

        If v_count = 1 Then
       
        Insert into vpp_voluntary_parent_policy_backup
        value (Select * from vpp_voluntary_parent_policy);

        Insert into vpp_voluntary_parent_policy_d_backup
        value (Select * from vpp_voluntary_parent_policy_d);
        
        commit;

            Update
                vpp_voluntary_parent_policy a

            Set
                a.old_insured_sum_id = a.insured_sum_id
            Where
                a.key_id In (
                    Select
                        b.key_id
                    From
                        vpp_voluntary_parent_policy b
                    Where
                        b.is_lock    = 1
                        And a.key_id = b.key_id
                );

            Update
                vpp_voluntary_parent_policy_d
            Set
                is_delete_allowed = 1
            Where
                f_key_id In(
                    Select
                        key_id
                    From
                        vpp_voluntary_parent_policy
                    Where
                        is_lock = 1
                );
            /*
            Insert Into vpp_backup (vpp_config, parent_key_id, application_id, empno, parents_name, relation_id, relation,
                        dob, gender, insured_sum_id,
                            insured_sum_words, modified_on, backup_on)
                        (
                            Select
                                vpp.config_key_id       As vpp_config,
                                vppd.key_id             As parent_key_id,
                                vpp.key_id              As application_id,
                                vpp.empno,
                                vppd.name               As parents_name,
                                rm.relation_id,
                                rm.relation,
                                vppd.dob                dob,
                                vppd.gender,
                                vpp.insured_sum_id,
                                ism.insured_sum_words,
                                trunc(vppd.modified_on) modified_on,
                                sysdate
                            From
                                vpp_voluntary_parent_policy   vpp,
                                vpp_voluntary_parent_policy_d vppd,
                                vpp_insured_sum_master        ism,
                                vpp_relation_master           rm,
                                vpp_grade_group_master        ggm,
                                vpp_vu_emplmast               ve
                            Where
                                vpp.key_id             = vppd.f_key_id
                                And vpp.is_lock        = 1
                                And vpp.insured_sum_id = ism.insured_sum_id
                                And vppd.relation_id   = rm.relation_id
                                And vpp.empno          = ve.empno
                                And ve.status          = 1
                                And ve.emptype In ('R', 'F')
                                And ism.is_active      = 1
                                And rm.is_active       = 1
                                And ggm.grade_grp      = substr(ve.grade, 1, 1)
                                And vppd.key_id Not In (
                                    Select
                                        parent_key_id
                                    From
                                        vpp_backup
                                )
                        );
            */
        End If;

        Update
            vpp_config
        Set
            is_initiate_config = 1,
            is_draft = 0,
            start_date = sysdate,
            modified_by = v_empno,
            modified_on = sysdate
        Where
            key_id = p_key_id;

        If (Sql%rowcount > 0) Then
            Commit;
            Select
                Count(*)
            Into
                v_count
            From
                vpp_premium_master
            Where
                config_key_id = p_key_id;

            If v_count = 0 Then
                Insert Into vpp_premium_master (
                    insured_sum_id,
                    persons,
                    premium,
                    lacs,
                    gst_amt,
                    total_premium,
                    config_key_id,
                    modified_on,
                    key_id
                )
                Values (
                    'I01',
                    1,
                    0,
                    '2',
                    0,
                    0,
                    p_key_id,
                    sysdate,
                    dbms_random.string('X', 10)
                );
                Insert Into vpp_premium_master (
                    insured_sum_id,
                    persons,
                    premium,
                    lacs,
                    gst_amt,
                    total_premium,
                    config_key_id,
                    modified_on,
                    key_id
                )
                Values (
                    'I01',
                    2,
                    0,
                    '2',
                    0,
                    0,
                    p_key_id,
                    sysdate,
                    dbms_random.string('X', 10)
                );
                Insert Into vpp_premium_master (
                    insured_sum_id,
                    persons,
                    premium,
                    lacs,
                    gst_amt,
                    total_premium,
                    config_key_id,
                    modified_on,
                    key_id
                )
                Values (
                    'I01',
                    3,
                    0,
                    '2',
                    0,
                    0,
                    p_key_id,
                    sysdate,
                    dbms_random.string('X', 10)
                );
                Insert Into vpp_premium_master (
                    insured_sum_id,
                    persons,
                    premium,
                    lacs,
                    gst_amt,
                    total_premium,
                    config_key_id,
                    modified_on,
                    key_id
                )
                Values (
                    'I01',
                    4,
                    0,
                    '2',
                    0,
                    0,
                    p_key_id,
                    sysdate,
                    dbms_random.string('X', 10)
                );
                Insert Into vpp_premium_master (
                    insured_sum_id,
                    persons,
                    premium,
                    lacs,
                    gst_amt,
                    total_premium,
                    config_key_id,
                    modified_on,
                    key_id
                )
                Values (
                    'I02',
                    1,
                    0,
                    '3',
                    0,
                    0,
                    p_key_id,
                    sysdate,
                    dbms_random.string('X', 10)
                );
                Insert Into vpp_premium_master (
                    insured_sum_id,
                    persons,
                    premium,
                    lacs,
                    gst_amt,
                    total_premium,
                    config_key_id,
                    modified_on,
                    key_id
                )
                Values (
                    'I02',
                    2,
                    0,
                    '3',
                    0,
                    0,
                    p_key_id,
                    sysdate,
                    dbms_random.string('X', 10)
                );
                Insert Into vpp_premium_master (
                    insured_sum_id,
                    persons,
                    premium,
                    lacs,
                    gst_amt,
                    total_premium,
                    config_key_id,
                    modified_on,
                    key_id
                )
                Values (
                    'I02',
                    3,
                    0,
                    '3',
                    0,
                    0,
                    p_key_id,
                    sysdate,
                    dbms_random.string('X', 10)
                );
                Insert Into vpp_premium_master (
                    insured_sum_id,
                    persons,
                    premium,
                    lacs,
                    gst_amt,
                    total_premium,
                    config_key_id,
                    modified_on,
                    key_id
                )
                Values (
                    'I02',
                    4,
                    0,
                    '3',
                    0,
                    0,
                    p_key_id,
                    sysdate,
                    dbms_random.string('X', 10)
                );
                Insert Into vpp_premium_master (
                    insured_sum_id,
                    persons,
                    premium,
                    lacs,
                    gst_amt,
                    total_premium,
                    config_key_id,
                    modified_on,
                    key_id
                )
                Values (
                    'I03',
                    1,
                    0,
                    '4',
                    0,
                    0,
                    p_key_id,
                    sysdate,
                    dbms_random.string('X', 10)
                );
                Insert Into vpp_premium_master (
                    insured_sum_id,
                    persons,
                    premium,
                    lacs,
                    gst_amt,
                    total_premium,
                    config_key_id,
                    modified_on,
                    key_id
                )
                Values (
                    'I03',
                    2,
                    0,
                    '4',
                    0,
                    0,
                    p_key_id,
                    sysdate,
                    dbms_random.string('X', 10)
                );
                Insert Into vpp_premium_master (
                    insured_sum_id,
                    persons,
                    premium,
                    lacs,
                    gst_amt,
                    total_premium,
                    config_key_id,
                    modified_on,
                    key_id
                )
                Values (
                    'I03',
                    3,
                    0,
                    '4',
                    0,
                    0,
                    p_key_id,
                    sysdate,
                    dbms_random.string('X', 10)
                );
                Insert Into vpp_premium_master (
                    insured_sum_id,
                    persons,
                    premium,
                    lacs,
                    gst_amt,
                    total_premium,
                    config_key_id,
                    modified_on,
                    key_id
                )
                Values (
                    'I03',
                    4,
                    0,
                    '4',
                    0,
                    0,
                    p_key_id,
                    sysdate,
                    dbms_random.string('X', 10)
                );
                 

            End If;
            sp_applicable_to_all_process(
                p_person_id    => p_person_id,
                p_meta_id      => p_meta_id,
                p_key_id       => p_key_id,
                p_message_type => p_message_type,
                p_message_text => p_message_text
            );

        End If;

        p_message_type := ok;
        p_message_text := 'Process exicuted successfully';
    Exception
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
    End sp_initiate_config_process;

    Procedure sp_applicable_to_all_process(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,
        p_key_id           Varchar2,
        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As

        v_empno        Varchar2(5);
        v_count        Varchar2(5);
        v_is_used      Number;
        v_user_tcp_ip  Varchar2(5) := 'NA';
        v_message_type Number      := 0;
    Begin
        v_empno        := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            p_message_type := not_ok;
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        Select
            Count(*)
        Into
            v_count
        From
            vpp_config
        Where
            is_draft                 = 0
            And is_applicable_to_all = 1
            And is_initiate_config   = 1
            And key_id               = p_key_id;

        If v_count = 1 Then
        
            -- Start Logs for old data
            Insert Into vpp_parent_policy_history
            Select
                dbms_random.string('X', 8),
                key_id,
                empno,
                insured_sum_id,
                modified_on,
                modified_by,
                is_lock,
                config_key_id
            From
                vpp_voluntary_parent_policy;
            -- End Logs for old data

            Update
                vpp_voluntary_parent_policy
            Set
                config_key_id = p_key_id;

            If (Sql%rowcount > 0) Then
                Commit;
                p_message_type := ok;
                p_message_text := 'Process exicuted successfully';
            Else
                Rollback;
                p_message_type := not_ok;
                p_message_text := 'Configuration record not inserted..!!';
                Return;
            End If;
        End If;
        Commit;
        p_message_type := ok;
        p_message_text := 'Process exicuted successfully';
    Exception
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
    End sp_applicable_to_all_process;

    Procedure sp_de_activate_vpp_config(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,
        p_key_id           Varchar2,
        p_end_date         Date,
        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As

        v_empno        Varchar2(5);
        v_count        Number;
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
            Count(*)
        Into
            v_count
        From
            vpp_config
        Where
            key_id                 = p_key_id
            And is_initiate_config = 1;

        If v_count = 0 Then
            p_message_type := not_ok;
            p_message_text := 'Process execution failed!!';
            Return;
        End If;

        Update
            vpp_config
        Set
            is_initiate_config = 0,
            end_date = p_end_date,
            modified_by = v_empno,
            modified_on = sysdate
        Where
            key_id             = p_key_id
            And
            --is_draft           = 0 And
            is_initiate_config = 1;

        If (Sql%rowcount > 0) Then
            Commit;
            p_message_type := ok;
            p_message_text := 'Process exicuted successfully';
        Else
            p_message_type := not_ok;
            p_message_text := 'Configuration record not inserted..!!';
            Return;
        End If;

    Exception
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
    End sp_de_activate_vpp_config;

    Procedure sp_validate_vpp_config(
        p_person_id            Varchar2,
        p_meta_id              Varchar2,
        p_key_id               Varchar2 Default Null,
        p_validate_for_action  Varchar2 Default Null,
        p_start_date           Date     Default Null,
        p_end_date             Date     Default Null,
        p_is_display_premium   Number   Default Null,
        p_is_draft             Number   Default Null,
        p_is_applicable_to_all Number   Default Null,
        p_emp_joining_date     Date     Default Null,
        p_is_initiate_config   Number   Default Null,
        p_json_obj             Blob     Default Null,
        p_message_type Out     Varchar2,
        p_message_text Out     Varchar2
    ) As

        v_empno                 Varchar2(5);
        v_count                 Number;
        v_user_tcp_ip           Varchar2(5) := 'NA';
        v_message_type          Number      := 0;
        v_last_emp_joining_date Date;
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            p_message_type := not_ok;
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        If p_validate_for_action = 'ADD' Then
            If sysdate >= p_end_date Then
                p_message_type := not_ok;
                p_message_text := 'Invalid closing date, Closing / End date should be future date.!!!';
                Return;
            End If;

            If (p_is_applicable_to_all = 0) Then
                Select
                    Max(emp_joining_date)
                Into
                    v_last_emp_joining_date
                From
                    vpp_config;

                Select
                    Count(*)
                Into
                    v_count
                From
                    vpp_config
                Where
                    p_emp_joining_date <= v_last_emp_joining_date;

                If v_count != 0 Then
                    p_message_type := not_ok;
                    p_message_text := 'Invalid joining date. Employee joining date should be greater than : '
                                      || v_last_emp_joining_date;
                    Return;
                End If;
            End If;

            If p_is_draft = 0 Then
                Select
                    Count(*)
                Into
                    v_count
                From
                    vpp_config
                Where
                    end_date >= p_end_date
                    And is_initiate_config = 1;

                If v_count > 0 Then
                    p_message_type := not_ok;
                    p_message_text := 'Non-Active /In-Draft Configuration already exists. Only one draft or non active is allowed.!!!';
                    Return;
                End If;
            End If;
            If p_is_draft = 1 Then
                Select
                    Count(*)
                Into
                    v_count
                From
                    vpp_config
                Where
                    is_draft = 1;

                If v_count > 0 Then
                    p_message_type := not_ok;
                    p_message_text := 'Error : Only one Draft record is allowed!!';
                    Return;
                End If;

            End If;

            If p_is_applicable_to_all = 0 Then
                If p_emp_joining_date Is Null Then
                    p_message_type := not_ok;
                    p_message_text := 'Error : Employee joining date is required.!!';
                    Return;
                End If;
            End If;
            Return;
        End If;

        Select
            Count(*)
        Into
            v_count
        From
            vpp_config
        Where
            key_id = p_key_id;

        If v_count = 0 Then
            p_message_type := not_ok;
            p_message_text := 'Record not found !!';
            Return;
        End If;
        If p_validate_for_action = 'UPDATE' Then
            -- All validation for New config
            Null;
            p_message_type := not_ok;
            p_message_text := 'Invalid employee number';
            Return;
        End If;
        If p_validate_for_action = 'ACTIVE' Then
            -- All validation for ACTIVE config
            Null;
            p_message_type := not_ok;
            p_message_text := 'Invalid employee number';
            Return;
        End If;
        If p_validate_for_action = 'DE_ACTIVE' Then
            -- All validation for DE_ACTIVE config
            Null;
            p_message_type := not_ok;
            p_message_text := 'Invalid employee number';
            Return;
        End If;
    Exception
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
    End sp_validate_vpp_config;

    Procedure sp_vpp_config(
        p_person_id              Varchar2,
        p_meta_id                Varchar2,
        p_empno                  Varchar2 Default Null,
        p_config_id          Out Varchar2,
        p_is_enable_mod      Out Number,
        p_is_display_premium Out Number,
        p_message_type       Out Varchar2,
        p_message_text       Out Varchar2
    ) As
        v_count        Number;
        v_empno        Varchar2(5);
        v_user_tcp_ip  Varchar2(5) := 'NA';
        v_message_type Number      := 0;
    Begin
        v_empno         := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            p_message_type := not_ok;
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        p_is_enable_mod := 0;
        p_message_type  := ok;
        p_message_text  := 'OK';
        --  p_is_enable_mod := 1;
        -- p_config_id     := 'NA';
     
        --  Return;

        If p_empno Is Not Null Then
            v_empno := p_empno;
        End If;
        If v_empno Is Null Then
            p_is_enable_mod      := 0;
            p_is_display_premium := 0;
            p_message_type       := not_ok;
            p_message_text       := 'Invalid employee number';
            Return;
        End If;

        Select
            Count(a.key_id)
        Into
            v_count
        From
            vpp_config a
        Where
            a.is_initiate_config = 1;

        If v_count = 1 Then
            Select
                key_id
            Into
                p_config_id
            From
                vpp_config
            Where
                is_initiate_config = 1;

        Else
            Select
                config_key_id
            Into
                p_config_id
            From
                vpp_voluntary_parent_policy
            Where
                empno = v_empno;
        End If;

        Select
            Count(a.key_id)
        Into
            v_count
        From
            vpp_config  a,
            vu_emplmast b
        Where
            a.is_initiate_config       = 1
            And a.is_applicable_to_all = 0
            And b.doj >= a.emp_joining_date
            And b.empno                = v_empno;

        If v_count = 1 Then
            Select
                key_id
            Into
                p_config_id
            From
                vpp_config
            Where
                is_initiate_config       = 1
                And is_draft             = 0
                And is_applicable_to_all = 0;

            p_is_enable_mod := 1;
            p_message_type  := ok;
            p_message_text  := 'Not Applicable To All..';
            Return;
        End If;

        Select
            Count(a.key_id)
        Into
            v_count
        From
            vpp_config a
        Where
            is_initiate_config       = 1
            And is_applicable_to_all = 1;

        If v_count = 1 Then
            p_is_enable_mod := 1;
        End If;
        p_message_type  := ok;
        p_message_text  := 'OK';
    Exception
        When no_data_found Then
            p_message_type := not_ok;
            p_message_text := 'Err - Data not found.';
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
    End sp_vpp_config;

    Procedure sp_auto_de_activate_vpp_config As

        v_empno        Varchar2(5);
        v_count        Number;
        v_user_tcp_ip  Varchar2(5) := 'NA';
        v_message_type Number      := 0;
    Begin
        Select
            Count(*)
        Into
            v_count
        From
            vpp_config
        Where
            is_initiate_config  = 1
            And trunc(end_date) = trunc(sysdate);

        If v_count = 0 Then
            Return;
        End If;
        Update
            vpp_config
        Set
            is_initiate_config = 0,
            end_date = sysdate,
            modified_by = 'Sys',
            modified_on = sysdate
        Where
            is_initiate_config  = 1
            And trunc(end_date) = trunc(sysdate);

        Commit;
    End sp_auto_de_activate_vpp_config;

End pkg_vpp_config;
/

Grant Execute On tcmpl_hr.pkg_vpp_config To tcmpl_app_config;