--------------------------------------------------------
--  DDL for Package Body OFB
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE BODY "TCMPL_HR"."OFB" As

    Function roleid_first_approver Return Varchar2 As
    Begin
        Return c_role_id_first_approver;
    End;

    Function roleid_second_approver Return Varchar2 As
    Begin
        Return c_role_id_second_approver;
    End;

    Function roleid_hod Return Varchar2 As
    Begin
        Return c_role_id_hod;
    End;

    Function roleid_initiator Return Varchar2 As
    Begin
        Return c_role_id_initiator;
    End;

    Function roleid_hr_manager Return Varchar2 As
    Begin
        Return c_role_id_hr_manager;
    End;

    Function roleid_user_admin Return Varchar2 As
    Begin
        Return c_role_id_user_admin;
    End;

    Function actionid_hr_mngr Return Varchar2 As
    Begin
        Return c_action_id_hr_mngr;
    End;

    Function actionid_hod_of_emp Return Varchar2 As
    Begin
        Return c_action_id_hod_of_emp;
    End;

    Function get_costcode_name (
        p_costcode Varchar2
    ) Return Varchar2 As
        v_parent_name Varchar2(100);
    Begin
        Select
            name
        Into v_parent_name
        From
            ofb_vu_costmast
        Where
            costcode = p_costcode;

        Return v_parent_name;
    Exception
        When Others Then
            Return 'Err';
    End;

End ofb;

/

  GRANT EXECUTE ON "TCMPL_HR"."OFB" TO "TCMPL_APP_CONFIG";
