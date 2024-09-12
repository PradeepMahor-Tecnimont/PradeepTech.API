-----------------------------------------------------
--  DDL for Package Body PKG_INV_TRANSACTIONS
-----------------------------------------------------

Create Or Replace Package Body dms.pkg_inv_transactions As

    Procedure sp_add_transaction(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,
        p_trans_id         Varchar2 Default Null,
        p_trans_date       Date     Default Null,
        p_empno            Varchar2 Default Null,
        p_trans_type_id    Varchar2 Default Null,
        p_remarks          Varchar2 Default Null,
        p_item_id          Varchar2,
        p_item_usable      Varchar2,

        p_get_trans_id Out Varchar2,
        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_empno         Varchar2(5);
        v_trans_id      inv_transaction_master.trans_id%Type;
        v_trans_details Varchar2(22);
        v_item_type     Varchar2(2);
    Begin
        v_empno        := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            p_message_type := 'KO';
            p_message_text := 'Invalid employee number';
            Return;
        End If;
        Begin
            Select
                assettype
            Into
                v_item_type
            From
                dm_assetcode
            Where
                barcode = Trim(p_item_id);
        Exception
            When Others Then
                v_item_type := Null;
        End;

        If p_trans_id Is Null Then

            v_trans_id := dbms_random.string('X', 10);

            Insert Into inv_transaction_master (
                trans_id,
                trans_date,
                empno,
                trans_type_id,
                remarks,
                modified_by,
                modified_on,
                item_type
            )
            Values (
                v_trans_id,
                p_trans_date,
                p_empno,
                p_trans_type_id,
                Trim(p_remarks),
                v_empno,
                sysdate,
                v_item_type
            );

            /*
            Select trans_id
                Into v_trans_id
                From (
                         Select trans_id
                           From inv_transaction_master
                          Order By modified_on Desc
                     )
               Where Rownum = 1;
            */
        Else
            v_trans_id := p_trans_id;
        End If;

        p_get_trans_id := v_trans_id;
        pkg_inv_transactions_detail.sp_add_consumable(
            p_person_id    => p_person_id,
            p_meta_id      => p_meta_id,
            p_trans_id     => v_trans_id,
            p_item_id      => p_item_id,
            p_item_usable  => p_item_usable,
            p_item_type    => v_item_type,
            p_message_type => p_message_type,
            p_message_text => p_message_text
        );

        If p_message_type = c_not_ok Then
            Rollback;
            Return;
        End If;

        If p_trans_type_id = c_trans_reserve_id Then
            /*
            Update
                inv_consumables_detail
            Set
                is_issued = 'Y'
            Where
                item_id = Trim(p_item_id);
            */
            Null;
        Else
            sp_refresh_emp_item_mapping(
                p_person_id    => p_person_id,
                p_meta_id      => p_meta_id,
                p_trans_id     => v_trans_id,
                p_item_id      => p_item_id,
                p_empno        => p_empno,
                p_trans_mode   => p_trans_type_id,
                p_message_type => p_message_type,
                p_message_text => p_message_text
            );

            If p_message_type = c_not_ok Then
                Rollback;
                Return;
            End If;
        End If;

        Commit;
        p_message_type := 'OK';
        p_message_text := 'Procedure executed successfully.';
    Exception
        When Others Then
            Rollback;
            p_message_type := 'KO';
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
    End sp_add_transaction;

    Procedure sp_update_transaction(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,
        p_trans_id         Varchar2,
        p_remarks          Varchar2 Default Null,
        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_empno         Varchar2(5);
        v_trans_details Varchar2(22);
        n_count         Number;
    Begin
        v_empno        := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            p_message_type := 'KO';
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        Update
            inv_transaction_master
        Set
            remarks = p_remarks
        Where
            trans_id = Trim(p_trans_id);

        Commit;
        p_message_type := 'OK';
        p_message_text := 'Procedure executed successfully.';
    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
    End sp_update_transaction;

    Procedure sp_delete_transaction(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,
        p_trans_id         Varchar2,
        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_empno Varchar2(5);
    Begin
        v_empno        := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            p_message_type := 'KO';
            p_message_text := 'Invalid employee number';
            Return;
        End If;
        /*
                Update
                    inv_consumables_detail
                Set
                    is_issued = 'N'
                Where
                    item_id In (
                        Select
                            item_id
                        From
                            inv_transaction_detail
                        Where
                            trans_id = Trim(p_trans_id)
                    );
        */
        Delete
            From inv_transaction_detail
        Where
            trans_id = Trim(p_trans_id);

        Delete
            From inv_transaction_master
        Where
            trans_id = Trim(p_trans_id);

        Commit;
        p_message_type := 'OK';
        p_message_text := 'Procedure executed successfully.';
    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
    End sp_delete_transaction;

    Procedure sp_delete_return_reserve_transaction(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,
        p_trans_id         Varchar2,
        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_empno Varchar2(5);
    Begin
        v_empno        := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            p_message_type := 'KO';
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        Delete
            From inv_emp_item_mapping_reserve_return
        Where
            trans_id = Trim(p_trans_id);

        Delete
            From inv_transaction_detail
        Where
            trans_id = Trim(p_trans_id);

        Delete
            From inv_transaction_master
        Where
            trans_id = Trim(p_trans_id);

        Commit;
        p_message_type := 'OK';
        p_message_text := 'Procedure executed successfully.';
    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
    End sp_delete_return_reserve_transaction;

    Procedure sp_issue_transaction(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,
        p_trans_id         Varchar2,
        p_trans_type_id    Varchar2,
        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_empno            Varchar2(5);
        v_gate_pass_ref_no inv_transaction_master.gate_pass_ref_no%Type;
    Begin
        v_empno            := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            p_message_type := 'KO';
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        v_gate_pass_ref_no := fn_get_gate_pass_ref_no(
                                  p_person_id => p_person_id,
                                  p_meta_id   => p_meta_id
                              );
        Update
            inv_transaction_master
        Set
            trans_type_id = p_trans_type_id,
            trans_date = sysdate,
            modified_by = v_empno,
            modified_on = sysdate,
            gate_pass_ref_no = v_gate_pass_ref_no,
            gate_pass = 'IT/NB/' || lpad(v_gate_pass_ref_no, 4, '0')
        Where
            trans_id = Trim(p_trans_id);

        sp_refresh_emp_item_mapping(
            p_person_id    => p_person_id,
            p_meta_id      => p_meta_id,
            p_trans_id     => p_trans_id,
            p_item_id      => Null,
            p_empno        => Null,
            p_trans_mode   => p_trans_type_id,
            p_message_type => p_message_type,
            p_message_text => p_message_text
        );

        Commit;
        p_message_type     := 'OK';
        p_message_text     := 'Procedure executed successfully.';
    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
    End sp_issue_transaction;

    Procedure sp_receive_transaction(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,
        p_trans_id         Varchar2,
        p_trans_type_id    Varchar2,
        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As

        Cursor cur_trans Is
            Select
                itm.empno       empno,
                itd.item_id     item_id,
                itd.item_usable item_usable
            From
                inv_transaction_master itm,
                inv_transaction_detail itd
            Where
                itm.trans_id = itd.trans_id
                And itm.trans_id = Trim(p_trans_id);

        v_empno Varchar2(5);
    Begin
        v_empno        := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            p_message_type := 'KO';
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        Update
            inv_transaction_master
        Set
            trans_type_id = p_trans_type_id,
            trans_date = sysdate,
            modified_by = v_empno,
            modified_on = sysdate
        Where
            trans_id = Trim(p_trans_id);

        For c1 In cur_trans
        Loop
            sp_refresh_emp_item_mapping(
                p_person_id    => p_person_id,
                p_meta_id      => p_meta_id,
                p_trans_id     => p_trans_id,
                p_item_id      => c1.item_id,
                p_empno        => c1.empno,
                p_trans_mode   => p_trans_type_id,
                p_message_type => p_message_type,
                p_message_text => p_message_text
            );
            /*
                        Update
                            inv_consumables_detail
                        Set
                            is_issued = 'N',
                            is_usable = c1.item_usable,
                            is_new = 'N'
                        Where
                            item_id = Trim(c1.item_id);
            */
            If Sql%notfound Then
                If c1.item_usable = 'N' Then
                    Insert Into dm_action_trans (
                        actiontransid,
                        assetid,
                        action_date,
                        action_by
                    )
                    Values (
                        dbms_random.string('X', 11),
                        c1.item_id,
                        sysdate,
                        v_empno
                    );

                End If;

            End If;

        End Loop;

        Commit;
        p_message_type := 'OK';
        p_message_text := 'Procedure executed successfully.';
    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
    End sp_receive_transaction;

    Function fn_get_gate_pass_ref_no(
        p_person_id Varchar2,
        p_meta_id   Varchar2
    ) Return Number Is
        v_empno            Varchar2(5);
        v_gate_pass_ref_no inv_transaction_master.gate_pass_ref_no%Type;
    Begin
        Select
            gate_pass_ref_no
        Into
            v_gate_pass_ref_no
        From
            (
                Select
                    gate_pass_ref_no
                From
                    inv_transaction_master
                Where
                    to_char(trans_date, 'YYYY') = to_char(sysdate, 'YYYY')
                    And gate_pass_ref_no Is Not Null
                Order By gate_pass_ref_no Desc
            )
        Where
            Rownum = 1;

        Return v_gate_pass_ref_no + 1;
    Exception
        When Others Then
            Return 1;
    End fn_get_gate_pass_ref_no;

    Procedure sp_refresh_emp_item_mapping(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,
        p_trans_id         Varchar2,
        p_item_id          Varchar2 Default Null,
        p_empno            Varchar2 Default Null,
        p_trans_mode       Varchar2,
        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_empno Varchar2(5);
    Begin
        v_empno        := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            p_message_type := 'KO';
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        If p_trans_mode = c_trans_reserve_return_id Then
            Insert Into inv_emp_item_mapping_reserve_return
            Select
                p_empno,
                p_item_id,
                p_trans_id
            From
                dual;

        End If;

        If p_trans_mode = c_trans_receive_id Then
            Delete
                From inv_emp_item_mapping_reserve_return
            Where
                item_id = Trim(p_item_id)
                And empno = Trim(p_empno);

            Delete
                From inv_emp_item_mapping
            Where
                item_id = Trim(p_item_id)
                And empno = Trim(p_empno);

        End If;

        If p_trans_mode = c_trans_issue_id Then
            Insert Into inv_emp_item_mapping
            Select
                itm.empno,
                itd.item_id,
                itm.trans_id
            From
                inv_transaction_master itm,
                inv_transaction_detail itd
            Where
                itm.trans_id = itd.trans_id
                And itm.trans_id = Trim(p_trans_id);

        End If;

        p_message_type := 'OK';
        p_message_text := 'Procedure executed successfully.';
    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
    End sp_refresh_emp_item_mapping;

    Procedure sp_receive_transaction_json(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_parameter_json   Varchar2,
        p_get_trans_id Out Varchar2,
        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_count         Number      := 0;
        v_empno         Varchar2(5);
        v_tranc_date    Date;
        v_trans_id      inv_transaction_master.trans_id%Type;
        v_trans_type_id Varchar2(3) := 'T04';
        v_action_type   Number;
        Cursor cur_json Is
            Select
                jt.*
            From
                Json_Table (p_parameter_json Format Json, '$[*]'
                    Columns (
                        empno       Varchar2 (5)   Path '$.Empno',
                        transdate   Varchar2 (20)  Path '$.TransDate',
                        transremark Varchar2 (200) Path '$.TransRemark',
                        Nested Path '$.ReturnItemList[*]'
                        Columns (
                            itemid   Varchar2 (20) Path '$[*].ItemId',
                            isusable Varchar2 (20) Path '$.IsUsable'
                        )
                    )
                )
                As jt;

    Begin
        v_empno        := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            p_message_type := 'KO';
            p_message_text := 'Invalid employee number';
            Return;
        End If;
        For c1 In cur_json
        Loop
            Begin
                If v_count = 0 Then
                    /*
                    T02	INCOMPLETE RETURN
                    T03	ISSUED
                    T04	RECEIVED
                    T01	RESERVE
                    */
                    v_tranc_date := To_Date(c1.transdate, 'YYYY-MM-DD"T"hh24:mi:ss');

                    If trunc(v_tranc_date) = trunc(sysdate) Then
                        v_tranc_date := sysdate;
                    Else
                        v_tranc_date := trunc(v_tranc_date) + ((1 / 24) * 23);
                    End If;

                    Insert Into inv_transaction_master (
                        trans_id,
                        trans_date,
                        empno,
                        trans_type_id,
                        remarks,
                        modified_by,
                        modified_on
                    )
                    Values (
                        dbms_random.string('X', 10),
                        v_tranc_date,
                        c1.empno,
                        v_trans_type_id,
                        Trim(c1.transremark),
                        v_empno,
                        sysdate
                    );
                    Select
                        trans_id
                    Into
                        v_trans_id
                    From
                        (
                            Select
                                trans_id
                            From
                                inv_transaction_master
                            Order By modified_on Desc
                        )
                    Where
                        Rownum = 1;

                    v_count      := 1;

                End If;

                p_get_trans_id := v_trans_id;

                pkg_inv_transactions_detail.sp_add_consumable(
                    p_person_id    => p_person_id,
                    p_meta_id      => p_meta_id,
                    p_trans_id     => v_trans_id,
                    p_item_id      => c1.itemid,
                    p_item_usable  => c1.isusable,
                    p_message_type => p_message_type,
                    p_message_text => p_message_text
                );

                If p_message_type = c_not_ok Then
                    Rollback;
                    Return;
                End If;

                -- Start - Insert into dm_action_item_exclude table
                If c1.itemid Is Not Null Or trim(c1.itemid) != '' Then

                    If c1.isusable = 'U' Then
                        v_action_type := 3; -- In Service
                    Else
                        v_action_type := 1; -- Out of Service
                    End If;

                    pkg_dms_asset_on_hold.sp_add_dm_action_trans(
                        p_person_id      => p_person_id,
                        p_meta_id        => p_meta_id,
                        p_actiontrans_id => dbms_random.string('X', 11),
                        p_asset_id       => c1.itemid,
                        p_source_desk    => '',
                        p_target_asset   => '',
                        p_action_type    => v_action_type, -- 3(In Service)
                        p_remarks        => Trim(c1.transremark),
                        p_action_date    => '',
                        p_action_by      => '',
                        p_source_emp     => c1.empno,
                        p_assetid_old    => '',
                        p_message_type   => p_message_type,
                        p_message_text   => p_message_text
                    );

                    /*
                      If p_message_type = c_not_ok Then
                          Rollback;
                          Return;
                      End If;
                    */

                End If;
                -- End  - Insert into dm_action_item_exclude table

                If v_trans_type_id = c_trans_reserve_id Then
                    /*
                    Update
                        inv_consumables_detail
                    Set
                        is_issued = 'Y'
                    Where
                        item_id = Trim(p_item_id);
                    */
                    Null;
                Else
                    sp_refresh_emp_item_mapping(
                        p_person_id    => p_person_id,
                        p_meta_id      => p_meta_id,
                        p_trans_id     => v_trans_id,
                        p_item_id      => c1.itemid,
                        p_empno        => c1.empno,
                        p_trans_mode   => v_trans_type_id,
                        p_message_type => p_message_type,
                        p_message_text => p_message_text
                    );

                    If p_message_type = c_not_ok Then
                        Rollback;
                        Return;
                    End If;
                End If;
            Exception
                When Others Then
                    p_message_type := 'KO';
                    p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
            End;
        End Loop;
        Null;

        Commit;
        p_message_type := 'OK';
        p_message_text := 'Procedure executed successfully.';
    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
    End sp_receive_transaction_json;

    Procedure sp_quick_issue_transaction(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_trans_id         Varchar2 Default Null,
        p_trans_date       Date     Default Null,
        p_empno            Varchar2 Default Null,
        p_trans_type_id    Varchar2 Default Null,
        p_remarks          Varchar2 Default Null,
        p_item_id          Varchar2,
        p_item_usable      Varchar2,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_empno            Varchar2(5);
        v_gate_pass_ref_no inv_transaction_master.gate_pass_ref_no%Type;
        p_get_trans_id     inv_transaction_master.trans_id%Type;
        v_item_type        Varchar2(2);
    Begin
        v_empno        := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            p_message_type := 'KO';
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        Select
            it.item_type_code
        Into
            v_item_type
        From
            inv_item_types              it
            Join inv_consumables_master cm
            On it.item_type_key_id = cm.item_type_key_id
            Join inv_consumables_detail cd
            On cm.consumable_id = cd.consumable_id
        Where
            cd.item_id = p_item_id;

        If (v_item_type = 'MU' Or v_item_type = 'KB' Or v_item_type != 'HS') Then
            sp_add_transaction(
                p_person_id     => p_person_id,
                p_meta_id       => p_meta_id,
                p_trans_id      => p_trans_id,
                p_trans_date    => p_trans_date,
                p_empno         => p_empno,
                p_trans_type_id => p_trans_type_id,
                p_remarks       => p_remarks,
                p_item_id       => p_item_id,
                p_item_usable   => p_item_usable,
                p_get_trans_id  => p_get_trans_id,
                p_message_type  => p_message_type,
                p_message_text  => p_message_text
            );

            v_gate_pass_ref_no := fn_get_gate_pass_ref_no(
                                      p_person_id => p_person_id,
                                      p_meta_id   => p_meta_id
                                  );
            Update
                inv_transaction_master
            Set
                trans_type_id = c_trans_issue_id,
                trans_date = p_trans_date,
                modified_by = v_empno,
                modified_on = sysdate,
                gate_pass_ref_no = v_gate_pass_ref_no,
                gate_pass = 'IT/NB/' || lpad(v_gate_pass_ref_no, 4, '0')
            Where
                trans_id = Trim(p_get_trans_id);

            sp_refresh_emp_item_mapping(
                p_person_id    => p_person_id,
                p_meta_id      => p_meta_id,
                p_trans_id     => p_trans_id,
                p_item_id      => Null,
                p_empno        => Null,
                p_trans_mode   => p_trans_type_id,
                p_message_type => p_message_type,
                p_message_text => p_message_text
            );

        End If;

        Commit;
        p_message_type := 'OK';
        p_message_text := 'Procedure executed successfully.';
    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
    End sp_quick_issue_transaction;

    Procedure sp_reserve_items_count(
        p_person_id              Varchar2,
        p_meta_id                Varchar2,

        p_reserve_item_count Out Varchar2,

        p_message_type       Out Varchar2,
        p_message_text       Out Varchar2
    ) As
        v_empno       Varchar2(5);
        v_count_total Number;
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
            p_reserve_item_count
        From
            inv_transaction_master itm,
            inv_transaction_types  itt,
            ss_emplmast            e,
            ss_costmast            c,
            ss_costmast            c1
        Where
            itm.empno = e.empno
            And itm.trans_type_id = itt.trans_type_id
            And e.assign = c.costcode
            And e.parent = c1.costcode
            And itm.trans_type_id = c_trans_reserve_id;

        p_message_type := ok;
        p_message_text := 'Procedure executed successfully.';
    Exception
        When Others Then
            p_reserve_item_count := '0';
            p_message_type       := not_ok;
            p_message_text       := 'Error in counting !!!';
    End;

End pkg_inv_transactions;
/

Grant Execute On dms.pkg_inv_transactions To tcmpl_app_config;