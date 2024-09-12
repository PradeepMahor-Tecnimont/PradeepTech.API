create or replace Package Body                    "TCMPL_APP_CONFIG"."APP_CONSTANTS" As

    Function role_id_emp_status_1 Return Varchar2 Is
    Begin
        Return c_role_emp_status_1;
    End;

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

    Function role_id_swp_seat_plan Return Varchar2 Is
    Begin
        Return c_role_seat_plan;
    End;

    Function role_id_status_1_emptype_tm_1 Return Varchar2 Is
    Begin
        Return c_role_emp_status_1_emptype_tm_1;
    End;

    Function role_id_onbehalf_erp_pm Return Varchar2 Is
    Begin
        Return c_role_onbehalf_erp_pm;
    End;

    Function role_id_onbehalf_js Return Varchar2 Is
    Begin
        Return c_role_onbehalf_js;
    End;

    Function role_id_onbehalf_md Return Varchar2 Is
    Begin
        Return c_role_onbehalf_md;
    End;

    Function role_id_onbehalf_afc Return Varchar2 Is
    Begin
        Return c_role_onbehalf_afc;
    End;

    Function role_id_regular_ftse Return Varchar2 Is
    Begin
        Return c_role_regular_ftse;
    End;

    --MODULES
    Function mod_id_hse_incident Return Varchar2 As
    Begin
        Return c_mod_id_hse_incident;
    End;

    Function mod_id_swp Return Varchar2 As
    Begin
        Return c_mod_id_swp;
    End;

    Function mod_id_swp_vaccine Return Varchar2
    As
    Begin
        Return c_mod_id_swp_vaccine;
    End;

    Function mod_id_ofb Return Varchar2 As
    Begin
        Return c_mod_id_ofb;
    End;

    Function mod_id_selfservice Return Varchar2 As
    Begin
        Return c_mod_id_selfservice;
    End;

    Function mod_id_rap_reporting Return Varchar2 As
    Begin
        Return c_mod_id_rap_reporting;
    End;

    Function mod_id_hrmasters Return Varchar2 As
    Begin
        Return c_mod_id_hrmasters;
    End;

    Function mod_id_letter_of_credit Return Varchar2 As
    Begin
        Return c_mod_id_letter_of_credit;
    End;

    Function mod_id_job_master Return Varchar2 As
    Begin
        Return c_mod_id_job_master;
    End;

    Function mod_id_timesheet Return Varchar2 As
    Begin
        Return c_mod_id_timesheet;
    End;

    Function mod_id_emp_gen_info Return Varchar2 As
    Begin
        Return c_mod_id_emp_gen_info;
    End;
    
    Function mod_id_ers_user Return Varchar2 As
    Begin
        Return c_mod_id_ers_user;
    End;

End app_constants;