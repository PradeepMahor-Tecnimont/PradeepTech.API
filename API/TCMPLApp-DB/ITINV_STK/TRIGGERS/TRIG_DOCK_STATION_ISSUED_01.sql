--------------------------------------------------------
--  DDL for Trigger TRIG_DOCK_STATION_ISSUED_01
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "ITINV_STK"."TRIG_DOCK_STATION_ISSUED_01" Before
    Delete Or Insert Or Update On dist_dock_station_issued
    Referencing
            Old As old
            New As new
    For Each Row
Begin
    If inserting Or updating Then
        :new.modified_on := Sysdate;
    Elsif deleting Then
        Insert Into dist_dock_stn_issued_dellog (
            sap_asset_code,
            assigned_to_empno,
            letter_ref_no,
            modified_on,
            del_on
        ) Values (
            :old.sap_asset_code,
            :old.assigned_to_empno,
            :old.letter_ref_no,
            :old.modified_on,
            Sysdate
        );

    End If;
End;
/
ALTER TRIGGER "ITINV_STK"."TRIG_DOCK_STATION_ISSUED_01" ENABLE;
