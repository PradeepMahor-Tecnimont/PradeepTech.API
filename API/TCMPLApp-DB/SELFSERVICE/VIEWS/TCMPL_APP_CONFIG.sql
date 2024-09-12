--------------------------------------------------------
--  DDL for View TCMPL_APP_CONFIG
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "SELFSERVICE"."TCMPL_APP_CONFIG" () AS 
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
        Null      module_name,
        mr.role_id,
        r.role_desc,
        mngr.mngr empno,
        Null      person_id,
        ra.action_id
    From
        (
            Select
            Distinct mngr
            From
                vu_emplmast
            Where
                status = 1
                And mngr Is Not Null
        )                       mngr,
        sec_module_roles        mr,
        sec_roles               r,
        sec_module_role_actions ra
    Where
        mr.role_id       = app_constants.role_id_mngr_hod
        And mr.role_id   = r.role_id
        And mr.module_id = ra.module_id(+)
        And mr.role_id   = ra.action_id(+)
        And mr.module_id = 'M04'
    Union
    Select
        mr.module_id,
        Null    module_name,
        mr.role_id,
        r.role_desc,
        d.empno empno,
        Null    person_id,
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
        And mr.module_id = 'M04'
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
        And mr.role_id   = ra.action_id(+)
        And mr.module_id = 'M04'
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
                        selfservice.ss_user_dept_rights
                )
        )                       lead,
        sec_module_roles        mr,
        sec_roles               r,
        sec_module_role_actions ra
    Where
        mr.role_id       = app_constants.role_id_lead
        And mr.role_id   = r.role_id
        And mr.module_id = ra.module_id(+)
        And mr.role_id   = ra.action_id(+)
        And mr.module_id = 'M04'
;
