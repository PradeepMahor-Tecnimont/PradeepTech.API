--------------------------------------------------------
--  DDL for Package Body SWP_OFFICE_VACCINE
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE BODY "SELFSERVICE"."SWP_OFFICE_VACCINE" As

    Procedure add_registration (
        param_win_uid                Varchar2,
        param_cowin_regtrd           Varchar2,
        param_mobile_no              Varchar2,
        param_office_bus             Varchar2,
        param_office_bus_route       Varchar2,
        param_is_attending           Varchar2,
        param_not_attending_reason   Varchar2,
        param_jab_number             Varchar2,
        param_success                Out                          Varchar2,
        param_message                Out                          Varchar2
    ) As
        v_empno Char(5);
    Begin
        v_empno         := swp_users.get_empno_from_win_uid(param_win_uid => param_win_uid);
        If v_empno Is Null Then
            param_success   := 'KO';
            param_message   := 'Error while retrieving EMPNO';
            return;
        End If;

        Insert Into swp_vaccination_office (
            empno,
            cowin_regtrd,
            mobile,
            office_bus,
            office_bus_route,
            attending_vaccination,
            not_attending_reason,
            jab_number
        ) Values (
            v_empno,
            param_cowin_regtrd,
            param_mobile_no,
            param_office_bus,
            param_office_bus_route,
            param_is_attending,
            param_not_attending_reason,
            param_jab_number
        );

        Commit;
        param_success   := 'OK';
        param_message   := 'Procedure executed';
    Exception
        When Others Then
            param_success   := 'KO';
            param_message   := 'Err - ' || Sqlcode || ' - ' || Sqlerrm;
    End;

    Procedure del_registration (
        param_empno     Varchar2,
        param_success   Out             Varchar2,
        param_message   Out             Varchar2
    ) As
    Begin
        Delete From swp_vaccination_office
        Where
            empno = param_empno;

        Commit;
        param_success   := 'OK';
        param_message   := 'Procedure executed';
    Exception
        When Others Then
            param_success   := 'KO';
            param_message   := 'Err - ' || Sqlcode || ' - ' || Sqlerrm;
    End;

End swp_office_vaccine;


/

  GRANT EXECUTE ON "SELFSERVICE"."SWP_OFFICE_VACCINE" TO "TCMPL_APP_CONFIG";
