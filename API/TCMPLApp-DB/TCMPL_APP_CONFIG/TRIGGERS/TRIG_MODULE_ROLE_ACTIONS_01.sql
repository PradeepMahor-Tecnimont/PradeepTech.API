Create Or Replace Trigger "TCMPL_APP_CONFIG"."TRIG_MODULE_ROLE_ACTIONS_01" Before
Insert Or Update Of module_id, role_id, action_id, module_role_action_key_id, module_role_key_id On sec_module_role_actions
Referencing
Old As old
New As new
For Each Row
Begin
    :new.module_id                 := upper(trim(:new.module_id));
    :new.role_id                   := upper(trim(:new.role_id));
    :new.action_id                 := upper(trim(:new.action_id));
    :new.module_role_action_key_id := :new.module_id || :new.role_id || :new.action_id;
    :new.module_role_key_id        := :new.module_id || :new.role_id;

End;
/
Alter Trigger "TCMPL_APP_CONFIG"."TRIG_MODULE_ROLE_ACTIONS_01" Enable;