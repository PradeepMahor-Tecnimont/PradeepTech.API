--------------------------------------------------------
--  DDL for Package Body PKG_SYSTEM_GRANTS
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE BODY "COMMONMASTERS"."PKG_SYSTEM_GRANTS" As

    Procedure system_grants_emp_details As

        c_emp_details_app_id Constant Varchar2(3) := '023';
    Begin

        Delete
            From commonmasters.system_grants
        Where
            applsystem = c_emp_details_app_id;

        --

        Delete
            From emp_user_access
        Where
            empno In (
                Select
                    empno
                From
                    emplmast
                Where
                    status     = 1
                    And parent = '0187'
            );
        Commit;
        --CV - Secretary
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
            ua.empno,
            'HR USER',
            'HR USER',
            c_emp_details_app_id,
            'EMPLOYEE GENERAL INFO',
            Null       As costcode,
            Null       As projno,
            Null       As role_on_costcode,
            Null       As role_on_projno,
            e.personid As personid
        From
            emp_user_access ua,
            emplmast        e
        Where
            e.empno      = ua.empno
            And e.status = 1
            And e.parent <> '0187';

    End system_grants_emp_details;

End pkg_system_grants;

/
