--------------------------------------------------------
--  DDL for View OFB_VU_USER_ROLES_ACTIONS
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "TCMPL_HR"."OFB_VU_USER_ROLES_ACTIONS" ("EMPNO", "NAME", "PARENT", "ACTION_ID", "ACTION_NAME", "ACTION_DESC", "GROUP_NAME", "HOD_COSTCODE", "IS_ACTION_FOR_HOD", "ROLE_ID", "CHECKER_ACTION_ID", "ROLE_NAME", "ROLE_DESC") AS 
  Select
    ua.empno,
    e.name,
    e.parent,
    ua.action_id,
    ra.action_name,
    ra.action_desc,
    ra.group_name,
    ra.hod_costcode,
    ra.is_action_for_hod,
    ra.role_id,
    ra.checker_action_id,
    r.role_name,
    r.role_desc
From
    ofb_user_actions   ua,
    ofb_roles          r,
    ofb_role_actions   ra,
    ofb_vu_emplmast    e
Where
    ua.empno = e.empno
    And ua.action_id  = ra.action_id
    And ra.role_id    = r.role_id
    And e.status      = 1
Union
--Automatic Checker Action/Role to HoD
Select
    cc.hod        empno,
    e.name,
    cc.costcode   parent,
    ra.action_id,
    ra.action_name,
    ra.action_desc,
    ra.group_name,
    ra.hod_costcode,
    ra.is_action_for_hod,
    ra.role_id,
    ra.checker_action_id,
    r.role_name,
    r.role_desc
From
    ofb_role_actions   ra,
    ofb_roles          r,
    ofb_vu_costmast    cc,
    ofb_vu_emplmast    e
Where
    ra.role_id = r.role_id
    And ra.hod_costcode  = cc.costcode
    And cc.hod           = e.empno
    And e.status         = 1
Union
--Off-Boarding TCMPL_User
Select
    ee.empno,
    e.name,
    e.parent,
    Null action_id,
    Null action_name,
    Null action_desc,
    Null group_name,
    Null hod_costcode,
    Null is_action_for_hod,
    r.role_id,
    Null,
    r.role_name,
    r.role_desc
From
    ofb_roles         r,
    ofb_emp_exits     ee,
    ofb_vu_emplmast   e
Where
    ee.empno = e.empno
    And r.role_id  = 'R0211'
    And e.status   = 1
Union 
--HoD
Select
    cc.hod        empno,
    e.name,
    cc.costcode   parent,
    ra.action_id,
    ra.action_name,
    ra.action_desc,
    ra.group_name,
    ra.hod_costcode,
    ra.is_action_for_hod,
    r.role_id,
    Null,
    r.role_name,
    r.role_desc
From
    ofb_roles          r,
    ofb_role_actions   ra,
    ofb_vu_costmast    cc,
    ofb_vu_emplmast    e
Where
    cc.hod = e.empno
    And ra.action_id  = 'A0217'
    And r.role_id     = ra.role_id
    And e.status      = 1
    And cc.noofemps > 0
Union    
    --OffBoarding Initiator
Select
    ur.empno,
    e.name,
    e.parent,
    Null action_id,
    Null action_name,
    Null action_desc,
    Null group_name,
    Null hod_costcode,
    Null is_action_for_hod,
    r.role_id,
    Null,
    r.role_name,
    r.role_desc
From
    ofb_roles         r,
    ofb_user_roles    ur,
    ofb_vu_emplmast   e
Where
    ur.empno = e.empno
    And r.role_id In (
    ofb.roleid_initiator,ofb.roleid_user_admin

    )
    And r.role_id  = ur.role_id
    And e.status   = 1
Union
Select
    ur.empno,
    e.name,
    e.parent,
    am.common_action_id     action_id,
    Null action_name,
    ca.common_action_desc   action_desc,
    Null group_name,
    Null hod_costcode,
    Null is_action_for_hod,
    Null,
    Null,
    Null,
    Null
From
    ofb_common_actions_mapping   am,
    ofb_common_actions           ca,
    ofb_vu_derived_roles         ur,
    ofb_vu_emplmast              e
Where
    ur.empno = e.empno
    And am.role_id           = ur.role_id
    And e.status             = 1
    And ca.common_action_id  = am.common_action_id
Union
Select
    ua.empno,
    e.name,
    e.parent,
    am.common_action_id     action_id,
    Null action_name,
    ca.common_action_desc   action_desc,
    Null group_name,
    Null hod_costcode,
    Null is_action_for_hod,
    Null,
    Null,
    Null,
    Null
From
    ofb_common_actions_mapping   am,
    ofb_common_actions           ca,
    ofb_user_actions             ua,
    ofb_vu_emplmast              e
Where
    ua.empno = e.empno
    And am.action_id         = ua.action_id
    And e.status             = 1
    And ca.common_action_id  = am.common_action_id
Union
--Common Actions for OffBoarding User
Select
    ex.empno,
    e.name,
    e.parent,
    am.common_action_id     action_id,
    Null action_name,
    ca.common_action_desc   action_desc,
    Null group_name,
    Null hod_costcode,
    Null is_action_for_hod,
    Null,
    Null,
    Null,
    Null
From
    ofb_common_actions_mapping   am,
    ofb_common_actions           ca,
    ofb_emp_exits             ex,
    ofb_vu_emplmast              e
Where
    e.empno = ex.empno
    And am.role_id         = 'R0211'
    And e.status             = 1
    And ca.common_action_id  = am.common_action_id
;
  GRANT SELECT ON "TCMPL_HR"."OFB_VU_USER_ROLES_ACTIONS" TO "TCMPL_APP_CONFIG";
