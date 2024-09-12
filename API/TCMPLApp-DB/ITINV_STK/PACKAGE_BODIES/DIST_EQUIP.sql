--------------------------------------------------------
--  DDL for Package Body DIST_EQUIP
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE BODY "ITINV_STK"."DIST_EQUIP" As

    Procedure update_equip (
        p_empno            Varchar2,
        p_laptop_sapcode   Varchar2,
        p_docking_station  Varchar2,
        p_headset          Varchar2,
        p_laptop_chrgr     Varchar2,
        p_travel_bag       Varchar2,
        p_disp_converter   Varchar2,
        p_proj_converter   Varchar2,
        p_issued           Varchar2,
        p_issue_date       Varchar2,
        p_success          Out                Varchar2,
        p_message          Out                Varchar2
    ) As
        v_count   Number;
        v_doc_no  Varchar2(100);
    Begin
        If Trim(p_laptop_sapcode) Is Not Null Then
            Update dist_surface_laptop_mast
            Set
                assigned_to_empno = p_empno
            Where
                sap_asset_code = p_laptop_sapcode;

            Commit;
        End If;

        Select
            Count(*)
        Into v_count
        From
            dist_emp_it_equip
        Where
            empno = p_empno
            And is_issued = 'OK';

        If v_count > 0 Then
            p_success  := 'KO';
            p_message  := 'Editing not allowed after Issue';
            return;
        End If;

        Delete From dist_emp_it_equip
        Where
            empno = p_empno;

        If p_issued = 'OK' Then
            v_doc_no := 'IT/BT/TN-' || dist_document_no.nextval || '-20';
        End If;

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
            document_no
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
            v_doc_no
        );
        Update dist_laptop_request
        Set
            reason_4_nopickup = null,
            pickupreason_modified_by = p_empno,
            pickupreason_modified_on = Sysdate
        Where
            empno = p_empno;

        Commit;
        p_success  := 'OK';
        p_message  := 'Details successfully saved.';
    Exception
        When Others Then
            p_success  := 'KO';
            p_message  := 'Err - ' || Sqlcode || ' - ' || Sqlerrm;
    End update_equip;

End dist_equip;

/
