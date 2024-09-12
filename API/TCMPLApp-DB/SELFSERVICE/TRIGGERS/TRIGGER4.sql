--------------------------------------------------------
--  DDL for Trigger TRIGGER4
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "SELFSERVICE"."TRIGGER4" 
BEFORE INSERT OR UPDATE OF EMPNO,ADJUSTMENT_MONTH,ADJ_FROM,ADJ_TO,REMARKS,ADJ_MONTH ON SS_SITE_ALLOWANCE_PERIOD_ADJ  
REFERENCING OLD AS old NEW AS new 
for each row
BEGIN
  :new.modified_on := sysdate;
END;

/
ALTER TRIGGER "SELFSERVICE"."TRIGGER4" ENABLE;
