--------------------------------------------------------
--  DDL for Package Body DIST_LAPTOP_LOT
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE BODY "ITINV_STK"."DIST_LAPTOP_LOT" As

    Procedure update_status (
        p_sap_asset_code      Varchar2,
        p_wifi_mac_addr       Varchar2,
        p_assigned_to_empno   Varchar2,
        p_status              Varchar2,
        p_remarks             Varchar2,
        p_problem             Varchar2,
        p_expected_dt         Varchar2,
        p_success             Out                   Varchar2,
        p_message             Out                   Varchar2
    ) As
        v_count               Number;
        v_ams_asset_id        Varchar2(30);
        v_assigned_to_empno   Varchar2(5);
    Begin
        Begin
            Select
                ams_asset_id
            Into v_ams_asset_id
            From
                dist_laptop_lot_details
            Where
                sap_asset_code = p_sap_asset_code;

        Exception
            When no_data_found Then
                p_success   := 'KO';
                p_message   := 'SAP Asset Code does not exists in defined Lots';
                return;
        End;

        If p_assigned_to_empno Is Not Null Then
            Update dist_laptop_status
            Set
                assigned_to_empno = Null
            Where
                assigned_to_empno = p_assigned_to_empno;

        End If;

        Select
            Count(*)
        Into v_count
        From
            dist_laptop_status
        Where
            Trim(ams_asset_id) = Trim(v_ams_asset_id);

        If v_count > 0 Then
            Update dist_laptop_status
            Set
                wifi_mac_address = p_wifi_mac_addr,
                assigned_to_empno = p_assigned_to_empno,
                current_status = p_status,
                remarks = Substr(p_remarks, 1, 100),
                problem = p_problem,
                expected_date = To_Date(p_expected_dt, 'dd-Mon-yyyy'),
                modified_on = Sysdate
            Where
                Trim(ams_asset_id) = Trim(v_ams_asset_id);

        Else
            Insert Into dist_laptop_status (
                ams_asset_id,
                wifi_mac_address,
                assigned_to_empno,
                current_status,
                remarks,
                problem,
                expected_date,
                modified_on
            ) Values (
                v_ams_asset_id,
                p_wifi_mac_addr,
                p_assigned_to_empno,
                p_status,
                Substr(p_remarks, 1, 100),
                p_problem,
                To_Date(p_expected_dt, 'dd-Mon-yyyy'),
                Sysdate
            );

        End If;

        Commit;
        p_success   := 'OK';
        p_message   := 'Details updated successfully.';
    Exception
        When Others Then
            p_success   := 'KO';
            p_message   := 'Err - ' || Sqlcode || '-' || Sqlerrm;
    End update_status;

    Procedure check_duplicate_in_lot (
        p_from_sap_code   Number,
        p_to_sap_code     Number,
        p_success         Out               Varchar2,
        p_message         Out               Varchar2
    ) As
        v_count Number;
    Begin
        Select
            Count(*)
        Into v_count
        From
            dist_laptop_lot_details
        Where
            sap_asset_code Between p_from_sap_code And Nvl(p_to_sap_code, p_from_sap_code);

        If v_count > 0 Then
            p_success   := 'KO';
            p_message   := 'Err - ' || To_Char(v_count) || ' records found duplicate';
            return;
        End If;

        p_success := 'OK';
    Exception
        When Others Then
            p_success   := 'KO';
            p_message   := 'Err - CHKDUP - ' || Sqlcode || ' - ' || Sqlerrm;
    End;

    Procedure add_new_lot (
        p_lot_desc        Varchar2,
        p_from_sap_code   Number,
        p_to_sap_code     Number,
        p_success         Out               Varchar2,
        p_message         Out               Varchar2
    ) As
        v_key_id Varchar2(5);
    Begin
        If Nvl(p_to_sap_code, p_from_sap_code) < p_from_sap_code Then
            p_success   := 'KO';
            p_message   := 'Err - From SAP Code should be less then To SAP Code';
            return;
        End If;

        check_duplicate_in_lot(
            p_from_sap_code,
            p_to_sap_code,
            p_success,
            p_message
        );
        If p_success = 'KO' Then
            return;
        End If;
        Insert Into dist_laptop_lot_mast ( lot_desc ) Values ( Substr(p_lot_desc, 1, 100) ) Returning key_id Into v_key_id;

        Insert Into dist_laptop_lot_details (
            key_id,
            ams_asset_id,
            sap_asset_code
        )
            Select
                v_key_id,
                ams_asset_id,
                sap_asset_code
            From
                ams_asset_master
            Where
                sap_asset_code Between p_from_sap_code And Nvl(p_to_sap_code, p_from_sap_code);

        p_success   := 'OK';
        p_message   := 'Laptop Lots updated successfully.';
    Exception
        When Others Then
            p_success   := 'KO';
            p_message   := 'Err - ' || Sqlcode || ' - ' || Sqlerrm;
    End;

    Function get_laptop_lot_desc (
        p_laptop_ams_ids Varchar2
    ) Return Varchar2 As
        v_lot_desc Varchar2(2000);
    Begin
        Select
            Listagg(lot_desc,
                    ', ') Within Group(
                Order By
                    ams_asset_id
            )
        Into v_lot_desc
        From
            dist_vu_laptop_lot_list
        Where
            ams_asset_id In (
                Select
                    Trim(Regexp_Substr(p_laptop_ams_ids, '[^,]+', 1, Level)) val
                From
                    dual
                Connect By
                    Regexp_Substr(p_laptop_ams_ids, '[^,]+', 1, Level) Is Not Null
            );

        Return v_lot_desc;
    Exception
        When Others Then
            Return Null;
    End get_laptop_lot_desc;

End dist_laptop_lot;

/
