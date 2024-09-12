Create Or Replace Package Body dms.pkg_inv_item_group As

    Procedure sp_bulk_add(
        p_inv_group_items  typ_tab_group_items,
        p_inv_group_desc   Varchar2,
        p_entry_by_empno   Varchar2,
        p_message_type Out Varchar2,
        p_message_text Out Varchar2

    ) As
        v_mast_key_id Varchar2(10);
        v_det_key_id  Varchar2(20);

    Begin
        Begin
            v_mast_key_id := dbms_random.string('X', 5);
            Insert Into inv_item_group_master(

                group_key_id,
                group_desc,
                modified_on,
                modified_by)
            Values(
                v_mast_key_id,
                p_inv_group_desc,
                sysdate,
                p_entry_by_empno
            );
        Exception
            When Others Then
                p_message_type := 'KO';
                p_message_text := 'Error Updating Consumable.';
                Return;
        End;

        For i In 1..p_inv_group_items.count
        Loop

            Insert Into inv_item_group_detail
            (
                group_key_id,
                item_id,
                sap_asset_code
            )
            Values(
                v_mast_key_id,
                p_inv_group_items(i).item_id,
                p_inv_group_items(i).sap_asset_code
            );

        End Loop;
        p_message_type := 'OK';
        p_message_text := 'Data generated successfully';

    Exception
        When Others Then
            Rollback;
            p_message_type := 'KO';
            p_message_text := sqlcode || ' - ' || sqlerrm;
    End;

    Procedure sp_import(
        p_person_id                 Varchar2,
        p_meta_id                   Varchar2,

        p_inv_group_desc            Varchar2,

        p_inv_group_items           typ_tab_string,

        p_inv_item_group_errors Out typ_tab_string,

        p_message_type          Out Varchar2,
        p_message_text          Out Varchar2
    ) As
        v_valid_row_num  Number;
        tab_valid_rows   typ_tab_group_items;
        rec_group_item   inv_item_group_detail%rowtype;
        v_err_num        Number;
        is_error_in_row  Boolean;
        v_msg_text       Varchar2(200);
        v_msg_type       Varchar2(10);
        v_count          Number;
        v_reason         Varchar2(30);
        v_item_id        Varchar(4000);
        v_ams_asset_id   Varchar2(30);
        v_sap_asset_code Number;
        v_array_count    Number;

        v_entry_by_empno Varchar2(5);
    Begin
        tab_valid_rows   := typ_tab_group_items();
        v_entry_by_empno := get_empno_from_meta_id(p_meta_id);

        If v_entry_by_empno = 'ERRRR' Then
            p_message_type := 'KO';
            p_message_text := 'Invalid employee number';
            Return;
        End If;
        v_err_num        := 0;

        If p_inv_group_items.count = 1 And Trim(p_inv_group_items(1)) Is Null Then
            v_array_count := 0;
        Else
            v_array_count := p_inv_group_items.count;
        End If;
        For i In 1..p_inv_group_items.count
        Loop
            is_error_in_row := false;

            v_item_id       := p_inv_group_items(i);
            Begin
                v_sap_asset_code := To_Number(v_item_id);
                v_ams_asset_id   := Null;
            Exception
                When Others Then
                    v_sap_asset_code := Null;
                    v_ams_asset_id   := v_item_id;
            End;

            Begin
                Select
                    ams_asset_id, sap_asset_code
                Into
                    v_ams_asset_id, v_sap_asset_code
                From
                    ams.as_asset_mast
                Where
                    ams_asset_id      = v_ams_asset_id
                    Or sap_asset_code = v_sap_asset_code;
            Exception
                When Others Then

                    v_err_num       := v_err_num + 1;
                    p_inv_item_group_errors(v_err_num) :=
                        v_err_num || '~!~' ||   --ID
                        '' || '~!~' ||          --Section
                        i || '~!~' ||           --XL row number
                        'ItemId' || '~!~' ||     --FieldName
                        '0' || '~!~' ||         --ErrorType
                        'Critical' || '~!~' ||  --ErrorTypeString
                        'Item not found in AMS Asset master';   --Message
                    is_error_in_row := true;

                    Continue;
            End;
            Select
                Count(*)
            Into
                v_count
            From
                inv_item_group_detail
            Where
                item_id = Trim(v_ams_asset_id);

            If v_count > 0 Then
                v_err_num       := v_err_num + 1;
                p_inv_item_group_errors(v_err_num) :=
                    v_err_num || '~!~' ||   --ID
                    '' || '~!~' ||          --Section
                    i || '~!~' ||           --XL row number
                    'ItemId' || '~!~' ||     --FieldName
                    '0' || '~!~' ||         --ErrorType
                    'Critical' || '~!~' ||  --ErrorTypeString
                    'Duplicate found.';   --Message
                is_error_in_row := true;
            End If;

            If is_error_in_row = false Then
                v_valid_row_num                 := nvl(v_valid_row_num, 0) + 1;

                rec_group_item.item_id          := v_ams_asset_id;
                rec_group_item.sap_asset_code   := v_sap_asset_code;

                tab_valid_rows.extend();
                tab_valid_rows(v_valid_row_num) := rec_group_item;

            End If;
        End Loop;
        If nvl(v_err_num, 0) > 0 Then
            p_message_type := 'KO';
            p_message_text := 'Not all records were imported.';
            Return;
        End If;

        sp_bulk_add(
            p_inv_group_items => tab_valid_rows,
            p_inv_group_desc  => p_inv_group_desc,
            p_entry_by_empno  => v_entry_by_empno,
            p_message_type    => p_message_type,
            p_message_text    => p_message_text

        );

        p_message_type   := 'OK';
        p_message_text   := 'File imported successfully.';
    Exception
        When Others Then
            Rollback;
            p_message_type := 'KO';
            p_message_text := sqlcode || ' Main - ' || sqlerrm;
    End;

    Procedure sp_item_group_detail(
        p_person_id           Varchar2,
        p_meta_id             Varchar2,

        p_inv_item_group_id   Varchar2,

        p_item_group_desc Out Varchar2,
        p_modified_on     Out Date,

        p_message_type    Out Varchar2,
        p_message_text    Out Varchar2

    ) As
        v_mast_key_id         Varchar2(10);
        v_det_key_id          Varchar2(20);

        v_quantity            Number;
        rec_item_group_master inv_item_group_master%rowtype;
    Begin

        Select
            *
        Into
            rec_item_group_master
        From
            inv_item_group_master
        Where
            group_key_id = p_inv_item_group_id;

        p_item_group_desc := rec_item_group_master.group_desc;
        p_modified_on     := rec_item_group_master.modified_on;
        
        p_message_type    := 'OK';
        p_message_text    := 'Data generated successfully';

    Exception
        When Others Then
            Rollback;
            p_message_type := 'KO';
            p_message_text := sqlcode || ' - ' || sqlerrm;
    End;

    Procedure sp_delete_inv_item_grpup(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_group_key_id            Varchar2,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_empno        Varchar2(5);
        v_user_tcp_ip  Varchar2(5) := 'NA';
        v_message_type Number      := 0;
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);

        If v_empno = 'ERRRR' Then
            p_message_type := 'KO';
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        Delete From inv_item_group_detail
         Where group_key_id = p_group_key_id;

        Delete From inv_item_group_master
         Where group_key_id = p_group_key_id;
         
        If (Sql%rowcount > 0) Then
            p_message_type := 'OK';
            p_message_text := 'Procedure executed successfully.';
        Else
            p_message_type := 'KO';
            p_message_text := 'Procedure not executed.';
        End If;

    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'Err - ' || sqlcode || ' - ' || sqlerrm;

    End sp_delete_inv_item_grpup;
End pkg_inv_item_group;