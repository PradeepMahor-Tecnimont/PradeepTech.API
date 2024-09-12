
  CREATE OR REPLACE FORCE EDITIONABLE VIEW "TCMPL_APP_CONFIG"."VU_MODULE_USER_ROLE_ACTIONS_4_OFB" ("MODULE_ID", "ACTION_ID", "ACTION_NAME", "ACTION_DESC", "EMPNO") AS 
  Select
    sa.module_id, sa.action_id, sa.action_name, sa.action_desc, smur.empno
From
    sec_module_user_roles   smur,
    sec_module_role_actions smra,
    sec_actions             sa

Where
    smur.module_id          = smra.module_id
    And smur.module_id      = sa.module_id
    And sa.action_id        = smra.action_id
    And smur.role_id        = smra.role_id
    And smur.module_id      = 'M02'
    And sa.action_is_active = ok

Union

Select
    sa.module_id, sa.action_id, sa.action_name, sa.action_desc, smura.empno
From
    sec_module_users_roles_actions smura,
    sec_module_role_actions        smra,
    sec_actions                    sa

Where
    smura.module_id         = smra.module_id
    And smura.module_id     = sa.module_id
    And sa.action_id        = smra.action_id
    And smura.role_id       = smra.role_id
    And smura.module_id     = 'M02'
    And sa.action_is_active = ok;


  GRANT SELECT ON "TCMPL_APP_CONFIG"."VU_MODULE_USER_ROLE_ACTIONS_4_OFB" TO "TCMPL_HR";
