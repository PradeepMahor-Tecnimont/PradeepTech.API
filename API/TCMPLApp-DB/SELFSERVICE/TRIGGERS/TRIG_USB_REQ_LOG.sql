--------------------------------------------------------
--  DDL for Trigger TRIG_USB_REQ_LOG
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "SELFSERVICE"."TRIG_USB_REQ_LOG" Before
    Update Of key_id,empno,comp_name Or Insert On ss_usb_request
    Referencing
            old As old
            new As new
    For Each Row
Begin

    If
        inserting
    Then
        Insert Into ss_usb_request_chg_log ( key_id,empno,comp_name,modified_on ) Values ( :new.key_id,:new.empno,:new.comp_name,Sysdate );

    Elsif updating Then
        Insert Into ss_usb_request_chg_log ( key_id,empno,comp_name,modified_on ) Values ( :old.key_id,:old.empno,:new.comp_name,Sysdate );

    End If;

End;

/
ALTER TRIGGER "SELFSERVICE"."TRIG_USB_REQ_LOG" ENABLE;
