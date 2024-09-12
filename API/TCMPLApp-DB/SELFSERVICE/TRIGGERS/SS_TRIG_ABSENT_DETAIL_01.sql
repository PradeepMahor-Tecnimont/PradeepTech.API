--------------------------------------------------------
--  DDL for Trigger SS_TRIG_ABSENT_DETAIL_01
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "SELFSERVICE"."SS_TRIG_ABSENT_DETAIL_01" Before
    Update Or Insert On ss_absent_detail
    Referencing
            Old As old
            New As new
    For Each Row
Begin
    :new.modified_on := Sysdate;
End;

/
ALTER TRIGGER "SELFSERVICE"."SS_TRIG_ABSENT_DETAIL_01" ENABLE;
