--------------------------------------------------------
--  DDL for Procedure SP_STATIONERY_SYSTEMGRANTS_OLD
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "COMMONMASTERS"."SP_STATIONERY_SYSTEMGRANTS_OLD" (
    param_msg_type Out Varchar2,
    param_msgtext  Out Varchar2
) Is
    vcount Number;
Begin

 /* Delete Employee who leave company */
        Delete from stationery.stn_stationary_mngr 
            where empno in 
            ( select empno 
                from stationery.stn_vu_emplmast 
                where stn_vu_emplmast.status = 0
            );
            
    Select
        Count(*)
    Into vcount
    From
        system_grants
    Where
        applsystem = '001';

    If ( vcount > 0 ) Then
        Delete From system_grants
        Where
            applsystem = '001';

    End If;
    Select
        Count(*)
    Into vcount
    From
        system_grants
    Where
        applsystem = '001';

    If ( vcount = 0 ) Then
        Insert Into system_grants (
            empno,
            applsystem,
            rolename,
            roledesc,
            module
        )
            Select
                stn.empno,
                stn.applsystem,
                stn.rolename,
                stn.roledesc,
                stn.module
            From
                stationery.vu_system_grants stn;

        If ( Sql%rowcount > 0 ) Then
            param_msg_type := 'SUCCESS';
        Else
            param_msg_type := 'FAILURE';
        End If;

    End If;

Exception
    When Others Then
        param_msg_type := 'FAILURE';
        param_msgtext := 'Exception error - '
                         || sqlcode
                         || ' -- '
                         || sqlerrm;
End sp_stationery_systemgrants_old;

/
