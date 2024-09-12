Create Or Replace Package Body "SELFSERVICE"."PKG_SYSTEMGRANTS" As

    Procedure sp_health_systemgrants(
        param_msg_type Out Varchar2,
        param_msgtext  Out Varchar2
    ) As
        vexits      Number;
        vapplsystem Varchar2(3) := '019';
    Begin
        -- Remove employees from table who left company
        Delete
            From ss_health_hrduser
        Where
            empno In (
                Select
                Distinct empno
                From
                    vu_system_grants_health
                Where
                    status = 0
            );
        Commit;

        -- Check records exists in COMMONMASTERS
        Select
            Count(*)
        Into
            vexits
        From
            commonmasters.system_grants
        Where
            applsystem = vapplsystem;

        -- Remove records in COMMONMASTERS if exits
        If (vexits > 0) Then
            Delete
                From commonmasters.system_grants
            Where
                applsystem = vapplsystem;
            Commit;
        End If;

        -- Insert records available in VU_SYSTEM_GRANTS
        Insert Into commonmasters.system_grants (
            empno,
            applsystem,
            rolename,
            roledesc,
            module
        )
        Select
            vu_sys.empno,
            vu_sys.applsystem,
            vu_sys.rolename,
            vu_sys.roledesc,
            vu_sys.module
        From
            vu_system_grants_health vu_sys
        Where
            applsystem = vapplsystem;

        If (Sql%rowcount > 0) Then
            param_msg_type := 'SUCCESS';
        Else
            param_msg_type := 'FAILURE';
        End If;
    End sp_health_systemgrants;

    Procedure sp_system_grants_selfservice As
        c_selfservice_app_id Constant Varchar2(3) := '021';
        c_amodule_id         Constant Varchar2(3) := 'M04';
        c_attendance_admin   Constant Varchar2(4) := 'R011';
        c_line_manager       Constant Varchar2(4) := 'R006';
    Begin

        Delete
            From commonmasters.system_grants
        Where
            applsystem = c_selfservice_app_id;
        Delete
            From ss_lead_approver
        Where
            empno Not In (
                Select
                    empno
                From
                    ss_emplmast
                Where
                    status = 1
            );
        Delete
            From ss_user_dept_rights
        Where
            empno Not In (
                Select
                    empno
                From
                    ss_emplmast
                Where
                    status = 1
            );
        Delete
            From ss_delegate
        Where
            empno Not In (
                Select
                    empno
                From
                    ss_emplmast
                Where
                    status = 1
            )
            Or mngr Not In (
                Select
                    empno
                From
                    ss_emplmast
                Where
                    status = 1
            );

        --selfservice - Attendance Administrator
        Insert Into commonmasters.system_grants(
            empno,
            rolename,
            roledesc,
            applsystem,
            module,
            costcode,
            projno,
            role_on_costcode,
            role_on_projno,
            personid
        )
        Select
        Distinct
            ra.empno,
            'ATTENDANCE_ADMIN',
            'ATTENDANCE ADMINISTRATOR',
            c_selfservice_app_id,
            'SELFSERVICE',
            Null       As costcode,
            Null       As projno,
            Null       As role_on_costcode,        --TCM_COSTCODE
            Null       As role_on_projno,        --TCMPL_COSTCODE
            e.personid As personid
        From
            tcmpl_app_config.vu_module_user_role_actions ra,
            ss_emplmast                                  e
        Where
            e.empno       = ra.empno
            And e.status  = 1
            And module_id = c_amodule_id
            And role_id   = c_attendance_admin;

        --Selfservice - LINE MANAGER 
        Insert Into commonmasters.system_grants(
            empno,
            rolename,
            roledesc,
            applsystem,
            module,
            costcode,
            projno,
            role_on_costcode,
            role_on_projno,
            personid
        )
        Select
        Distinct
            la.empno,
            'LINE MANAGER',
            'LINE MANAGER',
            c_selfservice_app_id,
            'SELFSERVICE',
            cc.sapcc   As costcode,
            Null       As projno,
            la.parent  As role_on_costcode,        --TCM_COSTCODE
            Null       As role_on_projno,        --TCMPL_COSTCODE
            e.personid As personid
        From
            ss_lead_approver la,
            ss_emplmast      e,
            ss_costmast      cc
        Where
            e.empno      = la.empno
            And e.status = 1
            And e.parent = cc.costcode;

        --Selfservice - SECRETARY

        Insert Into commonmasters.system_grants(
            empno,
            rolename,
            roledesc,
            applsystem,
            module,
            costcode,
            projno,
            role_on_costcode,
            role_on_projno,
            personid
        )
        Select
        Distinct
            sec.empno,
            'SECRETARY',
            'SECRETARY',
            c_selfservice_app_id,
            'SELFSERVICE',
            cc.sapcc   As costcode,
            Null       As projno,
            sec.parent As role_on_costcode,        --TCM_COSTCODE
            Null       As role_on_projno,        --TCMPL_COSTCODE
            e.personid As personid
        From
            ss_user_dept_rights sec,
            ss_emplmast         e,
            ss_costmast         cc
        Where
            e.empno        = sec.empno
            And e.status   = 1
            And sec.parent = cc.costcode;

        --Selfservice - ON BEHALF OF HoD
        Insert Into commonmasters.system_grants(
            empno,
            rolename,
            roledesc,
            applsystem,
            module,
            costcode,
            projno,
            role_on_costcode,
            role_on_projno,
            personid
        )
        Select
        Distinct
            d.empno,
            'ON BEHALF OF HoD',
            'ON BEHALF OF HoD',
            c_selfservice_app_id,
            'SELFSERVICE',
            cc.sapcc    As costcode,
            Null        As projno,
            cc.costcode As role_on_costcode,        --TCM_COSTCODE
            Null        As role_on_projno,        --TCMPL_COSTCODE
            e.personid  As personid
        From
            ss_delegate d,
            ss_emplmast e,
            ss_costmast cc
        Where
            e.empno      = d.empno
            And e.status = 1
            And d.mngr   = cc.hod;

    End sp_system_grants_selfservice;

End pkg_systemgrants;
/