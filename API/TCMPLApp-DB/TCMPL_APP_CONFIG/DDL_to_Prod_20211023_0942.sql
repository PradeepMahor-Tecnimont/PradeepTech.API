--------------------------------------------------------
--  File created - Saturday-October-23-2021   
--------------------------------------------------------
---------------------------
--New TABLE
--APP_FILTER
---------------------------
  CREATE TABLE "APP_FILTER" 
   (	"PERSON_ID" VARCHAR2(8) NOT NULL ENABLE,
	"MODULE_NAME" VARCHAR2(50) NOT NULL ENABLE,
	"MVC_ACTION_NAME" VARCHAR2(100) NOT NULL ENABLE,
	"FILTER_JSON" VARCHAR2(4000) NOT NULL ENABLE,
	"MODIFIED_ON" DATE NOT NULL ENABLE,
	CONSTRAINT "APP_FILTER_PK" PRIMARY KEY ("PERSON_ID","MODULE_NAME","MVC_ACTION_NAME","FILTER_JSON") ENABLE
   );
---------------------------
--Changed VIEW
--VU_MODULE_USER_ROLE_ACTIONS
---------------------------
CREATE OR REPLACE FORCE VIEW "VU_MODULE_USER_ROLE_ACTIONS" 
 ( "MODULE_ID", "MODULE_NAME", "ROLE_ID", "ROLE_NAME", "EMPNO", "PERSON_ID", "ACTION_ID"
  )  AS 
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
union
Select
    mr.module_id,
    Null module_name,
    mr.role_id,
    r.role_desc,
    d.empno empno,
    Null person_id,
    ra.action_id
From
    selfservice.ss_delegate d,
    sec_module_roles        mr,
    sec_roles               r,
    sec_module_role_actions ra
Where
    mr.role_id       = app_constants.role_id_mngr_hod_onbehalf
    And mr.role_id   = r.role_id
    And mr.module_id = ra.module_id(+)
    And mr.role_id   = ra.action_id(+)
Union

Select
    mr.module_id,
    Null          module_name,
    mr.role_id,
    r.role_desc,
    lead.empno,
    lead.personid person_id,
    ra.action_id
From
    (
        Select
            empno, personid
        From
            vu_emplmast
        Where
            status = 1
            And empno In (
                Select
                    empno
                From
                    selfservice.ss_lead_approver
            )
    )                       lead,
    sec_module_roles        mr,
    sec_roles               r,
    sec_module_role_actions ra
Where
    mr.role_id       = app_constants.role_id_lead
    And mr.role_id   = r.role_id
    And mr.module_id = ra.module_id(+)
    And mr.role_id   = ra.action_id(+);
---------------------------
--New INDEX
--APP_FILTER_PK
---------------------------
  CREATE UNIQUE INDEX "APP_FILTER_PK" ON "APP_FILTER" ("PERSON_ID","MODULE_NAME","MVC_ACTION_NAME","FILTER_JSON");
---------------------------
--New PACKAGE
--PKG_FILTER
---------------------------
CREATE OR REPLACE PACKAGE "PKG_FILTER" As

    Procedure add_filter(
        p_person_id       Varchar2,
        p_module_name     Varchar2,
        p_mvc_action_name Varchar2,
        p_filter_json     Varchar2,
        p_success Out     Varchar2,
        p_message Out     Varchar2
    );

    Procedure get_filter(
        p_person_id       Varchar2,
        p_module_name     Varchar2,
        p_mvc_action_name Varchar2,
        p_filter_json Out Varchar2,
        p_success     Out Varchar2,
        p_message     Out Varchar2
    );
End pkg_filter;
/
---------------------------
--Changed PACKAGE
--APP_CONSTANTS
---------------------------
CREATE OR REPLACE PACKAGE "APP_CONSTANTS" As

    c_role_hod Constant Varchar2(4) := 'R002';
    c_role_mngr_hod Constant Varchar2(4) := 'R004';
    c_role_mngr_hod_onbehalf Constant Varchar2(4) := 'R005';
    c_role_lead Constant Varchar2(4) := 'R006';
    
    Function role_id_hod Return Varchar2;

    Function role_id_mngr_hod Return Varchar2;

    Function role_id_mngr_hod_onbehalf Return Varchar2;

    Function role_id_lead Return Varchar2;

End app_constants;
/
---------------------------
--Changed PACKAGE BODY
--APP_CONSTANTS
---------------------------
CREATE OR REPLACE PACKAGE BODY "APP_CONSTANTS" As

    Function role_id_hod Return Varchar2 Is
    Begin
        Return c_role_hod;
    End;

    Function role_id_mngr_hod Return Varchar2 Is
    Begin
        Return c_role_mngr_hod;
    End;

    Function role_id_mngr_hod_onbehalf Return Varchar2 Is
    Begin
        Return c_role_mngr_hod_onbehalf;
    End;

    Function role_id_lead Return Varchar2 Is
    Begin
        Return c_role_lead;
    End;

End app_constants;
/
---------------------------
--New PACKAGE BODY
--PKG_FILTER
---------------------------
CREATE OR REPLACE PACKAGE BODY "PKG_FILTER" As

    Procedure add_filter(
        p_person_id       Varchar2,
        p_module_name     Varchar2,
        p_mvc_action_name Varchar2,
        p_filter_json     Varchar2,
        p_success Out     Varchar2,
        p_message Out     Varchar2
    ) As
    Begin
        Delete
            From app_filter
        Where
            person_id           = p_person_id
            And module_name     = p_module_name
            And mvc_action_name = p_mvc_action_name;
        Commit;
        Insert Into app_filter(person_id, module_name, mvc_action_name, filter_json, modified_on)
        Values (p_person_id, p_module_name, p_mvc_action_name, p_filter_json, sysdate);
    End add_filter;

    Procedure get_filter(
        p_person_id       Varchar2,
        p_module_name     Varchar2,
        p_mvc_action_name Varchar2,
        p_filter_json Out Varchar2,
        p_success     Out Varchar2,
        p_message     Out Varchar2
    ) As
        rec_app_filter app_filter%rowtype;
    Begin
        Select
            *
        Into
            rec_app_filter
        From
            app_filter
        Where
            person_id           = p_person_id
            And module_name     = p_module_name
            And mvc_action_name = p_mvc_action_name
            and trunc(modified_on) = trunc(sysdate);
        p_filter_json := rec_app_filter.filter_json;
        p_success     := 'OK';
    Exception
        When Others Then
            Rollback;
            p_success := 'KO';
            p_message := 'Err - ' || sqlcode || ' - ' || sqlerrm;
    End get_filter;

End pkg_filter;
/
