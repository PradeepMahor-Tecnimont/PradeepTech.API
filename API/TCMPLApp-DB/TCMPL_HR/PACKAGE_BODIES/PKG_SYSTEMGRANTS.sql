Create Or Replace Package Body tcmpl_hr.pkg_systemgrants As

    Procedure sp_system_grants_ofb As
        c_ofb_app_id    Constant Varchar2(3) := '026';
        c_hod_action_id Constant Varchar2(5) := 'A0217';

    Begin

        Delete
            From commonmasters.system_grants
        Where
            applsystem = c_ofb_app_id; 
        
        
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
            ra.action_name,
            ra.action_desc,
            c_ofb_app_id,
            'EMPLOYEE OFF-BOARDING',
            Null       As costcode,
            Null       As projno,
            Null       As role_on_costcode,        --TCM_COSTCODE
            Null       As role_on_projno,        --TCMPL_COSTCODE
            e.personid As personid
        From
            ofb_vu_user_roles_actions ra,
            ofb_vu_emplmast           e
        Where
            e.empno      = ra.empno
            And e.status = 1
            And ra.role_id Is Not Null
            And ra.action_id <> c_hod_action_id;

    End sp_system_grants_ofb;

End pkg_systemgrants;
/