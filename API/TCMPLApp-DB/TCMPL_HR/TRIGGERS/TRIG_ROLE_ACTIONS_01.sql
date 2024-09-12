--------------------------------------------------------
--  DDL for Trigger TRIG_ROLE_ACTIONS_01
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "TCMPL_HR"."TRIG_ROLE_ACTIONS_01" Before
    Insert Or Update Of action_id, action_name, is_action_for_hod On ofb_role_actions
    Referencing
            Old As old
            New As new
    For Each Row
Begin
    :new.action_id           := Upper(Trim(:new.action_id));
    :new.action_name         := Upper(Trim(:new.action_name));
    :new.is_action_for_hod   := Upper(Trim(:new.is_action_for_hod));
End;

/
ALTER TRIGGER "TCMPL_HR"."TRIG_ROLE_ACTIONS_01" ENABLE;
