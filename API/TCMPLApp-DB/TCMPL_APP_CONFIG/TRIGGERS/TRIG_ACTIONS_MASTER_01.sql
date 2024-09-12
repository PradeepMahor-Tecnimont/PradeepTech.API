--------------------------------------------------------
--  DDL for Trigger TRIG_ACTIONS_MASTER_01
--------------------------------------------------------

Create Or Replace Trigger "TCMPL_APP_CONFIG"."TRIG_ACTIONS_MASTER_01" Before
Insert Or Update Of action_id, action_name On sec_actions_master
Referencing
Old As old
New As new
For Each Row
Begin    
    :new.action_id            := trim(upper(:new.action_id));
    :new.action_name          := trim(upper(:new.action_name));    
End;

/
Alter Trigger "TCMPL_APP_CONFIG"."TRIG_ACTIONS_MASTER_01" Enable;