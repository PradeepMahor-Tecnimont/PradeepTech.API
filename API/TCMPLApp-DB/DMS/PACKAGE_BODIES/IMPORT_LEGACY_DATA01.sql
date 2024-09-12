Create Or Replace Package Body dms.import_legacy_data01 As


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
        p_det_item_id := dbms_random.string('X', 13);

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
        p_issue_date   Date,
        p_document_no  Varchar2,
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
            p_issue_date,
            p_empno,
            'T03',
            p_remarks,
            'SYS',
            g_sysdate,
            p_document_no
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
        v_rec_cntr                         Number;
        v_count                            Number;
        v_headset_count                    Number;
        v_docking_stn_count                Number;
        v_laptop_charger_count             Number;
        v_travel_bag_count                 Number;
        v_display_converter_count          Number;
        v_projector_converter_count        Number;

        v_type_id_headset                  Varchar2(5) := 'KEY14';
        v_type_id_docking_stn              Varchar2(5) := 'KEY05';
        v_type_id_laptop_charger           Varchar2(5) := 'KEY15';
        v_type_id_travel_bag               Varchar2(5) := 'KEY16';
        v_type_id_display_converter        Varchar2(5) := 'KEY17';
        v_type_id_projector_converter      Varchar2(5) := 'KEY18';

        Cursor c1 Is
            Select
                *
            From
                it_inv_issues
                where docking_stn not in(
'IT077D1S000755',
'IT077DS1000558',
'IT077DS0100752',
'IT077DS0010470',
'IT077DS0001787',
'IT077DS0004116',
'IT077DS0005619'
                )
                order by empno;

        Type typ_tab_legacy_issues Is Table Of c1%rowtype Index By Binary_Integer;
        tab_legacy_issues                  typ_tab_legacy_issues;

        v_cons_mast_id_headset             Varchar2(10);
        v_cons_mast_id_docking_stn         Varchar2(10);
        v_cons_mast_id_laptop_charger      Varchar2(10);
        v_cons_mast_id_travel_bag          Varchar2(10);
        v_cons_mast_id_display_converter   Varchar2(10);
        v_cons_mast_id_projector_converter Varchar2(10);
        v_mast_id_trans                    Varchar2(10);
        v_cons_item_id                     Varchar2(20);
    Begin
        g_sysdate      := sysdate;
        Select
            Count(*)
        Into
            v_count
        From
            it_inv_issues;

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
            it_inv_issues
        Where
            trim(headset) is not null;

        Select
            Count(*)
        Into
            v_docking_stn_count
        From
            it_inv_issues
        Where
            upper(Trim(docking_stn)) = 'OK';

        Select
            Count(*)
        Into
            v_laptop_charger_count
        From
            it_inv_issues
        Where
            upper(Trim(laptop_charger)) = 'OK';

        Select
            Count(*)
        Into
            v_travel_bag_count
        From
            it_inv_issues
        Where
            upper(Trim(travel_bag)) Is Not Null;

        Select
            Count(*)
        Into
            v_display_converter_count
        From
            it_inv_issues
        Where
            upper(Trim(display_converter)) Is Not Null;

        Select
            Count(*)
        Into
            v_projector_converter_count
        From
            it_inv_issues
        Where
            upper(Trim(projector_converter)) Is Not Null;

        If v_headset_count > 0 Then
            sp_insert_into_consum_mast(
                p_type_key_id       => v_type_id_headset,
                p_desc              => 'Legacy HeadSet - ' || to_char(g_sysdate, 'yyyymmddss'),
                p_master_rec_key_id => v_cons_mast_id_headset
            );

        End If;

        If v_laptop_charger_count > 0 Then
            sp_insert_into_consum_mast(
                p_type_key_id       => v_type_id_laptop_charger,
                p_desc              => 'Legacy Laptop Charger - ' || to_char(g_sysdate, 'yyyymmddss'),
                p_master_rec_key_id => v_cons_mast_id_laptop_charger
            );

        End If;

        If v_travel_bag_count > 0 Then
            sp_insert_into_consum_mast(
                p_type_key_id       => v_type_id_travel_bag,
                p_desc              => 'Legacy Travel Bag - ' || to_char(g_sysdate, 'yyyymmddss'),
                p_master_rec_key_id => v_cons_mast_id_travel_bag
            );

        End If;

        If v_display_converter_count > 0 Then
            sp_insert_into_consum_mast(
                p_type_key_id       => v_type_id_display_converter,
                p_desc              => 'Legacy Display Converter - ' || to_char(g_sysdate, 'yyyymmddss'),
                p_master_rec_key_id => v_cons_mast_id_display_converter
            );

        End If;

        If v_projector_converter_count > 0 Then
            sp_insert_into_consum_mast(
                p_type_key_id       => v_type_id_projector_converter,
                p_desc              => 'Legacy Projector Converter - ' || to_char(g_sysdate, 'yyyymmddss'),
                p_master_rec_key_id => v_cons_mast_id_projector_converter
            );

        End If;

        v_rec_cntr     := 0;

        Open c1;
        Loop
            Fetch c1 Bulk Collect Into tab_legacy_issues Limit 50;
            For i In 1..tab_legacy_issues.count
            Loop
                v_rec_cntr := v_rec_cntr + 1;
                if v_rec_cntr = 426 then
                v_rec_cntr := 426;
                end if;
                sp_insert_into_trans_master(
                    p_empno       => tab_legacy_issues(i).empno,
                    p_remarks     => 'Legacy issue - ' || tab_legacy_issues(i).empno || ' - ' || i || ' - ' || to_char(g_sysdate,
                    'yyyymmddss'),
                    p_rec_cntr    => v_rec_cntr,
                    p_trans_id    => v_mast_id_trans,
                    p_issue_date  => nvl(nvl(tab_legacy_issues(i).issue_date,tab_legacy_issues(i).modified_on),sysdate),
                    p_document_no => tab_legacy_issues(i).document_no
                );

                If tab_legacy_issues(i).headset Is Not Null Then

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

                If tab_legacy_issues(i).laptop_charger Is Not Null Then

                    sp_insert_into_consum_detail(
                        p_mast_rec_key_id => v_cons_mast_id_laptop_charger,
                        p_type_key_id     => v_type_id_laptop_charger,
                        p_empno           => tab_legacy_issues(i).empno,
                        p_item_mfg_id     => Null,
                        p_det_item_id     => v_cons_item_id
                    );

                    sp_insert_into_trans_det(
                        p_trans_id => v_mast_id_trans,
                        p_item_id  => v_cons_item_id
                    );
                End If;

                If tab_legacy_issues(i).travel_bag Is Not Null Then

                    sp_insert_into_consum_detail(
                        p_mast_rec_key_id => v_cons_mast_id_travel_bag,
                        p_type_key_id     => v_type_id_travel_bag,
                        p_empno           => tab_legacy_issues(i).empno,
                        p_item_mfg_id     => Null,
                        p_det_item_id     => v_cons_item_id
                    );

                    sp_insert_into_trans_det(
                        p_trans_id => v_mast_id_trans,
                        p_item_id  => v_cons_item_id
                    );
                End If;

                If tab_legacy_issues(i).display_converter Is Not Null Then

                    sp_insert_into_consum_detail(
                        p_mast_rec_key_id => v_cons_mast_id_display_converter,
                        p_type_key_id     => v_type_id_display_converter,
                        p_empno           => tab_legacy_issues(i).empno,
                        p_item_mfg_id     => Null,
                        p_det_item_id     => v_cons_item_id
                    );

                    sp_insert_into_trans_det(
                        p_trans_id => v_mast_id_trans,
                        p_item_id  => v_cons_item_id
                    );
                End If;

                If tab_legacy_issues(i).projector_converter Is Not Null Then

                    sp_insert_into_consum_detail(
                        p_mast_rec_key_id => v_cons_mast_id_projector_converter,
                        p_type_key_id     => v_type_id_projector_converter,
                        p_empno           => tab_legacy_issues(i).empno,
                        p_item_mfg_id     => Null,
                        p_det_item_id     => v_cons_item_id
                    );

                    sp_insert_into_trans_det(
                        p_trans_id => v_mast_id_trans,
                        p_item_id  => v_cons_item_id
                    );
                End If;
                If tab_legacy_issues(i).laptop_ams_id Is Not Null Then
                    sp_insert_into_trans_det(
                        p_trans_id => v_mast_id_trans,
                        p_item_id  => tab_legacy_issues(i).laptop_ams_id,
                        p_is_asset => 'OK',
                        p_empno    => tab_legacy_issues(i).empno
                    );
                End If;
                If tab_legacy_issues(i).docking_stn Is Not Null Then

                    sp_insert_into_trans_det(
                        p_trans_id => v_mast_id_trans,
                        p_item_id  => tab_legacy_issues(i).docking_stn,
                        p_is_asset => 'OK',
                        p_empno    => tab_legacy_issues(i).empno
                    );
                End If;
                commit;
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

End;