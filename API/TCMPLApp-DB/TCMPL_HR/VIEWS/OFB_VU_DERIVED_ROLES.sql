--------------------------------------------------------
--  DDL for View OFB_VU_DERIVED_ROLES
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "TCMPL_HR"."OFB_VU_DERIVED_ROLES" ("EMPNO", "ROLE_ID") AS 
  select empno, role_id from ofb_user_roles
union
Select Distinct
    hod              empno,
    ofb.roleid_hod   role_id
From
    ofb_vu_costmast
Where
    noofemps > 0
Union
Select
    c.hod empno,
    ra.role_id
From
    ofb_vu_costmast    c,
    ofb_role_actions   ra
Where
    ra.hod_costcode Is Not Null
    And ra.hod_costcode = c.costcode
;
  GRANT SELECT ON "TCMPL_HR"."OFB_VU_DERIVED_ROLES" TO "TCMPL_APP_CONFIG";
