--------------------------------------------------------
--  DDL for Trigger TRIGGER1
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "SELFSERVICE"."TRIGGER1" 
BEFORE INSERT OR UPDATE Or Delete ON SS_SITE_EMPLOYEE 
REFERENCING OLD AS old NEW AS new 
for each row
BEGIN
  Declare
    vCount Number;
  Begin
    If inserting or updating then
    :new.modified_on := sysdate;
    End if;
    /*Select count(*) InTo vCount From ss_site_allowance_trans Where Empno = :new.empno
    and start_date = :new.mobi_date;*/
    If Inserting Then
      Select count(*) InTo vCount From ss_site_allowance_trans where empno=:new.empno
      And start_date = :new.mobi_date;
      If vCount = 0 Then
        Insert into ss_site_allowance_trans(empno,start_date,processed_month)
         values (:new.empno, :new.mobi_date,'000000');
      Else
        Update ss_site_allowance_trans set start_date = :new.mobi_date
        Where EmpNo = :Old.EmpNo and start_date = :Old.mobi_date;
      End If;
    End If;
    If Updating Then
      Update ss_site_allowance_trans set start_date = :new.mobi_date
      Where EmpNo = :Old.EmpNo and start_date = :Old.mobi_date;
    End If;
    If deleting then
      Delete from ss_site_allowance_trans where empno= :old.empno and start_Date = :old.mobi_date;
    End if;
  End;
END;

/
ALTER TRIGGER "SELFSERVICE"."TRIGGER1" ENABLE;
