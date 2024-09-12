--------------------------------------------------------
--  DDL for Trigger TRIG_SYSTEM_GRANTS_DELETE
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "COMMONMASTERS"."TRIG_SYSTEM_GRANTS_DELETE" After
    Delete On system_grants
    For Each Row
Begin
    Insert Into system_grants_history (
        empno,
        rolename,
        roledesc,
        applsystem,
        module,
        role_on_costcode,
        role_on_projno,
        deleted_date
    ) Values (
        :old.empno,
        :old.rolename,
        :old.roledesc,
        :old.applsystem,
        :old.module,
        :old.role_on_costcode,
        :old.role_on_projno,
        sysdate
    );

End;
/
ALTER TRIGGER "COMMONMASTERS"."TRIG_SYSTEM_GRANTS_DELETE" ENABLE;
