Create Or Replace Force Editionable View "TCMPL_APP_CONFIG"."VU_MODULE_USER_ROLE_ACTIONS_4_DG" (
    "MODULE_ID",
    "ACTION_ID",
    "ACTION_NAME",
    "ACTION_DESC",
    "ROLE_ID",
    "EMPNO",
    "COSTCODE"
) As
    Select
        a.module_id,
        a.action_id,
        a.action_name,
        a.action_desc,
        ra.role_id,
        ur.empno,
        Null As costcode
    From
        sec_actions             a,
        sec_module_role_actions ra,
        sec_module_user_roles   ur
    Where
        a.module_id      = ra.module_id
        And a.action_id  = ra.action_id
        And ra.module_id = ur.module_id
        And ra.role_id   = ur.role_id
        And a.action_id  = 'A213'
        And a.module_id  = 'M19'

    Union All

    Select
        a.module_id,
        a.action_id,
        a.action_name,
        a.action_desc,
        ra.role_id,
        c.hod,
        c.costcode
    From
        sec_module_role_actions ra,
        sec_actions             a,
        vu_costmast             c
    Where
        ra.role_id      = app_constants.role_id_hod
        And a.action_id = ra.action_id
        And a.module_id = ra.module_id
        And a.action_id In ('A211', 'A212')
        And a.module_id = 'M19'
        And c.hod Is Not Null
        And c.hod In (
            Select
                empno
            From
                vu_emplmast
            Where
                status = 1
        )

    Union All

    Select
        a.module_id,
        a.action_id,
        a.action_name,
        a.action_desc,
        ra.role_id,
        urc.empno,
        urc.costcode
    From
        sec_module_role_actions        ra,
        sec_actions                    a,
        sec_module_user_roles_costcode urc
    Where
        a.action_id     = ra.action_id
        And a.module_id = ra.module_id
        And a.module_id = urc.module_id
        And ra.role_id = urc.role_id
        And a.module_id = 'M19'
        And urc.role_id In ('R002', 'R003');

  Grant Select On "TCMPL_APP_CONFIG"."VU_MODULE_USER_ROLE_ACTIONS_4_DG" To "TCMPL_HR";