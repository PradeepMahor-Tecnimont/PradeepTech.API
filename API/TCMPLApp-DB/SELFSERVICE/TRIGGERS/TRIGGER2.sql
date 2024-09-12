--------------------------------------------------------
--  DDL for Trigger TRIGGER2
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "SELFSERVICE"."TRIGGER2" 
BEFORE INSERT OR UPDATE OF PROCESSED_MONTH ON SS_SITE_ALLOWANCE_PROCESSED 
REFERENCING OLD AS old NEW AS new 
FOR EACH ROW 
BEGIN
  :new.sys_proc_month := TO_Char(:new.Processed_Month,'yyyymm');
END;

/
ALTER TRIGGER "SELFSERVICE"."TRIGGER2" ENABLE;
