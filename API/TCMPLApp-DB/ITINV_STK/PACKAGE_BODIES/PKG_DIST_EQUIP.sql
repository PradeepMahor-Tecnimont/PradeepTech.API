--------------------------------------------------------
--  DDL for Package Body PKG_DIST_EQUIP
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE BODY "ITINV_STK"."PKG_DIST_EQUIP" As

    Procedure update_equip (
        p_empno             Varchar2,
        p_laptop_sapcode    Varchar2,
        p_docking_station   Varchar2,
        p_headset           Varchar2,
        p_laptop_chrgr      Varchar2,
        p_travel_bag        Varchar2,
        p_disp_converter    Varchar2,
        p_proj_converter    Varchar2,
        p_issued            Varchar2,
        p_issue_date        Varchar2,
        p_success           Out                 Varchar2,
        p_message           Out                 Varchar2
    ) As
        v_count          Number;
        v_doc_no         Number;
        v_doc_code       Varchar2(100);
        v_ams_asset_id   Varchar2(30);
    Begin
        Begin
            Select
                ams_asset_id
            Into v_ams_asset_id
            From
                dist_laptop_lot_details
            Where
                sap_asset_code = p_laptop_sapcode;

        Exception
            When no_data_found Then
                p_success   := 'KO';
                p_message   := 'Err - SAP Asset Code does not exists in defined Lots';
                return;
        End;

        Select
            Count(*)
        Into v_count
        From
            dist_laptop_already_issued
        Where
            laptop_ams_id = v_ams_asset_id;

        If v_count > 0 Then
            p_success   := 'KO';
            p_message   := 'Err - Laptop has been already assigned to another user.';
            return;
        End If;

        Commit;
        Select
            Count(*)
        Into v_count
        From
            dist_emp_it_equip
        Where
            empno = p_empno
            And is_issued = 'OK';

        If v_count > 0 Then
            p_success   := 'KO';
            p_message   := 'Editing not allowed after Issue';
            return;
        End If;

        Delete From dist_emp_it_equip
        Where
            empno = p_empno;

        Insert Into dist_emp_it_equip (
            empno,
            headset,
            docking_stn,
            laptop_charger,
            travel_bag,
            display_converter,
            projector_converter,
            is_issued,
            issue_date,
            document_no,
            laptop_ams_id
        ) Values (
            p_empno,
            p_headset,
            p_docking_station,
            p_laptop_chrgr,
            p_travel_bag,
            p_disp_converter,
            p_proj_converter,
            p_issued,
            To_Date(p_issue_date, 'dd-Mon-yyyy'),
            v_doc_code,
            v_ams_asset_id
        );

        Update dist_laptop_request
        Set
            reason_4_nopickup = Null,
            pickupreason_modified_by = p_empno,
            pickupreason_modified_on = Sysdate
        Where
            empno = p_empno;

        Commit;
        If p_issued = 'OK' Then
            v_doc_no     := dist_nb_issue_doc_no.nextval;
            v_doc_code   := 'IT/NB/' || Lpad(To_Char(v_doc_no), 4, '0');
            Update dist_emp_it_equip
            Set
                document_no = v_doc_code
            Where
                empno = p_empno
                And laptop_ams_id = v_ams_asset_id;

            Insert Into dist_laptop_already_issued (
                empno,
                laptop_ams_id,
                permanent_issued,
                modified_on,
                letter_ref_no
            ) Values (
                p_empno,
                v_ams_asset_id,
                'OK',
                sysdate,
                v_doc_code
            );

            If Trim(p_docking_station) Is Not Null Then
                Insert Into dist_dock_station_issued (
                    sap_asset_code,
                    assigned_to_empno,
                    letter_ref_no
                ) Values (
                    p_docking_station,
                    p_empno,
                    v_doc_code
                );

            End If;

            If Trim(p_headset) Is Not Null Then
                Insert Into dist_headset_issued (
                    mfg_sr_no,
                    assigned_to_empno,
                    letter_ref_no
                ) Values (
                    p_headset,
                    p_empno,
                    v_doc_code
                );

            End If;

            Commit;
        End If;

        p_success   := 'OK';
        p_message   := 'Details successfully saved.';
    Exception
        When Others Then
            p_success   := 'KO';
            p_message   := 'Err - ' || Sqlcode || ' - ' || Sqlerrm;
    End update_equip;

End pkg_dist_equip;

/
