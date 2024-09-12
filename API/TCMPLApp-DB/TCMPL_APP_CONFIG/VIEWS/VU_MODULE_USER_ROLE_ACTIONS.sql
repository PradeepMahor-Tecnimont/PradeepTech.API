Create Or Replace Force Editionable View "TCMPL_APP_CONFIG"."VU_MODULE_USER_ROLE_ACTIONS" (
    "MODULE_ID",
    "MODULE_NAME",
    "ROLE_ID",
    "ROLE_NAME",
    "EMPNO",
    "PERSON_ID",
    "ACTION_ID"
) As
    Select
        ur.module_id,
        m.module_name,
        ur.role_id,
        r.role_name,
        ur.empno,
        ur.person_id,
        ra.action_id
    From
        sec_modules             m,
        sec_module_user_roles   ur,
        sec_roles               r,
        sec_module_role_actions ra
    Where
        m.module_id               = ur.module_id
        And ur.role_id            = r.role_id
        And ur.module_role_key_id = ra.module_role_key_id(+)

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
        And mr.role_id   = ra.role_id(+)
        And mr.module_id In ('M04', 'M01')

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
        And mr.role_id   = ra.role_id(+)
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
        And mr.role_id   = ra.role_id(+)
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
        mr.role_id       = app_constants.role_id_secretary
        And mr.role_id   = r.role_id
        And mr.module_id = ra.module_id(+)
        And mr.role_id   = ra.role_id(+)
        And mr.module_id = 'M04'

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
        And mr.role_id   = ra.role_id(+)
        And mr.module_id Not In('M05', 'M07')
    Union

    Select
        mura.module_id,
        m.module_name module_name,
        mura.role_id,
        r.role_desc   role_desc,
        mura.empno,
        e.personid    person_id,
        mura.action_id
    From
        sec_module_users_roles_actions mura,
        vu_emplmast                    e,
        sec_roles                      r,
        sec_modules                    m

    Where
        mura.empno         = e.empno
        And mura.role_id   = r.role_id
        And mura.module_id = m.module_id

    Union
    /*
    Select
        mr.module_id,
        Null module_name,
        mr.role_id,
        r.role_desc,
        e.empno,
        Null person_id,
        ra.action_id
    From
        vu_emplmast             e,
        sec_module_roles        mr,
        sec_roles               r,
        sec_module_role_actions ra
    Where
        e.status         = 1
        And mr.role_id   = 'R001'
        And mr.role_id   = r.role_id
        And mr.module_id = ra.module_id(+)
        And mr.role_id   = ra.role_id(+)
        And mr.module_id In('M01')
    */
    Select
        mr.module_id,
        Null module_name,
        mr.role_id,
        r.role_desc,
        e.empno,
        Null person_id,
        ra.action_id
    From
        vu_emplmast             e,
        sec_module_roles        mr,
        sec_roles               r,
        sec_module_role_actions ra
    Where
        e.status         = 1
        And mr.role_id   = app_constants.role_id_emp_status_1
        And mr.role_id   = r.role_id
        And mr.module_id = ra.module_id(+)
        And mr.role_id   = ra.role_id(+)
        And mr.module_id In(app_constants.mod_id_swp_vaccine, app_constants.mod_id_hse_incident, app_constants.mod_id_job_master)

    Union
    Select
        mr.module_id,
        Null module_name,
        mr.role_id,
        r.role_desc,
        e.empno,
        Null person_id,
        ra.action_id
    From
        vu_emplmast             e,
        sec_module_roles        mr,
        sec_roles               r,
        sec_module_role_actions ra
    Where
        e.status         = 1
        And mr.role_id   = app_constants.role_id_regular_ftse
        And mr.role_id   = r.role_id
        And e.emptype In ('R', 'F')
        And mr.module_id = ra.module_id(+)
        And mr.role_id   = ra.role_id(+)
        And mr.module_id In (app_constants.mod_id_emp_gen_info, app_constants.mod_id_ers_user)

    Union
    Select
        mr.module_id,
        Null module_name,
        mr.role_id,
        r.role_desc,
        e.empno,
        Null person_id,
        ra.action_id
    From
        vu_emplmast             e,
        sec_module_roles        mr,
        sec_roles               r,
        sec_module_role_actions ra
    Where
        e.status         = 1
        And mr.role_id   = 'R074'
        And mr.role_id   = r.role_id
        And e.emptype In ('C')
        And mr.module_id = ra.module_id(+)
        And mr.role_id   = ra.role_id(+)
        And mr.module_id In(app_constants.mod_id_emp_gen_info)

    Union

    Select
        mr.module_id,
        Null module_name,
        mr.role_id,
        r.role_desc,
        e.empno,
        Null person_id,
        ra.action_id
    From
        vu_emplmast             e,
        sec_module_roles        mr,
        sec_roles               r,
        sec_module_role_actions ra,
        timecurr.emptypemast    etm
    Where
        e.status         = 1
        And etm.emptype  = e.emptype
        And etm.tm       = 1
        And mr.role_id   = app_constants.role_id_status_1_emptype_tm_1
        And mr.role_id   = r.role_id
        And mr.module_id = ra.module_id(+)
        And mr.role_id   = ra.role_id(+)
        And mr.module_id = app_constants.mod_id_timesheet

    Union

    Select
        ur."MODULE_ID", ur."MODULE_NAME", ur."ROLE_ID", ur."ROLE_NAME", ur."EMPNO", Null person_id, ra.action_id
    From
        (
            Select
            Distinct
                rc.module_id,
                m.module_name,
                rc.role_id,
                r.role_name,
                rc.empno
            From
                sec_module_user_roles_costcode rc
                Inner Join sec_modules         m
                On rc.module_id = m.module_id
                Inner Join sec_roles           r
                On rc.role_id = r.role_id
            Where
                rc.module_id In ('M07','M10','M19')
        )                                       ur
        Left Outer Join sec_module_role_actions ra
        On ur.module_id = ra.module_id
        And ur.role_id  = ra.role_id;

  Grant Select On "TCMPL_APP_CONFIG"."VU_MODULE_USER_ROLE_ACTIONS" To "SELFSERVICE";