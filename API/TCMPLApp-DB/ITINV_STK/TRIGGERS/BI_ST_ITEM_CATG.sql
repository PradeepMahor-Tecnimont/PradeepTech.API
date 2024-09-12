--------------------------------------------------------
--  DDL for Trigger BI_ST_ITEM_CATG
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "ITINV_STK"."BI_ST_ITEM_CATG" 
  BEFORE INSERT ON "ITINV_STK"."ST_ITEM_CATG"
  REFERENCING FOR EACH ROW
  begin   
  if :NEW."CATG_ID" is null then 
    select "ST_ITEM_CATG_SEQ".nextval into :NEW."CATG_ID" from dual; 
  end if; 
end;
/
ALTER TRIGGER "ITINV_STK"."BI_ST_ITEM_CATG" ENABLE;
