--------------------------------------------------------
--  DDL for Trigger BI_ST_ITEM_REQUESTS
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "ITINV_STK"."BI_ST_ITEM_REQUESTS" 
  BEFORE INSERT ON "ITINV_STK"."ST_ITEM_REQUESTS"
  REFERENCING FOR EACH ROW
  begin   
  if :NEW."REQ_ID" is null then 
    select "ST_ITEM_REQUESTS_SEQ".nextval into :NEW."REQ_ID" from sys.dual; 
  end if; 
end;
/
ALTER TRIGGER "ITINV_STK"."BI_ST_ITEM_REQUESTS" ENABLE;
