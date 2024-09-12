--------------------------------------------------------
--  DDL for Package Body DIST_SURFACE_LAPTOPS
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE BODY "ITINV_STK"."DIST_SURFACE_LAPTOPS" As

    Procedure update_details (
        p_sap_asset_code     Varchar2,
        p_wifi_mac_addr      Varchar2,
        p_assigned_to_empno  Varchar2,
        p_status             Varchar2,
        p_remarks            Varchar2,
        p_problem            Varchar2,
        p_expected_dt        Varchar2,
        p_success            Out                  Varchar2,
        p_message            Out                  Varchar2
    ) As
        v_count Number;
    Begin
        Select
            Count(*)
        Into v_count
        From
            dist_surface_laptop_mast
        Where
            sap_asset_code = p_sap_asset_code;

        If v_count = 0 Then
            p_success  := 'KO';
            p_message  := 'SAP Asset Code does not exists';
            return;
        End If;

        Update dist_surface_laptop_mast
        Set
            wifi_mac_address = p_wifi_mac_addr,
            assigned_to_empno = p_assigned_to_empno,
            current_status = p_status,
            remarks = Substr(p_remarks, 1, 100),
            problem = p_problem,
            expected_date = To_Date(p_expected_dt, 'dd-Mon-yyyy'),
            modified_on = sysdate
        Where
            sap_asset_code = p_sap_asset_code;

        p_success  := 'OK';
        p_message  := 'Details updated successfully.';
    Exception
        When Others Then
            p_success  := 'KO';
            p_message  := 'Err - ' || Sqlcode || '-' || Sqlerrm;
    End update_details;

End dist_surface_laptops;

/
