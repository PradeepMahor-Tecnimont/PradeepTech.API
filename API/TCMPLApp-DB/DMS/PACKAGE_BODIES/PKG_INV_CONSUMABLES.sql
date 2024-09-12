-----------------------------------------------------
--  DDL for Package Body PKG_INV_TRANSACTIONS
-----------------------------------------------------

Create Or Replace Package Body "DMS"."PKG_INV_CONSUMABLES" As

    Procedure sp_bulk_add(
        p_consumables       typ_tab_string,
        p_consumable_desc   Varchar2,
        p_consumable_type   Varchar2,

        p_po_number         Varchar2 Default Null,
        p_po_date           Date     Default Null,
        p_vendor            Varchar2 Default Null,
        p_invoice_no        Varchar2 Default Null,
        p_invoice_date      Date     Default Null,
        p_warranty_end_date Date     Default Null,
        p_ram_capacity      Number   Default Null,

        p_message_type Out  Varchar2,
        p_message_text Out  Varchar2

    ) As
        v_mast_key_id Varchar2(10);
        v_det_key_id  Varchar2(20);
        v_item_id     Varchar2(20);
        v_quantity    Number;
        c_usable      Constant Varchar2(1) := 'U';
    Begin
        v_quantity     := p_consumables.count;
        Begin
            v_mast_key_id := dbms_random.string('X', 10);
            Insert Into inv_consumables_master(

                consumable_id,
                consumable_date,
                consumable_desc,
                item_type_key_id,
                quantity,

                po,
                po_date,
                vendor,
                invoice,
                invoice_date,
                warranty_end_date
            )
            Values(
                v_mast_key_id,
                sysdate,
                p_consumable_desc,
                p_consumable_type,
                v_quantity,
                p_po_number,
                p_po_date,
                p_vendor,
                p_invoice_no,
                p_invoice_date,
                p_warranty_end_date
            );
        Exception
            When Others Then
                p_message_type := 'KO';
                p_message_text := 'Error Updating Consumable.';
                Return;
        End;

        If p_consumable_type = 'KEYRM' Then
            Insert Into inv_ram_consumable_map(
                ram_capacity_gb, consumable_id
            )
            Values(
                p_ram_capacity, v_mast_key_id
            );
        End If;

        For i In 1..v_quantity
        Loop
            v_det_key_id := dbms_random.string('X', 20);
            v_item_id    := dbms_random.string('X', 13);
            Insert Into inv_consumables_detail
            (
                consumable_det_id,
                item_id,
                mfg_id,
                consumable_id,
                is_new,
                usable_type
            )
            Values(
                v_det_key_id,
                v_item_id,
                p_consumables(i),
                v_mast_key_id,
                'Y',
                c_usable
            );

        End Loop;
        p_message_type := 'OK';
        p_message_text := 'Data generated successfully';

    Exception
        When Others Then
            Rollback;
            p_message_type := not_ok;
            p_message_text := sqlcode || ' - ' || sqlerrm;
    End;

    Procedure sp_import(
        p_person_id              Varchar2,
        p_meta_id                Varchar2,

        p_consumable_desc        Varchar2,
        p_consumable_type        Varchar2,
        p_quantity               Number,

        p_po_number              Varchar2 Default Null,
        p_po_date                Date     Default Null,
        p_vendor                 Varchar2 Default Null,
        p_invoice_no             Varchar2 Default Null,
        p_invoice_date           Date     Default Null,
        p_warranty_end_date      Date     Default Null,
        p_ram_capacity           Number   Default Null,

        p_consumables            typ_tab_string,

        p_consumables_errors Out typ_tab_string,

        p_message_type       Out Varchar2,
        p_message_text       Out Varchar2
    ) As
        v_valid_row_num     Number;
        tab_valid_rows      typ_tab_string;

        v_err_num           Number;
        is_error_in_row     Boolean;
        v_msg_text          Varchar2(200);
        v_msg_type          Varchar2(10);
        v_count             Number;
        v_reason            Varchar2(30);
        v_mfg_id            Varchar(4000);

        rec_consumable_type inv_item_types%rowtype;
        c_trackable_item    Constant Varchar2(2) := 'C2';
        c_other_item        Constant Varchar2(2) := 'C3';
        v_array_count       Number;

    Begin
        v_err_num      := 0;
        Begin
            Select
                *
            Into
                rec_consumable_type
            From
                inv_item_types
            Where
                item_type_key_id = p_consumable_type;
        Exception
            When Others Then
                p_message_type := not_ok;
                p_message_text := 'Consumable type not found.';
                Return;
        End;

        If rec_consumable_type.category_code Not In(c_trackable_item, c_other_item) Then
            p_message_type := not_ok;
            p_message_text := 'Incorrect consumable type provided.';
            Return;
        End If;

        If nvl(p_ram_capacity, 0) = 0 And p_consumable_type = 'KEYRM' Then
            p_message_type := 'KO';
            p_message_text := 'RMA capacity not provided.';
            Return;
        End If;

        If p_consumables.count = 1 And Trim(p_consumables(1)) Is Null Then
            v_array_count := 0;
        Else
            v_array_count := p_consumables.count;
        End If;

        If rec_consumable_type.category_code = c_other_item And v_array_count = 0 Then
            For i In 1..p_quantity
            Loop
                tab_valid_rows(i) := dbms_random.string('X', 20);
            End Loop;

            sp_bulk_add(
                p_consumables       => tab_valid_rows,
                p_consumable_desc   => p_consumable_desc,
                p_consumable_type   => p_consumable_type,
                p_po_number         => p_po_number,
                p_po_date           => p_po_date,
                p_vendor            => p_vendor,
                p_invoice_no        => p_invoice_no,
                p_invoice_date      => p_invoice_date,
                p_warranty_end_date => p_warranty_end_date,

                p_ram_capacity      => p_ram_capacity,
                p_message_type      => p_message_type,
                p_message_text      => p_message_text

            );
            If p_message_type = 'OK' Then
                p_message_text := 'Data generated successfully.';
            End If;
            --
            --Return
            --
            Return;
            --XXXXXXXXXXXXXXXXX

        End If;

        For i In 1..p_consumables.count
        Loop
            is_error_in_row := false;

            v_mfg_id        := p_consumables(i);

            If length(trim(v_mfg_id)) > 20 Then
                v_err_num       := v_err_num + 1;
                p_consumables_errors(v_err_num) :=
                    v_err_num || '~!~' ||   --ID
                    '' || '~!~' ||          --Section
                    i || '~!~' ||           --XL row number
                    'ItemMfgId' || '~!~' ||     --FieldName
                    '0' || '~!~' ||         --ErrorType
                    'Critical' || '~!~' ||  --ErrorTypeString
                    'Length is more than 20char';   --Message
                is_error_in_row := true;
            End If;

            Select
                Count(*)
            Into
                v_count
            From
                inv_consumables_detail
            Where
                mfg_id = Trim(v_mfg_id);

            If v_count > 0 Then
                v_err_num       := v_err_num + 1;
                p_consumables_errors(v_err_num) :=
                    v_err_num || '~!~' ||   --ID
                    '' || '~!~' ||          --Section
                    i || '~!~' ||           --XL row number
                    'ItemMfgId' || '~!~' ||     --FieldName
                    '0' || '~!~' ||         --ErrorType
                    'Critical' || '~!~' ||  --ErrorTypeString
                    'Duplicate found.';   --Message
                is_error_in_row := true;
            End If;

            If is_error_in_row = false Then
                v_valid_row_num                 := nvl(v_valid_row_num, 0) + 1;

                --v_rec_claim.empno := v_empno;

                tab_valid_rows(v_valid_row_num) := v_mfg_id;

            End If;
        End Loop;
        If nvl(v_err_num, 0) > 0 Or nvl(v_valid_row_num, 0) != p_quantity Then
            p_message_type := not_ok;
            p_message_text := 'Not all records were imported.';
            Return;
        End If;
        sp_bulk_add(
            p_consumables       => tab_valid_rows,
            p_consumable_desc   => p_consumable_desc,
            p_consumable_type   => p_consumable_type,
            p_po_number         => p_po_number,
            p_po_date           => p_po_date,
            p_vendor            => p_vendor,
            p_invoice_no        => p_invoice_no,
            p_invoice_date      => p_invoice_date,
            p_warranty_end_date => p_warranty_end_date,

            p_ram_capacity      => p_ram_capacity,
            p_message_type      => p_message_type,
            p_message_text      => p_message_text

        );
        If p_message_type = not_ok Then
            Rollback;
            Return;
        End If;

        p_message_type := ok;
        p_message_text := 'File imported successfully.';
    Exception
        When Others Then
            Rollback;
            p_message_type := not_ok;
            p_message_text := sqlcode || ' - ' || sqlerrm;
    End;

    Procedure sp_consumables_details(
        p_person_id                Varchar2,
        p_meta_id                  Varchar2,

        p_consumable_id            Varchar2,

        p_consumable_date      Out Date,
        p_consumable_desc      Out Varchar2,
        p_consumable_type_id   Out Varchar2,
        p_consumable_type_desc Out Varchar2,
        p_quantity             Out Number,
        p_ram_capacity_desc    Out Varchar2,
        
        P_Po_Number            Out Varchar2,
        P_Po_Date              Out Varchar2,
        P_Vendor               Out Varchar2,
        P_Invoice_No           Out Varchar2,
        P_Invoice_Date         Out Varchar2,
        P_Warranty_End_Date     Out Varchar2,
        
        p_message_type         Out Varchar2,
        p_message_text         Out Varchar2

    ) As
        v_mast_key_id          Varchar2(10);
        v_det_key_id           Varchar2(20);

        v_quantity             Number;
        rec_consumables_master inv_consumables_master%rowtype;
    Begin
        --Get master record.
        Select
            *
        Into
            rec_consumables_master
        From
            inv_consumables_master
        Where
            consumable_id = p_consumable_id;

        -- get itemtype desc
        Select
            item_type_desc
        Into
            p_consumable_type_desc
        From
            inv_item_types
        Where
            item_type_key_id = rec_consumables_master.item_type_key_id;
        Begin
            Select
                ram_capacity_desc
            Into
                p_ram_capacity_desc
            From
                inv_ram_capacity
            Where
                ram_capacity_gb In (
                    Select
                        ram_capacity_gb
                    From
                        inv_ram_consumable_map
                    Where
                        consumable_id = p_consumable_id
                );
        Exception
            When Others Then
                Null;
        End;

        p_consumable_date    := rec_consumables_master.consumable_date;
        p_consumable_desc    := rec_consumables_master.consumable_desc;
        p_consumable_type_id := rec_consumables_master.item_type_key_id;
        p_quantity           := rec_consumables_master.quantity;
        
        P_Po_Number           := rec_consumables_master.Po;
        P_Po_Date             := to_char(rec_consumables_master.Po_Date,'DD-MON-YYYY');
        P_Vendor              := rec_consumables_master.Vendor;
        P_Invoice_No          := rec_consumables_master.Invoice;
        P_Invoice_Date        := to_char(rec_consumables_master.Invoice_Date,'DD-MON-YYYY');
        P_Warranty_End_Date    := to_char(rec_consumables_master.Warranty_End_Date,'DD-MON-YYYY');
        
        
        p_message_type       := 'OK';
        p_message_text       := 'Data generated successfully';

    Exception
        When Others Then
            Rollback;
            p_message_type := 'KO';
            p_message_text := sqlcode || ' - ' || sqlerrm;
    End;

End pkg_inv_consumables;