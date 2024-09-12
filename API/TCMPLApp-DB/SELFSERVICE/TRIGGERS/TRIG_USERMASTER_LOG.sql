--------------------------------------------------------
--  DDL for Trigger TRIG_USERMASTER_LOG
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "SELFSERVICE"."TRIG_USERMASTER_LOG" 
AFTER DELETE OR INSERT ON XDM_USERMASTER 
REFERENCING OLD AS OLD NEW AS NEW
for each row
BEGIN
  if inserting then      
    INSERT INTO DM_USERMASTER_LOG(EMPNO,DESKID,COSTCODE,DEP_FLAG,FLAG,LOG_DATE) VALUES(:new.empno,:new.deskid,:new.costcode,:new.dep_flag,'I',sysdate);
  elsif deleting then
INSERT INTO DM_USERMASTER_LOG(EMPNO,DESKID,COSTCODE,DEP_FLAG,FLAG,LOG_DATE) VALUES(:old.empno,:old.deskid,:old.costcode,:old.dep_flag,'D',sysdate);
  end if;
END;

/
ALTER TRIGGER "SELFSERVICE"."TRIG_USERMASTER_LOG" ENABLE;
