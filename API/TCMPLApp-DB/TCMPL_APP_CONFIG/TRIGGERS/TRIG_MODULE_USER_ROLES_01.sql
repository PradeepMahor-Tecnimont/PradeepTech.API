Create Or Replace Trigger "TCMPL_APP_CONFIG"."TRIG_MODULE_USER_ROLES_01" Before
Insert Or Update Of module_id, role_id, empno, person_id, module_role_key_id On sec_module_user_roles
Referencing
Old As old
New As new
For Each Row
Begin
    :new.module_id          := upper(trim(:new.module_id));
    :new.role_id            := upper(trim(:new.role_id));
    :new.empno              := upper(trim(:new.empno));
    :new.module_role_key_id := :new.module_id || :new.role_id;

End;
/
Alter Trigger "TCMPL_APP_CONFIG"."TRIG_MODULE_USER_ROLES_01" Enable;