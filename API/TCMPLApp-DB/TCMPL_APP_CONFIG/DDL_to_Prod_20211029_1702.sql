--------------------------------------------------------
--  File created - Friday-October-29-2021   
--------------------------------------------------------
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
        mr.role_id       = app_constants.role_id_secretary
        And mr.role_id   = r.role_id
        And mr.module_id = ra.module_id(+)
        And mr.role_id   = ra.action_id(+)
        And mr.module_id = 'M04';
---------------------------
--Changed PACKAGE
--APP_CONSTANTS
---------------------------
CREATE OR REPLACE PACKAGE "APP_CONSTANTS" As

    c_role_hod Constant Varchar2(4) := 'R002';
    c_role_secretary Constant Varchar2(4) := 'R003';
    c_role_mngr_hod Constant Varchar2(4) := 'R004';
    c_role_mngr_hod_onbehalf Constant Varchar2(4) := 'R005';
    c_role_lead Constant Varchar2(4) := 'R006';
    
    Function role_id_hod Return Varchar2;

    Function role_id_mngr_hod Return Varchar2;

    Function role_id_mngr_hod_onbehalf Return Varchar2;

    Function role_id_lead Return Varchar2;

    Function role_id_secretary Return Varchar2;

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

    Function role_id_secretary Return Varchar2 Is
    Begin
        Return c_role_secretary;
    End;

End app_constants;
/
---------------------------
--Changed PACKAGE BODY
--APP_USERS
---------------------------
CREATE OR REPLACE PACKAGE BODY "APP_USERS" As

    Function get_empno_from_win_uid(
        p_win_uid Varchar2
    ) Return Varchar2 As
        v_user_domain Varchar2(60);
        v_user_id     Varchar2(60);
        v_empno       Varchar2(5);
        v_host_name   Varchar2(100);
        c_dev_env     Constant Varchar2(100) := 'tpldevoradb';
    Begin
        v_user_domain := substr(p_win_uid, 1, instr(p_win_uid, '\') - 1);

        v_user_id     := substr(p_win_uid, instr(p_win_uid, '\') + 1);
        Select
            a.empno
        Into
            v_empno
        From
            vu_userids  a,
            vu_emplmast b
        Where
            a.empno             = b.empno
            And upper(a.userid) = upper(v_user_id)
            And upper(a.domain) = upper(v_user_domain)
            And b.status        = 1;

        Select
            sys_context('USERENV', 'SERVER_HOST')
        Into
            v_host_name
        From
            dual;
        If v_host_name = c_dev_env Then
            If v_empno = '02320' Then
                Null;
                --v_empno := '02242'; -- Nitin Narvekar
                --v_empno := '02640'; -- Mayekar Abhijit
                --v_empno := '02848'; -- Nilesh Sawant
                --v_empno := '01938'; -- Sanjay Mistry
                --v_empno := '02301'; -- Shridhara Poojary
                --v_empno := '02079'; -- Kotian
                --v_empno := '04057'; -- Kadam Sunil
                --v_empno := '00583'; -- MAKUR GAUTAM	
                --v_empno := '10072'; -- Vinay Joshi
                --v_empno := '02459'; -- Annie Fernandes
                --v_empno := '01994'; -- Sharvari Vaidya
                --v_empno := '03682'; -- Mandar Santan Chandrakant
                --v_empno := '01746';
                --v_empno := '01914'; -- Vaz Anthony
                --v_empno := '03847';
                --v_empno := '03150'; --MAHARNAWAR NAVNATH LAXMAN (Piping for punch details)
                --v_empno := '01412';
                --v_empno := '10646' --Rajitha;
            End If;
        End If;
        Return v_empno;
    Exception
        When Others Then
            Return Null;
    End;

    Procedure get_emp_details_from_win_uid(
        p_win_uid      Varchar2,
        p_empno    Out Varchar2,
        p_emp_name Out Varchar2,
        p_costcode Out Varchar2,
        p_success  Out Varchar2,
        p_message  Out Varchar2
    ) As
        v_empno Char(5);
    Begin
        v_empno   := get_empno_from_win_uid(p_win_uid);
        Select
            empno,
            name,
            parent
        Into
            p_empno,
            p_emp_name,
            p_costcode
        From
            vu_emplmast
        Where
            empno = v_empno;

        p_success := 'OK';
    Exception
        When Others Then
            p_success := 'KO';
            p_message := 'Err - ' || sqlcode || ' - ' || sqlerrm;
    End;

End app_users;
/
