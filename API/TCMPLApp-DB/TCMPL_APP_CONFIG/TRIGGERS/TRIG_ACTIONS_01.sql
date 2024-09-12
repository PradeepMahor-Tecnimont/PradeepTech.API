--------------------------------------------------------
--  DDL for Trigger TRIG_ACTIONS_01
--------------------------------------------------------

Create Or Replace Trigger "TCMPL_APP_CONFIG"."TRIG_ACTIONS_01" Before
Insert Or Update Of module_id, action_id, action_is_active, module_action_key_id On sec_actions
Referencing
Old As old
New As new
For Each Row
Begin

    :new.module_id            := trim(upper(:new.module_id));
    :new.action_id            := trim(upper(:new.action_id));
    :new.action_is_active     := trim(upper(:new.action_is_active));
    :new.module_action_key_id := :new.module_id || :new.action_id;
End;

/
Alter Trigger "TCMPL_APP_CONFIG"."TRIG_ACTIONS_01" Enable;