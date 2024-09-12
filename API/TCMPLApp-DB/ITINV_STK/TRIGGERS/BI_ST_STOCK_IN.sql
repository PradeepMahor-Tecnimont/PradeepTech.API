--------------------------------------------------------
--  DDL for Trigger BI_ST_STOCK_IN
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "ITINV_STK"."BI_ST_STOCK_IN" 
  BEFORE INSERT ON "ITINV_STK"."ST_STOCK_IN"
  REFERENCING FOR EACH ROW
  begin   
  if :NEW."IN_ID" is null then 
    select "ST_STOCK_IN_SEQ".nextval into :NEW."IN_ID" from sys.dual; 
  end if; 
end;
/
ALTER TRIGGER "ITINV_STK"."BI_ST_STOCK_IN" ENABLE;
