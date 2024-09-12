--------------------------------------------------------
--  DDL for Trigger TRIGGER6
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "SELFSERVICE"."TRIGGER6" 
BEFORE DELETE ON SS_SITE_ALLOWANCE_PERIOD_ADJ 
FOR EACH ROW 
--vCount Number;
BEGIN

  Insert into SS_SITE_ALLWNC_PERIOD_ADJ_DEL (	EMPNO,
	ADJUSTMENT_MONTH,
	ADJ_FROM,
	ADJ_TO,
	REMARKS,
	MODIFIED_ON,
	ADJ_MONTH,
	FOR_ALLOWANCE)
  values
  (
    :old.EMPNO,
	:old.ADJUSTMENT_MONTH,
	:old.ADJ_FROM,
	:old.ADJ_TO,
	:old.REMARKS,
	:old.MODIFIED_ON,
	:old.ADJ_MONTH,
	:old.FOR_ALLOWANCE  
  );

END;

/
ALTER TRIGGER "SELFSERVICE"."TRIGGER6" ENABLE;
