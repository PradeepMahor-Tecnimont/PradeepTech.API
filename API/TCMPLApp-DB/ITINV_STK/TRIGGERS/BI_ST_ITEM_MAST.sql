--------------------------------------------------------
--  DDL for Trigger BI_ST_ITEM_MAST
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "ITINV_STK"."BI_ST_ITEM_MAST" 
  BEFORE INSERT ON "ITINV_STK"."ST_ITEM_MAST"
  REFERENCING FOR EACH ROW
  begin   
  if :NEW."ITEM_ID" is null then 
    select "ST_ITEM_MAST_SEQ".nextval into :NEW."ITEM_ID" from dual; 
  end if; 
end;
/
ALTER TRIGGER "ITINV_STK"."BI_ST_ITEM_MAST" ENABLE;
