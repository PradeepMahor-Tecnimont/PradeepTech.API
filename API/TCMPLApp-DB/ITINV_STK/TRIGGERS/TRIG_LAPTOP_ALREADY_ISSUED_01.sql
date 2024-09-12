--------------------------------------------------------
--  DDL for Trigger TRIG_LAPTOP_ALREADY_ISSUED_01
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "ITINV_STK"."TRIG_LAPTOP_ALREADY_ISSUED_01" After
Delete Or Insert On dist_laptop_already_issued
Referencing
Old As old
New As new
For Each Row

Begin
    If inserting Then
        Declare
            v_count          Number;
            v_sap_asset_code Number;
            v_is_in_lot      Number;
        Begin
            Insert Into dist_laptop_already_issued_log (
                empno,
                laptop_ams_id,
                permanent_issued,
                modified_on,
                is_issued
            )
            Values (
                :new.empno,
                :new.laptop_ams_id,
                :new.permanent_issued,
                sysdate,
                1
            );
            /*
            If :new.permanent_issued = 'OK' Then
                Select
                    Count(*)
                Into
                    v_is_in_lot
                From
                    dist_vu_laptop_lot_list
                Where
                    ams_asset_id = :new.laptop_ams_id;
                If v_is_in_lot > 0 Then
                    Select
                        Count(*)
                    Into
                        v_count
                    From
                        dist_laptop_status
                    Where
                        ams_asset_id = :new.laptop_ams_id;
                    If v_count > 0 Then
                        Delete
                            From dist_laptop_status
                        Where
                            ams_asset_id = :new.laptop_ams_id;
                    End If;
                    Insert Into dist_laptop_status (
                        ams_asset_id,
                        current_status,
                        remarks,
                        assigned_to_empno,
                        emp_assigned_date,
                        modified_on)
                    Values (
                        :new.laptop_ams_id,
                        12,
                        'VARIOUS LAPTOP ASSIGNMENT',
                        :new.empno,
                        sysdate,
                        sysdate
                    );
                    Select
                        sap_asset_code
                    Into
                        v_sap_asset_code
                    From
                        ams_asset_master
                    Where
                        ams_asset_id = :new.laptop_ams_id;
                    Select
                        Count(*)
                    Into
                        v_count
                    From
                        dist_surface_laptop_mast
                    Where
                        sap_asset_code = v_sap_asset_code;
                    If v_count > 0 Then
                        Delete
                            From dist_surface_laptop_mast
                        Where
                            sap_asset_code = v_sap_asset_code;
                    End If;
                    Insert Into dist_surface_laptop_mast (
                        sap_asset_code,
                        current_status,
                        remarks,
                        assigned_to_empno,
                        emp_assigned_date,
                        modified_on)
                    Values (
                        v_sap_asset_code,
                        12,
                        'VARIOUS LAPTOP ASSIGNMENT',
                        :new.empno,
                        sysdate,
                        sysdate
                    );
                End If;
            End If;
            */
        End;
    Elsif deleting Then
        Update
            dist_laptop_already_issued_log
        Set
            empno = :old.empno,
            laptop_ams_id = :old.laptop_ams_id,
            permanent_issued = :old.permanent_issued,
            modified_on = sysdate,
            is_issued = 0;

        Delete
            From dist_laptop_status
        Where
            assigned_to_empno = :old.empno
            And ams_asset_id  = Trim(:old.laptop_ams_id);

    End If;
End;
/
ALTER TRIGGER "ITINV_STK"."TRIG_LAPTOP_ALREADY_ISSUED_01" ENABLE;
