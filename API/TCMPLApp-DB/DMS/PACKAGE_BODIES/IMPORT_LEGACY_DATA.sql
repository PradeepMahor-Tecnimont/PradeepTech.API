Create Or Replace Package Body dms.import_legacy_data As

    g_sysdate Date;

    Procedure sp_insert_into_consum_mast(
        p_type_key_id           Varchar2,
        p_desc                  Varchar2,
        p_master_rec_key_id Out Varchar2
    ) As
    Begin
        p_master_rec_key_id := dbms_random.string('X', 10);
        Insert Into inv_consumables_master(
            consumable_id,
            consumable_date,
            consumable_desc,
            item_type_key_id,
            quantity,
            total_issued,
            total_reserved,
            total_non_usable
        )
        Values(
            p_master_rec_key_id,
            g_sysdate,
            p_desc,
            p_type_key_id,
            0,
            0,
            0,
            0
        );
    End;

    Procedure sp_insert_into_consum_detail(
        p_mast_rec_key_id Varchar2,
        p_type_key_id     Varchar2,
        p_empno           Varchar2,
        p_item_mfg_id     Varchar2 Default Null,
        p_det_item_id Out Varchar2
    ) As
    Begin
        p_det_item_id := dbms_random.string('X', 20);

        Insert Into inv_consumables_detail(
            consumable_det_id,
            item_id,
            mfg_id,
            consumable_id,
            is_new,
            usable_type
        )
        Values
        (
            p_det_item_id,
            p_det_item_id,
            nvl(p_item_mfg_id, p_det_item_id),
            p_mast_rec_key_id,
            'Y',
            'U'
        );

    End;

    Procedure sp_insert_into_trans_master(
        p_empno        Varchar2,
        p_remarks      Varchar2,
        p_rec_cntr     Number,
        p_trans_id Out Varchar2
    ) As
        c_trans_type_issue Varchar2(3) := 'T03';
        v_gate_pass        Varchar2(20);
    Begin
        p_trans_id  := dbms_random.string('X', 10);
        v_gate_pass := 'LEGACY/IT/NB/' || lpad(p_rec_cntr, 4, '0');
        Insert Into inv_transaction_master(
            trans_id,
            trans_date,
            empno,
            trans_type_id,
            remarks,
            modified_by,
            modified_on,
            gate_pass
        )
        Values
        (
            p_trans_id,
            g_sysdate,
            p_empno,
            'T03',
            p_remarks,
            'SYS',
            g_sysdate,
            v_gate_pass
        );

    End;

    Procedure sp_insert_into_trans_det(

        p_trans_id Varchar2,
        p_item_id  Varchar2,
        p_is_asset Varchar2 Default Null,
        p_empno    Varchar2 Default Null
    )

    As
        v_trans_det_id Varchar2(15);
        v_count        Number;
    Begin
        If p_item_id Is Null Then
            Return;
        End If;

        For c1 In (
            With
                rws As (
                    Select
                        p_item_id str
                    From
                        dual
                )
            Select
                regexp_substr(str, '[^;]+', 1, level) item_id
            From
                rws
            Connect By
                level <=
                length(Trim (Both ';'
                        From
                        str)) - length(replace(str, ';')) + 1
        )
        Loop

            v_trans_det_id := dbms_random.string('X', 15);

            Insert Into inv_transaction_detail(
                trans_det_id,
                item_id,
                item_usable,
                trans_id
            )
            Values
            (
                v_trans_det_id,
                c1.item_id,
                'U',
                p_trans_id
            );
            If p_is_asset = 'OK' And p_empno Is Not Null Then
                Select
                    Count(*)
                Into
                    v_count
                From
                    inv_emp_item_mapping
                Where
                    item_id   = c1.item_id
                    And empno = p_empno;
                If v_count = 0 Then
                    Insert Into inv_emp_item_mapping(
                        trans_id,
                        item_id,
                        empno
                    )
                    Values
                    (
                        p_trans_id,
                        c1.item_id,
                        p_empno
                    );
                End If;
            End If;
        End Loop;
    End;
    Procedure sp_import(
        p_message_type Out Varchar2,
        p_message_text Out Varchar2

    ) As
        v_rec_cntr              Number;
        v_count                 Number;
        v_headset_count         Number;
        v_mouse_count           Number;
        v_keyboard_count        Number;
        v_ubikey_count          Number;
        v_type_id_mouse         Varchar2(5) := 'KEY06';
        v_type_id_keyboard      Varchar2(5) := 'KEY07';
        v_type_id_headset       Varchar2(5) := 'KEY14';
        v_type_id_ubikey        Varchar2(5) := 'KEY04';
        Cursor c1 Is
            Select
                *
            From
                legacy_inv_issue;

        Type typ_tab_legacy_issues Is Table Of c1%rowtype Index By Binary_Integer;
        tab_legacy_issues       typ_tab_legacy_issues;

        v_cons_mast_id_headset  Varchar2(10);
        v_cons_mast_id_mouse    Varchar2(10);
        v_cons_mast_id_keyboard Varchar2(10);
        v_cons_mast_id_ubikey   Varchar2(10);
        v_mast_id_trans         Varchar2(10);
        v_cons_item_id          Varchar2(20);
    Begin
        g_sysdate      := sysdate;
        Select
            Count(*)
        Into
            v_count
        From
            legacy_inv_issue;

        If v_count = 0 Then
            p_message_type := 'KO';
            p_message_text := 'Err - No data to import.';
            Return;
        End If;
        Select
            Count(*)
        Into
            v_headset_count
        From
            legacy_inv_issue
        Where
            upper(Trim(head_set)) = 'YES';

        Select
            Count(*)
        Into
            v_mouse_count
        From
            legacy_inv_issue
        Where
            upper(Trim(mouse)) = 'YES';

        Select
            Count(*)
        Into
            v_keyboard_count
        From
            legacy_inv_issue
        Where
            upper(Trim(key_board)) = 'YES';

        Select
            Count(*)
        Into
            v_ubikey_count
        From
            legacy_inv_issue
        Where
            upper(Trim(ubi_key)) Is Not Null;

        If v_headset_count > 0 Then
            sp_insert_into_consum_mast(
                p_type_key_id       => v_type_id_headset,
                p_desc              => 'Legacy HeadSet - ' || to_char(g_sysdate, 'yyyymmddss'),
                p_master_rec_key_id => v_cons_mast_id_headset
            );

        End If;
        If v_mouse_count > 0 Then
            sp_insert_into_consum_mast(
                p_type_key_id       => v_type_id_mouse,
                p_desc              => 'Legacy Mouse - ' || to_char(g_sysdate, 'yyyymmddss'),
                p_master_rec_key_id => v_cons_mast_id_mouse
            );

        End If;

        If v_keyboard_count > 0 Then
            sp_insert_into_consum_mast(
                p_type_key_id       => v_type_id_keyboard,
                p_desc              => 'Legacy Keyboard - ' || to_char(g_sysdate, 'yyyymmddss'),
                p_master_rec_key_id => v_cons_mast_id_keyboard
            );

        End If;

        If v_ubikey_count > 0 Then
            sp_insert_into_consum_mast(
                p_type_key_id       => v_type_id_ubikey,
                p_desc              => 'Legacy Ubikey - ' || to_char(g_sysdate, 'yyyymmddss'),
                p_master_rec_key_id => v_cons_mast_id_ubikey
            );

        End If;

        v_rec_cntr     := 0;

        Open c1;
        Loop
            Fetch c1 Bulk Collect Into tab_legacy_issues Limit 50;
            For i In 1..tab_legacy_issues.count
            Loop
                v_rec_cntr := v_rec_cntr + 1;
                sp_insert_into_trans_master(
                    p_empno    => tab_legacy_issues(i).empno,
                    p_remarks  => 'Legacy issue - ' || tab_legacy_issues(i).empno || ' - ' || i || ' - ' || to_char(g_sysdate,
                    'yyyymmddss'),
                    p_rec_cntr => v_rec_cntr,
                    p_trans_id => v_mast_id_trans

                );

                If tab_legacy_issues(i).head_set Is Not Null Then

                    sp_insert_into_consum_detail(
                        p_mast_rec_key_id => v_cons_mast_id_headset,
                        p_type_key_id     => v_type_id_headset,
                        p_empno           => tab_legacy_issues(i).empno,
                        p_item_mfg_id     => Null,
                        p_det_item_id     => v_cons_item_id
                    );

                    sp_insert_into_trans_det(
                        p_trans_id => v_mast_id_trans,
                        p_item_id  => v_cons_item_id
                    );
                End If;

                If tab_legacy_issues(i).mouse Is Not Null Then

                    sp_insert_into_consum_detail(
                        p_mast_rec_key_id => v_cons_mast_id_mouse,
                        p_type_key_id     => v_type_id_mouse,
                        p_empno           => tab_legacy_issues(i).empno,
                        p_item_mfg_id     => Null,
                        p_det_item_id     => v_cons_item_id
                    );

                    sp_insert_into_trans_det(
                        p_trans_id => v_mast_id_trans,
                        p_item_id  => v_cons_item_id
                    );
                End If;
                If tab_legacy_issues(i).key_board Is Not Null Then

                    sp_insert_into_consum_detail(
                        p_mast_rec_key_id => v_cons_mast_id_keyboard,
                        p_type_key_id     => v_type_id_keyboard,
                        p_empno           => tab_legacy_issues(i).empno,
                        p_item_mfg_id     => Null,
                        p_det_item_id     => v_cons_item_id
                    );

                    sp_insert_into_trans_det(
                        p_trans_id => v_mast_id_trans,
                        p_item_id  => v_cons_item_id
                    );
                End If;

                If tab_legacy_issues(i).ubi_key Is Not Null Then

                    sp_insert_into_consum_detail(
                        p_mast_rec_key_id => v_cons_mast_id_ubikey,
                        p_type_key_id     => v_type_id_ubikey,
                        p_empno           => tab_legacy_issues(i).empno,
                        p_item_mfg_id     => tab_legacy_issues(i).ubi_key,
                        p_det_item_id     => v_cons_item_id
                    );

                    sp_insert_into_trans_det(
                        p_trans_id => v_mast_id_trans,
                        p_item_id  => v_cons_item_id
                    );
                End If;

                sp_insert_into_trans_det(
                    p_trans_id => v_mast_id_trans,
                    p_item_id  => tab_legacy_issues(i).pc_laptop_id,
                    p_is_asset => 'OK',
                    p_empno    => tab_legacy_issues(i).empno
                );

                sp_insert_into_trans_det(
                    p_trans_id => v_mast_id_trans,
                    p_item_id  => tab_legacy_issues(i).docking_stn_id,
                    p_is_asset => 'OK',
                    p_empno    => tab_legacy_issues(i).empno
                );

            End Loop;
            Exit When c1%notfound;
        End Loop;
        Commit;
        p_message_type := 'OK';
        p_message_text := 'Procedure execute successfully.';

    Exception
        When Others Then
            Rollback;
            p_message_type := 'KO';
            p_message_text := 'Err :- ' || sqlcode || ' - ' || sqlerrm;
    End;

    Procedure sp_delete_legacy(
        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
    Begin
        Delete
            From inv_transaction_detail
        Where
            trans_id In (
                Select
                    trans_id
                From
                    inv_transaction_master

                Where
                    remarks Like 'Legacy%'
            );

        Delete
            From inv_emp_item_mapping
        Where
            trans_id In (
                Select
                    trans_id
                From
                    inv_transaction_master

                Where
                    remarks Like 'Legacy%'
            );

        Delete
            From inv_transaction_master
        Where
            remarks Like 'Legacy%';

        Delete
            From inv_consumables_detail
        Where
            consumable_id In (

                Select
                    consumable_id
                From
                    inv_consumables_master
                Where
                    inv_consumables_master.consumable_desc Like 'Legacy%'
            );

        Delete
            From inv_consumables_master
        Where
            inv_consumables_master.consumable_desc Like 'Legacy%';
        p_message_type := 'OK';
        p_message_text := 'Procedure execute successfully.';

    Exception
        When Others Then
            Rollback;
            p_message_type := 'KO';
            p_message_text := 'Err :- ' || sqlcode || ' - ' || sqlerrm;

    End;

    Procedure sp_update_from_home_desk(
        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        Cursor c1 Is
            Select
                empno,
                Listagg(assetid, ';') Within
                    Group (Order By
                        empno) As assets
            From
                (
                    Select
                    Distinct
                        um.empno, da.assetid
                    From
                        dm_deskallocation da,
                        dm_usermaster     um

                    Where
                        da.deskid = um.deskid
                        And da.deskid Like 'H%'
                )
            Group By
                empno
            Order By
                empno;
        v_count Number;
    Begin
        For data_row In c1
        Loop
            Select
                Count(*)
            Into
                v_count
            From
                legacy_inv_issue
            Where
                empno = data_row.empno;
            If v_count > 0 Then
                Update
                    legacy_inv_issue
                Set
                    pc_laptop_id = data_row.assets, docking_stn_id = Null
                Where
                    empno = data_row.empno;
            Else
                Insert Into legacy_inv_issue (empno, pc_laptop_id) Values (data_row.empno, data_row.assets);
            End If;

        End Loop;
        Commit;
        p_message_type := 'OK';
        p_message_text := 'Procedure execute successfully.';

    Exception
        When Others Then
            Rollback;
            p_message_type := 'KO';
            p_message_text := 'Err :- ' || sqlcode || ' - ' || sqlerrm;
    End;

    Procedure sp_delete_home_desks(
        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
    Begin
        Delete
            From dm_deskallocation
        Where
            deskid Like 'H%';
        Delete
            From dm_usermaster
        Where
            deskid Like 'H%';
        Commit;

        p_message_type := 'OK';
        p_message_text := 'Procedure execute successfully.';

    Exception
        When Others Then
            Rollback;
            p_message_type := 'KO';
            p_message_text := 'Err :- ' || sqlcode || ' - ' || sqlerrm;
    End;
End;