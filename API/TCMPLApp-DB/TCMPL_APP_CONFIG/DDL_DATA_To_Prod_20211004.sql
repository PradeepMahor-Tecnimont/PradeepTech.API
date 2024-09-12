--------------------------------------------------------
--  File created - Monday-October-04-2021   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for View VU_MODULE_USER_ROLE_ACTIONS
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "VU_MODULE_USER_ROLE_ACTIONS" ("MODULE_ID", "MODULE_NAME", "ROLE_ID", "ROLE_NAME", "EMPNO", "PERSON_ID", "ACTION_ID") AS 
  Select
    ur.module_id,
    m.module_name,
    ur.role_id,
    r.role_name,
    ur.empno,
    ur.person_id,
    ra.action_id
From
    sec_module_user_roles   ur,
    sec_modules             m,
    sec_roles               r,
    sec_module_role_actions ra
Where
    ur.module_id              = m.module_id
    And ur.role_id            = r.role_id
    And ur.module_role_key_id = ra.module_role_key_id(+)
Union
Select
    mr.module_id,
    Null module_name,
    mr.role_id,
    r.role_desc,
    hod  empno,
    Null person_id,
    ra.action_id
From
    vu_costmast             c,
    sec_module_roles        mr,
    sec_roles               r,
    sec_module_role_actions ra
Where
    mr.role_id       = app_constants.role_id_hod
    And mr.role_id   = r.role_id
    And mr.module_id = ra.module_id(+)
    And mr.role_id   = ra.action_id(+)
Union
Select
    mr.module_id,
    Null module_name,
    mr.role_id,
    r.role_desc,
    mngr.mngr  empno,
    Null person_id,
    ra.action_id
From
    (select distinct mngr from vu_emplmast where status = 1 and mngr is not null) mngr,
    sec_module_roles        mr,
    sec_roles               r,
    sec_module_role_actions ra
Where
    mr.role_id       = app_constants.role_id_mngr_hod
    And mr.role_id   = r.role_id
    And mr.module_id = ra.module_id(+)
    And mr.role_id   = ra.action_id(+)
;
REM INSERTING into SEC_ACTIONS
SET DEFINE OFF;
REM INSERTING into SEC_MODULE_ROLE_ACTIONS
SET DEFINE OFF;
REM INSERTING into SEC_MODULE_ROLES
SET DEFINE OFF;
Insert into SEC_MODULE_ROLES (MODULE_ID,ROLE_ID,MODULE_ROLE_KEY_ID) values ('M04','R004','M04R004');
Insert into SEC_MODULE_ROLES (MODULE_ID,ROLE_ID,MODULE_ROLE_KEY_ID) values ('M04','R011','M04R011');
REM INSERTING into SEC_MODULE_USER_ROLES
SET DEFINE OFF;
Insert into SEC_MODULE_USER_ROLES (MODULE_ID,ROLE_ID,EMPNO,PERSON_ID,MODULE_ROLE_KEY_ID) values ('M04','R011','02320','01009257','M04R011');
REM INSERTING into SEC_MODULES
SET DEFINE OFF;
Insert into SEC_MODULES (MODULE_ID,MODULE_NAME,MODULE_LONG_DESC,MODULE_IS_ACTIVE,MODULE_SCHEMA_NAME,FUNC_TO_CHECK_USER_ACCESS,MODULE_SHORT_DESC) values ('M04','SELFSERVICE','Attendance, Leave Management','OK','SELFSERVICE',null,'SelfService');
--------------------------------------------------------
--  DDL for Package APP_CONSTANTS
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE "APP_CONSTANTS" As

    c_role_hod Constant Varchar2(4) := 'R002';
    c_role_mngr_hod Constant Varchar2(4) := 'R004';

    Function role_id_hod Return Varchar2;

    Function role_id_mngr_hod Return Varchar2;

End app_constants;

/
--------------------------------------------------------
--  DDL for Package Body APP_CONSTANTS
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE BODY "APP_CONSTANTS" As

    Function role_id_hod Return Varchar2 Is
    Begin
        Return c_role_hod;
    End;

    Function role_id_mngr_hod Return Varchar2 Is
    Begin
        Return c_role_mngr_hod;
    End;

End app_constants;

/
