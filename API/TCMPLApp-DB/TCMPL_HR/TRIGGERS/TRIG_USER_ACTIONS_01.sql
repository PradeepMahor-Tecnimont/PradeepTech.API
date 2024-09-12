--------------------------------------------------------
--  DDL for Trigger TRIG_USER_ACTIONS_01
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "TCMPL_HR"."TRIG_USER_ACTIONS_01" Before
    Insert Or Update Of action_id, empno, role_id On ofb_user_actions
    Referencing
            Old As old
            New As new
    For Each Row
Begin
    Declare
        v_role_id Varchar2(5);
    Begin
        If :new.action_id Is Null Then
            :new.role_id := Null;
            return;
        End If;

        Select
            role_id
        Into v_role_id
        From
            ofb_role_actions
        Where
            action_id = :new.action_id;

        :new.role_id := v_role_id;
    Exception
        When others Then
            :new.role_id := Null;
    End;
End;

/
ALTER TRIGGER "TCMPL_HR"."TRIG_USER_ACTIONS_01" ENABLE;
