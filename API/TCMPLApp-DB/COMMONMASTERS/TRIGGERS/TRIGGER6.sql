--------------------------------------------------------
--  DDL for Trigger TRIGGER6
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "COMMONMASTERS"."TRIGGER6" 
BEFORE INSERT OR DELETE ON EMP_FAMILY 
REFERENCING OLD AS old NEW AS new 
FOR EACH ROW 
BEGIN
  If inserting then
    :new.key_id := dbms_random.string('X',8);
    Insert into emp_family_log (empno,member,dob,relation,occupation, remarks,chg_date,chg_type, key_id)
    values
    (:new.empno,:new.member,:new.dob,:new.relation,:new.occupation ,:new.remarks,sysdate,'INSERT', :new.key_id);
  ElsIf deleting then
    begin
      Insert into emp_family_log (empno,member,dob,relation,occupation, remarks,chg_date,chg_type,key_id)
      values
      (:old.empno,:old.member,:old.dob,:old.relation,:old.occupation ,:old.remarks,sysdate,'DELETE',:old.key_id);
    exception
      when others then
        null;
    end;
  End If;
  Exception
  when others then
    null;
END;

/
ALTER TRIGGER "COMMONMASTERS"."TRIGGER6" ENABLE;
