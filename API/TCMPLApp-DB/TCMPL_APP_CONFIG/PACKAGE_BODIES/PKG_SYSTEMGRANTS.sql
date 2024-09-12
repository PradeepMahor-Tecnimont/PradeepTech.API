Create Or Replace Package Body pkg_systemgrants As

    Procedure sp_tcmplapps_systemgrants(
        param_msg_type Out Varchar2,
        param_msgtext  Out Varchar2
    ) Is
        vcount       Number;
        v_applsystem Varchar2(10) := '027';
    Begin

        /* Delete Employee who leave company */

        Delete
            From sec_module_users_roles_actions
        Where
            empno In
            (
                Select
                    empno
                From
                    vu_emplmast
                Where
                    vu_emplmast.status = 0
            );

        Delete
            From sec_module_user_roles
        Where
            empno In
            (
                Select
                    empno
                From
                    vu_emplmast
                Where
                    vu_emplmast.status = 0
            );

        Select
            Count(*)
        Into
            vcount
        From
            commonmasters.system_grants
        Where
            applsystem = v_applsystem;

        If (vcount > 0) Then
            Delete
                From commonmasters.system_grants
            Where
                applsystem = v_applsystem;

        End If;
        Select
            Count(*)
        Into
            vcount
        From
            commonmasters.system_grants
        Where
            applsystem = v_applsystem;

        If (vcount = 0) Then
            Insert Into commonmasters.system_grants (
                empno,
                applsystem,
                rolename,
                roledesc,
                module
            --  COSTCODE,
            -- ROLE_ON_COSTCODE
            )
            Select
                vu_sys.empno,
                vu_sys.applsystem,
                vu_sys.rolename,
                vu_sys.roledesc,
                vu_sys.module 
            --  vu_sys.COSTCODE,
            --vu_sys.ROLE_ON_COSTCODE
            From
                vu_system_grants vu_sys
            Where
                applsystem = v_applsystem;

            If (Sql%rowcount > 0) Then
                param_msg_type := 'SUCCESS';
            Else
                param_msg_type := 'FAILURE';
            End If;

        End If;

    Exception
        When Others Then
            param_msg_type := 'FAILURE';
            param_msgtext  := 'Exception error - ' || sqlcode || ' -- ' || sqlerrm;
    End sp_tcmplapps_systemgrants;

End pkg_systemgrants;
/
--GRANT all ON "COMMONMASTERS"."SYSTEM_GRANTS" TO "TCMPL_APP_CONFIG" WITH GRANT OPTION;