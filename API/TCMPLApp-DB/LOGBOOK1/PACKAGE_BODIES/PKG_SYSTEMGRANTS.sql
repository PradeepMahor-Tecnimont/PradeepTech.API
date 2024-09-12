--------------------------------------------------------
--  DDL for Package Body PKG_SYSTEMGRANTS
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "LOGBOOK1"."PKG_SYSTEMGRANTS" As

    Procedure sp_system_grants_rscl As
        c_rscl_app_id Constant Varchar2(3) := '025';
    Begin
        Delete
            From commonmasters.system_grants
        Where
            applsystem = c_rscl_app_id;

        Delete
            From rscl_loginmast
        Where
            empno Not In (
                Select
                    empno
                From
                    rwk_emplmast
                Where
                    status = 1
            );

        Delete
            From rscl_rights_emp
        Where
            empno Not In (
                Select
                    empno
                From
                    rwk_emplmast
                Where
                    status = 1
            );

        Insert Into commonmasters.system_grants(
            empno,
            rolename,
            roledesc,
            personid,
            applsystem,
            module
        )
        Select
            d.empno,
            'LOGBOOK_ADMIN',
            'LOGBOOK_ADMIN',
            e.personid,
            c_rscl_app_id,
            'Rework Scope Change Logbook'
        From
            rscl_loginmast d,
            rwk_emplmast   e
        Where
            e.status    = 1
            And d.empno = e.empno;

        Insert Into commonmasters.system_grants(
            empno,
            rolename,
            roledesc,
            projno,
            role_on_projno,
            personid,
            applsystem,
            module
        )
        Select
            r.empno,
            Case
                When nvl(lead, 0) = 1 Then
                    'LINE_MANAGER'
                Else
                    'LOGBOOK_USER'
            End rolename,
            Case
                When nvl(lead, 0) = 1 Then
                    'LINE_MANAGER'
                Else
                    'LOGBOOK_USER'
            End roledesc,
            r.projno,
            r.projno,
            e.personid,
            c_rscl_app_id,
            'Rework Scope Change Logbook'
        From
            rscl_rights_emp r,
            rwk_emplmast    e
        Where
            e.status    = 1
            And r.empno = e.empno;

        Commit;
    End sp_system_grants_rscl ;

End pkg_systemgrants;

/
