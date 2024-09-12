--------------------------------------------------------
--  DDL for Trigger TRIG_LAPTOP_STATUS_02
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "ITINV_STK"."TRIG_LAPTOP_STATUS_02" Before
    Delete On dist_laptop_status
    Referencing
            Old As old
            New As new
    For Each Row
Begin
    Insert Into dist_laptop_status_log_del (
        ams_asset_id,
        current_status,
        expected_date,
        remarks,
        assigned_to_empno,
        problem,
        wifi_mac_address,
        emp_assigned_date,
        modified_on,
        deleted_on
    ) Values (
        :old.ams_asset_id,
        :old.current_status,
        :old.expected_date,
        :old.remarks,
        :old.assigned_to_empno,
        :old.problem,
        :old.wifi_mac_address,
        :old.emp_assigned_date,
        :old.modified_on,
        Sysdate
    );

End;
/
ALTER TRIGGER "ITINV_STK"."TRIG_LAPTOP_STATUS_02" ENABLE;
