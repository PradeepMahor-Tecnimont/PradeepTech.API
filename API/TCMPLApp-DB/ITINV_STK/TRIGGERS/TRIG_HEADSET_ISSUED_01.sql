--------------------------------------------------------
--  DDL for Trigger TRIG_HEADSET_ISSUED_01
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "ITINV_STK"."TRIG_HEADSET_ISSUED_01" Before
    Insert Or Update Of modified_on On dist_headset_issued
    Referencing
            Old As old
            New As new
    For Each Row
Begin
    :new.modified_on := Sysdate;
End;
/
ALTER TRIGGER "ITINV_STK"."TRIG_HEADSET_ISSUED_01" ENABLE;
