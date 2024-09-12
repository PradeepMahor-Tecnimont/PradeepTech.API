--------------------------------------------------------
--  DDL for Trigger TL_PHONE_EXTENSIONS_T1
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "ITINV_STK"."TL_PHONE_EXTENSIONS_T1" 
    BEFORE UPDATE 
    ON "TL_PHONE_EXTENSIONS" 
    FOR EACH row 
BEGIN 
    :New.key_id := :Old.Key_id;
    :new.change_date := sysdate;
END;
/
ALTER TRIGGER "ITINV_STK"."TL_PHONE_EXTENSIONS_T1" ENABLE;
