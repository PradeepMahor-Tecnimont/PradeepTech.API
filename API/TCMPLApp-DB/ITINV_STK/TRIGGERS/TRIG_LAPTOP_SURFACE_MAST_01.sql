--------------------------------------------------------
--  DDL for Trigger TRIG_LAPTOP_SURFACE_MAST_01
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "ITINV_STK"."TRIG_LAPTOP_SURFACE_MAST_01" Before
    Update Of assigned_to_empno, current_status On dist_surface_laptop_mast
    Referencing
            Old As old
            New As new
    For Each Row
Begin
    If :old.assigned_to_empno <> :new.assigned_to_empno Then
        :new.emp_assigned_date := Sysdate;
    End If;

    If :old.current_status <> :new.current_status Then
        Insert Into dist_surface_latptop_statuslog (
            sap_asset_code,
            status_code,
            modified_on
        ) Values (
            :new.sap_asset_code,
            :new.current_status,
            Sysdate
        );

    End If;

End;
/
ALTER TRIGGER "ITINV_STK"."TRIG_LAPTOP_SURFACE_MAST_01" ENABLE;
