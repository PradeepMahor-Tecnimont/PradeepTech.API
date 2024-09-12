--------------------------------------------------------
--  DDL for Trigger SS_TRIG_ABSENT_TS_DETAIL_01
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "SELFSERVICE"."SS_TRIG_ABSENT_TS_DETAIL_01" Before
    Update Or Insert On ss_absent_ts_detail
    Referencing
            Old As old
            New As new
    For Each Row
Begin
    :new.modified_on := Sysdate;
End;
/
ALTER TRIGGER "SELFSERVICE"."SS_TRIG_ABSENT_TS_DETAIL_01" ENABLE;
