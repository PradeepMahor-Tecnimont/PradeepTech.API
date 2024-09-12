--------------------------------------------------------
--  DDL for Trigger TRIG_HEADSET_ISSUED_02
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "ITINV_STK"."TRIG_HEADSET_ISSUED_02" Before
    Delete On dist_headset_issued
    Referencing
            Old As old
            New As new
    For Each Row
Begin
    Insert Into dist_headset_issued_del_log (
        mfg_sr_no,
        assigned_to_empno,
        letter_ref_no,
        modified_on,
        del_on
    ) Values (
        :old.mfg_sr_no,
        :old.assigned_to_empno,
        :old.letter_ref_no,
        :old.modified_on,
        Sysdate
    );

End;
/
ALTER TRIGGER "ITINV_STK"."TRIG_HEADSET_ISSUED_02" ENABLE;
