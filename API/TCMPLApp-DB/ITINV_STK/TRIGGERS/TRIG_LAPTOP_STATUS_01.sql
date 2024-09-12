--------------------------------------------------------
--  DDL for Trigger TRIG_LAPTOP_STATUS_01
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "ITINV_STK"."TRIG_LAPTOP_STATUS_01" Before
    Update Of assigned_to_empno, current_status On dist_laptop_status
    Referencing
            Old As old
            New As new
    For Each Row
Begin
    If :old.assigned_to_empno <> :new.assigned_to_empno Then
        :new.emp_assigned_date := Sysdate;
    End If;

    If :old.current_status <> :new.current_status Then
        Insert Into dist_laptop_status_log (
            ams_asset_id,
            status_code,
            modified_on
        ) Values (
            :new.ams_asset_id,
            :new.current_status,
            Sysdate
        );

    End If;

End;
/
ALTER TRIGGER "ITINV_STK"."TRIG_LAPTOP_STATUS_01" ENABLE;
