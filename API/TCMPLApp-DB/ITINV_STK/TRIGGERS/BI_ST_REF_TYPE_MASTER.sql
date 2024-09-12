--------------------------------------------------------
--  DDL for Trigger BI_ST_REF_TYPE_MASTER
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "ITINV_STK"."BI_ST_REF_TYPE_MASTER" 
  BEFORE INSERT ON "ITINV_STK"."ST_REF_TYPE_MASTER"
  REFERENCING FOR EACH ROW
  begin   
  if :NEW."REF_TYPE_ID" is null then 
    select "ST_REF_TYPE_MASTER_SEQ".nextval into :NEW."REF_TYPE_ID" from dual; 
  end if; 
end;
/
ALTER TRIGGER "ITINV_STK"."BI_ST_REF_TYPE_MASTER" ENABLE;
